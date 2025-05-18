//
//  ViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 28.03.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    var currentDate: Date?
    let trackersCollectionService = TrackersCollectionService.shared
    
    private lazy var searchField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.placeholder = NSLocalizedString("search", comment: "")
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.12))
        textField.layer.cornerRadius = 10
        
        let imageView = UIImageView(image: UIImage.magnifyingglass)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: textField.frame.height))
        imageView.frame = CGRect(x: 10, y: -7, width: 15, height: 15)
        imageView.contentMode = .scaleAspectFit
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var starImage: UIImageView = {
        let view = UIImageView()
        let image = UIImage.star
        view.image = image
        return view
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text =  NSLocalizedString("whatToTrack", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nothingFoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        let image = UIImageView(image: .thinkingEmoji)
        let label = UILabel()
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ничего не найдено"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.addSubview(image)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: view.topAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor),
        ])
        view.isHidden = true
        return view
    }()
    
    lazy var trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackersCollectionService.viewController = self
        trackersCollectionService.currentDate = Date()
        trackersCollectionService.reload()
        trackersCollectionView.delegate = trackersCollectionService
        trackersCollectionView.dataSource = trackersCollectionService
        trackersCollectionView.register(TrackerCell.self, forCellWithReuseIdentifier: Constants.trackerCellIdentifier)
        trackersCollectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.headerIdentifier
        )
        trackersCollectionView.allowsMultipleSelection = false
        
        loadViews()
        loadConstraints()
        //hideNothingFoundView()
    }
    
    func hideCollection() {
        trackersCollectionView.isHidden = true
    }
    func hidefilters() {
        filtersButton.isHidden = true
    }
    
    func showNothingFoundView() {
        nothingFoundView.isHidden = false
    }
    
    func hideNothingFoundView() {
        nothingFoundView.isHidden = true
    }
    
    func showCollectionAndFilters() {
        trackersCollectionView.isHidden = false
        filtersButton.isHidden = false
    }
    
    private func loadViews() {
        view.backgroundColor = .ypWhite
        trackersCollectionView.backgroundColor = .ypWhite
        [searchField ,starImage, questionLabel, trackersCollectionView, filtersButton, nothingFoundView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func loadConstraints() {
        NSLayoutConstraint.activate([
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultPadding),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultPadding),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            questionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(Constants.defaultPadding * 2)),
            questionLabel.heightAnchor.constraint(equalToConstant: 18),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            trackersCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 30),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultPadding),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultPadding),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultPadding),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            nothingFoundView.widthAnchor.constraint(equalToConstant: 340),
            nothingFoundView.heightAnchor.constraint(equalToConstant: 120),
            nothingFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingFoundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
        ])
    }
    
    @objc func textDidChange(_ searchField: UISearchTextField) {
        if let text = searchField.text {
            trackersCollectionService.searchText = text
        }
        trackersCollectionService.reload()
    }
    
    @objc func filterButtonTapped() {
        let filtersVC = FiltersViewController(selectedCategory: trackersCollectionService.currentFilter)
        print(trackersCollectionService.currentFilter)
        present(filtersVC, animated: true)
    }
}

#Preview(body: {
    TabBarController()
})
