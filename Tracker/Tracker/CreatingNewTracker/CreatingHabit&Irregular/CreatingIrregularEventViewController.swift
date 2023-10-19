//
//  CreatingIrregularEventViewController.swift
//  Tracker
//
//  Created by Alexandr Seva on 04.10.2023.
//

import UIKit

protocol CreatingIrregularEventViewControllerDelegate: AnyObject {
    func updateSubitle(nameSubitle: String)
}

// MARK: - CreatingHabitViewController
final class CreatingIrregularEventViewController: UIViewController {
    private let dataSorege = DataStorege.shared
    private var countButtonForTableView = [("Категория", "")]
    private let characterLimitInField = 38
    private let color: UIColor = .colorSelection.randomElement()!
    weak var delegate: TrackerCreationDelegate?
    
    //MARK: - UiElements
    private var tableView: UITableView = .init()
    
    private lazy var newHabitLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "Новое нерегулярное событие"
        trackerLabel.textColor = .blackDay
        trackerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        let textField = UITextField()
        textField.indent(size: 16)
        textField.placeholder = "Введите название трекера"
        textField.textColor = .blackDay
        textField.backgroundColor = .backgroundDay
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        UITextField.appearance().clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .redYP
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .justified
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.cancelCreation), for: .touchUpInside)
        button.accessibilityIdentifier = "cancelButton"
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.redYP, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.redYP.cgColor
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var creatingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.create), for: .touchUpInside)
        button.accessibilityIdentifier = "creatingButton"
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.whiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .grayYP
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSorege.removeIndexPathForCheckmark()
        configViews()
        configTableView()
        configConstraints()
    }
    
    // MARK: - Actions
    @objc func textFieldChanged() {
        guard let numberOfCharacters = nameTrackerTextField.text?.count else { return }
        if numberOfCharacters < characterLimitInField{
            errorLabel.isHidden = true
            updateCreatingButton()
        } else {
            errorLabel.isHidden = false
        }
    }
    
    @objc
    private func cancelCreation() {
        dismiss(animated: true)
    }
    
    @objc
    private func create() {
        guard let text = nameTrackerTextField.text else { return }
        let newTracker = Tracker(id: UUID(), name: text, color: color, emoji: "🤔", dateEvents: nil)
        let categoryTracker = TrackerCategory(title: countButtonForTableView[0].1, trackers: [newTracker])
        delegate?.didCreateTracker(newTracker, category: categoryTracker)
        self.view.window?.rootViewController?.dismiss(animated: true) {
        }
    }
    
    //MARK: - Private methods
    private func updateCreatingButton() {
        let categoryForActivButton = countButtonForTableView[0].1
        creatingButton.isEnabled = nameTrackerTextField.text?.isEmpty == false && categoryForActivButton.isEmpty == false
        if creatingButton.isEnabled {
            creatingButton.backgroundColor = .blackDay
        } else {
            creatingButton.isEnabled = false
            creatingButton.backgroundColor = .grayYP
        }
    }
    
    private func configTableView() {
        tableView.register(CreatingTableCell.self, forCellReuseIdentifier: "CreatingTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .grayYP
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configViews() {
        _ = self.skipKeyboard
        view.backgroundColor = .whiteDay
        view.addSubview(newHabitLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(errorLabel)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(creatingButton)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            newHabitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newHabitLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            nameTrackerTextField.topAnchor.constraint(equalTo: newHabitLabel.bottomAnchor, constant: 38),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            errorLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 237),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 168),
            creatingButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            creatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            creatingButton.heightAnchor.constraint(equalToConstant: 60),
            creatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - CreatingIrregularEventViewControllerDelegate
extension CreatingIrregularEventViewController: CreatingIrregularEventViewControllerDelegate {
    func updateSubitle(nameSubitle: String) {
        countButtonForTableView[0].1 = nameSubitle
        tableView.reloadData()
        updateCreatingButton()
    }
}

// MARK: - UITextFieldDelegate
extension CreatingIrregularEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textField = textField.text ?? ""
        let newLength = textField.count + string.count - range.length
        return newLength <= characterLimitInField
    }
}

// MARK: - UITableViewDelegate
extension CreatingIrregularEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let categoryViewController = CategoryViewController()
            categoryViewController.delegateIrregular = self
            let navigationController = UINavigationController(rootViewController: categoryViewController)
            present(navigationController, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - UITableViewDataSource
extension CreatingIrregularEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countButtonForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreatingTableCell", for: indexPath) as? CreatingTableCell
        else { fatalError() }
        let data = countButtonForTableView[indexPath.row]
        cell.configureCell(title: data.0, subTitle: data.1)
        
        return cell
    }
}
