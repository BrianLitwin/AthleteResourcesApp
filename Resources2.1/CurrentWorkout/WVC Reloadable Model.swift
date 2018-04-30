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
    
    func loadLastWorkout() {
        let lastWorkout = Workouts.fetchLast() ?? Workouts.createNewWorkout()
        delegate?.setup(for: lastWorkout)
    }
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any])
    {
        
        guard let workout = entity as? Workouts else { return }
        
        switch type {
            
        case .delete:
    
            if workout == delegate?.currentWorkout {
                loadLastWorkout()
            }
            
        default:
            break
        }
        
    }
    

}
