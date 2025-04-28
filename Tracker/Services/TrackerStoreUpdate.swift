//
//  TrackerStoreUpdate.swift
//  Tracker
//
//  Created by Артем Табенский on 27.04.2025.
//

import Foundation

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}
