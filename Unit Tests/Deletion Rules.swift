//
//  Deletion Rules.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/22/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

//Test whether cascading rules work

class Deletion_Rules: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func test() {
        
        //MARK: TEST PRE-EXISTING EXERCISE
        
        let exercise = makeExercise()
        
        let model = CreateOreditExercise(exercise: exercise)
        
        
        
        
    }
    
    
}
