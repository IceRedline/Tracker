//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Артем Табенский on 18.05.2025.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    let filters = [FilterType.all, FilterType.today, FilterType.completed, FilterType.incomplete]
    
    let filtersTableView = UITableView()
    var selectedFilter: FilterType
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("filters", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    init(selectedFilter: FilterType) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupView()
        setupTableView()
        setupConstraints()
    }
    
    private func setupView() {
        modalPresentationStyle = .currentContext
        view.backgroundColor = .ypWhite
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(filtersTableView)
        
    }
    
    private func setupTableView() {
        filtersTableView.register(CategoryAndFilterTableViewCell.self, forCellReuseIdentifier: CategoryAndFilterTableViewCell.reuseIdentifier)
        filtersTableView.backgroundColor = .ypWhite
        filtersTableView.layer.cornerRadius = Constants.cornerRadius
        filtersTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            filtersTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(Constants.defaultPadding * 2)),
            filtersTableView.heightAnchor.constraint(equalToConstant: 525),
            filtersTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersTableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
        ])
    }
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 4 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryAndFilterTableViewCell.reuseIdentifier, for: indexPath) as? CategoryAndFilterTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .background
        
        let filter = filters[indexPath.row]
        cell.configure(with: filter.localizedName, isSelected: filter.localizedName == selectedFilter.localizedName)
        
        if indexPath.row == filters.count - 1 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = Constants.cornerRadius
            cell.layer.masksToBounds = true
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.layer.cornerRadius = 0
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilter = filters[indexPath.row]
        print("выбран фильтр: \(selectedFilter)")
        TrackersCollectionService.shared.currentFilter = selectedFilter
        
        if selectedFilter == FilterType.today {
            NotificationCenter.default.post(name: .setTodayDate, object: nil)
        }
        
        dismiss(animated: true)
    }
}
