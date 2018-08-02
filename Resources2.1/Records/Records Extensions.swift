//
//  Records Extensions.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/22/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData


extension Exercises: HasRecords {
    
    typealias RecordType = Exercise_Metrics
    
    func fetchAll() -> [Exercise_Metrics] {
        return exerciseMetrics()
    }
    
    func returnUpdate(for entity: NSManagedObject, changeType: ContextObserver.changeType) -> RecordsManagerUpdate {
        
        if let em = entity as? Exercise_Metrics {
            
            if em.exercise === self {
                return .addToPendingComparisonList
            }
            
            if changeType == .delete {
                return .recalculateAll
            }
        }

        return .noAction
        
    }
    
    func sortByIsRecordOver(items: [Exercise_Metrics]) -> [Exercise_Metrics] {
        return items.sorted(by: { sortValuesForRecords(
            firstGroup: $0.valuesSortedByMetricPriority,
            secondGroup: $1.valuesSortedByMetricPriority
        )})
    }
    
    func firstIsRecordOverSecond(first: Exercise_Metrics, second: Exercise_Metrics) -> Bool {
        let metricInfo = metricInfoSet.sortedByMetricPriority
        let sortDescriptors = metricInfo.map({ $0.sort_in_ascending_order })
        var firstGroup = first.valuesSortedByMetricPriority
        var secondGroup = second.valuesSortedByMetricPriority
        
        for (i, sortDescriptor) in sortDescriptors.enumerated() {
            if sortDescriptor == true {
                guard i < firstGroup.count, i < secondGroup.count else { continue }
                firstGroup[i] = -firstGroup[i]
                secondGroup[i] = -secondGroup[i]
            }
        }
        
        return secondValuesAreRecordOverFirst(firstGroup, secondGroup)
    }
    
    func displayInfo(for object: Exercise_Metrics) -> (displayString: String, date: Date) {
        return (object.displayString(), object.date)
    }
    
    func setObjectsAsPersonalRecord(forObjects: [RecordType]) {
        forObjects.setRecordType(personalRecord: true, localRecord: true)
    }
    
    func setObjectsAsLocalRecordsOnly(forObjects: [RecordType]) {
        forObjects.setRecordType(personalRecord: false, localRecord: true)
    }
    
    
}

extension Exercise_Metrics {
    
    var valuesSortedByMetricPriority: [Double] {
        return metricInfoSet.sortedByMetricPriority.map({ value(for: $0 ).converted })
    }
    
    var valuesSortedByDefaultOrder: [Double] {
        return metricInfoSet.sortedByDefaultOrder.map({ value(for: $0 ).converted })
    }
    
}













func sortValuesForRecords(firstGroup: [Double], secondGroup: [Double]) -> Bool {
    for (x1, x2) in zip(firstGroup, secondGroup) {
        if x1 > x2 { return true }
        if x1 == x2 { continue }
        if x1 < x2 { return false }
    }
    
    return false
}






/*
    for (i,(firstValue,secondValue)) in zip(firstGroup, secondGroup).enumerated() {


        if i > metricCount { break }

        let a = firstValue
        let c = secondValue

        switch (a,c) {

        case let (a,c) where a > c:

            guard i < metricCount - 1 else {
                return true
            }

            if firstGroup[i+1] >= secondGroup[i+1] {
                return true
            }

        case let(a,c) where a == c:

            guard i < metricCount - 1 else {
                return false
            }

            if firstGroup[i+1] > secondGroup[i+1] {
                return true
            }

        case let (a,c) where a < c: return false

        default:
            continue

        }

    }

    return false
 
 */
