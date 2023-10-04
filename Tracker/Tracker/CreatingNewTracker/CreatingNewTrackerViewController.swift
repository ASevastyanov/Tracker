//
//  CreatingNewTracker.swift
//  Tracker
//
//  Created by Alexandr Seva on 03.10.2023.
//

import UIKit

// MARK: - CreatingNewTrackerViewController
final class CreatingNewTrackerViewController: UIViewController {
    
    private lazy var creatingTrackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "Создание трекера"
        trackerLabel.textColor = .blackDay
        trackerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    private lazy var creatingHabitButton: UIButton = {
        let title = "Привычка"
        let button = addActionsForButton(title: title)
        button.addTarget(self, action: #selector(self.creatingHabit), for: .touchUpInside)
        button.accessibilityIdentifier = "creatingHabitButton"
        return button
    }()
    
    private lazy var createIrregularEventButton: UIButton = {
        let title = "Нерегулярные событие"
        let button = addActionsForButton(title: title)
        button.addTarget(self, action: #selector(self.createIrregularEvent), for: .touchUpInside)
        button.accessibilityIdentifier = "createIrregularEventButton"
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
    }
    
    // MARK: - Actions
    @objc
    private func creatingHabit() {
    }
    
    @objc
    private func createIrregularEvent() {
    }
    
    //MARK: - Private methods
    private func configViews() {
        view.backgroundColor = .whiteDay
        view.addSubview(creatingTrackerLabel)
        view.addSubview(creatingHabitButton)
        view.addSubview(createIrregularEventButton)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            creatingTrackerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creatingTrackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            creatingHabitButton.heightAnchor.constraint(equalToConstant: 60),
            creatingHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            creatingHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            creatingHabitButton.topAnchor.constraint(equalTo: creatingTrackerLabel.bottomAnchor, constant: 281),
            createIrregularEventButton.topAnchor.constraint(equalTo: creatingHabitButton.bottomAnchor, constant: 16),
            createIrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            createIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func addActionsForButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.whiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
