//
//  delete_first_workout.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class delete_first_workout: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
        
        
    }
    
    func test() {
        
        //test that when first workout has been deleted, or when current workout has been deleted, the workout controller deletes its workout
        
        let workout = Workouts.createNewWorkout()
        workout.addNewSequence(at: 0, with: makeExercise())
        
        let workoutController = getWorkoutViewController()
        
        //test that there is something in the content view to delete
        XCTAssertFalse(workoutController.scrollView.contentView.subviews.isEmpty)
        
        let workoutHistory = getWorkoutHistoryTableViewController()
        let tableViewModel = workoutHistory.reloadableModel as! WorkoutHistoryModel
        
        tableViewModel.loadModel() //this is normally done through the context observor 
        
        tableViewModel.deletItem(at: [0,0])
        
        XCTAssertEqual(workoutController.scrollView.contentView.subviews.count, 0)
        
        
        
        
    }
    
    
    
}
