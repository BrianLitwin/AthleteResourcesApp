//
//  Create Exercises From Database.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Create_Exercises_From_Database: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func test_setup() {
        
        setupExercisesInDatabase()
        
        let category = Categories(context: context)
        let exercise1 = makeExercise()
        let exercise2 = makeExercise()
        let exercise3 = makeExercise()
        exercise1.name = "Clean"
        exercise2.name = "Front Squat"
        exercise3.name = "Jerk"
        
        let workout = Workouts.createNewWorkout()
        
        let compoundContainerType = Multi_Exercise_Container_Types.create(category: category, with: [exercise1, exercise2, exercise3])
        
        //Test that three containers are created when you create a new type with 3 exercises
        
        let sequence = workout.addNewSequence(at: 0, multiExerciseType: compoundContainerType)
        
        let sequence2 = workout.addNewSequence(at: 1, with: exercise1)
        
        let controller = WorkoutViewController()
        controller.viewDidLoad()
        
    }
    
    
}
