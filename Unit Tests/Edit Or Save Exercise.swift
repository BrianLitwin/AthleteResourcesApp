//
//  Edit Or Save Exercise.swift
//  Resources2.1Tests
//
//  Created by B_Litwin on 2/22/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1


class Edit_Or_Save_Exercise: XCTestCase {
    
    var model: UpdateExercise!
    
    var weight: PendingUpdate {
        return model.pendingUpdates[0]
    }
    
    var reps: PendingUpdate {
        return model.pendingUpdates[1]
    }
    
    var sets: PendingUpdate {
        return model.pendingUpdates[2]
    }
    
    var time: PendingUpdate {
        return model.pendingUpdates[3]
    }
    
    var length: PendingUpdate {
        return model.pendingUpdates[4]
    }
    
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    
    func testExample() {
        
        let exercise = makeExercise()
        let category = Categories(context: context)
        
        //Change weight unit to KGs for testing
        
        exercise.metricInfo[0].unit_of_measurement = UnitMass.kilograms.symbol
        exercise.name = "Back Squat"
        exercise.variation = "Dead Stop"
        
        model = UpdateExercise(exercise: exercise, category: category)
        
        //
        //Mark: Test Initial State
        //
        
        XCTAssertEqual(weight.metric, Metric.Weight)
        XCTAssertEqual(reps.metric, Metric.Reps)
        XCTAssertEqual(sets.metric, Metric.Sets)
        XCTAssertEqual(time.metric, Metric.Time)
        XCTAssertEqual(length.metric, Metric.Length)
        
        //Test Name, Variation, Instructions label
        
        let NVI = model.pendingNVI
        
        XCTAssertEqual(NVI.pendingState.name, "Back Squat")
        XCTAssertEqual(NVI.pendingState.variation, "Dead Stop")
        XCTAssertEqual(NVI.pendingState.instructions, "")
        
        // Test Active vs InActive Metrics
        
        XCTAssertTrue(weight.initialState.isActive)
        XCTAssertTrue(reps.initialState.isActive)
        XCTAssertTrue(sets.initialState.isActive)
        
        XCTAssertFalse(time.initialState.isActive)
        XCTAssertFalse(length.initialState.isActive)
        
        // Test Unit Options
        
        XCTAssertEqual(weight.initialState.unitSelection, 1)
        XCTAssertEqual(reps.initialState.unitSelection, 0)
        XCTAssertEqual(length.initialState.unitSelection, 0)
        
        // Test Time Metric is set to SortInAscendingOrder
        
        XCTAssertTrue(time.initialState.sortInAscendingOrder)
        XCTAssertFalse(reps.initialState.sortInAscendingOrder)
        
        //
        // Mark: Test making changes to name, variation, and instructions
        //
        
        XCTAssertFalse(NVI.dataWasUpdated()) //test initial condition
        
        NVI.updateInstructions(with: "Below Parrelel")
        XCTAssertEqual(NVI.pendingState.instructions,  "Below Parrelel")
        XCTAssertTrue(NVI.dataWasUpdated())
        
        //test switching back to original state
        NVI.updateInstructions(with: "") //resset
        XCTAssertFalse(NVI.dataWasUpdated())
        
        NVI.updateName(with: "Front Squat")
        XCTAssertEqual(NVI.pendingState.name,  "Front Squat")
        XCTAssertTrue(NVI.dataWasUpdated())
        
        
        //
        //Mark: Test making updates to Metrics
        //
        
        //test initial state
        XCTAssertFalse(weight.dataWasUpdated() )
        
        //test state after updating Is Active
        
        XCTAssertTrue(weight.initialState.isActive) //initial state
        
        weight.metricIs(active: false) //change state
        XCTAssertFalse(weight.pendingState.isActive) //test change in pendingState
        XCTAssertTrue(weight.initialState.isActive) //test that there was no change in initial state
        XCTAssertTrue(weight.dataWasUpdated() ) //test that data was updated
        
        //reset state
        weight.metricIs(active: true)
        XCTAssertFalse(weight.dataWasUpdated() )
        
        //test changing ascending order
        weight.sortInAscendingOrder(update: true)
        XCTAssertTrue(weight.dataWasUpdated() )
        
        weight.sortInAscendingOrder(update: false) //reset
        
        //test changing unit
        weight.unitSelectionChanged(to: 0)
        XCTAssertTrue(weight.dataWasUpdated())
        
        //
        // Mark: test saving changes to  Metrics
        //
        
        weight.unitSelectionChanged(to: 2)
        reps.metricIs(active: false)
        time.metricIs(active: true)
        time.sortInAscendingOrder(update: false)
        
        model.saveAllChanges()
        
        XCTAssertEqual(exercise.metricInfo[0].unit_of_measurement!, UnitMass.ounces.symbol)
        XCTAssertEqual(exercise.metricInfo[1].metric, .Sets)
        XCTAssertEqual(exercise.metricInfo[2].metric, .Time)
        XCTAssertEqual(exercise.metricInfo[2].sort_in_ascending_order, false)
        
        
        //
        //Mark: Test Saving Changes to NVI
        //
        
        NVI.updateName(with: "Leg Press")
        NVI.updateVariation(with: "Narrow Foot Position")
        NVI.updateInstructions(with: "Focus on lowering the weight slowly")
        
        model.saveAllChanges()
        
        XCTAssertEqual(exercise.name, "Leg Press")
        XCTAssertEqual(exercise.variation, "Narrow Foot Position")
        XCTAssertEqual(exercise.instructions, "Focus on lowering the weight slowly")

    }
    
    
    func test_create_exercise() {
        
        let category = Categories(context: context)
        category.name = "Plyometrics"
        
        model = UpdateExercise(exercise: nil, category: category)
        

        
    }
    
