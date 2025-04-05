//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Артем Табенский on 05.04.2025.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidTapComplete(_ cell: TrackerCell, isCompleted: Bool)
}
