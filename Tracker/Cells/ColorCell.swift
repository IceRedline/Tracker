//
//  ColorCell.swift
//  Tracker
//
//  Created by Артем Табенский on 11.04.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    let colorStrokeView: UIView = {
        let view = UIView()
        view.alpha = 0.3
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorStrokeView)
        contentView.addSubview(colorView)
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            colorStrokeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorStrokeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorStrokeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorStrokeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