    func test_updatesAreComplete() {
        
        //
        //Test New Exercise
        //
        
        var exercise = Exercises(context: context)
        let category = Categories(context: context)
        
        model = UpdateExercise(exercise: exercise, category: category)
        
        XCTAssertEqual(model.UpdatesRequiredToComplete(), UpdateExercise.UnableToSaveUpdate.noName) //test no name selected
        
        model.pendingNVI.updateName(with: "ExerciseName")
        model.saveAllChanges()
        
        XCTAssertEqual(model.UpdatesRequiredToComplete(), UpdateExercise.UnableToSaveUpdate.noMetricsSelected)
        
        weight.metricIs(active: true)
        model.saveAllChanges()
        
        XCTAssertNil(model.UpdatesRequiredToComplete() )
        
        //
        // Test previously created exercise
        //
        
        exercise = makeExercise()
        
        model = UpdateExercise(exercise: exercise, category: category)
        
        model.pendingNVI.updateName(with: "ExerciseName")
        model.pendingNVI.updateName(with: "   ") //update name with blank spaces
        model.saveAllChanges()
        
        XCTAssertEqual(model.UpdatesRequiredToComplete(), UpdateExercise.UnableToSaveUpdate.noName) //test no name selected
        
        model.pendingNVI.updateName(with: "ExerciseName")
        
        weight.metricIs(active: false)
        reps.metricIs(active: false) //Test by setting all the metrics to not active
        sets.metricIs(active: false)
        model.saveAllChanges()
        
        XCTAssertEqual(model.UpdatesRequiredToComplete(), UpdateExercise.UnableToSaveUpdate.noMetricsSelected)
        
        reps.metricIs(active: true)
        model.saveAllChanges()
        
        XCTAssertNil(model.UpdatesRequiredToComplete() )
        
    }
    
    
    func test_selected_Unit_Index() {
        
        let exercise = Exercises(context: context)
        let metricInfo1 = Metric_Info.create(metric: .Weight, unitOfM: UnitMass.kilograms, exercise: exercise)
        let metricInfo2 = Metric_Info.create(metric: .Time, unitOfM: UnitDuration.seconds, exercise: exercise)
        let category = Categories(context: context)
        model = UpdateExercise(exercise: exercise, category: category)
        
        XCTAssertEqual(weight.selectedUnitIndex, 1)
        XCTAssertEqual(time.selectedUnitIndex, 1)
        XCTAssertEqual(length.selectedUnitIndex, nil)
        
        time.metricIs(active: false)
        XCTAssertEqual(time.selectedUnitIndex, nil)
        
    }
    
    func test_duplicateExercise() {
        
        let exercise = makeExercise()
        exercise.name = "Leg Press"
        exercise.variation = ""
        
        let model = UpdateExercise(exercise: exercise, category: Categories(context: context))
        //test that exercise variation is set to "" by default
        
        XCTAssertEqual((model.pendingNVI as! PendingNVIUpdate).initialState.variation, "")
        
        model.pendingNVI.pendingState.name = "Leg Press"
        
        //test that exercise exists
        
        XCTAssertEqual(Exercises.exerciseAlreadyExistsWith(name: "Leg Press", variation: ""), exercise)
        
    }
    
    func test_newExerciseCreated_isActive() {

        let model = UpdateExercise(exercise: nil, category: Categories(context: context))
        
        model.pendingUpdates[0].metricIs(active: true)
        model.pendingNVI.updateName(with: "exercise")
        
        model.saveAllChanges()
        
        XCTAssertTrue(model.exercise!.isActive)
        
    }
    
    func test_switch_lbs_to_kg_backToLbs() {
        
        let e = makeExercise()
        let em = makeEM(with: e)
        let category = Categories(context: context)
        model = UpdateExercise(exercise: e, category: category)
        
        var weightMetric: Metric {
            return em.exercise!.metricInfo[0].metric
        }
        
        //first unit is lbs
        XCTAssertEqual(model.pendingUpdateModels[0].selectedUnitIndex, 0)
        model.pendingUpdateModels[0].unitSelectionChanged(to: 1)
        model.saveAllChanges()
        
        //switch to kg
        model = UpdateExercise(exercise: e, category: category)
        XCTAssertEqual(model.pendingUpdateModels[0].selectedUnitIndex, 1)
        model.pendingUpdateModels[0].unitSelectionChanged(to: 0)
        model.saveAllChanges()
        
        //back to lbs
        model = UpdateExercise(exercise: e, category: category)
        XCTAssertEqual(model.pendingUpdateModels[0].selectedUnitIndex, 0)
        
        
    }

    
}
