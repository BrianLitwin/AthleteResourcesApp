//
//  CompoundExercise.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//


import XCTest
@testable import Resources2_1

class Compound_Exercise_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }

    
    func test_setUp() {
        
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
        
        XCTAssertEqual(compoundContainerType.orderedExerciseContainers.count, 3)
        
        let sequence = Sequences.createNewSequence(workout: workout,
                                                   workoutOrder: 0,
                                                   type: compoundContainerType)
        
        //test that the sequences type has 3 exerciseContainers
        
        XCTAssertEqual(sequence.multi_exercise_container_type!.orderedExercises.count, 3)
        
        
        //test three exercisemetrics are created initially /
        
        let initialExerciseMetrics = sequence.orderedContainers.map({ $0.exerciseMetrics })
        
        XCTAssertEqual(initialExerciseMetrics.count, 3)
        
        
        //Mark: Create Model //test initial conditions
        
        var model = CompoundExerciseModel(sequence: sequence)
        
        func exerciseMetrics(at row: Int) -> [Exercise_Metrics] {
            return model.section.exerciseMetrics(at: row)
        }
        
        let emptyRow = "0 lb x (0 + 0 + 0)"
        
        XCTAssertEqual(model.sections[0].data[0], emptyRow )
        
        
        //
        //Mark:Test Sequence Model Updater
        //
        
        
        let modelUpadater = SequenceModelUpdater(exerciseMetrics: exerciseMetrics(at: 0) )
        
        let textfields = modelUpadater.textfields
        let headers = modelUpadater.textfieldLabels
        
        XCTAssertEqual(headers[0], "Weight")
        
        //Test that weight saves to all exercise metrics
        
        textfields[0].saveValue!("500")
        
        for e in exerciseMetrics(at: 0) {
            XCTAssertEqual(e.weightSV, 500)
        }
        
        //Test Reps Text Fields
        
        XCTAssertEqual(headers[1], "Clean Reps")
        XCTAssertEqual(headers[2], "Front Squat Reps")
        XCTAssertEqual(headers[3], "Jerk Reps")
        
        //Test that reps save correctly
        
        textfields[1].saveValue!("2")
        
        XCTAssertEqual(exerciseMetrics(at: 0)[0].repsSV, 2)
        XCTAssertEqual(exerciseMetrics(at: 0)[1].repsSV, 0)
        XCTAssertEqual(exerciseMetrics(at: 0)[2].repsSV, 0)
        
        // Test that textField behaves correctly
        
        textfields[1].text = "2"
        textfields[1].resignFirstResponder()
        XCTAssertEqual(textfields[1].text, "2")
        
        
        textfields[3].saveValue!("4")
        
        XCTAssertEqual(exerciseMetrics(at: 0)[0].repsSV, 2)
        XCTAssertEqual(exerciseMetrics(at: 0)[1].repsSV, 0)
        XCTAssertEqual(exerciseMetrics(at: 0)[2].repsSV, 4)
        
        textfields[2].saveValue!("3")
        
        XCTAssertEqual(exerciseMetrics(at: 0)[0].repsSV, 2)
        XCTAssertEqual(exerciseMetrics(at: 0)[1].repsSV, 3)
        XCTAssertEqual(exerciseMetrics(at: 0)[2].repsSV, 4)
        
        //Test Sets Textfield
        
        XCTAssertEqual(headers[4], "Sets")
        
        textfields[4].saveValue!("2")
        
        for e in exerciseMetrics(at: 0) {
            XCTAssertEqual(e.setsSV, 2)
        }
        
        
        
        //Mark: Test Model Methods
        
        model = CompoundExerciseModel(sequence: sequence)
        
        XCTAssertEqual(model.section.sections[0].displayString(), "500 lb x (2 + 3 + 4) x 2")
        
        
        //test that sets don't show up if they equal ` or 0
        textfields[4].saveValue!("0")
        
        XCTAssertEqual(model.section.sections[0].displayString(), "500 lb x (2 + 3 + 4)")
        
        textfields[4].saveValue!("1")
        
        XCTAssertEqual(model.section.sections[0].displayString(), "500 lb x (2 + 3 + 4)")
        
        //Test: updateRow
        
        XCTAssertEqual(model.sections[0].data[0], "500 lb x (2 + 3 + 4) x 2")
        
        model.update(with: .editRow, at: [0,0])
        
        XCTAssertEqual(model.sections[0].data[0], "500 lb x (2 + 3 + 4)")
        
        //Mark: test adding a row
    
        model.update(with: .insertRow, at: [0,1])
        
        XCTAssertEqual(model.sections[0].data[0], "500 lb x (2 + 3 + 4)")
        XCTAssertEqual(model.sections[0].data[1], emptyRow)
        
        
        //Mark: test delete row
        
        model.update(with: .deleteRow, at: [0,0])
        XCTAssertEqual(model.sections[0].data[0], emptyRow)
        
        
    }
    
    func test_creatingDuplicateContainers() {
        
        //want to see if if there is a container containing the exercises in their exact order, if it's inActive, make it active and change its category, if it's active, change it's category
        
        
        
    }
    
    
    
    
}
 

