//
//  LoadExampleData.swift
//  Resources2.1
//
//  Created by B_Litwin on 7/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class ExampleData {

    var exercise: Exercises!
    var dates: [Date] = []
    var startingWeight = 200.0
    
    init() {
        exercise = createExercise(name: "Back Squa w/ pause")
        exercise.isActive = true
        
        for i in 0...300 {
            dates += [getDate(daysAgo: i)]
        }
        setup()
    }
    
    func setup() {
        let sv = startingWeight
        makeSet(increment: 1.8, day: 65)
        makeSet(increment: 0.8, day: 60)
        makeSet(increment: 2.9, day: 55)
        makeSet(increment: 1.1, day: 50)
        makeSet(increment: 1.1, day: 45)
        makeSet(increment: 2, day: 40)
        makeSet(increment: 6, day: 35)
        makeSet(increment: 1.5, day: 30)
        makeSet(increment: 0.0, day: 25)
        makeSet(increment: 4.3, day: 20)
        makeSet(increment: 2, day: 15)
        makeSet(increment: 0.0, day: 10)
        makeSet(increment: 2.9, day: 5)
        makeSet(increment: 5.4, day: 0)
        
        
        var day = 0
        var bodyweight: Double = 200
        
        
        var Is = [ -4.1, -2.2, -1, 1 ,2, -0.4, -1.1, -1, 2.4, 5, 3, -4, 2, 2.4, 1, 3, -4, 2, -0.1, 3, -2, 1, -1.1, 2.2, -1, -0.1, 3, -2, 1, -1.1, 2.2, -1, 3,2, 2.4, -1.1, -4, -3, -6, 4,2, -0.1, 3, -2.3, 1, -1.1, -2, 2.1, -1, 3,2, -0.45, -1.1, -0.8, 3,2, 2.4, -1.5, -4, -3, -5, 4, 2, -0.1, 3, -2, 1, -1.1, -2.2, -1, 3,2, -0.4, -1.1, -1, 2.4].map {
            ($0 / 2.5).rounded(toPlaces: 1)
        }
        
        for i in 0..<Is.count {
            if i % 2 == 0 {
                let next = Is.popLast()
                
                bodyweight += next!
                day = i
                
                makeBodyweight(weight: bodyweight, day: day)
            } else {
                let next = Is.firstItem!
                Is.remove(at: 0)
                
                bodyweight += next
                makeBodyweight(weight: bodyweight, day: day)
            }
        }
        
        makeSet(increment: 1.1, day: day + 1)
        
    }
    
    func makeSet(increment: Double, day: Int) {
        let workout = Workouts.createNewWorkout(date: dates[day])
        workout.addNewSequence(at: 0, with: exercise)
        startingWeight += increment
        workout.exerciseMetricsSet.first!.weightSV = startingWeight
        workout.exerciseMetricsSet.first!.repsSV = 1
        workout.exerciseMetricsSet.first!.setsSV = 1
    }
    
    func makeBodyweight(weight: Double, day: Int) {
        let bodyweight = Bodyweight(context: context)
        bodyweight.bodyweight = weight
        bodyweight.dateSV = getDate(daysAgo: day)
    }
    
    func createExercise(name: String, variation: String? = nil) -> Exercises {
        let exercise = Exercises(context: context)
        exercise.name = name
        exercise.variation = variation
        Metric_Info.create(metric: Metric.Weight, unitOfM: UnitMass.pounds, exercise: exercise)
        Metric_Info.create(metric: Metric.Reps, unitOfM: UnitReps.reps, exercise: exercise)
        Metric_Info.create(metric: Metric.Sets, unitOfM: UnitSets.sets, exercise: exercise)
        saveContext()
        return exercise
        
    }
    
    func getDate(daysAgo: Int) -> Date {
        var date = Date()
        date = calendar.date(byAdding: .day, value: -daysAgo, to: date)!
        return date
    }
}
