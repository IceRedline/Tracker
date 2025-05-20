//
//  AppDelegate.swift
//  Tracker
//
//  Created by Артем Табенский on 28.03.2025.
//

import UIKit
import CoreData
import YandexMobileMetrica


@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try TrackerCategoryStore.shared.createPinnedCategoryIfNeeded()
        } catch {
            print("❌ Failed to create pinned category: \(error)")
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}
