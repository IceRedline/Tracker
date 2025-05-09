//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Артем Табенский on 09.05.2025.
//

import UIKit

class CategoryViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let categoryStore = TrackerCategoryStore.shared
    private var categories: [TrackerCategory] = []
    
    var onCategoriesUpdated: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?
    
    func loadCategories() {
        do {
            categories = try categoryStore.fetchCategories()
            onCategoriesUpdated?()
        } catch {
            print("Ошибка загрузки категорий: \(error)")
        }
    }
    
    func addCategory(title: String) {
        do {
            try categoryStore.findOrCreateCategory(with: title)
            loadCategories()
        } catch {
            print("Ошибка добавления категории: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { categories.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        cell.backgroundColor = .background
        
        let titleLabel = UILabel()
        titleLabel.text = categories[indexPath.row].title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: Constants.defaultPadding),
        ])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView
        
        let selectedCategory = categories[indexPath.row].title
        onCategorySelected?(selectedCategory)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    //self?.makeBold(indexPath: indexPath)
                },
                UIAction(title: "Удалить") { [weak self] _ in
                    //self?.makeItalic(indexPath: indexPath)
                },
            ])
        })
    }
}


#Preview(traits: .defaultLayout, body: {
    NewTrackerViewController(titleName: "Новая привычка")
})
