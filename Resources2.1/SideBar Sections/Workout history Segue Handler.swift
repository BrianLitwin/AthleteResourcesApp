//
//  Workout history Segue Handler.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

class PreviousWorkoutViewController: WorkoutViewController {
    
}

class WorkoutHistorySegueHandlerClass: WorkoutHistorySegueHandler {

    let workoutHistoryModel: WorkoutHistoryModel
    
    var selectedIndexPath: IndexPath?
    
    init(model: WorkoutHistoryModel) {
        self.workoutHistoryModel = model
    }
    
    func setIndexPath(_ indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func prepareForSegue(with viewController: UIViewController) {
        guard let vc = viewController as? PreviousWorkoutViewController else { return }
        guard let indexPath = selectedIndexPath else { return }
        
        let workout = workoutHistoryModel.returnWorkout(for: indexPath)
        vc.currentWorkout = workout
    }
    

}
