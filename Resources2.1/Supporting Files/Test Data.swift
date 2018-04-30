//
//  Test Data.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/15/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


func setupExercisePickerWithCompoundExercise() {
    
    let category = Categories(context: context)
    category.name = "test"
    let exercise1 = makeExercise()
    let exercise2 = makeExercise()
    let exercise3 = makeExercise()
    exercise1.name = "Clean"
    exercise2.name = "Front Squat"
    exercise3.name = "Jerk"
    category.isActive = true
    exercise1.isActive = true
    exercise2.isActive = true
    exercise3.isActive = true
    exercise1.category = category
    exercise2.category = category
    exercise3.category = category
    
    
    let compoundContainerType = Multi_Exercise_Container_Types.create(category: category, with: [exercise1, exercise2, exercise3])
    compoundContainerType.isActive = true
    
    let exercise4 = Exercises(context: context)
    exercise4.isActive = true
    exercise4.category = category
    exercise4.name = "Split Jerk"
    saveContext()
   
}


func setupTestCategories() {
    

    
}

private func makeExercise() -> Exercises {
    let backSquat = Exercises(context: context)
    Metric_Info.create(metric: Metric.Weight, unitOfM: UnitMass.pounds, exercise: backSquat)
    Metric_Info.create(metric: Metric.Reps, unitOfM: UnitReps.reps, exercise: backSquat)
    Metric_Info.create(metric: Metric.Sets, unitOfM: UnitSets.sets, exercise: backSquat)
    return backSquat
}



