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
    
    var currentDate: Date?
    
    var categories: [TrackerCategory] = [TrackerCategory(title: "Домашний уют", trackers: [Tracker(id: UUID(), name: "Поливать растения", color: .colorSelection5, emoji: "❤️", schedule: [WeekDays.monday, WeekDays.tuesday])])]
    var completedTrackers: [TrackerRecord] = []
    
    private override init() {}
    
    func reload() {
        viewController?.trackersCollectionView.reloadData()
    }
    
    func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        var newCategories = categories
        
        if let index = newCategories.firstIndex(where: { $0.title == title }) {
            let existingCategory = newCategories[index]
            let updatedTrackers = existingCategory.trackers + [tracker]
            newCategories[index] = TrackerCategory(title: title, trackers: updatedTrackers)
        } else {
            let newCategory = TrackerCategory(title: title, trackers: [tracker])
            newCategories.append(newCategory)
        }
        
        categories = newCategories
        reload()
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
            if filteredTrackers.isEmpty {
                viewController?.hideCollection()
            } else {
                viewController?.showCollection()
            }
            return filteredTrackers.isEmpty ? nil :
            TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
    }
    
    func trackerCellDidTapComplete(_ cell: TrackerCell, isCompleted: Bool) {
        guard let indexPath = viewController?.trackersCollectionView.indexPath(for: cell) else { return }
        
        let date = currentDate ?? Date()
        let trackerID = filteredCategories()[indexPath.section].trackers[indexPath.item].id
        
        if isCompleted {
            completedTrackers.append(TrackerRecord(id: trackerID, date: Calendar.current.startOfDay(for: date)))
        } else {
            completedTrackers.removeAll {
                $0.id == trackerID && Calendar.current.isDate($0.date, inSameDayAs: date)
            }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.trackerCellIdentifier, for: indexPath) as! TrackerCell
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
        let currentCategory = filteredCategories()[indexPath.section]
        if kind == UICollectionView.elementKindSectionHeader {
            let label = UILabel()
            label.text = currentCategory.title
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
    
    // MARK: - UICollectionDelegateFlowLayout
    
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
