//
//  TrackerCell.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    var cellID: UUID?
    let colorView = UIView()
    let nameLabel = UILabel()
    let emojiLabel = UILabel()
    let daysCountLabel = UILabel()
    let completedButton = UIButton()
    let pinImageView = UIImageView()
    
    var isCompleted: Bool = false {
        didSet {
            let imageName = isCompleted ? "checkmark" : "plus"
            completedButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completedButton.addTarget(self, action: #selector(trackerCompletedTapped(_:)), for: .touchUpInside)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        colorView.layer.cornerRadius = Constants.cornerRadius
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        emojiLabel.backgroundColor = .background.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        emojiLabel.font = UIFont.systemFont(ofSize: 12)
        emojiLabel.textAlignment = .center
        emojiLabel.clipsToBounds = true
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(emojiLabel)
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.addSubview(nameLabel)
        
        daysCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        daysCountLabel.textAlignment = .left
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(daysCountLabel)
        
        updateCompletedButtonAppearance()
        
        completedButton.layer.cornerRadius = Constants.cornerRadius
        completedButton.tintColor = .ypWhite
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(completedButton)
        
        pinImageView.image = .pin
        pinImageView.isHidden = true
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pinImageView)
    }
    
    private func updateCompletedButtonAppearance() {
        let imageName = isCompleted ? "checkmark" : "plus"
        completedButton.setImage(UIImage(systemName: imageName), for: .normal)
        completedButton.alpha = isCompleted ? 0.3 : 1
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
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            
            daysCountLabel.widthAnchor.constraint(equalToConstant: 101),
            daysCountLabel.heightAnchor.constraint(equalToConstant: 18),
            daysCountLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: Constants.defaultPadding),
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.defaultPadding),
            
            completedButton.widthAnchor.constraint(equalToConstant: 34),
            completedButton.heightAnchor.constraint(equalToConstant: 34),
            completedButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            completedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            pinImageView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 18),
            pinImageView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
        ])
    }
    
    func configure(id: UUID, color: UIColor, name: String, emoji: String, count: Int) {
        cellID = id
        colorView.backgroundColor = color
        nameLabel.text = name
        emojiLabel.text = emoji
        completedButton.backgroundColor = color
        completedButton.alpha = isCompleted ? 0.3 : 1
        
        daysCountLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: ""), count)
    }
    
    @objc func trackerCompletedTapped(_ sender: UIButton) {
        if TrackersCollectionService.shared.currentDate ?? Date() > Date() {
            return
        }
        if isCompleted {
            updateCompletedButtonAppearance()
            isCompleted = false
        } else {
            updateCompletedButtonAppearance()
            isCompleted = true
        }
        delegate?.trackerCellDidTapComplete(self, isCompleted: isCompleted)
        
        AnalyticsService.shared.report(event: "click", screen: "Main", item: "track")
    }
}
