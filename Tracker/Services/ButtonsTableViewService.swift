//
//  TableViewService.swift
//  Tracker
//
//  Created by Артем Табенский on 03.04.2025.
//

import UIKit

final class ButtonsTableViewService: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var viewController: NewTrackerViewController?
    
    let trackerButtonsTexts = ["Категория", "Расписание"]
    let irregularActionButtonTexts = ["Категория"]
    var chosenType: String
    
    init(chosenType: String) {
        self.chosenType = chosenType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chosenType == "Новая привычка" ? trackerButtonsTexts.count : irregularActionButtonTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.categoryCellIdentifier)
        cell.backgroundColor = .background
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = trackerButtonsTexts[indexPath.row]
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .ypGray
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(chevronImageView)
        cell.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: Constants.defaultPadding),
            titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -22),
            chevronImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: viewController?.openCategoryController()
        case 1: viewController?.openScheduleController()
        default: return
        }
    }
}
