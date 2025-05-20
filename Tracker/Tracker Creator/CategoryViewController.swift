//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 09.05.2025.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    let categoriesTableView = UITableView()
    var selectedCategory: String
    
    var viewModel: CategoryViewModel
    var onCategorySelected: ((String) -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("category", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("addCategory", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: CategoryViewModel, selectedCategory: String) {
        self.viewModel = viewModel
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.selectedCategory = selectedCategory
        
        
        bindViewModel()
        
        categoriesTableView.delegate = viewModel
        categoriesTableView.dataSource = viewModel
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupViewsAndActivateConstraints()
        
        viewModel.loadCategories()
    }
    
    private func bindViewModel() {
        viewModel.onCategoriesUpdated = { [weak self] in
            self?.categoriesTableView.reloadData()
        }
        
        viewModel.onCategorySelected = { [weak self] categoryTitle in
            self?.onCategorySelected?(categoryTitle)
            self?.dismiss(animated: true)
        }
        
        viewModel.onShowEditModal = { [weak self] currentTitle, completion in
            self?.showEditModal(currentTitle: currentTitle, completion: completion)
        }
        
        viewModel.onShowDeleteAlert = { [weak self] confirmAction in
            self?.showDeleteConfirmation(confirmAction: confirmAction)
        }
    }
    
    private func showEditModal(currentTitle: String, completion: @escaping (String) -> Void) {
        let editVC = EditCategoryViewController(currentTitle: currentTitle)
        editVC.onSave = { [weak self] newTitle in
            self?.dismiss(animated: true) {
                completion(newTitle)
            }
        }
        editVC.onCancel = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true)
    }
    
    private func showDeleteConfirmation(confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("areYouSure", comment: ""),
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive) { _ in
            confirmAction()
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func setupViewsAndActivateConstraints() {
        categoriesTableView.register(CategoryAndFilterTableViewCell.self, forCellReuseIdentifier: CategoryAndFilterTableViewCell.reuseIdentifier)
        modalPresentationStyle = .currentContext
        view.backgroundColor = .ypWhite
        categoriesTableView.backgroundColor = .ypWhite
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoriesTableView.layer.cornerRadius = Constants.cornerRadius
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(categoriesTableView)
        view.addSubview(addCategoryButton)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            categoriesTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(Constants.defaultPadding * 2)),
            categoriesTableView.heightAnchor.constraint(equalToConstant: 525),
            categoriesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesTableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            addCategoryButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            addCategoryButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding)
        ])
    }
    
    @objc private func addCategoryButtonTapped() {
        let alert = UIAlertController(title: NSLocalizedString("newCategory", comment: ""), message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("enterName", comment: "")
        }
        
        let addAction = UIAlertAction(title: NSLocalizedString("add", comment: ""), style: .default) { [weak self] _ in
            guard let title = alert.textFields?.first?.text, !title.isEmpty else { return }
            self?.viewModel.addCategory(title: title)
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel))
        present(alert, animated: true)
    }
}
