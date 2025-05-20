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
        
        configureTabBarAppearance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyTodayDate), name: .setTodayDate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsService.shared.report(event: "open", screen: "Main")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AnalyticsService.shared.report(event: "close", screen: "Main")
    }
    
    private func configureTabBarAppearance() {
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
        tabBar.barTintColor = .ypWhite
    }
    
    private func makeDatePickerItem() -> UIBarButtonItem {
        let datePicker = UIDatePicker()
        datePicker.tintColor = .ypBlue
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale.current
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return UIBarButtonItem(customView: datePicker)
    }
    
    private func setupTabs() {
        
        let trackersViewController = self.createNav(
            title: NSLocalizedString("trackers", comment: ""),
            image: .trackersTabBar,
            leftButtonItem: UIBarButtonItem(image: .addTracker, style: .plain, target: nil, action: #selector(addTrackerButtonTapped)),
            rightButtonItem: makeDatePickerItem(),
            vc: TrackersViewController()
        )
        let statisticsViewController = self.createNav(
            title: NSLocalizedString("statistics", comment: ""),
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
        
        AnalyticsService.shared.report(event: "click", screen: "Main", item: "add_track")
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        TrackersCollectionService.shared.currentDate = sender.date
        TrackersCollectionService.shared.reload()
    }
    
    @objc private func applyTodayDate() {
        if let datePickerItem = (self.viewControllers?.first as? UINavigationController)?
            .viewControllers.first?.navigationItem.rightBarButtonItem?.customView as? UIDatePicker {
            datePickerItem.setDate(Date(), animated: true)
            self.dateChanged(datePickerItem)
        }
    }
}

extension Notification.Name {
    static let setTodayDate = Notification.Name("setTodayDate")
}
