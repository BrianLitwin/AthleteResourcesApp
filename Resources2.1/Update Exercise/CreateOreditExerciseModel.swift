//
//  CreateOreditExercise.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/21/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class CreateOreditExercise {
    
    enum Update {
        case add(metric: Metric_Info, to: Exercises)
        case update(oldMetric: Metric_Info, with: Metric_Info, for: Exercises)
        case delete(metric: Metric_Info)
    }
    
    let exercise: Exercises
    
    let pendingMetricInfos: [PendingMetricInfo]
    
    init(exercise: Exercises) {
        
        self.exercise = exercise
        self.pendingMetricInfos = Metric.orderedMetrics.map({
            let preexistingMetricInfo = exercise.metricInfoSet.containsMetric($0)
            return PendingMetricInfo(metric: $0,
                              preexistingMetricInfo: preexistingMetricInfo)
        })
        
    }
    
    func performUpdate(with update: Update) {
        
        switch update {
            
        case .add(let metricInfo, let exercise):
            exercise.addToMetric_info(metricInfo)
            
        case .update(let oldMetric, let newMetric, let exercise):
            oldMetric.delete()
            exercise.addToMetric_info(newMetric)
            
        case .delete(let metricInfo):
            metricInfo.delete()
            
        }
        
    }
    
    func save() {
        
        for pendingInfo in pendingMetricInfos {
            if let update = pendingInfo.determineUpdate(with: exercise) {
                performUpdate(with: update)
            }
        }
        
}
    
    
class PendingMetricInfo {
        
        let metric: Metric
        
        let metricInfo: Metric_Info
        
        let preexistingMetricInfo: Metric_Info?
        
        var dataUpdated = false
        
        var addDataToExercise = false
        
        var unitOptions: [Unit] = []
        
        init(metric: Metric, preexistingMetricInfo: Metric_Info?) {
            self.metric = metric
            self.metricInfo = Metric_Info(context: context)
            self.unitOptions = Metric.Units[metric] ?? []
            self.preexistingMetricInfo = preexistingMetricInfo
        }
        
        func setupInitialState() -> InitialState
        {
            
            if preexistingMetricInfo != nil {
                
                let unitStrings = unitOptions.map({ $0.symbol })
                
                let unitSelection =
                    unitStrings.index(of: preexistingMetricInfo!.unit_of_measurement ?? "") ?? 0
                let sortInAscendingOrder = preexistingMetricInfo!.sort_in_ascending_order
                
                return (

                    InitialState(isActive: true,
                                 sortInAscendingOrder: sortInAscendingOrder,
                                 unitSelection: unitSelection)
                    
                )
                
            } else {
                
                var sortInAscendingOrder: Bool = false
                
                if metric == .Time {
                    
                    //set the default state of the time metric to sort in ascending order, all
                    //other metrics to sort in descending order, and the unitOption to the
                    //first unit in the array
                    
                    sortInAscendingOrder = true
                    
                }
                
                return InitialState(isActive: false,
                                    sortInAscendingOrder: sortInAscendingOrder,
                                    unitSelection: 0)
                
                
                
            }
            
        }
        
        struct InitialState {
            let isActive: Bool
            let sortInAscendingOrder: Bool
            let unitSelection: Int
        }
        
        func dataWasUpdated() {
            dataUpdated = true
        }
        
        func metricIs(active: Bool) {
            addDataToExercise = active
            dataWasUpdated()
        }
        
        func setSortInAscendingOrder(with bool: Bool) {
            metricInfo.sort_in_ascending_order = bool
            dataWasUpdated()
        }
        
        func setUnitOfMeasurement(with unitChoice: Int) {
            guard unitChoice < unitOptions.endIndex else { return }
            let unit = unitOptions[unitChoice]
            metricInfo.unit_of_measurement = unit.symbol
            dataWasUpdated()
        }
        
        
        func determineUpdate(with exercise: Exercises) -> CreateOreditExercise.Update? {
            
            guard dataUpdated else {
                
                //Mark: If no updates, delete the metricInfo created
                
                metricInfo.delete()
                return nil
            }
            
            //first check to see whether the metric was a deletion of a currently existing metric info
            
            if preexistingMetricInfo != nil {
                
                if !addDataToExercise {
    
                    return .delete(metric: preexistingMetricInfo!)
                    
                } else {

                    return .update(oldMetric: preexistingMetricInfo!, with: metricInfo, for: exercise)
                    
                }
                
            } else {
                
                if addDataToExercise {
                    
                    return .add(metric: metricInfo, to: exercise)
                    
                }
                
            }
            
            
            return nil
            
        }
        
    }
    
}

































