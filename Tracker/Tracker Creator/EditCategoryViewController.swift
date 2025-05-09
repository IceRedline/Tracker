//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 09.05.2025.
//

import UIKit

final class EditCategoryViewController: UIViewController {
    private let currentTitle: String
    
    var onSave: ((String) -> Void)?
    var onCancel: (() -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактирование категории"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название"
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = .background
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.becomeFirstResponder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(currentTitle: String) {
        self.currentTitle = currentTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        textField.text = currentTitle
        
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            textField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            returnButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            returnButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            returnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding)
        ])
    }
    
    @objc private func returnButtonTapped() {
        guard let newTitle = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !newTitle.isEmpty else { return }
        
        onSave?(newTitle)
    }
    
    @objc private func cancelButtonTapped() {
        onCancel?()
    }
}
