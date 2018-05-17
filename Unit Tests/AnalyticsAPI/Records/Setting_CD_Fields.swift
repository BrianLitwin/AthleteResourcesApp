//
//  Setting_CD_Fields.swift
//  Unit Tests
//
//  Created by B_Litwin on 3/23/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Setting_CD_Fields: XCTestCase {
    
    var exercise: Exercises!
    
    func createEM(weight: Double, reps: Double, sets: Double) -> Exercise_Metrics {
        let em = makeEM(with: exercise)
        em.weightSV = weight
        em.repsSV = reps
        em.setsSV = sets
        return em
    }
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
        exercise = makeExercise()
    }
    
    func test_records_are_set() {
        
        let em1 = createEM(weight: 100, reps: 10, sets: 1)
        let em2 = createEM(weight: 200, reps: 5, sets: 1)
        let em3 = createEM(weight: 300, reps: 1, sets: 1)
        
        //test that default records values are false in database
        
        XCTAssertFalse(em1.is_local_record)
        XCTAssertFalse(em1.is_personal_record)
        XCTAssertFalse(em2.is_local_record)
        XCTAssertFalse(em2.is_personal_record)
        XCTAssertFalse(em3.is_local_record)
        XCTAssertFalse(em3.is_personal_record)
        
        //test that is_personal_record, is_local_record fields are being set after an update
        
        var manager = exercise.personalRecordsManager
        manager.updateRecords()
        
        XCTAssertTrue(em1.is_local_record)
        XCTAssertTrue(em1.is_personal_record)
        XCTAssertTrue(em2.is_local_record)
        XCTAssertTrue(em2.is_personal_record)
        XCTAssertTrue(em3.is_local_record)
        XCTAssertTrue(em3.is_personal_record)
        
        //test that records are updated
        let em4 = createEM(weight: 301, reps: 1, sets: 1)
        manager.recalculateAll = true
        manager.updateRecords()
        
        XCTAssertTrue(em4.is_personal_record)
        XCTAssertTrue(em4.is_local_record)
        
        //old record should no longer be personal record but should remain local record
        XCTAssertFalse(em3.is_personal_record)
        XCTAssertTrue(em3.is_local_record)
        
        
    }
    
    
}
