//
//  StatisticsCollectionService.swift
//  Tracker
//
//  Created by Артем Табенский on 18.05.2025.
//

import UIKit

class StatisticsCollectionService: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let shared = StatisticsCollectionService()
    private let trackerRecordStore = TrackerRecordStore()
    
    weak var viewController: StatisticsViewController?
    
    private var completedTrackers: [TrackerRecord] = []
    
    private override init() {}
    
    func reload() {
        loadCompletedTrackers()
        if completedTrackers.isEmpty {
            viewController?.hideCollection()
        } else {
            viewController?.showCollection()
        }
        viewController?.statisticsCollectionView.reloadData()
    }
    
    func loadCompletedTrackers() {
        do {
            completedTrackers = try trackerRecordStore.fetchAll()
        } catch {
            print("Ошибка при загрузке выполненных трекеров: \(error)")
            completedTrackers = []
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.statisticsCellIdentifier, for: indexPath) as? StatisticsCell else {
            fatalError("Не удалось привести ячейку к типу StatisticsCell")
        }
        cell.prepareForReuse()
        
        cell.configure(title: "Трекеров завершено", count: completedTrackers.count)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 100)
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



