//
//  Sequence sequence.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 1/31/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Sequence_Model: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context =  setUpInMemoryManagedObjectContext()
    }
    
    func test_Model() {
        
        let sequence = Sequences(context: context)
        let exercise = makeExercise()
        let container = EM_Containers.create(exercise: exercise, sequence: sequence, order: 0)
        
        func exercises() -> [Exercises] {
            return sequence.orderedContainers.map({ $0.exercise! })
        }
        
        func containerAt(_ int: Int) -> EM_Containers {
            return sequence.orderedContainers[int]
        }
        
        func weightsAt(_ index: Int) -> [Double] {
            let container = containerAt(index)
            return container.exerciseMetrics.map({ $0.weight })
        }
        
        //test initial values
        
        XCTAssert(sequence.containers?.count == 1)
        XCTAssert(containerAt(0).exerciseMetrics.count == 1)
        
        func insertAndRemoveExerciseMetrics(from Num: Int) {
        
            containerAt(Num).exerciseMetrics[0].weightSV = 200
            
            // insert exercise metric
            
            _ = sequence.insertExerciseMetric(at: [Num,  1])
            containerAt(Num).exerciseMetrics[1].weightSV = 100
            
            XCTAssert(containerAt(Num).exerciseMetrics.count == 2)
            XCTAssertEqual(weightsAt(Num), [200, 100])
            
            //insert exerciseMetric at beginning
            
            _ = sequence.insertExerciseMetric(at: [Num, 0])
            containerAt(Num).exerciseMetrics[0].weightSV = 300
            XCTAssertEqual(weightsAt(Num), [300, 200, 100])
            
            //insert exerciseMetric at end
            
            _ = sequence.insertExerciseMetric(at: [Num, 3])
            containerAt(Num).exerciseMetrics[3].weightSV = 400
            XCTAssertEqual(weightsAt(Num), [300, 200, 100, 400])
            
            //remove exerciseMetric at beginning
            
            sequence.removeExerciseMetric(at: [Num, 0])
            XCTAssertEqual(weightsAt(Num), [200, 100, 400])
            
            //remove exerciseMetric from the middle
            
            sequence.removeExerciseMetric(at: [Num, 1])
            XCTAssertEqual(weightsAt(Num), [200, 400])
            
            //remove exerciseMetric from end
            
            sequence.removeExerciseMetric(at: [Num, 1])
            XCTAssertEqual(weightsAt(Num), [200])
        
        }
        
        
        
        insertAndRemoveExerciseMetrics(from: 0)
        
        //add container
        
        let newExercise = makeExercise()
        XCTAssert(newExercise != exercise)
        sequence.insertContainer(exercise: newExercise, section: 1)
        XCTAssertEqual(exercises(), [exercise, newExercise])
        insertAndRemoveExerciseMetrics(from: 1)
        
        
        //add container to beginning
        
        let newExercise1 = makeExercise()
        sequence.insertContainer(exercise: newExercise1, section: 0)
        XCTAssertEqual(exercises(), [newExercise1, exercise, newExercise])
        insertAndRemoveExerciseMetrics(from: 0)
        
        //add container to middle
        
        let newExercise2 = makeExercise()
        sequence.insertContainer(exercise: newExercise2, section: 1)
        XCTAssertEqual(exercises(), [newExercise1, newExercise2, exercise, newExercise])
        insertAndRemoveExerciseMetrics(from: 1)
        
        //add container toEnd
        
        let newExercise3 = makeExercise()
        sequence.insertContainer(exercise: newExercise3, section: 4)
        XCTAssert(exercises()[0] == newExercise1)
        XCTAssert(exercises()[1] == newExercise2)
        XCTAssert(exercises()[2] == exercise)
        XCTAssert(exercises()[3] == newExercise)
        XCTAssert(exercises()[4] == newExercise3)

        insertAndRemoveExerciseMetrics(from: 4)
        insertAndRemoveExerciseMetrics(from: 4)
        
        //remove container from middle
        
        sequence.removeContainer(at: 3)
        XCTAssertEqual(exercises().count, 4)
        XCTAssert(exercises()[0] == newExercise1)
        XCTAssert(exercises()[1] == newExercise2)
        XCTAssert(exercises()[2] == exercise)
        XCTAssert(exercises()[3] == newExercise3)
        
        //remove container at beginning
        
        sequence.removeContainer(at: 0)
        XCTAssertEqual(exercises(), [newExercise2, exercise, newExercise3])
        
        
        //remove container from end
        sequence.removeContainer(at: 2)
        XCTAssertEqual(exercises(), [newExercise2, exercise])
        insertAndRemoveExerciseMetrics(from: 1)
        insertAndRemoveExerciseMetrics(from: 0)
        
        
    }
    
    func test_exerciseMetricForIndex() {
        
        //test fetching exercise metrics at
        
        let sequence = Sequences(context: context)
        let exercise = makeExercise()

        sequence.insertContainer(exercise: exercise, section: 0)
        sequence.insertContainer(exercise: exercise, section: 1)
        sequence.insertContainer(exercise: exercise, section: 2)
        sequence.insertContainer(exercise: exercise, section: 3)
        
        _ = sequence.insertExerciseMetric(at: [0,0])
        _ = sequence.insertExerciseMetric(at: [0,1])
        _ = sequence.insertExerciseMetric(at: [0,2])
        _ = sequence.insertExerciseMetric(at: [0,3])
        
        _ = sequence.insertExerciseMetric(at: [1,0])
        _ = sequence.insertExerciseMetric(at: [1,1])
        _ = sequence.insertExerciseMetric(at: [1,2])
        _ = sequence.insertExerciseMetric(at: [1,3])
        
        _ = sequence.insertExerciseMetric(at: [2,0])
        _ = sequence.insertExerciseMetric(at: [2,1])
        _ = sequence.insertExerciseMetric(at: [2,2])
        _ = sequence.insertExerciseMetric(at: [2,3])

        sequence.orderedContainers[0].exerciseMetrics[0].weightSV = 100
        sequence.orderedContainers[0].exerciseMetrics[1].weightSV = 20
        sequence.orderedContainers[1].exerciseMetrics[2].weightSV = 3
        sequence.orderedContainers[1].exerciseMetrics[3].weightSV = 400
        sequence.orderedContainers[2].exerciseMetrics[0].weightSV = 500
        sequence.orderedContainers[2].exerciseMetrics[3].weightSV = 600
        
        XCTAssert(sequence.exerciseMetric(for: [0,0]).weightSV == 100 )
        XCTAssert(sequence.exerciseMetric(for: [0,1]).weightSV == 20 )
        XCTAssert(sequence.exerciseMetric(for: [1,2]).weightSV == 3 )
        XCTAssert(sequence.exerciseMetric(for: [1,3]).weightSV == 400 )
        XCTAssert(sequence.exerciseMetric(for: [2,0]).weightSV == 500 )
        XCTAssert(sequence.exerciseMetric(for: [2,3]).weightSV == 600 )
        
        
    }
    

    
}
