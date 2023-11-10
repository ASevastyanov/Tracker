//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Alexandr Seva on 09.11.2023.
//

import UIKit

//MARK: - CategoryViewDelegate
protocol CategoryViewModelDelegate: AnyObject {
    func updateData(nameCategory: String)
}

final class CategoryViewModel {
    @ObservableValue private(set) var categories: [TrackerCategory] = []
    
    weak var delegateHabbit: CreatingHabitViewControllerDelegate?
    weak var delegateIrregular: CreatingIrregularEventViewControllerDelegate?
    private let dataSorege = DataStorege.shared
    private let trackerCategoryStore = TrackerCategoryStore()
    
    func countCategries() -> Int {
        if categories.count >= 0 {
            return categories.count
        } else {
            return 0
        }
    }
    
    func addNewCategory() -> CreatingCategoryViewController {
        let addNewCategoryViewController = CreatingCategoryViewController()
        addNewCategoryViewController.delegate = self
        return addNewCategoryViewController
    }
    
    func addingCategoryToCreate(_ indexPath: IndexPath){
        let nameCategory = categories[indexPath.row].title
        delegateIrregular?.updateSubitle(nameSubitle: nameCategory)
        delegateHabbit?.updateSubitle(nameSubitle: nameCategory)
    }
    
    func selectedCategoryForCheckmark(_ indexPath: IndexPath) {
        dataSorege.saveIndexPathForCheckmark(indexPath)
    }
    
    func loadIndexPathForCheckmark() -> IndexPath? {
        return dataSorege.loadIndexPathForCheckmark()
    }
}

// MARK: - ConfigForCell
extension CategoryViewModel {
    func roundingForCellsInATable(cellIndex: Int) -> CACornerMask {
        let numberOfLines = countCategries()
        switch (cellIndex, numberOfLines) {
        case (0, 1):
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (0, _):
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (_, _) where cellIndex == numberOfLines - 1:
            return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default:
            return []
        }
    }
    
    func separatorInsetForCell(index: Int) -> UIEdgeInsets {
        let count = countCategries()
        let quantityCategory = count - 1
        if index == quantityCategory {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

// MARK: - CategoryStoreCoreDate
extension CategoryViewModel {
    func fetchCategory() throws {
        do {
            let coreDataCategories = try trackerCategoryStore.fetchAllCategories()
            categories = try coreDataCategories.compactMap { coreDataCategory in
                return try trackerCategoryStore.decodingCategory(from: coreDataCategory)
            }
        } catch {
            throw StoreError.failedReading
        }
    }
    
    func createCategory(nameOfCategory: String) throws {
        do {
            let newCategory = TrackerCategory(title: nameOfCategory, trackers: [])
            try trackerCategoryStore.createCategory(newCategory)
        } catch {
            throw StoreError.failedToWrite
        }
    }
    
    func removeCategory(atIndex index: Int) throws {
        let nameOfCategory = categories[index].title
        do {
            try trackerCategoryStore.deleteCategory(with: nameOfCategory)
            try fetchCategory()
        } catch {
            throw StoreError.failedActoionDelete
        }
    }
}

// MARK: - TrackerStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func didUpdateData(in store: TrackerCategoryStore) {
        try? fetchCategory()
    }
}

// MARK: - CreateCategoryViewDelegate
extension CategoryViewModel: CategoryViewModelDelegate {
    func updateData(nameCategory: String) {
        try? createCategory(nameOfCategory: nameCategory)
        try? fetchCategory()
    }
}
