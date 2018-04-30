//
//  Workout Header Model.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//
import UIKit
import Resources_View2_1

class WorkoutHeaderModel: WorkoutHeaderInfo {
    
    var workout: Workouts
    
    weak var reloadDelegate: ReloadsWorkoutHeader?
    
    let workoutDatePicker = DatePickerAlertController()
    
    init(workout: Workouts, delegate: ReloadsWorkoutHeader) {
        self.reloadDelegate = delegate
        self.workout = workout
    }
    
    var date: Date? {
        return workout.date
    }
    
    var bodyweight: Double? {
        //todo
        return nil
    }
    
    var notes: String? {
        //todo
        return nil
    }
    
    func showEditOptions() {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Change Workout Date", style: .default) {
            action in
            self.workoutDatePicker.configure(with: self.workout.date, delegate: self)
            self.workoutDatePicker.show()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.show()
        
    }
    
    func save(date: Date) {
        workout.dateSV = date
        reloadDelegate?.setupHeaderInfo()
    }
    
}









