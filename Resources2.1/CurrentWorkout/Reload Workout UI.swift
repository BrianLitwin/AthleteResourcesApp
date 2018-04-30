//
//  Reload Workout UI.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

class UpdateWorkoutUIClass: ReloadWorkoutUIHandler {

    let workoutController: WorkoutViewController
    
    init(workoutController: WorkoutViewController) {
        self.workoutController = workoutController
        super.init()
    }
    
    override func reloadWith(change: ChangeType) {
        
        switch change {
            
        case .exerciseName(let model, let section):
            
            guard let sequenceModel = model as? WorkoutSequenceModel else { return }
            
            guard let exercise = sequenceModel.sequence.orderedContainers[section].exercise else { return }
            
            for subview in workoutController.scrollView.contentView.subviews {
                if let sequenceModel = subview as? ReturnsSequenceModelAndUIUpdater {
                    if let reloadableModel = sequenceModel.model as? ReloadableSequenceModel {
                        let sectionsToReload = reloadableModel.sectionsContaining(exercise: exercise)
                        let uiHandler = sequenceModel.uiHandler
                        sectionsToReload.forEach({
                            uiHandler?.updateView(for: .reloadSection, at: [ $0 , 0 ])
                        })
                    }
                }
            }
            
            
        case .compoundExercise(model: let model):
            break //not editing compound exercises 
            
        }
    }
    

}
