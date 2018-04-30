//
//  Creating Exercises From Database.swift
//  ResourcesTests
//
//  Created by B_Litwin on 3/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Creating_Exercises_From_Database: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testExample() {
        
        setupExercisesInDatabase()
        let exercises = Exercises.fetchAll()
        
        for exercise in exercises {
            
            exercise.metricInfo.forEach({
                let _ = $0.metric
            })
            
            
            
            
            
        }
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
