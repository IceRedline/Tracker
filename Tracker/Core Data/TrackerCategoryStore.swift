//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Артем Табенский on 18.04.2025.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    
    static let shared = TrackerCategoryStore()
    
    private let context: NSManagedObjectContext
    private let trackerStore: TrackerStore
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryData>?

    init(
        context: NSManagedObjectContext = DatabaseStore.shared.persistentContainer.viewContext,
        trackerStore: TrackerStore = TrackerStore()
    ) {
        self.context = context
        self.trackerStore = trackerStore
    }

    var categories: [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryData> = TrackerCategoryData.fetchRequest()
        guard let result = try? context.fetch(fetchRequest) else { return [] }

        return result.compactMap { try? category(from: $0) }
    }

    func findOrCreateCategory(with title: String) throws -> TrackerCategoryData {
        let fetchRequest: NSFetchRequest<TrackerCategoryData> = TrackerCategoryData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        if let existingCategory = try context.fetch(fetchRequest).first {
            return existingCategory
        }
        
        let newCategory = TrackerCategoryData(context: context)
        newCategory.title = title
        try context.save()
        return newCategory
    }
    
    func updateCategoryTitle(from oldTitle: String, to newTitle: String) throws {
        let request = TrackerCategoryData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", oldTitle)
        
        if let category = try context.fetch(request).first {
            category.title = newTitle
            
            if let trackers = category.trackers?.allObjects as? [TrackerData] {
                for tracker in trackers {
                    tracker.category?.title = newTitle
                }
            }
            
            try context.save()
            NotificationCenter.default.post(name: .categoryDidChange, object: nil)
        } else {
            throw NSError(domain: "TrackerCategoryStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Категория не найдена"])
        }
    }
    
    func deleteCategory(with title: String) throws {
        let request = TrackerCategoryData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        if let category = try context.fetch(request).first {
            if let trackers = category.trackers?.allObjects as? [TrackerData] {
                for tracker in trackers {
                    context.delete(tracker)
                }
            }
            
            context.delete(category)
            
            try context.save()
            context.refreshAllObjects()
        }
        NotificationCenter.default.post(name: .categoryDidChange, object: nil)
    }
    
    func createPinnedCategoryIfNeeded() throws {
        let categoryTitle = NSLocalizedString("pinned", comment: "Закрепленные")
        let fetchRequest: NSFetchRequest<TrackerCategoryData> = TrackerCategoryData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        guard try context.count(for: fetchRequest) == 0 else { return }
        
        let categoryData = TrackerCategoryData(context: context)
        categoryData.title = categoryTitle
        try context.save()
    }

    private func category(from data: TrackerCategoryData) throws -> TrackerCategory {
        guard let title = data.title else {
            throw TrackerStoreError.decodingErrorInvalidName
        }

        let trackers: [Tracker] = (data.trackers as? Set<TrackerData>)?.compactMap {
            try? trackerStore.tracker(from: $0)
        } ?? []

        return TrackerCategory(title: title, trackers: trackers)
    }
    
    func fetchCategories() throws -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryData> = TrackerCategoryData.fetchRequest()
        let result = try context.fetch(fetchRequest)
        return try result.map { try category(from: $0) }
    }
}

extension Notification.Name {
    static let categoryDidChange = Notification.Name("categoryDidChange")
}
