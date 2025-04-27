//
//  TrackerStore.swift
//  Tracker
//
//  Created by Артем Табенский on 18.04.2025.
//

import UIKit
import CoreData

class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    
    private let uiColorMarshalling = UIColorMarshalling()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerData>!
    
    weak var delegate: TrackerStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?

    private convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerData.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try? controller.performFetch()
    }
    
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    func addNewTracker(_ tracker: Tracker, to categoryData: TrackerCategoryData) throws {
        let trackerData = TrackerData(context: context)
        updateExistingTracker(trackerData, with: tracker)
        categoryData.addToTrackers(trackerData)
        try context.save()
    }

    func updateExistingTracker(_ trackerCorData: TrackerData, with tracker: Tracker) {
        trackerCorData.id = tracker.id
        trackerCorData.name = tracker.name
        trackerCorData.emoji = tracker.emoji
        trackerCorData.colorHex = uiColorMarshalling.hexString(from: tracker.color)
        trackerCorData.schedule = tracker.schedule.map { String($0.rawValue) }.joined(separator: ",")
    }
    
    func tracker(from trackerCorData: TrackerData) throws -> Tracker {
        guard let id = trackerCorData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let name = trackerCorData.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        guard let emoji = trackerCorData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        guard let colorHex = trackerCorData.colorHex else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let scheduleString = trackerCorData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }

        let rawValues = scheduleString.components(separatedBy: ",")
        let schedule = rawValues.compactMap { Int($0) }.compactMap { WeekDays(rawValue: $0) }

        return Tracker(id: id, name: name, color: uiColorMarshalling.color(from: colorHex), emoji: emoji, schedule: schedule)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerStoreUpdate.Move>()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!,
                updatedIndexes: updatedIndexes!,
                movedIndexes: movedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
}
