//
//  SplashViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 08.05.2025.
//

import UIKit

final class SplashViewController: UIPageViewController {
    
    let ypLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage.ypLogo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypBlue
        view.addSubview(ypLogo)
        
        NSLayoutConstraint.activate([
            ypLogo.widthAnchor.constraint(equalToConstant: 91),
            ypLogo.heightAnchor.constraint(equalToConstant: 94),
            ypLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ypLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "notFirstLaunch") {
            guard let window = UIApplication.shared.currentUIWindow() else {
                assertionFailure("Invalid window configuration")
                return
            }
            let tabBarVC = TabBarController()
            window.rootViewController = tabBarVC
        } else {
            let onboardingVC = OnboardingViewController()
            onboardingVC.modalPresentationStyle = .fullScreen
            present(onboardingVC, animated: true)
        }
    }
}
