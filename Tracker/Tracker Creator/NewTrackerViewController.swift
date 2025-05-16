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
    var selectedCategory: String?
    
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
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("create", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = Constants.cornerRadius
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
        setupEmojiCollectionView()
        setupColorsCollectionView()
        setupScrollView()
        setupHStackView()
        setupVStackView()
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
    
    private func setupEmojiCollectionView() {
        emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiCollectionView.isScrollEnabled = false
        emojiCollectionView.allowsMultipleSelection = false
        
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
        
        switch titleName {
        case NSLocalizedString("newHabit", comment: ""):
            tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        case NSLocalizedString("newIrregularActivity", comment: ""):
            tableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        default: return
        }
        
        vStackView.addArrangedSubview(trackerNameTextField)
        vStackView.addArrangedSubview(tableView)
        
        vStackView.addArrangedSubview(emojiLabel)
        vStackView.addArrangedSubview(emojiCollectionView)
        vStackView.addArrangedSubview(colorLabel)
        vStackView.addArrangedSubview(colorsCollectionView)
        
        hStackView.addArrangedSubview(cancelButton)
        hStackView.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
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
    
    
    @objc private func createButtonTapped() {
        guard let trackerName = trackerNameTextField.text, !trackerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Ошибка: Имя трекера не может быть пустым")
            return
        }
        
        let newTracker = Tracker(
            id: UUID(),
            name: trackerName,
            color: colorsCollectionService?.chosenColor ?? .colorSelection1,
            emoji: emojiCollectionService?.chosenEmoji ?? "🙂",
            schedule: schedule
        )
        
        do {
            let categoryTitle = selectedCategory ?? NSLocalizedString("noCategory", comment: "")
            let categoryData = try TrackerCategoryStore.shared.findOrCreateCategory(with: categoryTitle)
            
            try TrackerStore.shared.addNewTracker(newTracker, to: categoryData)
            
            TrackersCollectionService.shared.reload()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
        
        dismiss(animated: true)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
