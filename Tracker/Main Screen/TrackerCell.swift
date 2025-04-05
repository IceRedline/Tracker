//
//  TrackerCell.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

class TrackerCell: UICollectionViewCell {
    private let colorView = UIView()
    private let nameLabel = UILabel()
    private let emojiLabel = UILabel()
    private let dayCountLabel = UILabel()
    private let completedButton = UIButton()
    
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
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.layer.cornerRadius = 68
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
        
        completedButton.setImage(UIImage(named: "trackerCompletedButton"), for: .normal)
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completedButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 167),
            colorView.heightAnchor.constraint(equalToConstant: 90),
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
    
    func configure(color: UIColor, name: String, emoji: String, count: String) {
        colorView.backgroundColor = color
        nameLabel.text = name
        emojiLabel.text = emoji
        completedButton.imageView?.tintColor = color
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
    }
}
