//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 03.04.2025.
//

import UIKit

class NewTrackerViewController: UIViewController {
    
    var titleName: String
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let tableView = UITableView()
    private var emojiCollectionView: UICollectionView!
    private var emojiCollectionService: EmojiCollectionService!
    private var colorsCollectionView: UICollectionView!
    private var colorsCollectionService: ColorsCollectionService!
    
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
        
        return textField
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "   Emoji"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "   Цвет"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.backgroundColor = .ypWhite
        button.tintColor = .ypRed
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
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
        
        setupTitleLabel()
        setupEmojiCollectionView()
        setupColorsCollectionView()
        setupScrollView()
        setupStackView()
        setupAndAddElements()
    }
    
    // MARK: - Methods
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 133),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupEmojiCollectionView() {
        emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojiCollectionView.isScrollEnabled = false
        //emojiCollectionView.backgroundColor = .black
        
        emojiCollectionService = EmojiCollectionService()
        emojiCollectionView.dataSource = emojiCollectionService
        emojiCollectionView.delegate = emojiCollectionService
    }
    
    private func setupColorsCollectionView() {
        colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        colorsCollectionView.isScrollEnabled = false
        //emojiCollectionView.backgroundColor = .black
        
        colorsCollectionService = ColorsCollectionService()
        colorsCollectionView.dataSource = colorsCollectionService
        colorsCollectionView.delegate = colorsCollectionService
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        //scrollView.backgroundColor = .red
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
        //stackView.backgroundColor = .blue
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
        tableView.backgroundColor = .systemGray6
        tableView.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
            trackerNameTextField.widthAnchor.constraint(equalToConstant: 343),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            emojiLabel.widthAnchor.constraint(equalToConstant: 300),
            emojiCollectionView.widthAnchor.constraint(equalToConstant: 374),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            colorsCollectionView.widthAnchor.constraint(equalToConstant: 374),
            colorsCollectionView.heightAnchor.constraint(equalToConstant: 204),
        ])
        stackView.addArrangedSubview(trackerNameTextField)
        stackView.addArrangedSubview(tableView)
        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(emojiCollectionView)
        stackView.addArrangedSubview(colorsCollectionView)
    }
}
