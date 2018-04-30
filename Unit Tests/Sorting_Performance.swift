//
//  Sorting_Performance.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/23/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Sorting_Performance: XCTestCase {
    
    var exercise: Exercises!
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
        exercise = makeExercise()
        
        for _ in 0..<200 {
            
            let new = makeEM(with: exercise)
            new.weight = Double(arc4random())
            new.repsSV = Double(arc4random())
            new.setsSV = Double(arc4random())
            
        }
        
    }
    
    func test_performance_NewAlgorithm() {
        
        self.measure {
            
            _ = exercise.personalRecordsManager.updateRecords()
            
        }
        
    }
    
    
    func test_Performance_OldAlgorithm() {
        
        
    }
    
}
