//
//  Exercise_Metrics.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Test_Exercise_Metrics: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    
    func test_DisplayString() {
        
        var exerciseMetric = Exercise_Metrics(context: context)
        
        //test if exerciseMetric doesn't have exercise, or doesn't have metric_infos: doesn't crash
        
        XCTAssert( exerciseMetric.displayString() == "" )
        
        exerciseMetric = makeEM(with: Exercises(context: context))
        
        XCTAssert( exerciseMetric.displayString() == ""  )
        
        
        //test methods with weight, reps, and sets
        exerciseMetric = makeEM(with: makeExercise())
        
        exerciseMetric.weightSV = 200
        exerciseMetric.repsSV = 5
        exerciseMetric.setsSV = 2
        
        let metricInfos = exerciseMetric.metricInfos
        
        var weight: String { return exerciseMetric.displayValue(for: metricInfos[0] ) }
        var reps: String { return exerciseMetric.displayValue(for: metricInfos[1] ) }
        var sets: String { return exerciseMetric.displayValue(for: metricInfos[2] ) }
        
        XCTAssert(weight == "200" )
        XCTAssert(reps == "5")
        XCTAssert(sets == "2")
        XCTAssertEqual(exerciseMetric.displayString(), "200 lb x 5 x 2")
        
        //test that sets == 1 doesn't show sets in displayString when sets is last
        
        exerciseMetric.weightSV = 3
        exerciseMetric.repsSV = 500
        exerciseMetric.setsSV = 1
        
        XCTAssert(weight == "3" )
        XCTAssert(reps == "500")
        XCTAssert(sets == "1")
        XCTAssertEqual(exerciseMetric.displayString(), "3 lb x 500")
        
        //test that sets == 1 doesn't show sets in displayString when sets is first
        
        let backSquat = Exercises(context: context)
        Metric_Info.create(metric: Metric.Sets, unitOfM: UnitMass.pounds, exercise: backSquat)
        Metric_Info.create(metric: Metric.Time, unitOfM: UnitDuration.seconds, exercise: backSquat)
        
        var em2 = makeEM(with: backSquat)
        em2.setsSV = 1
        em2.timeSV = 30
        
        XCTAssertEqual(em2.displayString(), "30 s")
        
    
    }
    
    func test_minutes_seconds_feet_inches() {
        
        //Feet/inches
        
        //test feet/inches getters 
        let em = Exercise_Metrics(context: context)
        em.timeSV = 59
        XCTAssertEqual(em.wholeMinutes, 0)
        XCTAssertEqual(em.remainderSeconds, 59)
        em.timeSV = 61
        XCTAssertEqual(em.wholeMinutes, 1)
        XCTAssertEqual(em.remainderSeconds, 1)
        em.timeSV = 180
        XCTAssertEqual(em.wholeMinutes, 3)
        XCTAssertEqual(em.remainderSeconds, 0)
        
        //test whole feet: setters
        
        em.timeSV = 121
        em.wholeMinutes = 3
        XCTAssertEqual(em.timeSV, 181)
        
        em.timeSV = 66
        em.remainderSeconds = 35
        XCTAssertEqual(em.timeSV, 95)
        
        //text minutes/sec getters
        
        em.lengthSV = 11
        XCTAssertEqual(em.wholeFeet, 0)
        XCTAssertEqual(em.remainderInches, 11)
        em.lengthSV = 14
        XCTAssertEqual(em.wholeFeet, 1)
        XCTAssertEqual(em.remainderInches, 2)
        em.lengthSV = 36
        XCTAssertEqual(em.wholeFeet, 3)
        XCTAssertEqual(em.remainderInches, 0)
        
        //minutes/sec setters
        
        em.lengthSV = 44
        em.wholeFeet = 1
        XCTAssertEqual(em.lengthSV, 20)
        
        em.lengthSV = 47
        em.remainderInches = 4
        XCTAssertEqual(em.lengthSV, 40)
        
    }
    
    
    
}
