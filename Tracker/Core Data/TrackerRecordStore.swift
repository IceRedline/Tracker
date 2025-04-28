//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Артем Табенский on 18.04.2025.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = DatabaseStore.shared.persistentContainer.viewContext) {
        self.context = context
    }
    
    func addRecord(_ record: TrackerRecord) throws {
        let new = TrackerRecordData(context: context)
        new.id = record.id
        new.date = Calendar.current.startOfDay(for: record.date)
        try context.save()
    }
    
    func removeRecord(for id: UUID, on date: Date) throws {
        let request: NSFetchRequest = TrackerRecordData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", id as CVarArg, Calendar.current.startOfDay(for: date) as CVarArg)
        if let record = try context.fetch(request).first {
            context.delete(record)
            try context.save()
        }
    }
    
    func isCompleted(id: UUID, on date: Date) -> Bool {
        let request: NSFetchRequest<TrackerRecordData> = TrackerRecordData.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %@", id as CVarArg),
            NSPredicate(format: "date == %@", date as NSDate)
        ])
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
    
    func fetchAll() throws -> [TrackerRecord] {
        let records = try context.fetch(TrackerRecordData.fetchRequest())
        return records.compactMap { data in
            guard let id = data.id, let date = data.date else { return nil }
            return TrackerRecord(id: id, date: date)
        }
    }
}
