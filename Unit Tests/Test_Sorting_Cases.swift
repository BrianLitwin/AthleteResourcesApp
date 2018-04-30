//
//  Test_Sorting_Cases.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/22/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Test_Sorting_Cases: XCTestCase {
    
    var exerciseMetrics: [Exercise_Metrics] = []
    var exercise: Exercises!
    
    func E(_ weight: Double, _ reps: Double, _ sets: Double) -> Exercise_Metrics {
        let p = makeEM(with: exercise)
        p.weightSV = weight
        p.repsSV = reps
        p.setsSV = sets
        return p
    }
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func test_weightSetsReps() {
       
        exercise = makeExercise()
        
        let e1 = E(300, 1, 1)
        let x1 = E(299, 1, 1)
        let x2 = E(200, 1, 10)
        
        let e2 = E(280, 2, 5)
        let x3 = E(280, 2, 4) //same weight, reps, fewwer sets
        let x4 = E(279, 2, 10) //less weight, same reps
        let x5 = E(280, 1, 10) // same weight, fewer reps
        
        let e3 = E(250, 5, 5)
        let x6 = E(250, 5, 4)
        let x7 = E(250, 4, 10)
        
        //randomizeEMs()
        
        //Test that they are sorted correctly first
        
        let em = exercise.sortByIsRecordOver(items: exercise.exerciseMetrics())
        
        let ordered = [e1, x1, e2, x3, x5, x4, e3, x6, x7, x2]
        
        XCTAssertEqual(em, ordered)
        
        exercise.personalRecordsManager.recalculateAll = true
        exercise.personalRecordsManager.updateRecords()
        let records = exercise.personalRecordsManager.personalRecords
        
        XCTAssertEqual(records, [e1, e2, e3] )
        
        for (i, x) in zip(em, ordered) {
            XCTAssertEqual(i, x)
            //print("\(Int(i.weightSV)) \(Int(i.repsSV)) \(Int(i.setsSV))")
        }
        
        print("****************")
        
        for record in records {
            print("\(Int(record.weightSV)) \(Int(record.repsSV)) \(Int(record.setsSV))")
        }
        
    }
    
    
    func test_equalExerciseMetrics() {
        
        //Mark: have to independently test this as Xcode will get ID's confused or something
        // in == operator in normal test
        
        exercise = makeExercise()
        
        _ = E(20, 5, 5)
        _ = E(20, 5, 5)
        
        exercise.personalRecordsManager.updateRecords()
        XCTAssertEqual(exercise.personalRecordsManager.personalRecords.count, 2)
        
        
    }
    
    
}



func combos<T>( array: Array<T>, k: Int) -> Array<Array<T>> {
    var array = array
    if k == 0 {
        return [[]]
    }
    
    if array.isEmpty {
        return []
    }
    
    let head = [array[0]]
    let subcombos = combos(array: array, k: k - 1)
    var ret = subcombos.map {head + $0}
    array.remove(at: 0)
    ret += combos(array: array, k: k)
    
    return ret
}














