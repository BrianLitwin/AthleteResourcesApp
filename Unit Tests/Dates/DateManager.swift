//
//  DateManager.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/22/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

// DateManagers have two responsibilities:
// Keep track of the date of the first workout/bodyweight
// keep track of the active weeks between now and the first workout/bodyweight entry
//



class Date_Manager: XCTestCase {
    
    let date1 = getDate(daysAgo: 1)
    let date2 = getDate(daysAgo: 2)
    let date3 = getDate(daysAgo: 3)
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func test_DateManager_Workouts() {
        
        let workout1 = Workouts.createNewWorkout()
        let workout2 = Workouts.createNewWorkout()
        let workout3 = Workouts.createNewWorkout()
        
        workout1.dateSV = date1
        workout2.dateSV = date2
        workout3.dateSV = date3
        
        saveContext()
        
        let dateManager = DateManager(type: Workouts.self)
        
        //test that manager finds last workout
        XCTAssertEqual(dateManager.firstEntry, workout3)
        
        
        //Test changing the date of a firstWorkout
        workout3.dateSV = date1
        saveContext()
        XCTAssertEqual(dateManager.firstEntry, workout2)
        
        //test adding a workout with an earlier data
        let workout4 = Workouts.createNewWorkout()
        workout4.dateSV = getDate(daysAgo: 45)
        saveContext()
        XCTAssertEqual(dateManager.firstEntry, workout4)
        
        //test that active weeks changes if date of first workout is changed to a later date
        XCTAssertTrue(dateManager.activeWeeks.count > 5)
        
        //test that active weeks changes if date of first workout is changed to an earlier date
        workout4.dateSV = date1
        saveContext()
        XCTAssertTrue(dateManager.activeWeeks.count < 3)
        
        
    }
    
    func test_lastWorkoutDeleted() {
        
        //test deleting the first workout doesn't cause crash
        
        let workout1 = Workouts.createNewWorkout()
        
        let dateManager = DateManager(type: Workouts.self)
        
        workout1.delete()
        
        let newWorkout = Workouts.createNewWorkout() //was causing crash on unwrapping dateSV for firstEntry
        
        newWorkout.addNewSequence(at: 0, with: makeExercise() )
        
        //no crash = succesful test
        
    }
    
    
    func test_DateManager_Bodyweight() {
        
        var dateManager = DateManager(type: Bodyweight.self)
        
        //test that bodyweight is nil w/ no entries and weeksArray is []
        XCTAssertNil(dateManager.firstEntry)
        XCTAssertTrue(dateManager.activeWeeks.isEmpty)
        
        //test adding a first bodyweight
        let bWeight = Bodyweight(context: context)
        bWeight.dateSV = date1
        saveContext()
        XCTAssertEqual(dateManager.firstEntry, bWeight)
        
        //test that manager finds last bodyweight
        
        let bWeight1 = Bodyweight(context: context)
        bWeight1.dateSV = date2
        
        let bWeight2 = Bodyweight(context: context)
        bWeight2.dateSV = date3
        saveContext()
        
        dateManager = DateManager(type: Bodyweight.self)
        XCTAssertEqual(dateManager.firstEntry, bWeight2)
        
        //test changing date of the first bodyweight
        
        bWeight2.dateSV = date1
        saveContext()
        XCTAssertEqual(dateManager.firstEntry, bWeight1)
        
        //test adding a bodyweight with earlier date
        
        let bodyweight3 = Bodyweight(context: context)
        bodyweight3.dateSV = getDate(daysAgo: 45)
        saveContext()
        XCTAssertEqual(dateManager.firstEntry, bodyweight3)
        

    }

    
}
