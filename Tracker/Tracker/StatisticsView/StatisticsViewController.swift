//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Alexandr Seva on 17.10.2023.
//

import UIKit

//MARK: - UIViewController
final class StatisticsViewController: UIViewController {
    var viewModel: StatisticsViewModel?
    private let analyticsService = AnalyticsService()
    
    //MARK: - UiElements
    private lazy var trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "Статистика"
        trackerLabel.textColor = .blackDay
        trackerLabel.font = .boldSystemFont(ofSize: 34)
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    private lazy var descriptionImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "statisticsError"))
        image.clipsToBounds = true
        image.isHidden = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var descriptionPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.numberOfLines = 2
        label.textColor = .blackDay
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .none
        collectionView.register(StatisticsCell.self, forCellWithReuseIdentifier: "StatisticsCell")
        return collectionView
    }()
    
    // MARK: Initialisation
    func initialize(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
        try? viewModel?.fetchStatistics()
        analyticsService.report(event: .open, params: ["Screen" : "Statistics"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: .close, params: ["Screen" : "Statistics"])
    }
    
    // MARK: Binding
    private func bind() {
        viewModel?.$completedTrackers.bind(action: { [weak self] _ in
            guard let self else { return }
            self.screenRenderingLogic()
        })
    }
    
    //MARK: - Private methods
    private func screenRenderingLogic() {
        guard let completedTrackers = viewModel?.completedTrackers else { return }
        collectionView.reloadData()
        if completedTrackers.isEmpty {
            placeholderDisplaySwitch(isHidden: false)
        } else {
            placeholderDisplaySwitch(isHidden: true)
            configThereAreCategories()
        }
    }
    
    private func placeholderDisplaySwitch(isHidden: Bool) {
        descriptionImage.isHidden = isHidden
        descriptionPlaceholder.isHidden = isHidden
        collectionView.isHidden = !isHidden
    }
    
    private func configViews() {
        view.backgroundColor = .whiteDay
        view.addSubview(trackerLabel)
        view.addSubview(descriptionImage)
        view.addSubview(descriptionPlaceholder)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionImage.widthAnchor.constraint(equalToConstant: 80),
            descriptionImage.heightAnchor.constraint(equalToConstant: 80),
            descriptionImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            descriptionPlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionPlaceholder.topAnchor.constraint(equalTo: descriptionImage.bottomAnchor, constant: 8)
        ])
    }
    
    private func configThereAreCategories() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 77),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -126)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension StatisticsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

//MARK: - UICollectionViewDataSource
extension StatisticsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel?.statistics.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCell", for: indexPath) as! StatisticsCell
        guard let statistics = viewModel?.statistics[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.configure(with: statistics)
        return cell
    }
}
