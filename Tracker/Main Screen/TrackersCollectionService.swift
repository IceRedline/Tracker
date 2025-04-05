//
//  TrackersCollectionService.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

class TrackersCollectionService: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let trackers: Array<Tracker> = [Tracker(id: 1, name: "Поливать растения", color: .colorSelection5, emoji: "❤️", schedule: ["Понедельник", "Вторник"])]
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCell
        cell?.prepareForReuse()
        cell?.backgroundColor = .systemGray4
        
        cell?.configure(color: trackers[indexPath.item].color,
                        name: trackers[indexPath.item].name,
                        emoji: trackers[indexPath.item].emoji,
                        count: String(trackers[indexPath.item].schedule.count)
        )
        
        return cell!
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
    
}

#Preview(traits: .defaultLayout, body: {
    TabBarController()
})
