//
//  Update Name Variation Instructions.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

class PendingNVIUpdate: UpdateExerciseNVIModel {
    
    var pendingUpdates: [UpdateExerciseModelSection] = []
    let initialState: PendingNVIUpdateState
    let pendingState: PendingNVIUpdateState
    
    init(exercise: Exercises?) {
        initialState = PendingNVIUpdateState(exercise: exercise)
        pendingState = PendingNVIUpdateState(exercise: exercise)
    }
    
    var exerciseInfo: ExerciseNameVariationInstructionsInfo {
        return pendingState
    }
    
    func updateName(with string: String) {
        pendingState.name = string
    }
    
    func updateVariation(with string: String) {
        pendingState.variation = string
    }
    
    func updateInstructions(with string: String) {
        pendingState.instructions = string
    }
    
    func dataWasUpdated() -> Bool {
        return initialState != pendingState
    }
    
}


class PendingNVIUpdateState: ExerciseNameVariationInstructionsInfo, Equatable {
    
    init(exercise: Exercises?) {
        self.name =         exercise?.name ?? ""
        self.variation =    exercise?.variation ?? ""
        self.instructions = exercise?.instructions ?? ""
    }
    
    var name: String
    var variation: String
    var instructions: String
    
    static func ==(lhs: PendingNVIUpdateState,
                   rhs: PendingNVIUpdateState) -> Bool {
        
        return
                lhs.name ==         rhs.name &&
                lhs.variation ==    rhs.variation &&
                lhs.instructions == rhs.instructions
    }
    
}
