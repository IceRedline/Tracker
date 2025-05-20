//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Артем Табенский on 18.05.2025.
//

import UIKit

final class StatisticsCell: UICollectionViewCell {
    
    private let gradient = CAGradientLayer()
    private let shape = CAShapeLayer()
    private let backgroundColorView = UIView()
    private let nameLabel = UILabel()
    private let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    private func updateGradientFrame() {
        let borderWidth: CGFloat = 1
        self.gradient.frame = self.contentView.bounds
        
        let outerPath = UIBezierPath(
            roundedRect: self.contentView.bounds,
            cornerRadius: Constants.cornerRadius
        )
        
        let innerPath = UIBezierPath(
            roundedRect: self.contentView.bounds.insetBy(dx: borderWidth, dy: borderWidth),
            cornerRadius: Constants.cornerRadius - borderWidth
        )
        
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true
        
        self.shape.path = outerPath.cgPath
        self.shape.fillRule = .evenOdd
    }
    
    private func setupViews() {
        backgroundColorView.backgroundColor = .ypWhite
        backgroundColorView.layer.cornerRadius = Constants.cornerRadius
        backgroundColorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundColorView)
        
        setupGradient()
        
        nameLabel.textColor = .ypBlack
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorView.addSubview(nameLabel)
        
        countLabel.textColor = .ypBlack
        countLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        countLabel.textAlignment = .left
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorView.addSubview(countLabel)
    }
    
    private func setupGradient() {
        gradient.colors = [
            UIColor.colorSelection1.cgColor,
            UIColor.colorSelection9.cgColor,
            UIColor.colorSelection3.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)

        shape.fillColor = UIColor.black.cgColor
        shape.lineWidth = 0
        shape.strokeColor = UIColor.black.cgColor
        gradient.mask = shape

        backgroundColorView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundColorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: Constants.defaultPadding),
            countLabel.trailingAnchor.constraint(equalTo: backgroundColorView.trailingAnchor, constant: -Constants.defaultPadding),
            countLabel.heightAnchor.constraint(equalToConstant: 41),
            countLabel.topAnchor.constraint(equalTo: backgroundColorView.topAnchor, constant: Constants.defaultPadding),
            
            nameLabel.bottomAnchor.constraint(equalTo: backgroundColorView.bottomAnchor, constant: -12),
            nameLabel.widthAnchor.constraint(equalToConstant: 143),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundColorView.leadingAnchor, constant: 16),
        ])
    }
    
    func configure(title: String, count: Int) {
        nameLabel.text = title
        countLabel.text = String(count)
    }
}
