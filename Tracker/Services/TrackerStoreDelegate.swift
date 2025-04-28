//
//  TrackerStoreDelegate.swift
//  Tracker
//
//  Created by Артем Табенский on 27.04.2025.
//

import Foundation

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
}
