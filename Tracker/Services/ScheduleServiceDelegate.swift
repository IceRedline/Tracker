//
//  ScheduleServiceDelegate.swift
//  Tracker
//
//  Created by Артем Табенский on 05.04.2025.
//

import Foundation

protocol ScheduleServiceDelegate: AnyObject {
    func didSelectSchedule(days: [WeekDays])
}
