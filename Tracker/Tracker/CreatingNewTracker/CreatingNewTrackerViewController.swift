//
//  CreatingNewTracker.swift
//  Tracker
//
//  Created by Alexandr Seva on 03.10.2023.
//

import UIKit

// MARK: - CreatingNewTrackerViewController
final class CreatingNewTrackerViewController: UIViewController {
    weak var delegate: TrackerCreationDelegate?
    private let analyticsService = AnalyticsService()
    
    //MARK: - UiElements
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
        let button = addActionsForButton(title: title, action: #selector(creatingHabit))
        button.accessibilityIdentifier = "creatingHabitButton"
        return button
    }()
    
    private lazy var creatingIrregularEventButton: UIButton = {
        let title = "Нерегулярные событие"
        let button = addActionsForButton(title: title, action: #selector(creatingIrregularEvent))
        button.accessibilityIdentifier = "createIrregularEventButton"
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
        analyticsService.report(event: .open, params: ["Screen" : "CreatingNewTracker"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: .close, params: ["Screen" : "CreatingNewTracker"])
    }
    
    // MARK: - Actions
    @objc
    private func creatingHabit() {
        let createHabitViewController = CreatingHabitViewController()
        createHabitViewController.delegate = self.delegate
        let navigationController = UINavigationController(rootViewController: createHabitViewController)
        analyticsService.report(event: .click, params: ["Screen" : "CreatingHabitViewController"])
        present(navigationController, animated: true)
    }
    
    @objc
    private func creatingIrregularEvent() {
        let createIrregularEventViewController = CreatingIrregularEventViewController()
        createIrregularEventViewController.delegate = self.delegate
        let navigationController = UINavigationController(rootViewController: createIrregularEventViewController)
        analyticsService.report(event: .click, params: ["Screen" : "CreatingIrregularEventViewController"])
        present(navigationController, animated: true)
    }
    
    //MARK: - Private methods
    private func configViews() {
        view.backgroundColor = .whiteDay
        view.addSubview(creatingTrackerLabel)
        view.addSubview(creatingHabitButton)
        view.addSubview(creatingIrregularEventButton)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            creatingTrackerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creatingTrackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            creatingHabitButton.heightAnchor.constraint(equalToConstant: 60),
            creatingHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            creatingHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            creatingHabitButton.topAnchor.constraint(equalTo: creatingTrackerLabel.bottomAnchor, constant: 281),
            creatingIrregularEventButton.topAnchor.constraint(equalTo: creatingHabitButton.bottomAnchor, constant: 16),
            creatingIrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
            creatingIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            creatingIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func addActionsForButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.whiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
