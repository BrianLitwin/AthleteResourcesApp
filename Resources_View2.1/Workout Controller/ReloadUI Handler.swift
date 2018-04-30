//
//  ReloadUI Handler.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol ReloadsWorkoutUI: class {
    func reloadWith(change: ReloadWorkoutUIHandler.ChangeType)
}

open class ReloadWorkoutUIHandler: ReloadsWorkoutUI {
    
    public init() {
        
    }
    
    public enum ChangeType {
        case exerciseName(model: SequenceModel, section: Int)
        case compoundExercise(model: SequenceModel)
    }
    
    open func reloadWith(change: ChangeType) {
        
    }

}
