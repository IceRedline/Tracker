//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

class ScheduleViewController: UIViewController {

    let tableView = UITableView()
    let scheduleTableViewService = ScheduleTableViewService()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .currentContext
        view.backgroundColor = .ypWhite
        
        tableView.delegate = scheduleTableViewService
        tableView.dataSource = scheduleTableViewService
        
        setupViewsAndActivateConstraints()
    }
    
    private func setupViewsAndActivateConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            doneButton.widthAnchor.constraint(equalToConstant: 335),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }

}

#Preview(traits: .defaultLayout, body: {
    TabBarController()
})
