//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Артем Табенский on 18.05.2025.
//

import UIKit

final class StatisticsCell: UICollectionViewCell {
    
    let gradient = CAGradientLayer()
    let shape = CAShapeLayer()
    let view = UIView()
    let nameLabel = UILabel()
    let countLabel = UILabel()
    
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
        DispatchQueue.main.async {
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
    }
    
    private func setupViews() {
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = Constants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        gradient.colors = [
            UIColor.colorSelection1.cgColor,
            UIColor.colorSelection9.cgColor,
            UIColor.colorSelection3.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Настройка shape
        shape.fillColor = UIColor.black.cgColor
        shape.lineWidth = 0
        shape.strokeColor = UIColor.black.cgColor
        gradient.mask = shape
        
        view.layer.insertSublayer(gradient, at: 0)
        
        nameLabel.textColor = .ypBlack
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        countLabel.textColor = .ypBlack
        countLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        countLabel.textAlignment = .left
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultPadding),
            countLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultPadding),
            countLabel.heightAnchor.constraint(equalToConstant: 41),
            countLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.defaultPadding),
            
            nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            nameLabel.widthAnchor.constraint(equalToConstant: 143),
            nameLabel.heightAnchor.constraint(equalToConstant: 34),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    
    func configure(title: String, count: Int) {
        nameLabel.text = title
        countLabel.text = String(count)
    }
}
