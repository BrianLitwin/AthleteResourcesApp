//
//  PersonalRecords_DeletionTest.swift
//  Unit Tests
//
//  Created by B_Litwin on 4/8/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class PersonalRecords_DeletionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    
    
    func test_personalRecordsAreDeleted() {
        
        let exercise = makeExercise()
        
        let exercise2 = makeExercise()
        exercise2.name = "Something"
        let model2 = exercise2.personalRecordsManager
        model2.updateRecords()
        XCTAssertFalse(model2.needsReload)
        
        
        let em = makeEM(with: exercise)
        let em1 = makeEM(with: exercise)
        
        em1.weightSV = 100
        em1.repsSV = 4
        em1.setsSV = 2
        
        em.weightSV = 110
        em.repsSV = 1
        em.setsSV = 2
        
        let recordModel = exercise.personalRecordsManager
        
        recordModel.updateRecords()
        
        XCTAssertEqual(recordModel.personalRecords.count, 2)
        
        em.container?.sequence?.delete()
        
        recordModel.updateRecords()
        
        XCTAssertEqual(recordModel.personalRecords.count, 1)
        
        //need to test that other exercises aren't required to reload all if one exercisemetric is deleted
        //Pending: don't know how to implement this yet 
        
        XCTAssertFalse(model2.needsReload)
        
        
    }
    
    
}
