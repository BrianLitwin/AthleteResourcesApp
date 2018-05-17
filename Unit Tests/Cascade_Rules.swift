//
//  Cascade_Rules.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 3/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1
@testable import Resources_View2_1

class Cascade_Rules: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }

    func test() {
        
        //workout deletes exercise metrics, container, and sequences
        
        let workout = Workouts.createNewWorkout()
        
        let sequence = workout.addNewSequence(at: 0, with: makeExercise())
        
        XCTAssertEqual(workout.exerciseMetricsSet.count, 1)
        XCTAssertEqual(workout.orderedSequences.count, 1)
        XCTAssertEqual(workout.orderedSequences[0].containerSet.count, 1)
        
        workout.delete()
        
        //test that exercise metrics are deleted
        
        let em = Exercise_Metrics.fetchAll()
        
        XCTAssertEqual(em.count, 0)
        
        //test that containers are deleted
        
        let containers = EM_Containers.fetchAll()
        
        XCTAssertEqual(containers.count, 0)
        
        //test that sequences are deleted
        
        let sequences = Sequences.fetchAll()
        
        XCTAssertEqual(sequences.count, 0)
    }
    
}
