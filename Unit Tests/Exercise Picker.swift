//
//  Exercise Picker.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Exercise_Picker: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test() {
        
        let category = Categories(context: context)
        let exercise1 = makeExercise()
        let exercise2 = makeExercise()
        let exercise3 = makeExercise()
        exercise1.name = "Clean"
        exercise2.name = "Front Squat"
        exercise3.name = "Jerk"
        category.isActive = true
        exercise1.isActive = true
        exercise2.isActive = true
        exercise3.isActive = true
        exercise1.category = category
        exercise2.category = category
        exercise3.category = category
        
        
        let compoundContainerType = Multi_Exercise_Container_Types.create(category: category, with: [exercise1, exercise2, exercise3])
        compoundContainerType.isActive = true
        
        let exercise4 = Exercises(context: context)
        exercise4.isActive = true
        exercise4.category = category
        exercise4.name = "Split Jerk"
        
        let exercisePickerModel = ExercisePickerDropDownModel(includeMultiExerciseContainer: true)
        
        exercisePickerModel.loadModel()
        
        XCTAssertEqual(exercisePickerModel.data[0].count, 5)
        
        //alphabetical order
        
        XCTAssertEqual(exercisePickerModel.data[0][0].name, "Clean")
        XCTAssertEqual(exercisePickerModel.data[0][1].name, "Clean + Front Squat + Jerk")
        XCTAssertEqual(exercisePickerModel.data[0][2].name, "Front Squat")
        XCTAssertEqual(exercisePickerModel.data[0][3].name, "Jerk")
        XCTAssertEqual(exercisePickerModel.data[0][4].name, "Split Jerk")
    
        
        
    }
    
    
}
