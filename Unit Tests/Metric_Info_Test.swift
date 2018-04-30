//
//  Metric.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Metric_Test: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    
    func test_sort_order() {
        
        let weight = Metric_Info(context: context)
        weight.metric = Metric.Weight
        let reps = Metric_Info(context: context)
        reps.metric = Metric.Reps
        let sets = Metric_Info(context: context)
        sets.metric = Metric.Sets
        let time = Metric_Info(context: context)
        time.metric = Metric.Time
        let velocity = Metric_Info(context: context)
        velocity.metric = Metric.Velocity
        
        var array = [velocity, reps, sets, time, weight]
        var order = [weight, reps, sets, time, velocity]
        
        XCTAssertEqual(array.sortedByDefaultOrder, order)
        
        array = [time, reps]
        order = [reps, time]
        
        XCTAssertEqual(array.sortedByDefaultOrder, order)
        
        
    }
    
    func test_primaryMetrcs() {
    
        let exercise = makeExercise()
        XCTAssertEqual(exercise.metricInfoSet.primaryMetric.metric, .Weight)
        
    }
    
    
}
