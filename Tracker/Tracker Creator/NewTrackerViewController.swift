//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 03.04.2025.
//

import UIKit

final class NewTrackerViewController: UIViewController, ScheduleServiceDelegate {
    
    var titleName: String
    var schedule: Array<WeekDays> = []
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let tableView = UITableView()
    private var tableViewService: ButtonsTableViewService?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .background
        textField.layer.cornerRadius = 16
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textfieldChanged(_:)), for: .editingChanged)
        
        return textField
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .ypWhite
        button.tintColor = .ypRed
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(titleName: String) {
        self.titleName = titleName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .currentContext
        view.backgroundColor = .ypWhite
        titleLabel.text = titleName
        tableViewService = ButtonsTableViewService(chosenType: titleName)
        tableView.delegate = tableViewService
        tableView.dataSource = tableViewService
        tableViewService?.viewController = self
        
        setupTitleLabel()
        setupBottomButtons()
        setupScrollView()
        setupStackView()
        setupAndAddElements()
    }
    
    // MARK: - Methods
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 241),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupBottomButtons() {
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints  = false
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: 176),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 171),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupAndAddElements() {
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
            trackerNameTextField.widthAnchor.constraint(equalToConstant: 343),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            tableView.widthAnchor.constraint(equalToConstant: 343),
        ])
        switch titleName {
        case "Новая привычка":
            tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        case "Новое нерегулярное событие":
            tableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        default: return
        }
        stackView.addArrangedSubview(trackerNameTextField)
        stackView.addArrangedSubview(tableView)
    }
    
    @objc private func textfieldChanged(_ sender: UITextField) {
        if let text = sender.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
    
    func didSelectSchedule(days: [WeekDays]) {
        self.schedule = days
        print("Получены выбранные дни: \(days)")
    }
    
    func openScheduleController() {
        trackerNameTextField.resignFirstResponder()
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true)
    }
    
    @objc private func createButtonTapped() {
        let newTracker = Tracker(
            id: UInt.random(in: 2...1000),
            name: trackerNameTextField.text!,
            color: .colorSelection14,
            emoji: "🥸",
            schedule: schedule
        )
        
        if let firstCategory = TrackersCollectionService.shared.categories.first {
            TrackersCollectionService.shared.addTracker(newTracker, toCategoryWithTitle: firstCategory.title)
        } else {
            TrackersCollectionService.shared.addTracker(newTracker, toCategoryWithTitle: "Домашний уют")
        }
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
