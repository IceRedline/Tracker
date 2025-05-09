//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 09.05.2025.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    let tableView = UITableView()
    
    var viewModel = CategoryViewModel()
    var onCategorySelected: ((String) -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            viewModel.onCategoriesUpdated = { [weak self] in
                self?.tableView.reloadData()
            }
            
            viewModel.onCategorySelected = { [weak self] categoryTitle in
                self?.onCategorySelected?(categoryTitle)
                self?.dismiss(animated: true)
            }
            
            tableView.delegate = viewModel
            tableView.dataSource = viewModel
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            setupViewsAndActivateConstraints()
            
            viewModel.loadCategories()
        }
    
    private func setupViewsAndActivateConstraints() {
        self.modalPresentationStyle = .currentContext
        view.backgroundColor = .ypWhite
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(Constants.defaultPadding * 2)),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            addCategoryButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            addCategoryButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding)
        ])
    }
    
    @objc private func addCategoryButtonTapped() {
        let alert = UIAlertController(title: "Новая категория", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else { return }
            self?.viewModel.addCategory(title: title)
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

#Preview(traits: .defaultLayout, body: {
    NewTrackerViewController(titleName: "Новая привычка")
})
