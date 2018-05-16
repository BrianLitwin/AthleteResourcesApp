//
//  Compound ExerciseRecords.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 3/2/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources_View2_1
@testable import Resources2_1

class Compound_ExerciseRecords: XCTestCase {
    
    var type: Multi_Exercise_Container_Types!
    
    var containerType: Multi_Exercise_Container_Types!
    
    func compoundSet(_ weight: Double, _ reps: [Double], _ sets: Double) -> CompoundRecordClass
    {
        
        let sequence = Sequences.createNewSequence(workout: Workouts.createNewWorkout(), workoutOrder: 0, type: containerType)
        
        let sectionModel = CompoundExerciseModel(sequence: sequence)
        
        let ems = sequence.orderedContainers.map({ $0.exerciseMetrics[0] })
        
        for (i, rep) in reps.enumerated() {
            ems.map({ $0.weightSV = weight })
            ems.map({ $0.setsSV = sets })
            ems[i].repsSV = rep
        }
        
        return CompoundRecordClass(exerciseMetrics: ems)
        
    }
    
    override func setUp() {
        context = setUpInMemoryManagedObjectContext()
        
        containerType = Multi_Exercise_Container_Types.create(category: Categories(context: context) , with:  [makeExercise(), makeExercise(), makeExercise()])
        
        
    }

    
    func test_setup() {
        
        //equal
        
        let recordManager = containerType.personalRecordsManager
        
        let a = compoundSet(1, [1, 1, 1], 1)
        let b = compoundSet(1, [1, 1, 1], 1)
        recordManager.updateRecords()
        XCTAssertEqual(recordManager.personalRecords.count, 2)
    
    }
    
    func test_weight_is_greater() {
        let recordManager = containerType.personalRecordsManager
        //weight greater, reps equal, sets equal
        let c = compoundSet(2, [1, 1, 1], 1)
        let d = compoundSet(1, [1, 1, 1], 1)
        recordManager.updateRecords()
        var record = recordManager.personalRecords.first!
        XCTAssertEqual(record, c)
        XCTAssertEqual(recordManager.personalRecords.count, 1)
        
    }
    
    func test_reps_are_greater() {
        let recordManager = containerType.personalRecordsManager
        //weight equal, reps greater, sets equal
        let e = compoundSet(1, [2, 1, 1], 1)
        let f = compoundSet(1, [1, 1, 1], 1)
 
        recordManager.updateRecords()
        let record = recordManager.personalRecords.first!
        XCTAssertEqual(record, e)
        XCTAssertEqual(recordManager.personalRecords.count, 1)

    }
    
    func test_reps_uneven() {
    
        let recordManager = containerType.personalRecordsManager

        let a = compoundSet(1, [2, 1, 2], 1)
        let b = compoundSet(1, [1, 2, 5], 1)
        recordManager.personalRecords = []
        recordManager.updateRecords()
        let record = recordManager.personalRecords.first!
        XCTAssertEqual(recordManager.personalRecords.count, 2)
        
        
    }

}




