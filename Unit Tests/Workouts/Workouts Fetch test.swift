//
//  Workouts test.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1
import CoreData

class Workouts_test: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
   
    
    func testFirst() {

        let workout1 = Workouts.createNewWorkout()
        let workout2 = Workouts.createNewWorkout()
        let workout3 = Workouts.createNewWorkout()
        
        let date1 = getDate(daysAgo: 5) 
        let date2 = getDate(monthsAgo: 5)
        let date3 = getDate(daysAgo: 4)
        
        workout1.dateSV = date1
        workout2.dateSV = date2
        workout3.dateSV = date3
        
        let lastWorkout: Workouts? =  Workouts.fetchLast()
        let allWorkouts: [Workouts] = Workouts.fetchAll()
        
        print(allWorkouts.map({ $0.date.monthDay }))
     
        XCTAssert(lastWorkout == workout3)
        
    }
    
}
