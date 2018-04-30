
//
//  Compound Exercise Records.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData


extension Multi_Exercise_Container_Types: HasRecords {
    
    typealias RecordType = CompoundRecordClass
    
    func fetchAll() -> [RecordType] {
        
        let request: NSFetchRequest<Sequences> = Sequences.fetchRequest()
        request.predicate = NSPredicate(format: "multi_exercise_container_type = %@", self)
        let results = try? context.fetch(request)
        guard let sequences = results else { return [] }
        guard !sequences.isEmpty else { return [] }
        
        let rowCount = orderedExerciseContainers.count
        
        var recordContainers = [CompoundRecordClass]()
        
        for sequence in sequences {
            
            for row in 0..<rowCount {
                
                let ems: [Exercise_Metrics] = sequence.orderedContainers.flatMap({
                    guard $0.exerciseMetrics.indices.contains(row) else { return nil }
                    return $0.exerciseMetrics[row]
                })
                
                guard !ems.isEmpty else { continue }
                
                recordContainers.append(CompoundRecordClass(exerciseMetrics: ems))
                
            }
            
        }
        
        return recordContainers
    }
    
    func sortByIsRecordOver(items: [RecordType]) -> [RecordType] {
        
        return items.sorted(by: {
            
            return sortValuesForRecords(firstGroup: $0.values(), secondGroup: $1.values())
            
        })
    }
    
    func firstIsRecordOverSecond(first: RecordType, second: RecordType) -> Bool {
        
        if first.weight < second.weight {
            return false
        }
        
        if first.weight > second.weight {
            
            if first.reps == second.reps {
                return true
            }
            
            if !second.repsAreGreaterThan(group: first.reps) {
                return true
            }
            
        }
        
        //first.weight == second.weight
        if first.repsAreGreaterThan(group: second.reps) {
            return true
        }
        
        if first.reps == second.reps {
            if first.sets > second.sets {
                return true
            }
        }
        
        return false
    }
    
    func returnUpdate(for entity: NSManagedObject, changeType: ContextObserver.changeType) -> RecordsManagerUpdate {
        
        guard let exerciseMetric = entity as? Exercise_Metrics else { return .noAction }
        
        guard exerciseMetric.container?.sequence?.multi_exercise_container_type == self else { return .noAction }
        
        //for now, recalculating all
        return .recalculateAll
        
    }
    
    func displayInfo(for object: RecordType) -> (displayString: String, date: Date) {
        
        let date = object.exerciseMetrics.first?.date ?? Date()
        return (object.displayString(), date)
        
    }
    
    func setObjectsAsPersonalRecord(forObjects: [RecordType]) {
        forObjects.forEach({
            $0.exerciseMetrics.setRecordType(personalRecord: true, localRecord: true)
        })
    }
    
    func setObjectsAsLocalRecordsOnly(forObjects: [RecordType]) {
        forObjects.forEach({
            $0.exerciseMetrics.setRecordType(personalRecord: false, localRecord: true)
        })
    }
    
}

class CompoundRecordClass: CompoundExerciseSection {
    
    func values() -> [Double] {
        var vals: [Double] = [weight]
        reps.forEach({ vals.append($0)})
        vals.append(sets)
        return vals
    }
    
    func repsAreGreaterThan(group: [Double]) -> Bool {
        
        if reps == group {
            return false  
        }
        
        for (rep1, rep2) in zip(reps, group) {
            if rep1 < rep2 {
                return false
            }
        }
        
        return true
        
    }
    
}




