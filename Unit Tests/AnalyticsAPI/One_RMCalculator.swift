//
//  One_RMCalculator.swift
//  Unit Tests
//
//  Created by B_Litwin on 3/20/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class One_RMCalculator: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func test() {
        
        let exercise = makeExercise()
        let em = makeEM(with: exercise)
        let model = OneRepMaxManager(exercise: exercise)
        
        em.weightSV = 300
        em.repsSV = 3
        model.loadModel()
        
        XCTAssertEqual(model.oneRM!.oneRM, 330)
        
        //test single reps
        em.repsSV = 1
        model.loadModel()
        XCTAssertEqual(model.oneRM!.oneRM, 300)
        
        em.weightSV = 217
        em.repsSV = 5
        model.loadModel()
        XCTAssertEqual(Int(model.oneRM!.oneRM), 253)
        
        em.weightSV = 401
        em.repsSV = 10
        model.loadModel()
        XCTAssertEqual(Int(model.oneRM!.oneRM), 534)
        
        //test multiple exercise_metrics
        let em1 = makeEM(with: exercise)
        let em2 = makeEM(with: exercise)
        
        em.weightSV = 386
        em.repsSV = 9
        em1.weightSV = 317
        em1.repsSV = 10
        em2.weightSV = 387
        em2.repsSV = 9
        
        model.loadModel()
        XCTAssertEqual(Int(model.oneRM!.oneRM), 503)
        
        
        
    }
    

    
}
