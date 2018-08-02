//
//  Test Record Sorter.swift
//  Resources
//
//  Created by B_Litwin on 11/30/17.
//  Copyright © 2017 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1


var data: [[Double]] = [[300, 5, 1],
            [300, 1, 5]
    
]

class TestRecordSorter: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func testTwo() {
        
        let sortDescriptors = [false, false, false]
        let metricCount = 3
        
        //let x = Sort(metricCount: metricCount, sortDescriptors: sortDescriptors)
        
        //var data: [comparison] = []
        var result: Bool!
    }
    
    
func testMetricCombinations() {
    
    var exercise = makeExercise()
    
    func makeMetrics(_ data: [[Double]]) -> (Exercise_Metrics, Exercise_Metrics) {
        let e1 = makeEM(with: exercise)
        e1.weightSV = data[0][0]
        e1.repsSV = data[0][1]
        e1.setsSV = data[0][2]
        
        let e2 = makeEM(with: exercise)
        e2.weightSV = data[1][0]
        e2.repsSV = data[1][1]
        e2.setsSV = data[1][2]
        
        return (e1, e2)
    }
    
    func clearRecords() {
        exercise.exerciseMetrics().forEach({ $0.delete() })
    }
    
        
    //
    //Test: Weight equal, reps lower
    //
        
    var data: [[Double]] = [
            [300, 5, 1],
            [300, 1, 5]
        ]
    
    var em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    var record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
    
        
    data = [
        [300, 1, 5],
        [300, 5, 1]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
        
        
    //
    //Test: Weight higher, reps and sets equal
    //
        
    data = [
        [300, 5, 5],
        [301, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
        
    data = [
        [301, 5, 5], 
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
        
        
    //
    //Test: Weight higher, reps higher and sets equal
    //
    data = [
        [300, 5, 5],
        [301, 6, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
        
    data = [
        [301, 6, 5],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
        
        
        
        
    //
    //Test: Weight higher, reps higher and sets higher
    //
    data = [
        [300, 5, 5],
        [301, 6, 6]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
        
    data = [
        [301, 6, 6],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
        
        
        
    
    //
    //Test: Weight equal, reps higher, and sets equal
    //
        
    data = [
        [300, 5, 5],
        [300, 6, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
        
    data = [
        [300, 6, 5],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
        
    
    //
    //Test: Weight equal, reps equal and sets higher
    //
        
    data = [
        [300, 5, 5],
        [300, 5, 6]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
        
    data = [
        [300, 5, 6],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
        
    //
    //Test: Weight equal reps lower, sets higher
    //
        
    data = [
        [300, 10, 1],
        [300, 5, 10]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
    
    data = [
        [300, 9, 10],
        [300, 10, 1]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
    
    
        
    //Test: nil: equal
    data = [
        [300, 5, 5],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    var records = exercise.personalRecordsManager.personalRecords
    XCTAssertEqual(records.count, 2)
    clearRecords()
    
        
    //
    //Test: nil: weight lower, reps higher, sets equal
    //
    
    data = [
        [299, 6, 5],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    records = exercise.personalRecordsManager.personalRecords
    XCTAssertEqual(records.count, 2)
    clearRecords()

    data = [
        [300, 5, 5],
        [299, 6, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    records = exercise.personalRecordsManager.personalRecords
    XCTAssertEqual(records.count, 2)
    clearRecords()
    
    
    //
    //Test: nil: weight lower, reps higher, sets higher
    //
        
    data = [
        [299, 6, 6],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    records = exercise.personalRecordsManager.personalRecords
    XCTAssertEqual(records.count, 2)
    clearRecords()
    
    data = [
        [299, 6, 6],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    records = exercise.personalRecordsManager.personalRecords
    XCTAssertEqual(records.count, 2)
    clearRecords()
        
    //
    //Test: nil: weight lower, reps higher, sets lower
    //
        
    data = [
        [299, 6, 4],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    records = exercise.personalRecordsManager.personalRecords
    XCTAssertEqual(records.count, 2)
    clearRecords()
        
    data = [
        [300, 5, 5],
        [299, 6, 4]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    records = exercise.personalRecordsManager.personalRecords
    XCTAssertEqual(records.count, 2)
    clearRecords()
        
        
    //
    //Test: weight equal, reps equal, sets higher   
    //
        
        
    data = [
        [300, 5, 5],
        [300, 5, 6]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
        
        
    data = [
        [300, 5, 6],
        [300, 5, 5]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
    
        
    
    //
    //Test: weight higher, reps equal, sets lower
    //
    
        
    data = [
        [301, 5, 1],
        [300, 5, 6]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.0)
    clearRecords()
    
    data = [
        [300, 5, 6],
        [301, 5, 1]
    ]
    
    exercise = makeExercise()
    em = makeMetrics(data)
    exercise.personalRecordsManager.updateRecords()
    record = exercise.personalRecordsManager.personalRecords[0]
    XCTAssertEqual(record, em.1)
    clearRecords()
        
        
    }
    
    
    func testTime() {
        
        var exercise: Exercises!
        
        func makeExercise() {
            exercise = Exercises(context: context)
            Metric_Info.create(metric: .Time, unitOfM: UnitDuration.seconds, exercise: exercise)
            Metric_Info.create(metric: .Reps, unitOfM: UnitReps.reps, exercise: exercise)
        }
        
        func makeMetrics(_ data: [[Double]]) -> (Exercise_Metrics, Exercise_Metrics) {
            let e1 = makeEM(with: exercise)
            e1.timeSV = data[0][0]
            e1.repsSV = data[0][1]
            
            let e2 = makeEM(with: exercise)
            e2.timeSV = data[1][0]
            e2.repsSV = data[1][1]
            
            return (e1, e2)
        }
        
        func clearRecords() {
            exercise.exerciseMetrics().forEach({ $0.delete() })
        }
        
        //
        //Test: time equal, reps equal
        //
        
       var data: [[Double]] = [
            [29.3, 5],
            [30.1, 5]
        ]
        
        makeExercise()
        var em = makeMetrics(data)
        exercise.personalRecordsManager.updateRecords()
        var record = exercise.personalRecordsManager.personalRecords[0]
        XCTAssertEqual(record, em.1)
        clearRecords()
        
         data = [
            [39.3, 5],
            [30.1, 5]
        ]
        
        makeExercise()
        em = makeMetrics(data)
        exercise.personalRecordsManager.updateRecords()
        record = exercise.personalRecordsManager.personalRecords[0]
        XCTAssertEqual(record, em.0)
        clearRecords()
        
        
        //test sort descriptor true one metric
        
        makeExercise()
        exercise.metricInfo[0].sort_in_ascending_order = true
        
        func makeMetrics1(_ data: [[Double]]) -> (Exercise_Metrics, Exercise_Metrics) {
            let e1 = makeEM(with: exercise)
            e1.timeSV = data[0][0]
            
            
            let e2 = makeEM(with: exercise)
            e2.timeSV = data[1][0]
            
            return (e1, e2)
        }
        
        data = [
            [29.3],
            [31.5]
        ]
        
        makeExercise()
        exercise.metricInfo[0].sort_in_ascending_order = true
        em = makeMetrics1(data)
        exercise.personalRecordsManager.updateRecords()
        record = exercise.personalRecordsManager.personalRecords[0]
        XCTAssertEqual(record, em.0)
        clearRecords()
        
        data = [
            [31.5],
            [29.3]
        ]
        
        makeExercise()
        exercise.metricInfo[0].sort_in_ascending_order = true
        em = makeMetrics1(data)
        exercise.personalRecordsManager.updateRecords()
        record = exercise.personalRecordsManager.personalRecords[0]
        XCTAssertEqual(record, em.1)
        clearRecords()
        
        
        
        //test sort descriptor false, one metric
        
        data = [
            [29.3],
            [31.5]
        ]
        
        makeExercise()
        em = makeMetrics1(data)
        exercise.personalRecordsManager.updateRecords()
        record = exercise.personalRecordsManager.personalRecords[0]
        XCTAssertEqual(record, em.1)
        clearRecords()
        
        data = [
            [49.3],
            [31.5]
        ]
        
        makeExercise()
        em = makeMetrics1(data)
        exercise.personalRecordsManager.updateRecords()
        record = exercise.personalRecordsManager.personalRecords[0]
        XCTAssertEqual(record, em.0)
        clearRecords()
        
        
    }
    
}










