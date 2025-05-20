
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
    var searchText = ""
    var currentFilter: FilterType = FilterType.all {
        didSet {
            reload()
        }
    }
    
    private override init() {}
    
    func reload() {
        loadCategories()
        loadCompletedTrackers()
        
        let filtered = filteredCategories()
        
        if filtered.isEmpty {
            viewController?.hideCollection()
            if currentFilter == FilterType.all && searchText.isEmpty {
                viewController?.hidefilters()
                viewController?.hideNothingFoundView()
            } else {
                viewController?.showNothingFoundView()
            }
        } else {
            viewController?.showCollectionAndFilters()
            viewController?.hideNothingFoundView()
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
    
    func deleteTracker(at indexPath: IndexPath) {
        do {
            let trackerID = filteredCategories()[indexPath.section].trackers[indexPath.item].id
            try trackerStore.deleteTracker(with: trackerID)
            
            reload()
            
        } catch {
            print("Ошибка удаления трекера: \(error)")
        }
    }
    
    private func filteredCategories() -> [TrackerCategory] {
        let calendar = Calendar.current
        let selectedDate = currentDate ?? Date()
        
        let weekdayNumber = calendar.component(.weekday, from: selectedDate)
        let adjustedIndex = (weekdayNumber + 5) % 7
        guard let currentWeekday = WeekDays(rawValue: adjustedIndex) else { return [] }
        
        let searchLowercased = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        return categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let matchesSchedule = tracker.schedule.isEmpty || tracker.schedule.contains(currentWeekday)
                let isCompleted = completedTrackers.contains {
                    $0.id == tracker.id && calendar.isDate($0.date, inSameDayAs: selectedDate)
                }
                let matchesSearch = searchLowercased.isEmpty || tracker.name.lowercased().contains(searchLowercased)
                
                switch currentFilter {
                case FilterType.today:
                    return matchesSchedule && matchesSearch
                    
                case FilterType.completed:
                    return isCompleted && matchesSchedule && matchesSearch
                    
                case FilterType.incomplete:
                    return !isCompleted && matchesSchedule && matchesSearch
                    
                default:
                    return matchesSchedule && matchesSearch
                }
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
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCategoryChange),
            name: .categoryDidChange,
            object: nil
        )
    }
    
    @objc private func handleCategoryChange() {
        reload()
    }
    
    private func pinTracker(for indexPath: IndexPath) {
        var tracker = filteredCategories()[indexPath.section].trackers[indexPath.item]
        let isPinned = filteredCategories()[indexPath.section].title == "Закрепленные"
        let originalCategory = tracker.originalCategory
        
        print("Вызван трекер, закрепление: \(isPinned)")
        
        switch isPinned {
        case true:
            tracker.originalCategory = nil
            print("Сброшена ориг категория")
            
        case false:
            tracker.originalCategory = filteredCategories()[indexPath.section].title
            print("назначена ориг категория перед закреплением")
        }
        
        do {
            let categoryTitle = isPinned ? (originalCategory ?? "Без категории") : "Закрепленные"
            print("Трекер будет помещен в категорию \(categoryTitle)")
            let categoryData = try TrackerCategoryStore.shared.findOrCreateCategory(with: categoryTitle)
            
            try TrackerStore.shared.addNewTracker(tracker, to: categoryData)
            
        } catch {
            print("Ошибка сохранения: \(error)")
        }
        
        deleteTracker(at: indexPath)
        
        TrackersCollectionService.shared.reload()
        reload()
    }
    
    private func showEditViewController(for indexPath: IndexPath) {
        let tracker = filteredCategories()[indexPath.section].trackers[indexPath.item]
        let trackerID = tracker.id
        let count = completedTrackers.filter { $0.id == trackerID }.count
        let stringCount = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: ""), count)
        let categoryName = filteredCategories()[indexPath.section].title
        
        let editVC = EditTrackerViewController(
            trackerID: trackerID,
            daysCount: stringCount,
            trackerTitle: tracker.name,
            schedule: tracker.schedule,
            selectedCategory: categoryName,
            color: tracker.color,
            emoji: tracker.emoji
        )
        viewController?.present(editVC, animated: true)
        
        AnalyticsService.shared.report(event: "click", screen: "Main", item: "edit")
    }
    
    private func showDeleteConfirmation(for indexPath: IndexPath) {
        deleteTracker(at: indexPath)
        
        AnalyticsService.shared.report(event: "click", screen: "Main", item: "delete")
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
        let trackerCategory = filteredCategories()[indexPath.section].title
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
            count: completedTrackers.filter { $0.id == tracker.id }.count
        )
        
        
        cell.pinImageView.isHidden = trackerCategory == "Закрепленные" ? false : true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerIdentifier, for: indexPath)
        
        header.subviews.forEach { $0.removeFromSuperview() }
        
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
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let categoryName = filteredCategories()[indexPath.section].title
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: categoryName == "Закрепленные" ? NSLocalizedString("unpin", comment: "") : NSLocalizedString("pin", comment: "")) { [weak self] _ in
                    self?.pinTracker(for: indexPath)
                },
                UIAction(title: NSLocalizedString("edit", comment: "")) { [weak self] _ in
                    self?.showEditViewController(for: indexPath)
                },
                UIAction(title: NSLocalizedString("delete", comment: ""), attributes: .destructive) { [weak self] _ in
                    self?.showDeleteConfirmation(for: indexPath)
                },
            ])
        })
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
