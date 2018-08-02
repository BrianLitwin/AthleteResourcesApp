//
//  WorkoutHistory.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData
import Resources_View2_1

class WorkoutHistoryModel: ContextObserver, Resources_View2_1.WorkoutHistoryModel {
    var workoutSections: [WorkoutHistoryWeek] = []
    var needsReload = true
    var segueHandler: WorkoutHistorySegueHandler?
    
    var sections: [WorkoutHistoryModelSection] { //compromise to satisfy protocol ?? is this necessary
        return workoutSections
    }
    
    init() {
        super.init(context: context)
        segueHandler = WorkoutHistorySegueHandlerClass(model: self)
    }
    
    func seperateWorkoutsByWeek(workouts: [Workouts], weeks: [Date.Week]) -> [WorkoutHistoryWeek]  {
        return weeks.reduce(into: [WorkoutHistoryWeek]() ) { weeks, week in
            let workouts = workouts.filter() {
                guard let date = $0.date else { fatalError() }
                return week.interval().contains(date)
            }
            
            let newWeek = WorkoutHistoryWeek(week: week, workouts: workouts)
            newWeek.workouts = workouts
            weeks.append(newWeek)
        } 
    }
    
    func loadModel() {
        workoutSections = seperateWorkoutsByWeek(workouts: Workouts.fetchAll(),
                                          weeks: workoutDateManager.activeWeeks.reversed()) //reverse chronological order
        needsReload = false
    }
    
    func returnWorkout(for indexPath: IndexPath) -> Workouts {
        let section = workoutSections[indexPath.section]
        let workout = section.workouts[indexPath.row]
        return workout
    }
    
    func deletItem(at indexPath: IndexPath) {
        let section = workoutSections[indexPath.section]
        section.items.remove(at: indexPath.row)
        returnWorkout(for: indexPath).delete()
        section.workouts.remove(at: indexPath.row)
    }
    
    func prepareWorkoutViewController(for indexPath: IndexPath, with viewController: UIViewController) {
        let workout = workoutSections[indexPath.section].workouts[indexPath.row]
        guard let workoutViewController = viewController as? WorkoutViewController
            else { return }
        workoutViewController.currentWorkout = workout
    }
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any]) {
  
        if let _ = entity as? Workouts {
            
            //FIX ME: YOu NEED TO RELOAD EXERCISE COUNT IN ROWS
            //WHERE EXERCISE COUNT HAS CHANGED 
            
            switch type {
            case .delete, .insert:
                needsReload = true
                
            case .update:
                if changedValues["dateSV"] != nil { //Unit Test This 
                    needsReload = true
                }
            }
        }
    }
}

class WorkoutHistoryWeek: WorkoutHistoryModelSection {
    let dateInterval: DateInterval
    var items: [WorkoutHistoryItem] = []
    var workouts: [Workouts] = []
    
    init(week: Date.Week, workouts: [Workouts]) {
        dateInterval = week.interval()
        items = workouts.map({
            return WorkoutItem(date: $0.date!)
        })
    }
}


class WorkoutItem: WorkoutHistoryItem {
    let date: Date
    init(date: Date) {
        self.date = date
    }
}



