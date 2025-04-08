//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleServiceDelegate?
    
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
        button.layer.cornerRadius = Constants.cornerRadius
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
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(Constants.defaultPadding * 2)),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            doneButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding)
        ])
    }
    
    @objc private func doneButtonTapped() {
        let selectedDays = scheduleTableViewService.getSelectedDays()
        print("selectedDays: \(selectedDays)")
        delegate?.didSelectSchedule(days: selectedDays)
        dismiss(animated: true)
    }
}
