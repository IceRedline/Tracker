//
//  Tracker.swift
//  Tracker
//
//  Created by Артем Табенский on 01.04.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDays]
    var originalCategory: String?
}
