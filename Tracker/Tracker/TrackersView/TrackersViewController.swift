//
//  ViewController.swift
//  Tracker
//
//  Created by Alexandr Seva on 01.10.2023.
//

import UIKit

//MARK: - TrackersViewController
class TrackersViewController: UIViewController {
    private var searchText = [String]()
    private var recordsStorege = [String]()
    
    //MARK: - UiElements
    private let navigationBar = UINavigationBar()
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "plusDayIcon")!,
            target: self,
            action: #selector(self.addNewTracker))
        button.accessibilityIdentifier = "addTrackerButton"
        button.tintColor = .blackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.layer.cornerRadius = 8
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(filterByDate), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "Трекеры"
        trackerLabel.font = .boldSystemFont(ofSize: 34)
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    private lazy var searchBar: UISearchBar = {
        let trackersSearchBar = UISearchBar()
        trackersSearchBar.layer.masksToBounds = true
        trackersSearchBar.searchBarStyle = .minimal
        trackersSearchBar.translatesAutoresizingMaskIntoConstraints = false
        trackersSearchBar.placeholder = "Поиск"
        trackersSearchBar.delegate = self
        return trackersSearchBar
    }()
    
    private lazy var mainStarImageStub: UIImageView = {
        let mainSpacePlaceholderStack = UIImageView(image: UIImage(named: "starIcon"))
        mainSpacePlaceholderStack.clipsToBounds = true
        mainSpacePlaceholderStack.contentMode = .scaleAspectFill
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        return mainSpacePlaceholderStack
    }()
    
    private lazy var searchMainPlaceholderStub: UILabel = {
        let searchSpacePlaceholderStack = UILabel()
        searchSpacePlaceholderStack.text = "Что будем отслеживать?"
        searchSpacePlaceholderStack.font = .systemFont(ofSize: 12, weight: .medium)
        searchSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        return searchSpacePlaceholderStack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
        configNavigationBar()
    }
    
    // MARK: - Actions
    @objc
    private func addNewTracker() {
        let сreatingNewTrackerViewController = CreatingNewTrackerViewController()
        let navigationController = UINavigationController(rootViewController: сreatingNewTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc
    private func filterByDate() {
        //TODO: - Создать метод фильтрации по дате
    }
    
    //MARK: - Private methods
    private func configNavigationBar() {
        let addTrackerBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        let datePickerBarButtonItem = UIBarButtonItem(customView: datePicker)
        let datePickerConstraint = NSLayoutConstraint(item: datePicker, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0)
        navigationItem.leftBarButtonItem = addTrackerBarButtonItem
        navigationItem.rightBarButtonItems = [datePickerBarButtonItem]
        navigationBar.barTintColor = UIColor.whiteDay
        navigationBar.shadowImage = UIImage()
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([datePickerConstraint])
    }
    
    private func configViews() {
        searchBar.setValue("Отменить", forKey: "cancelButtonText")
        view.backgroundColor = .whiteDay
        view.addSubview(navigationBar)
        view.addSubview(trackerLabel)
        view.addSubview(searchBar)
        view.addSubview(mainStarImageStub)
        view.addSubview(searchMainPlaceholderStub)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 1),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            mainStarImageStub.widthAnchor.constraint(equalToConstant: 80),
            mainStarImageStub.heightAnchor.constraint(equalToConstant: 80),
            mainStarImageStub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStarImageStub.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchMainPlaceholderStub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchMainPlaceholderStub.topAnchor.constraint(equalTo: mainStarImageStub.bottomAnchor, constant: 8)
        ])
    }
}

//MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText.removeAll()
        guard searchText != "" || searchText != " " else { return }
        for item in recordsStorege {
            let text = searchText.lowercased()
            let isArrayContain = item.lowercased().range(of: text)
            if isArrayContain != nil {
                self.searchText.append(item)
                print(searchText)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}
