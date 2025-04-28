//
//  EmojiCollectionService.swift
//  Tracker
//
//  Created by Артем Табенский on 03.04.2025.
//

import UIKit

class EmojiCollectionService: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let emojis: Array<String> = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    var chosenEmoji: String?
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell else {
            fatalError("Не удалось привести ячейку к типу EmojiCell")
        }
        cell.emojiLabel.text = emojis[indexPath.item]
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenEmoji = emojis[indexPath.item]
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.contentView.layer.cornerRadius = 16
        UIView.animate(withDuration: 0.2) {
            cell.contentView.backgroundColor = .ypLightGray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.2) {
            cell.contentView.backgroundColor = .clear
        }
    }
    
    // MARK: - UICollectionDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
    
}
