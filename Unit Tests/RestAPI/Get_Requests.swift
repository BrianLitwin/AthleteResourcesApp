//
//  Get_Requests.swift
//  Unit Tests
//
//  Created by B_Litwin on 5/17/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Get_Requests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    func test_creatingDuplicates() {
        
        //exercises
        let exercise = makeExercise()
        exercise.name = "exercise1"
        exercise.variation = "aVariation"
        let retExercise = Exercises.exerciseAlreadyExistsWith(name: "exercise1", variation: "aVariation")
        XCTAssertNotNil(retExercise)
        
        
        
    }
}
