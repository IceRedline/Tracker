//
//  FilterType.swift
//  Tracker
//
//  Created by Артем Табенский on 20.05.2025.
//

import Foundation

enum FilterType: String, CaseIterable {
    case all = "allTrackers"
    case today = "todayTrackers"
    case completed = "completedTrackers"
    case incomplete = "incompleteTrackers"

    var localizedName: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}
