//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 17.05.2025.
//

import UIKit

final class EditTrackerViewController: UIViewController, ScheduleServiceDelegate, ButtonsTableViewServiceViewControllerProtocol {
    
    var trackerID: UUID
    var daysCount: String
    var trackerTitle: String
    var schedule: [WeekDays] = []
    var selectedCategory: String
    var color: UIColor
    var emoji: String
    
    private let scrollView = UIScrollView()
    private let vStackView = UIStackView()
    private let hStackView = UIStackView()
    private let tableView = UITableView()
    private var tableViewService: ButtonsTableViewService?
    private var emojiCollectionView: UICollectionView!
    private var emojiCollectionService: EmojiCollectionService?
    private var colorsCollectionView: UICollectionView!
    private var colorsCollectionService: ColorsCollectionService?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.text = "404"
        return label
    }()
    
    lazy var trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("enterTrackerName", comment: "")
        textField.backgroundColor = .background
        textField.layer.cornerRadius = Constants.cornerRadius
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textfieldChanged(_:)), for: .editingChanged)
        
        return textField
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("emoji", comment: "")
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("color", comment: "")
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .ypWhite
        button.tintColor = .ypRed
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(trackerID: UUID, daysCount: String, trackerTitle: String, schedule: [WeekDays], selectedCategory: String, color: UIColor, emoji: String) {
        self.trackerID = trackerID
        self.daysCount = daysCount
        self.trackerTitle = trackerTitle
        self.schedule = schedule
        self.selectedCategory = selectedCategory
        self.color = color
        self.emoji = emoji
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
        trackerNameTextField.text = trackerTitle
        tableViewService = ButtonsTableViewService(chosenType: NSLocalizedString("newHabit", comment: ""))
        tableView.delegate = tableViewService
        tableView.dataSource = tableViewService
        tableViewService?.viewController = self
        
        setupLabels()
        setupEmojiCollectionView()
        setupColorsCollectionView()
        setupScrollView()
        setupHStackView()
        setupVStackView()
        setupAndAddElements()
        
        colorsCollectionService?.chosenColor = color
        emojiCollectionService?.chosenEmoji = emoji
    }
    
    // MARK: - Methods
    
    private func setupLabels() {
        titleLabel.text = "Редактирование привычки"
        daysCountLabel.text = daysCount
        [titleLabel, daysCountLabel].forEach { x in
            x.textAlignment = .center
            view.addSubview(x)
            x.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 241),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            daysCountLabel.widthAnchor.constraint(equalToConstant: 343),
        ])
    }
    
    private func setupEmojiCollectionView() {
        emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiCollectionView.isScrollEnabled = false
        emojiCollectionView.allowsMultipleSelection = false
        emojiCollectionView.backgroundColor = .ypWhite
        
        emojiCollectionService = EmojiCollectionService()
        emojiCollectionView.dataSource = emojiCollectionService
        emojiCollectionView.delegate = emojiCollectionService
    }
    
    private func setupColorsCollectionView() {
        colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorsCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        colorsCollectionView.isScrollEnabled = false
        colorsCollectionView.allowsMultipleSelection = false
        
        colorsCollectionService = ColorsCollectionService()
        colorsCollectionView.dataSource = colorsCollectionService
        colorsCollectionView.delegate = colorsCollectionService
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
    
    private func setupVStackView() {
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.spacing = 30
        scrollView.addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            vStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.defaultPadding),
            vStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.defaultPadding),
            vStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupHStackView() {
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        hStackView.spacing = 8
        view.addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            hStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.defaultPadding),
            hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupAndAddElements() {
        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = Constants.cornerRadius
        
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        vStackView.addArrangedSubview(daysCountLabel)
        vStackView.addArrangedSubview(trackerNameTextField)
        vStackView.addArrangedSubview(tableView)
        
        vStackView.addArrangedSubview(emojiLabel)
        vStackView.addArrangedSubview(emojiCollectionView)
        vStackView.addArrangedSubview(colorLabel)
        vStackView.addArrangedSubview(colorsCollectionView)
        
        hStackView.addArrangedSubview(cancelButton)
        hStackView.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            daysCountLabel.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            daysCountLabel.heightAnchor.constraint(equalToConstant: 40),
            trackerNameTextField.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            tableView.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 300),
            emojiLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: 10),
            emojiCollectionView.widthAnchor.constraint(equalToConstant: 364),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 184),
            colorLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor, constant: 10),
            colorsCollectionView.widthAnchor.constraint(equalToConstant: 374),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 184),
        ])
    }
    
    @objc private func textfieldChanged(_ sender: UITextField) {
        if let text = sender.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .ypBlack
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .ypGray
        }
    }
    
    func didSelectSchedule(days: [WeekDays]) {
        self.schedule = days
        print("Получены выбранные дни: \(days)")
    }
    
    func openCategoryController() {
        trackerNameTextField.resignFirstResponder()
        let categoryVC = CategoryViewController(viewModel: CategoryViewModel(), selectedCategory: selectedCategory ?? NSLocalizedString("noCategory", comment: ""))
        categoryVC.onCategorySelected = { [weak self] categoryTitle in
            self?.selectedCategory = categoryTitle
            print("Выбрана категория: \(categoryTitle)")
        }
        present(categoryVC, animated: true)
    }
    
    func openScheduleController() {
        trackerNameTextField.resignFirstResponder()
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true)
    }
    
    
    @objc private func saveButtonTapped() {
        guard let trackerName = trackerNameTextField.text, !trackerName.isEmpty else {
            print("Ошибка: Имя трекера не может быть пустым")
            return
        }
        
        let updatedTracker = Tracker(
            id: trackerID,
            name: trackerName,
            color: colorsCollectionService?.chosenColor ?? .colorSelection1,
            emoji: emojiCollectionService?.chosenEmoji ?? "🙂",
            schedule: schedule
        )
        
        do {
            try TrackerStore.shared.updateTracker(with: trackerID, newTracker: updatedTracker)
            TrackersCollectionService.shared.reload()
        } catch {
            print("Ошибка обновления: \(error)")
        }
        
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
