//
//  Metrics.swift
//  exerciseModel1
//
//  Created by B_Litwin on 1/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData


class Metric_Info: NSManagedObject {
    
    var metric: Metric {
        get { return Metric(metricSV!) }
        set { metricSV = newValue.rawValue }
    }
    
    func saveExerciseMetricValue(_ exerciseMetric: Exercise_Metrics,
                                 nonStandardValue: NonStandardSaveValue? = nil) -> (String) -> Void
    {
        if nonStandardValue != nil {
            func saveNonStandard(text: String) {
                print(text)
                saveNonStandardExerciseMetricValue(nonStandardValue!,
                                                   exerciseMetric: exerciseMetric,
                                                   saveValue: text)
            }
            
            return saveNonStandard
            
        } else {
            
            func saveValue(text: String) { exerciseMetric.save(string: text, metricInfo: self)}
            return saveValue
        }
    }
    
    //if saving in feet, want to be able to input feet and inches; same with minutes/minutes/seconds
    func saveNonStandardExerciseMetricValue(_ nonStandardValue: NonStandardSaveValue,
                                            exerciseMetric: Exercise_Metrics,
                                            saveValue: String) {
        
        guard let value = Double(saveValue) else { return }
        
        switch nonStandardValue {
            
        case .feet(let unit):
            switch unit {
            case .feet: exerciseMetric.wholeFeet = value
            case .inches: exerciseMetric.remainderInches = value
            }
            
        case .minutes(let unit):
            switch unit {
            case .minutes: exerciseMetric.wholeMinutes = value
            case .seconds: exerciseMetric.remainderSeconds = value
            }
        }
    }
    
    enum NonStandardSaveValue {
        case feet(feetUnit)
        case minutes(minuteUnit)
        
        enum feetUnit {
            case feet
            case inches
        }
        enum minuteUnit {
            case minutes
            case seconds
        }
    }
    
    var sortDescriptor: NSSortDescriptor {
        return NSSortDescriptor(key: metric.searchKey, ascending: sort_in_ascending_order)
    }
    
    var unitOfMeasurement: Dimension {
        return unitDictionary[unit_of_measurement!]!
    }
    
    class func create(metric: Metric,
                      unitOfM: Dimension,
                      exercise: Exercises,
                      sortInAscendingOrder: Bool = false)
    {
        let newMetricInfo = Metric_Info(context: context)
        newMetricInfo.metric = metric
        newMetricInfo.unit_of_measurement = unitOfM.symbol
        newMetricInfo.exercise = exercise
        newMetricInfo.sort_in_ascending_order = sortInAscendingOrder
    }
    
    class func fetchAll() -> [Metric_Info] {
        let request: NSFetchRequest<Metric_Info> = Metric_Info.fetchRequest()
        let result = try? context.fetch(request)
        guard let metricInfo = result else { return [] }
        return metricInfo
    }
    
}




extension Sequence where Iterator.Element == Metric_Info {
    
    var primaryMetric: Metric_Info {
        return self.max(by:{
            $0.metric.primaryMetricOrder > $1.metric.primaryMetricOrder
        })!
    }
    
    var sortedByDefaultOrder: [Metric_Info] {
        return self.sorted(by: { $0.metric.defaultOrder < $1.metric.defaultOrder } )
    }
    
    var sortedByMetricPriority: [Metric_Info] {
        return self.sorted(by: { $0.metric.primaryMetricOrder < $1.metric.primaryMetricOrder } )
    }
    
    func containsMetric(_ metric: Metric) -> Metric_Info? {
        for m in self {
            if m.metric == metric {
                return m
            }
        }
        return nil
    }
    
}













