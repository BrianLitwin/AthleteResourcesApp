//
//  Update Exercise Models.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol UpdateExerciseModel {
    
    func saveAllChanges()
    
    func incompleteInformation() -> String?
    
    var pendingUpdateModels: [UpdateExerciseModelSection] { get }

    var exerciseInfo: UpdateExerciseNVIModel { get }
    
}

public protocol UpdateExerciseNVIModel {
    
    var exerciseInfo: ExerciseNameVariationInstructionsInfo { get }
    
    func updateName(with string: String)
    
    func updateVariation(with string: String)
    
    func updateInstructions(with string: String)
    
}

public protocol ExerciseNameVariationInstructionsInfo {
    
    var name: String { get }
    
    var variation: String { get }
    
    var instructions: String { get }
    
}

public protocol UpdateExerciseModelSection: class {
    
    var metricName: String { get }
    
    var unitOptions: [Unit] { get }
    
    var selectedUnitIndex: Int? { get }
    
    func metricIs(active: Bool)
    
    func unitSelectionChanged(to selection: Int)
    
    func sortInAscendingOrder(update: Bool)
    
}

