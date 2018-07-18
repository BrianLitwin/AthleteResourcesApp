//
//  OneRM_Weeks.swift
//  Unit Tests
//
//  Created by B_Litwin on 3/23/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class OneRM_Weeks: XCTestCase {
    
    var exercise: Exercises!
    
    func createEMInWeek(week: Int, weight: Int, reps: Int) -> Exercise_Metrics {
        
        let daysAgo = (week * 7) -  1
        let date = Date().mondaysDate.add(days: -daysAgo)
        let workout = Workouts.createNewWorkout()
        workout.dateSV = date
        let em = makeEM(with: exercise)
        em.weightSV = Double(weight)
        em.repsSV = Double(reps)
        em.setsSV = 1
        em.container?.sequence?.workout = workout
        return em
    }
    
    
    func createEM(weight: Double, reps: Double, sets: Double, workout: Workouts) -> Exercise_Metrics {
        let em = makeEM(with: exercise)
        em.weightSV = weight
        em.repsSV = reps
        em.setsSV = sets
        em.container?.sequence?.workout = workout
        return em
    }
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
        exercise = makeExercise()
    }
    
    
    func test_four_weeks() {
        
        //weeks 4
        let workout4 = Workouts.createNewWorkout()
        let em4 = createEM(weight: 100, reps: 1, sets: 1, workout: workout4)
        let _ = createEM(weight: 9, reps: 1, sets: 1, workout: workout4)
        workout4.dateSV = Date().mondaysDate.add(days: -15)
        let oneRM4 = em4.calculateOneRM()
        
        //week 3
        let workout3 = Workouts.createNewWorkout()
        let em3 = createEM(weight: 300, reps: 1, sets: 1, workout: workout3)
        workout3.dateSV = Date().mondaysDate.add(days: -8)
        let oneRM3 = em3.calculateOneRM()
        
        //week 2
        let workout2 = Workouts.createNewWorkout()
        let em2 = createEM(weight: 200, reps: 1, sets: 1, workout: workout2)
        let _ = createEM(weight: 9, reps: 1, sets: 1, workout: workout2)
        workout2.dateSV = Date().mondaysDate.add(days: -1)
        let oneRM2 = em2.calculateOneRM()
        
        //week 1
        let workout1 = Workouts.createNewWorkout()
        let em1 = createEM(weight: 300, reps: 1, sets: 1, workout: workout1)
        let _ = createEM(weight: 9, reps: 1, sets: 1, workout: workout1)
        workout1.dateSV = Date()
        let oneRM1 = em1.calculateOneRM()
        
        let manager = OneRepMaxOverTimeModel(exercise: exercise)
        manager.loadMainQueueItems()
        manager.loadModel()
        let weeks = manager.oneRMWeeks
        
        let week1 = weeks[0]
        let week2 = weeks[1]
        let week3 = weeks[2]
        let week4 = weeks[3]
        
        XCTAssertEqual(week1.oneRepMax!.oneRM, oneRM1)
        XCTAssertEqual(week2.oneRepMax!.oneRM, oneRM2)
        XCTAssertEqual(week3.oneRepMax!.oneRM, oneRM3)
        XCTAssertEqual(week4.oneRepMax!.oneRM, 100)
        XCTAssertEqual(week1.weekNumber, 4)
        XCTAssertEqual(week3.weekNumber, 2)
        
        //first weeks "best onerm" should be the same as that weeks oneRM
        //XCTAssertEqual(week4.bestPriorOneRM!.oneRM, oneRM4)
        
        XCTAssertEqual(week4.bestPriorOneRM, nil)
        XCTAssertEqual(week3.bestPriorOneRM, week4.oneRepMax)

        //test that best prior gets max from previous weeks
        XCTAssertEqual(week2.bestPriorOneRM, week3.oneRepMax)
        XCTAssertEqual(week1.bestPriorOneRM, week3.oneRepMax)
        
        //test protocol adoption methods for tableViewController
        
        XCTAssertEqual(manager.totalImprovement, 200)
        XCTAssertEqual(manager.averageWeeklyImprovement, 50)
        XCTAssertEqual(manager.beginningEstOneRM, 100)
        XCTAssertEqual(manager.currentEstOneRM, 300)
        
        XCTAssertEqual(week4.improvement(), 0)
        XCTAssertEqual(week3.improvement(), 200)
        XCTAssertEqual(week2.improvement(), -100)
        XCTAssertEqual(week1.improvement(), 0)
        
        XCTAssertEqual(week4.percentageChange, "100%")
        XCTAssertEqual(week3.percentageChange, "+300%")
        XCTAssertEqual(week2.percentageChange, "-33%")
        XCTAssertEqual(week1.percentageChange, "100%")
        
        
    }
    
    
    func test_newDataSet() {
        
        let _ = createEMInWeek(week: 5, weight: 50, reps: 2)
        //let _ = createEMInWeek(week: 4, weight: 0, reps: 0)
        let _ = createEMInWeek(week: 3, weight: 70, reps: 2)
        //let _ = createEMInWeek(week: 2, weight: 0, reps: 0)
        let _ = createEMInWeek(week: 1, weight: 58, reps: 0)
        let _ = createEMInWeek(week: 0, weight: 50, reps: 5)
        
        let manager = OneRepMaxOverTimeModel(exercise: exercise)
        manager.loadModel()
        let weeks = manager.oneRMWeeks
        
        var oneRMs: [Int] {
            return weeks.map({
                if let oneRM = $0.oneRepMax { return Int(oneRM.oneRM)}
                return -1
            })
        }
        
        var absoluteChnges: [Int] {
            return weeks.map({
                if let ac = $0.absoluteChange { return Int(ac)}
                return -1
            })
        }
        
        XCTAssertEqual(manager.numberOfWeeks, 6)
        
        XCTAssertEqual(oneRMs, [58, 0, -1, 74, -1, 53])
        
        XCTAssertEqual(absoluteChnges, [-16, -1, 0, 21, 0, 0])
        
        
    }
    
    
    
}



