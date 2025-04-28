//
//  TrackersCollectionService.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

final class TrackersCollectionService: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, TrackerCellDelegate {
    
    static let shared = TrackersCollectionService()
    
    weak var viewController: TrackersViewController?
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    var currentDate: Date?
    
    private override init() {}
    
    func reload() {
        loadCategories()
        loadCompletedTrackers()
        
        let filtered = filteredCategories()
        
        if filtered.isEmpty {
            viewController?.hideCollection()
        } else {
            viewController?.showCollection()
        }
        
        viewController?.trackersCollectionView.reloadData()
    }
    
    private func loadCategories() {
        do {
            categories = try trackerCategoryStore.fetchCategories()
        } catch {
            print("Ошибка при загрузке категорий: \(error)")
            categories = []
        }
    }
    
    private func loadCompletedTrackers() {
        do {
            completedTrackers = try trackerRecordStore.fetchAll()
        } catch {
            print("Ошибка при загрузке выполненных трекеров: \(error)")
            completedTrackers = []
        }
    }
    
    func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        do {
            let categoryData = try trackerCategoryStore.findOrCreateCategory(with: title)
            try trackerStore.addNewTracker(tracker, to: categoryData)
            reload()
        } catch {
            print("Ошибка при добавлении трекера: \(error)")
        }
    }
    
    private func filteredCategories() -> [TrackerCategory] {
        guard let currentDate = currentDate else {
            return categories
        }
        
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: currentDate)
        let adjustedIndex = (weekdayNumber + 5) % 7
        guard let currentWeekday = WeekDays(rawValue: adjustedIndex) else {
            return []
        }
        
        return categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                if tracker.schedule.isEmpty { return true }
                return tracker.schedule.contains(currentWeekday)
            }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
    }
    
    func trackerCellDidTapComplete(_ cell: TrackerCell, isCompleted: Bool) {
        guard let indexPath = viewController?.trackersCollectionView.indexPath(for: cell) else { return }
        let tracker = filteredCategories()[indexPath.section].trackers[indexPath.item]
        let date = currentDate ?? Date()
        
        do {
            if isCompleted {
                try trackerRecordStore.addRecord(TrackerRecord(id: tracker.id, date: date))
            } else {
                try trackerRecordStore.removeRecord(for: tracker.id, on: date)
            }
        } catch {
            print("Ошибка при обновлении статуса выполнения: \(error)")
        }
        
        reload()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories().count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories()[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.trackerCellIdentifier, for: indexPath) as? TrackerCell else {
            fatalError("Не удалось привести ячейку к типу TrackerCell")
        }
        cell.prepareForReuse()
        cell.delegate = self
        
        let tracker = filteredCategories()[indexPath.section].trackers[indexPath.item]
        let current = currentDate ?? Date()
        
        let isCompleted = completedTrackers.contains {
            $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: current)
        }
        cell.isCompleted = isCompleted
        
        cell.configure(
            id: tracker.id,
            color: tracker.color,
            name: tracker.name,
            emoji: tracker.emoji,
            count: String(completedTrackers.filter { $0.id == tracker.id }.count)
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerIdentifier, for: indexPath)
        if kind == UICollectionView.elementKindSectionHeader {
            let label = UILabel()
            label.text = filteredCategories()[indexPath.section].title
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: Constants.defaultPadding),
                label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
            ])
        }
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2 - 5, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 42)
    }
}
