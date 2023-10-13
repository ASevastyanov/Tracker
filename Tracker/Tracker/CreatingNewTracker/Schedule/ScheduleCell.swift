//
//  CategoryCell.swift
//  Tracker
//
//  Created by Alexandr Seva on 09.10.2023.
//

import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func didToogleSwitch(for day: String, switchActiv: Bool)
}

final class ScheduleCell: UITableViewCell {
    weak var delegate: ScheduleCellDelegate?
    
    //MARK: - UiElements
    private let scheduleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackDay
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var switchDay: UISwitch = {
        let switchDay = UISwitch()
        switchDay.onTintColor = .blueYP
        switchDay.translatesAutoresizingMaskIntoConstraints = false
        switchDay.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        return switchDay
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .backgroundDay
        configViews()
        configConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Action
    @objc func switchAction(_ sender: UISwitch) {
        guard let nameDay = scheduleLabel.text else { return }
        if switchDay.isOn {
            delegate?.didToogleSwitch(for: nameDay, switchActiv: true)
        } else {
            delegate?.didToogleSwitch(for: nameDay, switchActiv: false)
        }
    }
    
    // MARK: - Methods
    func configureCell(with text: String, isSwitchOn: Bool) {
        scheduleLabel.text = text
        switchDay.setOn(isSwitchOn, animated: true)
    }
    
    // MARK: - Private methods
    private func configViews() {
        contentView.addSubview(scheduleLabel)
        contentView.addSubview(switchDay)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            scheduleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            scheduleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchDay.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchDay.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            switchDay.heightAnchor.constraint(equalToConstant: 31),
            switchDay.widthAnchor.constraint(equalToConstant: 51),
        ])
    }
}

