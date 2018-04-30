//
//  ExerciseMetricInputManager.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1
@testable import Resources_View2_1

class Test_ExerciseMetricInputManager: XCTestCase {
    
    typealias TextField = EditExerciseMetricTextField
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    

    func test() {
       
        let eM = makeEM(with: makeExercise())
        
        var model = SequenceModelUpdater(exerciseMetric: eM)
        var view = ExerciseMetricEditingTableView(modelUpdater: model)
        
        func createNewModelandview() {
            model = SequenceModelUpdater(exerciseMetric: eM)
            view = ExerciseMetricEditingTableView(modelUpdater: model)
        }
        
        var textFields: [TextField] {
            return view.textFields
        }
        
        XCTAssert(textFields.count == 3)
        
        //test that exerciseMetrics save values 
        
        textFields[0].saveValue!("1.5")
        textFields[1].saveValue!("5")
        
        
        XCTAssert(eM.weightSV == 1.5 )
        XCTAssert(eM.repsSV == 5)
        
        //test that sets default value is 1
        
        createNewModelandview()
        
        XCTAssertEqual(textFields[2].text, "1")
        
        
        //test that the textfields have the right value when they load (saved previously)
        createNewModelandview()
        
        XCTAssertEqual(textFields[0].text, "1.5")
        
        textFields[1].saveValue!("15")
        
        createNewModelandview()
        
        XCTAssertEqual(textFields[1].text,"15")
        
        
        
        //test that textfield with weight of 0, sets == 1, reps == 1 clears text when editing begins
        textFields[0].text = "0"
        textFields[1].text = "1"
        textFields[2].text = "1"
        
        XCTAssertEqual( textFields[0].setTextForEditingState!(.beginning), "" )
        
        //--> Not setting the default value to 1 anymore for sets and reps
        //XCTAssertEqual( textFields[1].setTextForEditingState!(.beginning), "" )
        //XCTAssertEqual( textFields[2].setTextForEditingState!(.beginning), "" )
        
        //test that textfield with empty value is set back to 1 for sets, reps, 0 for weight
        
        XCTAssertEqual( textFields[0].setTextForEditingState!(.ending), "0" )
        XCTAssertEqual( textFields[1].setTextForEditingState!(.ending), "1" )
        XCTAssertEqual( textFields[2].setTextForEditingState!(.ending), "1" )
        
        //test that on initial load, the first textfield is firstResponder and has "" value 
        view = ExerciseMetricEditingTableView(modelUpdater: model)
        textFields[0].text = ""
        
    }
    
    func test_MinutesSeconds() {
        
        
        var backsquat = Exercises(context: context)
        var eM = makeEM(with: backsquat)
        Metric_Info.create(metric: .Time, unitOfM: UnitDuration.minutes, exercise: backsquat)
        Metric_Info.create(metric: .Reps, unitOfM: UnitReps.reps, exercise: backsquat)

        XCTAssertEqual(eM.metricInfos.map({ $0.metric }), [Metric.Reps, Metric.Time])
        
        var model = SequenceModelUpdater(exerciseMetric: eM)
        var view = ExerciseMetricEditingTableView(modelUpdater: model)
        
        var textFields: [TextField] {
            return view.textFields
        }
        
        
        //Test that minutes and seconds are labeled correctly on the header when you load a min:sec metric
        
        /*
        
        XCTAssert(view.textFields.count == 3)
        XCTAssertEqual(view.textFields[1].header, "Minutes")
        XCTAssertEqual(manager.textFieldContainers[2].header, "Seconds")
 
     */
        
        
        
    }
    
    
    
    
}
