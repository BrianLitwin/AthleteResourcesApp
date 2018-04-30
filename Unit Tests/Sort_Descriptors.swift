//
//  Sort_Descriptors.swift
//  Unit Tests
//
//  Created by B_Litwin on 4/6/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Sort_Descriptors: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func test_sortDescriptors() {
        
        let date = getDate(daysAgo: 0)
        let date1 = getDate(daysAgo: 1)
        let date2 = getDate(daysAgo: 2)
        let date3 = getDate(daysAgo: 3)
        let date4 = getDate(daysAgo: 4)
        let date5 = getDate(daysAgo: 5)
        
        let dates: [Date] = [ date, date1, date2, date3, date4, date5 ]
        
        let values: [Double] = [
            1,2,3,4,5,6
        ]
        
        
        let exercise = Exercises(context: context)
        Metric_Info.create(metric: Metric.Weight, unitOfM: UnitMass.pounds, exercise: exercise)
        Metric_Info.create(metric: Metric.Reps, unitOfM: UnitReps.reps, exercise: exercise)
        Metric_Info.create(metric: Metric.Sets, unitOfM: UnitSets.sets, exercise: exercise)
        Metric_Info.create(metric: Metric.Time, unitOfM: UnitDuration.seconds, exercise: exercise)
        Metric_Info.create(metric: Metric.Length, unitOfM: UnitLength.inches, exercise: exercise)
        Metric_Info.create(metric: Metric.Velocity, unitOfM: UnitSpeed.metersPerSecond, exercise: exercise)
        
        
        var exerciseMetrics: [Exercise_Metrics] = []
        
        for (value, dateSV) in zip(values, dates) {
            let em = makeEM(with: exercise)
            
            let workout = Workouts(context: context)
            workout.dateSV = dateSV
            em.container!.sequence!.workout = workout
            em.save(double: value, metric: .Weight)
            em.save(double: value, metric: .Reps)
            em.save(double: value, metric: .Sets)
            em.save(double: value, metric: .Time)
            em.save(double: value, metric: .Length)
            em.save(double: value, metric: .Velocity)
            exerciseMetrics.append(em)
        }
        
        let weightSD = exercise.metricInfo[0].sortDescriptor
        let repsSD = exercise.metricInfo[1].sortDescriptor
        let setsSD = exercise.metricInfo[2].sortDescriptor
        let timeSD = exercise.metricInfo[3].sortDescriptor
        let lengthSD = exercise.metricInfo[4].sortDescriptor
        let velocitySD = exercise.metricInfo[5].sortDescriptor
        let dateSD = Exercise_Metrics.dateSortDescriptor()
        
        //test that sort descriptors don't crash
        
        var sort = exerciseMetrics.sort(by: [weightSD])
        sort = exerciseMetrics.sort(by: [repsSD])
        sort = exerciseMetrics.sort(by: [setsSD])
        sort = exerciseMetrics.sort(by: [timeSD])
        sort = exerciseMetrics.sort(by: [lengthSD])
        sort = exerciseMetrics.sort(by: [velocitySD])
        sort = exerciseMetrics.sort(by: [timeSD])

        //test are in order
        
        sort = exerciseMetrics.sort(by: [dateSD])
        
        XCTAssertEqual(sort[0].date, date)
        XCTAssertEqual(sort[5].date, date5)
        
        sort = exerciseMetrics.sort(by: [weightSD])
        
        XCTAssertEqual(sort[0].weight, 6)
        XCTAssertEqual(sort[5].weight, 1)
        
        let highestWeight = sort[4]
        highestWeight.weightSV = 25
        
        sort = exerciseMetrics.sort(by: [weightSD])
        
        XCTAssertEqual(sort[0].weight, highestWeight.weightSV)
        
        //test sorting two metrics
        
        sort = exerciseMetrics.sort(by: [lengthSD, weightSD])
        
        //theres one with weight == 25,
        
        XCTAssertEqual(sort[0].lengthSV, 6)
        XCTAssertEqual(sort[4].weightSV, 25)
        
        
        
    }
    
    
    
}
