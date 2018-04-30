//
//  Workout_HistoryModel.swift
//  Unit Tests
//
//  Created by B_Litwin on 3/13/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Workout_HistoryModel: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }

    
    func test_Example() {
        let workout = Workouts.createNewWorkout()
        let workout1 = Workouts.createNewWorkout()
        
        //bug: workout history model wasn't updating correctly after it had been loaded
        //test creating class, then create new workout, and that the class adds the workout correctly 
        
        let workoutHistoryModel = WorkoutHistoryModel()
        workoutHistoryModel.loadModel()
        
        let _ = workoutHistoryModel.returnWorkout(for: [0,0])
        let _ = workoutHistoryModel.returnWorkout(for: [0,1])
        
        let newWorkout = Workouts.createNewWorkout()
        
        XCTAssertEqual(Workouts.fetchAll().count, 3)
        
        workoutHistoryModel.loadModel()
        
        XCTAssertEqual(workout, workoutHistoryModel.returnWorkout(for: [0,2]))
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
