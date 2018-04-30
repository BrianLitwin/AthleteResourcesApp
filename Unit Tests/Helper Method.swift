//
//  Helper Method.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/13/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1
@testable import Resources_View2_1
import CoreData



var calendar = Calendar.current



func makeEM(with exercise: Exercises) -> Exercise_Metrics {
    let em = Exercise_Metrics(context: context)
    let container = EM_Containers(context: context)
    em.container = container
    let sequence = Sequences(context: context)
    sequence.addToContainers(container)
    container.exercise = exercise
    return em
}


func makeExercise() -> Exercises {
    let backSquat = Exercises(context: context)
    Metric_Info.create(metric: Metric.Weight, unitOfM: UnitMass.pounds, exercise: backSquat)
    Metric_Info.create(metric: Metric.Reps, unitOfM: UnitReps.reps, exercise: backSquat)
    Metric_Info.create(metric: Metric.Sets, unitOfM: UnitSets.sets, exercise: backSquat)
    backSquat.name = "Squat"
    backSquat.variation = "From Dead Start "
    backSquat.isActive = true 
    return backSquat
}

func getStoryboard() -> UIStoryboard {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    return storyboard
}

func getNavControl() -> NavigationController {
    
    let storyboard = getStoryboard()
    let navControl = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
    navControl.viewDidLoad()
    return navControl
    
}

func getMasterVC() -> MasterVC {
    return getNavControl().childViewControllers[0] as! MasterVC
    
}

func getWorkoutViewController() -> WorkoutViewController {
    let masterVC = getMasterVC()
    let wvc = masterVC.currentWorkout
    masterVC.addChildViewController(wvc)
    wvc.viewDidLoad()
    return wvc
}

func getWorkoutHistoryTableViewController() -> WorkoutHistoryTableViewController {
    let masterVC = getMasterVC()
    let wh = masterVC.workoutHistory
    masterVC.addChildViewController(wh)
    wh.viewDidLoad()
    return wh
}

func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
    
}



func createDate2(day: Int, month: Int) -> NSDate {
    
    var dateComponents = DateComponents()
    dateComponents.year = 2016
    dateComponents.month = month
    dateComponents.day = day
    
    // Create date from components
    let userCalendar = Calendar.current // user calendar
    let someDateTime = userCalendar.date(from: dateComponents)
    return someDateTime! as NSDate
}


func createDate(_ day: Int) -> NSDate {
    
    var dateComponents = DateComponents()
    dateComponents.year = 2016
    dateComponents.month = 7
    dateComponents.day = day
    
    // Create date from components
    let userCalendar = Calendar.current // user calendar
    let someDateTime = userCalendar.date(from: dateComponents)
    return someDateTime! as NSDate
}


func getDate(daysAgo: Int) -> Date {
    
    var date = Date()
    date = calendar.date(byAdding: .day, value: -daysAgo, to: date)!
    return date 
    
}

func getDate(monthsAgo: Int) -> Date {
    var date = Date()
    date = calendar.date(byAdding: .month, value: -monthsAgo, to: date)!
    return date
}

func createDate(startDate: Date, daysAgo: Int) -> Date {
    
    var date = startDate
    date = calendar.date(byAdding: .day, value: -daysAgo, to: startDate)!
    return date
    
}





