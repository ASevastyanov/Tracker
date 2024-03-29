//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Alexandr Seva on 24.10.2023.
//

import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateData(in store: TrackerRecordStore)
}

final class TrackerRecordStore: NSObject {
    weak var delegate: TrackerRecordStoreDelegate?
    private let context: NSManagedObjectContext
    
    // MARK: Initialisation
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: - Methods
    func addNewRecord(from trackerRecord: TrackerRecord) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else {
            throw StoreError.failedToWrite
        }
        let newRecord = TrackerRecordCoreData(entity: entity, insertInto: context)
        newRecord.id = trackerRecord.id
        newRecord.date = trackerRecord.date
        try context.save()
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) throws {let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerRecord.id as CVarArg)
        
        do {
            let records = try context.fetch(fetchRequest)
            
            if let recordToDelete = records.first {
                context.delete(recordToDelete)
                try context.save()
            } else {
                throw StoreError.failedGettingTitle
            }
        } catch {
            throw StoreError.failedActoionDelete
        }
    }
    
    func fetchRecords() throws -> [TrackerRecord] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw StoreError.failedReading
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        do {
            let trackerRecordCoreDataArray = try managedContext.fetch(fetchRequest)
            let trackerRecords = trackerRecordCoreDataArray.map { trackerRecordCoreData in
                return TrackerRecord(
                    id: trackerRecordCoreData.id ?? UUID(),
                    date: trackerRecordCoreData.date ?? Date()
                )
            }
            return trackerRecords
        } catch {
            throw StoreError.failedReading
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateData(in: self)
    }
}
