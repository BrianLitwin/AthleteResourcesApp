//
//  CreateExercise.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/22/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

//Todo: selecting switch does not auto-select a unit of measurement choice in UI
//Todo: getting error: please set exercise name when creating new exercise, name in name field
//todo: if you select/deselect an exercise in search exercises, and you go back to current workout, add exercise ->will have an empty category box 


import UIKit

import Resources_View2_1


class UpdateExercise: UpdateExerciseModel {
    
    enum UnableToSaveUpdate: String {
        case noName = "Please Give Your Exercise A Name"
        case noMetricsSelected = "Choose At least One Metric For Your Exercise"
        case exerciseAlreadyExists = "An Exercise With That Name And Variation Already Exists"
    }

    var exercise: Exercises?
    
    let category: Categories
    
    let pendingNVI: PendingNVIUpdate // NVI: Name, Variation, Instructions
    
    let pendingUpdates: [PendingUpdate]
    
    //extraneous //
    var exerciseInfo: UpdateExerciseNVIModel {
        return pendingNVI
    }
    
    //extraneous //
    var pendingUpdateModels: [UpdateExerciseModelSection] {
        return pendingUpdates // for protocol 
    }
    
    init(exercise: Exercises?, category: Categories) {
        
        self.exercise = exercise
        
        self.category = category
        
        pendingNVI = PendingNVIUpdate(exercise: exercise)
        
        self.pendingUpdates = Metric.orderedMetrics.map({
            if let metricInfo = exercise?.metricInfoSet.containsMetric($0) {
                return PendingUpdate(metric: $0, with: metricInfo)
            } else {
                return PendingUpdate(metric: $0, with: nil)
            }
        })
        
    }
    
    func incompleteInformation() -> String? {
        return UpdatesRequiredToComplete()?.rawValue
    }
    
    func UpdatesRequiredToComplete() -> UnableToSaveUpdate? {
        
        guard !pendingNVI.pendingState.name.IsEmptyString else { return .noName }
        
        let activeMetrics = pendingUpdates.filter({ $0.pendingState.isActive })
        
        guard !activeMetrics.isEmpty else { return .noMetricsSelected }
        
        if let _ =  Exercises.exerciseAlreadyExistsWith(name: pendingNVI.pendingState.name,
                                                        variation: pendingNVI.pendingState.name) {
            
            return .exerciseAlreadyExists
        }
        
        return nil
        
    }
    
    
    func saveAllChanges() {
        
        if exercise == nil {
            let newExercise = Exercises(context: context)
            newExercise.isActive = true 
            newExercise.category = category
            exercise = newExercise
        }
        
        if pendingNVI.dataWasUpdated() {
            exercise!.name = pendingNVI.pendingState.name
            exercise!.variation = pendingNVI.pendingState.variation
            exercise!.instructions = pendingNVI.pendingState.instructions
            exercise!.category?.isActive = true
        }
        
        pendingUpdates.forEach({ saveChanges(with: $0, exercise: exercise!) })
        
        saveContext()
        
    }
    
    func saveChanges(with update: PendingUpdate, exercise: Exercises) {
        
        guard update.dataWasUpdated() else { return }
        
        if let existingMetricInfo = exercise.metricInfoSet.containsMetric(update.metric) {
            
            if update.pendingState.isActive { //edit the old exercise metric with updates
            
                existingMetricInfo.sort_in_ascending_order = update.pendingState.sortInAscendingOrder
                existingMetricInfo.unit_of_measurement = update.selectedUnitOfMeasurement()
                
            } else {
                
                existingMetricInfo.delete() //if the switch was turned off for a previously existing exerciseMetric, delete it
            }
            
            
        } else {
            
            let newMetricInfo = Metric_Info(context: context) //If the metric didn't previously exist, create it
            newMetricInfo.metric = update.metric
            newMetricInfo.sort_in_ascending_order = update.pendingState.sortInAscendingOrder
            newMetricInfo.unit_of_measurement = update.selectedUnitOfMeasurement()
            newMetricInfo.exercise = exercise
            
        }
        
    }
    

}




