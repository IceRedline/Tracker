//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 29.03.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    let statisticsCollectionService = StatisticsCollectionService.shared
    
    private lazy var emojiImage: UIImageView = {
        let view = UIImageView()
        let image = UIImage.sadEmoj
        view.image = image
        return view
    }()
    
    private lazy var nothingToTrackLabel: UILabel = {
        let label = UILabel()
        label.text =  NSLocalizedString("nothingToTrack", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var statisticsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        statisticsCollectionService.loadCompletedTrackers()
        statisticsCollectionService.viewController = self
        
        setupCollectionView()
        loadConstraints()
    }
    
    private func setupCollectionView() {
        statisticsCollectionView.backgroundColor = .ypWhite
        statisticsCollectionView.delegate = statisticsCollectionService
        statisticsCollectionView.dataSource = statisticsCollectionService
        statisticsCollectionView.register(StatisticsCell.self, forCellWithReuseIdentifier: Constants.statisticsCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statisticsCollectionService.reload()
    }
    
    func hideCollection() {
        statisticsCollectionView.isHidden = true
    }
    
    func showCollection() {
        statisticsCollectionView.isHidden = false
    }
    
    private func loadConstraints() {
        [emojiImage ,nothingToTrackLabel, statisticsCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            emojiImage.widthAnchor.constraint(equalToConstant: 80),
            emojiImage.heightAnchor.constraint(equalToConstant: 80),
            emojiImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            nothingToTrackLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(Constants.defaultPadding * 2)),
            nothingToTrackLabel.heightAnchor.constraint(equalToConstant: 18),
            nothingToTrackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingToTrackLabel.topAnchor.constraint(equalTo: emojiImage.bottomAnchor, constant: 8),
            statisticsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            statisticsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultPadding),
            statisticsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultPadding),
            statisticsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding)
        ])
    }
}
