//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Артем Табенский on 09.05.2025.
//

import UIKit

final class CategoryViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let categoryStore = TrackerCategoryStore.shared
    private var categories: [TrackerCategory] = []
    var selectedCategory: String?
    
    var onCategoriesUpdated: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?
    var onShowEditModal: ((String, @escaping (String) -> Void) -> Void)?
    var onShowDeleteAlert: ((@escaping () -> Void) -> Void)?
    
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
    
    private func updateCategory(title: String, newTitle: String) {
        do {
            try categoryStore.updateCategoryTitle(from: title, to: newTitle)
            loadCategories()
        } catch {
            print("Ошибка редактирования категории: \(error)")
        }
    }
    
    private func deleteCategory(at indexPath: IndexPath) {
        do {
            let categoryTitle = categories[indexPath.row].title
            try categoryStore.deleteCategory(with: categoryTitle)
            
            categories.remove(at: indexPath.row)
            
            if selectedCategory == categoryTitle {
                selectedCategory = nil
            }
            
            loadCategories()
            
        } catch {
            print("Ошибка удаления категории: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { categories.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        
        let category = categories[indexPath.row]
        cell.configure(
            with: category.title,
            isSelected: category.title == selectedCategory
        )
        
        // Настройка закругления
        if indexPath.row == categories.count - 1 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = Constants.cornerRadius
            cell.layer.masksToBounds = true
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.layer.cornerRadius = 0
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row].title
        onCategorySelected?(selectedCategory ?? "Без категории")
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let category = categories[indexPath.row]
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.showEditModal(for: category)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.showDeleteConfirmation(for: indexPath)
                },
            ])
        })
    }
    
    private func showEditModal(for category: TrackerCategory) {
        onShowEditModal?(category.title) { [weak self] newTitle in
            self?.updateCategory(title: category.title, newTitle: newTitle)
        }
    }
    
    private func showDeleteConfirmation(for indexPath: IndexPath) {
        onShowDeleteAlert? { [weak self] in
            self?.deleteCategory(at: indexPath)
        }
    }
    
}
