//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Alexandr Seva on 16.11.2023.
//

import Foundation

//MARK: - Protocol
protocol StatisticViewControllerProtocol: AnyObject {
    var completedTrackers: [TrackerRecord] { get set }
}

//MARK: - UIViewController
final class StatisticsViewModel: StatisticViewControllerProtocol {
    @ObservableValue var completedTrackers: [TrackerRecord] = [] {
        didSet {
            getStatisticsCalculation()
        }
    }
    var statistics: [StatisticsModel] = []
    private let trackerRecordStore = TrackerRecordStore()
}

//MARK: - CoreData
extension StatisticsViewModel {
    func fetchStatistics() throws {
        do {
            completedTrackers = try trackerRecordStore.fetchRecords()
            getStatisticsCalculation()
        } catch {
            throw StoreError.failedReading
        }
    }
}

//MARK: - LogicStatistics
extension StatisticsViewModel {
    private func getStatisticsCalculation() {
        if completedTrackers.isEmpty {
            statistics.removeAll()
        } else {
            statistics = [
                StatisticsModel(title: "Лучший период", value: "\(bestPeriod())"),
                StatisticsModel(title: "Идеальные дни", value: "\(idealDays())"),
                StatisticsModel(title: "Трекеров завершено", value: "\(trackersCompleted())"),
                StatisticsModel(title: "Среднее значение", value: "\(averageValue())")
            ]
        }
    }
    
    private func bestPeriod() -> Int {
        let countDict = Dictionary(grouping: completedTrackers, by: { $0.id }).mapValues { $0.count }
        guard let maxCount = countDict.values.max() else {
            return 0
        }
        return maxCount
    }
    
    private func idealDays() -> Int {
        //TODO: добавить логику расчета
        return 0
    }
    
    private func trackersCompleted() -> Int {
        return completedTrackers.count
    }
    
    private func averageValue() -> Int {
        //TODO: добавить логику расчета
        return 0
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension StatisticsViewModel: TrackerRecordStoreDelegate {
    func didUpdateData(in store: TrackerRecordStore) {
        try? fetchStatistics()
    }
}
