//
//  TabBarController.swift
//  Tracker
//
//  Created by Артем Табенский on 29.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        self.modalPresentationStyle = .fullScreen
        
        self.tabBar.tintColor = .ypBlue
        self.tabBar.barTintColor = .ypWhite
        self.tabBar.unselectedItemTintColor = .ypGray
    }
    
    private func setupTabs() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        let datePickerItem = UIBarButtonItem(customView: datePicker)
        
        let trackersViewController = self.createNav(
            title: "Трекеры",
            image: .trackersTabBar,
            leftButtonItem: UIBarButtonItem(image: .addTracker, style: .plain, target: nil, action: #selector(addTrackerButtonTapped)),
            rightButtonItem: datePickerItem,
            vc: TrackersViewController()
        )
        let statisticsViewController = self.createNav(
            title: "Статистика",
            image: .statsTabBar,
            leftButtonItem: nil,
            rightButtonItem: nil,
            vc: StatisticsViewController()
        )
        self.setViewControllers([trackersViewController, statisticsViewController], animated: true)
    }
    
    private func createNav(title: String, image: UIImage, leftButtonItem: UIBarButtonItem?, rightButtonItem: UIBarButtonItem?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        nav.viewControllers.first?.navigationItem.leftBarButtonItem = leftButtonItem
        nav.viewControllers.first?.navigationItem.rightBarButtonItem = rightButtonItem
        nav.viewControllers.first?.navigationItem.leftBarButtonItem?.tintColor = .ypBlack
        nav.viewControllers.first?.navigationItem.rightBarButtonItem?.tintColor = .ypBlack
        return nav
    }
    
    @objc private func addTrackerButtonTapped() {
        let vc = TrackerTypeViewController()
        present(vc, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        TrackersCollectionService.shared.currentDate = sender.date
        TrackersCollectionService.shared.reload()
    }
}
