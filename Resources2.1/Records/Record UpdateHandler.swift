//
//  Record Sorter.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/22/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData
import Resources_View2_1


protocol HasRecords {
    
    associatedtype RecordType: Hashable
    
    var personalRecordsManager: RecordsManager<Self> { get }
    
    func fetchAll() -> [RecordType]
    
    func sortByIsRecordOver(items: [RecordType]) -> [RecordType]
    
    func firstIsRecordOverSecond(first: RecordType, second: RecordType) -> Bool
    
    func returnUpdate(for entity: NSManagedObject, changeType: ContextObserver.changeType) -> RecordsManagerUpdate
    
    func displayInfo(for object: RecordType) -> (displayString: String, date: Date)
    
    func setObjectsAsPersonalRecord(forObjects: [RecordType])
    
    func setObjectsAsLocalRecordsOnly(forObjects: [RecordType])
    
}


enum RecordsManagerUpdate {
    case recalculateAll
    case addToPendingComparisonList
    case noAction
}



class RecordsManager<T: HasRecords>: ContextObserver {
    
    typealias RecordType = T.RecordType
    let parentClass: T
    var personalRecords: [RecordType] = []
    var pendingItemsToCompare: [RecordType] = []
    var recalculateAll = true
    
    init(parentClass: T) {
        self.parentClass = parentClass
        super.init(context: context)
    }
    
    var needsReload: Bool {
        return !(!recalculateAll && pendingItemsToCompare.isEmpty)
    }
    
    func updateRecords() {
        
        //create copy to update records that have been removed from PR List after re-calculation
        let previousRecordList = personalRecords
        
        //calculate new personal precords
        personalRecords = recalculateAll ?
            recalculateAllRecords() : !pendingItemsToCompare.isEmpty ?
            comparePendingItems()   : personalRecords
        
        //set NeedsReload to false after personal record list has been updated
        pendingItemsToCompare = []
        recalculateAll = false
        
        //update core data objects on main queue 
        updateCoreDataObjectsOnMainThread(newRecords: personalRecords, oldRecords: previousRecordList)
    }
    
    func updateCoreDataObjectsOnMainThread(newRecords: [RecordType], oldRecords: [RecordType]) {
        
        func updateRecords() {
            parentClass.setObjectsAsPersonalRecord(forObjects: newRecords)
            let removedRecords = oldRecords.filter({
                return newRecords.contains($0) == false
            })
            parentClass.setObjectsAsLocalRecordsOnly(forObjects: oldRecords)
        }
        
        if Thread.isMainThread {
            updateRecords()
        } else {
            Queue.main.execute {
                updateRecords()
            }
        }
    }

    func recalculateAllRecords() -> [RecordType] {
        let allItems = parentClass.fetchAll()
        let sortedItems = parentClass.sortByIsRecordOver(items: allItems)
        let records = recordsFromSortedList(sortedItems)
        return records 
    }
    
    func comparePendingItems() -> [RecordType] {
        let items = personalRecords + pendingItemsToCompare
        let uniqueItems: Set<RecordType> = Set(items)
        let sortedItems = parentClass.sortByIsRecordOver(items: Array(uniqueItems))
        return recordsFromSortedList(sortedItems)
        
    }
    
    func recordsFromSortedList(_ sortedItems: [RecordType]) -> [RecordType] {
        
        var list = sortedItems
        guard !list.isEmpty else { return [] }
        let first = list.removeFirst()
        
        return list.reduce([first], {
            list, item in
            let firstIsRecord = parentClass.firstIsRecordOverSecond(first: list.last!, second: item)
            if firstIsRecord {
                return list
            } else {
                return list + [item]
            }
        })
    }
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any]) {
        
        if type == .delete {

        }
        
        let update = parentClass.returnUpdate(for: entity, changeType: type)
        
        switch update {
            
        case .recalculateAll:
            recalculateAll = true
            
        case .addToPendingComparisonList:
            guard let recordType = entity as? RecordType else { return }
            pendingItemsToCompare.append(recordType)
            
        case .noAction:
            break
            
        }
    }
}













/*


class PersonRecordsManager: ContextObserver {
    
    let exercise: Exercises
    
    var personalRecords: [Exercise_Metrics] = []
    
    var needsReload: Bool {
        return !(recalculateAll == false && pendingExerciseMetricsToCheck.isEmpty)
    }
    
    var recalculateAll = true
    
    var pendingExerciseMetricsToCheck: [Exercise_Metrics] = []
    
    init(exercise: Exercises) {
        self.exercise = exercise
        super.init(context: context)
    }
    
    func updatePersonalRecords() {
        
        if recalculateAll {
            
            personalRecords = exercise.calculateAllPersonalRecords()
            
        } else {
            
            let tempRecords = Set(personalRecords + pendingExerciseMetricsToCheck)
            
            personalRecords = exercise.calculatePersonalRecords(from: Array(tempRecords))
            
        }
        
        recalculateAll = false
        
        pendingExerciseMetricsToCheck = []
        
    }
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any]) {
        
        guard let exerciseMetric = entity as? Exercise_Metrics else { return }
        
        switch type {
            
        case .delete:
            
            if personalRecords.contains(exerciseMetric) {
                recalculateAll = true
            }
            
        default:
            
            pendingExerciseMetricsToCheck.append(exerciseMetric)
        }
        
    }
    
}


*/




