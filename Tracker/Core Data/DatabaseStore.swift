//
//  DateBaseStore.swift
//  Tracker
//
//  Created by Артем Табенский on 28.04.2025.
//

import Foundation
import CoreData

final class DatabaseStore {
    static let shared = DatabaseStore()
    
    private init() {}
        
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Не удалось создать контейнер: \(error)")
            }
        })
        return container
    }()
}
