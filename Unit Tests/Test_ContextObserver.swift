//
//  Test_ContextObservor.swift
//  Unit Tests
//
//  Created by B_Litwin on 5/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1
import CoreData

class Test_ContextObserver: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    
    class Test_ContextObserver: ContextObserver {
        
        var mostRecentChangesValues: [String: Any] = [:]
        
        override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any]) {
            mostRecentChangesValues = changedValues
        }
    }
    
    func test() {
        let contextObserver = Test_ContextObserver(context: context)
        
        //context observor should only send updated changes - one at a time
        
        let workout = Workouts.createNewWorkout()
        let exercise = makeExercise()
        workout.addNewSequence(at: 0, with: exercise)
        XCTAssertEqual(contextObserver.mostRecentChangesValues.count, 1)
        
        workout.addNewSequence(at: 1, with: exercise)
        XCTAssertEqual(contextObserver.mostRecentChangesValues.count, 1)
        
        
    }
    
}
