//
//  TrackerStoreError.swift
//  Tracker
//
//  Created by Артем Табенский on 27.04.2025.
//

import Foundation

enum TrackerStoreError: Error {
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidId
    case decodingErrorInvalidName
    case decodingErrorInvalidSchedule
}
