//
//  Save.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 1/28/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//


@testable import Resources2_1
import XCTest

class EMValueSaveMethods: XCTestCase {
    
    var em: Exercise_Metrics!
    
    var weightMetric: Metric_Info {
        return em.container!.exercise!.metricInfo.first!
    }
    
    var repMetric: Metric_Info {
        return em.container!.exercise!.metricInfo[1]
    }
    
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext() 
    }
    
    func test_converting_between_lbs_and_kg() {
        
        var backsquat = makeExercise()
        em = makeEM(with: backsquat )
        
        var weight: Double { return em.value(for: .Weight).converted }
        
        em.save(double: 200, metric: .Weight)
        XCTAssert(weight == 200.0)
        
        let weightMetric = backsquat.metricInfo.sortedByMetricPriority[0]
        weightMetric.unit_of_measurement = UnitMass.kilograms.symbol
        XCTAssert( weight == 90.7184 )
        
        weightMetric.unit_of_measurement = UnitMass.pounds.symbol
        XCTAssert( weight == 200.0 )
    }
    
    func test_displaying_nonStandardValues() {
        
        em = makeEM(with: makeExercise())
        
        //test single missed rep
        
        em.missed_reps = true
        
        XCTAssertEqual(em.displayValue(for: repMetric), "X")
        
        //test reps + single missed rep
        
        em.repsSV = 5
        
        XCTAssertEqual(em.displayValue(for: repMetric), "5 + X")
        
        //test bodyweight
        
        em.used_bodyweight = true
        
        XCTAssertEqual(em.displayValue(for: weightMetric), "BW")
        
        XCTAssertEqual(em.displayString(), "BW x 5 + X")
    }
    
    func test_saving_nonStandardValues() {
        
        em = makeEM(with: makeExercise())
        
        var string = "5 + X"
        em.save(string: string, metricInfo: repMetric)
        XCTAssertTrue(em.missed_reps)
        XCTAssertEqual(em.repsSV, 5)
        
        string = "X"
        em.save(string: string, metricInfo: repMetric)
        XCTAssertTrue(em.missed_reps)
        XCTAssertEqual(em.repsSV, 0)
        
        string = "BW"
        em.save(string: string, metricInfo: weightMetric)
        XCTAssertTrue(em.used_bodyweight)
        XCTAssertEqual(em.weightSV, 0)
        
        
    }
    
}
