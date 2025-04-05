//
//  ScheduleTableViewService.swift
//  Tracker
//
//  Created by Артем Табенский on 04.04.2025.
//

import UIKit

class ScheduleTableViewService: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let dayNames = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { dayNames.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dayCell")
        cell.backgroundColor = .background
        
        let titleLabel = UILabel()
        titleLabel.text = dayNames[indexPath.row]
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(titleLabel)
        
        let switchView = UISwitch()
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
        ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc private func switchChanged(_ sender: UISwitch!) {
        print("Переключен switch с тэгом \(sender.tag)")
    }
}
