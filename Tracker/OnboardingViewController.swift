//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 08.05.2025.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    let pages: [UIViewController] = {
        let firstVC = UIViewController()
        let secondVC = UIViewController()
        
        let firstImage = UIImageView(image: UIImage.onboardingFirst)
        let firstLabel = UILabel()
        firstLabel.text = "Отслеживайте только то, что хотите"
        firstLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        firstLabel.numberOfLines = 0
        firstLabel.textAlignment = .center
        
        let secondImage = UIImageView(image: UIImage.onboardingSecond)
        let secondLabel = UILabel()
        secondLabel.text = "Даже если это не литры воды и йога"
        secondLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        secondLabel.numberOfLines = 0
        secondLabel.textAlignment = .center
        
        firstVC.view.addSubview(firstImage)
        firstVC.view.addSubview(firstLabel)
        secondVC.view.addSubview(secondImage)
        secondVC.view.addSubview(secondLabel)
        
        firstImage.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondImage.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstImage.topAnchor.constraint(equalTo: firstVC.view.topAnchor),
            firstImage.bottomAnchor.constraint(equalTo: firstVC.view.bottomAnchor),
            firstImage.leadingAnchor.constraint(equalTo: firstVC.view.leadingAnchor),
            firstImage.trailingAnchor.constraint(equalTo: firstVC.view.trailingAnchor),
            firstLabel.leadingAnchor.constraint(equalTo: firstVC.view.leadingAnchor, constant: 16),
            firstLabel.centerXAnchor.constraint(equalTo: firstVC.view.centerXAnchor),
            firstLabel.bottomAnchor.constraint(equalTo: firstVC.view.bottomAnchor, constant: -304),
            secondImage.topAnchor.constraint(equalTo: secondVC.view.topAnchor),
            secondImage.bottomAnchor.constraint(equalTo: secondVC.view.bottomAnchor),
            secondImage.leadingAnchor.constraint(equalTo: secondVC.view.leadingAnchor),
            secondImage.trailingAnchor.constraint(equalTo: secondVC.view.trailingAnchor),
            secondLabel.widthAnchor.constraint(equalToConstant: 343),
            secondLabel.centerXAnchor.constraint(equalTo: secondVC.view.centerXAnchor),
            secondLabel.bottomAnchor.constraint(equalTo: secondVC.view.bottomAnchor, constant: -304),
        ])
        return [firstVC, secondVC]
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self

        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        view.addSubview(button)
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarVC = TabBarController()
        window.rootViewController = tabBarVC
        
        UserDefaults.standard.set(true, forKey: "notFirstLaunch")
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
