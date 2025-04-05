//
//  TrackersCollectionService.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

class TrackersCollectionService: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, TrackerCellDelegate {
    
    static let shared = TrackersCollectionService()
    
    weak var viewController: TrackersViewController?
    
    var categories: [TrackerCategory] = [TrackerCategory(title: "Домашний уют", trackers: [Tracker(id: 1, name: "Поливать растения", color: .colorSelection5, emoji: "❤️", schedule: ["Понедельник", "Вторник"])])]
    var completedTrackers: [TrackerRecord] = []
    
    private override init() {}
    
    func reload() {
        viewController?.trackersCollectionView.reloadData()
    }
    
    func trackerCellDidTapComplete(_ cell: TrackerCell, isCompleted: Bool) {
        guard let indexPath = viewController?.trackersCollectionView.indexPath(for: cell) else { return }
        
        switch isCompleted {
        case true:
            completedTrackers.append(TrackerRecord(id: categories[0].trackers[indexPath.item].id, date: Date()))
        case false:
            completedTrackers.remove(at: indexPath.item)
        }
        reload()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[0].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCell
        cell?.prepareForReuse()
        cell?.delegate = self
        
        cell?.configure(id: categories[0].trackers[indexPath.item].id,
                        color: categories[0].trackers[indexPath.item].color,
                        name: categories[0].trackers[indexPath.item].name,
                        emoji: categories[0].trackers[indexPath.item].emoji,
                        count: String( completedTrackers.count(where: {$0.id == categories[0].trackers[indexPath.item].id}))
        )
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        if kind == UICollectionView.elementKindSectionHeader {
            let label = UILabel()
            label.text = categories[0].title
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
                label.centerYAnchor.constraint(equalTo: header.centerYAnchor)
            ])
        }
        
        return header
    }
    
    // MARK: - UICollectionDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: 42)
    }
}



#Preview(traits: .defaultLayout, body: {
    TabBarController()
})
