//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 03.04.2025.
//

import UIKit

final class TrackerTypeViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let irregularEventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.modalPresentationStyle = .popover
        addViewsAndActivateConstraints()
    }
    
    private func addViewsAndActivateConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            habitButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            irregularEventButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            irregularEventButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularEventButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -281),
            irregularEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.bottomAnchor.constraint(equalTo: irregularEventButton.topAnchor, constant: -Constants.defaultPadding),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func habitButtonTapped(sender: UIButton) {
        let vc = NewTrackerViewController(titleName: "Новая привычка")
        present(vc, animated: true)
    }
    
    @objc private func irregularEventButtonTapped(sender: UIButton) {
        let vc = NewTrackerViewController(titleName: "Новое нерегулярное событие")
        present(vc, animated: true)
    }
}
