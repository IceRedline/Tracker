//
//  TrackerCell.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    var cellID: UInt?
    let colorView = UIView()
    let nameLabel = UILabel()
    let emojiLabel = UILabel()
    let dayCountLabel = UILabel()
    let completedButton = UIButton()
    
    var isCompleted: Bool = false {
        didSet {
            let imageName = isCompleted ? "checkmark" : "plus"
            completedButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        colorView.layer.cornerRadius = 16
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        emojiLabel.backgroundColor = .background
        emojiLabel.font = UIFont.systemFont(ofSize: 12)
        emojiLabel.textAlignment = .center
        emojiLabel.clipsToBounds = true
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(emojiLabel)
        
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(nameLabel)
        
        dayCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        dayCountLabel.textAlignment = .left
        dayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayCountLabel)
        
        isCompleted ? completedButton.setImage(UIImage(systemName: "checkmark"), for: .normal) : completedButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completedButton.layer.cornerRadius = 16
        completedButton.tintColor = .ypWhite
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completedButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 95),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            nameLabel.widthAnchor.constraint(equalToConstant: 143),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            
            dayCountLabel.widthAnchor.constraint(equalToConstant: 101),
            dayCountLabel.heightAnchor.constraint(equalToConstant: 18),
            dayCountLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            dayCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            completedButton.widthAnchor.constraint(equalToConstant: 34),
            completedButton.heightAnchor.constraint(equalToConstant: 34),
            completedButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            completedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
    
    func configure(id: UInt, color: UIColor, name: String, emoji: String, count: String) {
        cellID = id
        colorView.backgroundColor = color
        nameLabel.text = name
        emojiLabel.text = emoji
        completedButton.backgroundColor = color
        completedButton.alpha = isCompleted ? 0.3 : 1
        
        switch count.last {
        case "0":
            dayCountLabel.text = "\(count) дней"
        case "1":
            dayCountLabel.text = "\(count) день"
        case "2":
            dayCountLabel.text = "\(count) дня"
        case "3":
            dayCountLabel.text = "\(count) дня"
        case "4":
            dayCountLabel.text = "\(count) дня"
        case "5":
            dayCountLabel.text = "\(count) дней"
        case "6":
            dayCountLabel.text = "\(count) дней"
        case "7":
            dayCountLabel.text = "\(count) дней"
        case "8":
            dayCountLabel.text = "\(count) дней"
        case "9":
            dayCountLabel.text = "\(count) дней"
        default: return
        }
        
        completedButton.addTarget(self, action: #selector(trackerCompletedTapped(_:)), for: .touchUpInside)
    }
    
    @objc func trackerCompletedTapped(_ sender: UIButton) {
        if TrackersCollectionService.shared.currentDate ?? Date() > Date() {
            return
        }
        if isCompleted {
            isCompleted = false
            completedButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completedButton.alpha = 1
        } else {
            isCompleted = true
            completedButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completedButton.alpha = 0.3
        }
        delegate?.trackerCellDidTapComplete(self, isCompleted: isCompleted)
    }
}
