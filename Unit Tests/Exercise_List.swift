//
//  Exercise_List.swift
//  Unit Tests
//
//  Created by B_Litwin on 4/3/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Exercise_List: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func test_exercise_workoutCount() {
        
        let exercise = makeExercise()
        
        //no workouts
        XCTAssertEqual(exercise.workoutsUsed, 0)
        
        //add 3 workouts
        for _ in 0..<2 {
            let workout = Workouts.createNewWorkout()
            let em = makeEM(with: exercise)
            em.container?.sequence?.workout = workout
        }
        
        let workout = Workouts.createNewWorkout()
        let em = makeEM(with: exercise)
        em.container?.sequence?.workout = workout
        
        XCTAssertEqual(exercise.workoutsUsed, 3)
        
        workout.delete()
        
        //delete a workout
        XCTAssertEqual(exercise.workoutsUsed, 2)
        
    }
    
    func test_multi_exercise_containerCount() {
        
        let exercise1 = makeExercise()
        let exercise2 = makeExercise()
        let category = Categories(context: context)
        
        let container = Multi_Exercise_Container_Types.create(category: category, with: [exercise1, exercise2])
        
        XCTAssertEqual(container.workoutsUsed, 0)
        
        for i in 0..<2 {
            let workout = Workouts.createNewWorkout()
            let _ = Sequences.createNewSequence(workout: workout, workoutOrder: i, type: container)
        }
        
        XCTAssertEqual(container.workoutsUsed, 2)
        
    }
    
    func test_fetchActive() {
        
        let exercise1 = makeExercise()
        let exercise2 = makeExercise()
        let exercise3 = makeExercise()
        
        exercise1.isActive = true
        exercise2.isActive = false
        exercise3.isActive = false
        
        XCTAssertEqual(Exercises.fetchAll(active: true).count, 1)
        
        exercise2.isActive = true
        
        XCTAssertEqual(Exercises.fetchAll(active: true).count, 2)
        
        let container = Multi_Exercise_Container_Types.create(category: Categories(context: context), with: [exercise1, exercise2])
        
        let container2 = Multi_Exercise_Container_Types.create(category: Categories(context: context), with: [exercise1, exercise2])
        
        XCTAssertEqual(Multi_Exercise_Container_Types.fetchAll(active: true).count, 2)
        
    }
    
    func test_model() {
        
        let exercise = makeExercise()
        
        //no workouts
        XCTAssertEqual(exercise.workoutsUsed, 0)
        
        //add 3 workouts
        for _ in 0..<2 {
            let workout = Workouts.createNewWorkout()
            let em = makeEM(with: exercise)
            em.container?.sequence?.workout = workout
        }
        
        let exercise1 = makeExercise()
        let exercise2 = makeExercise()
        let category = Categories(context: context)
        
        let container = Multi_Exercise_Container_Types.create(category: category, with: [exercise1, exercise2])
        
        for i in 0..<3 {
            let workout = Workouts.createNewWorkout()
            let _ = Sequences.createNewSequence(workout: workout, workoutOrder: i, type: container)
        }
        
        
        let exercise4 = makeExercise()
        let workout = Workouts.createNewWorkout()
        let em = makeEM(with: exercise4)
        em.container?.sequence?.workout = workout
        
        let model = ExerciseListModel()
        
        XCTAssertEqual(model.listItems.count, 5)
        
        
    }
}
