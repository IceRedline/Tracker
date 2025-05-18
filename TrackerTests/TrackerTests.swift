//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Артем Табенский on 18.05.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class AlpabetTests: XCTestCase {

    func testViewController() {
        let vc = TabBarController()
        //vc.tabBar.backgroundColor = .red
        //isRecording = true
        assertSnapshot(of: vc, as: .image)
    }
}
