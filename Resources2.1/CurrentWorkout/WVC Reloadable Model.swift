//
//  Model CW.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/3/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1
import CoreData

protocol ReloadWorkoutDelegate: class {
    func setup(for workout: Workouts)
    var currentWorkout: Workouts? { get }
    var scrollView: ScrollView { get }
}

class WorkoutReloadHandler: ContextObserver {
    
    weak var delegate: ReloadWorkoutDelegate?
    
    init(delegate: ReloadWorkoutDelegate) {
        self.delegate = delegate
        super.init(context: context)
    }
    
    private func loadLastWorkout() {
        let lastWorkout = Workouts.fetchLast() ?? Workouts.createNewWorkout()
        delegate?.setup(for: lastWorkout)
    }
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any])
    {
        
        //if the current workout gets deleted, reload to previous workout
        //if no previous workouts exist, create first workout 
        if let workout = entity as? Workouts {
            switch type {
            case .delete:
                if workout == delegate?.currentWorkout { loadLastWorkout() }
            default:
                break
            }
        }
        
        //if a metric info changes .e.g changes the unit of measurement, reload the workout UI 
        if let metricInfo = entity as? Metric_Info {
            if let exercise = metricInfo.exercise {
                reloadWorkoutIfItContains(exercise: exercise)
            }
        }
        
        
        //if an exercise is updated, and workout contains the exercise, need to reload
        if let exercise = entity as? Exercises {
            
//            check for containers first because every time you add or subtract an exercise from the workout,
//            the container order changes, and this registers w/ the exercise, but shouldn't trigger a reload of the
//            entire workout page
            if changedValues["containers"] == nil {
                //this is to say the workout contains the exercise that was changed.
                reloadWorkoutIfItContains(exercise: exercise)
            }
        }
    }
    
    func reloadWorkoutIfItContains(exercise: Exercises) {
        guard let currentWorkout = delegate?.currentWorkout else { return }
        if currentWorkout.exerciseMetricsSet.contains(where: {
            $0.exercise == exercise
        }) {
            delegate?.setup(for: currentWorkout)
        }
    }
    

}
