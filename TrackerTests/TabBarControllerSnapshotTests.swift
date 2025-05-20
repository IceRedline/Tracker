//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Артем Табенский on 18.05.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TabBarControllerSnapshotTests: XCTestCase {

    // MARK: - Properties
        
        private var viewController: TabBarController!
        
        // MARK: - Lifecycle
        
        override func setUp() {
            super.setUp()
            viewController = TabBarController()
            //viewController.tabBar.backgroundColor = .red
        }
        
        override func tearDown() {
            viewController = nil
            super.tearDown()
        }
        
        // MARK: - Tests
        
        func testTabBarControllerSnapshot() {
            assertSnapshot(of: viewController, as: .image)
        }
}
