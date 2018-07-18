//
//  Compound Lift Creator.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1


class CompoundExerciseBuilderModel: CompoundExerciseCreatorModel {
    weak var uiUpdateHandler: TableUIUpdateHandler?
    
    var displayString: String? {
        return exercises.map({ $0.namePlusVariation }).joined(separator: " + ")
    }
    
    var exercises: [Exercises] = []
    
    var category: Categories?

    func categorySelected(_ category: Categories) {
        self.category = category
    }
    
    func add(exercise: Exercises) {
        exercises.append(exercise)
        uiUpdateHandler?.update()
    }
    
    func stepBack() {
        _ = exercises.popLast()
        uiUpdateHandler?.update()
    }
    
    func saveCompoundExercise() {
        
        guard let cat = category else { return }
        guard !exercises.isEmpty else { return } //FIX ME: PUT UP AN ALERT HERE
        let container = Multi_Exercise_Container_Types.create(category: cat, with: exercises)
        container.typeSV = MultiExerciseContainerType.compoundExercise.rawValue
        cat.isActive = true
    }
}



class UpdateCompoundExercise: CompoundExerciseBuilderModel {
    
    let containerType: Multi_Exercise_Container_Types
    
    init(type: Multi_Exercise_Container_Types) {
        self.containerType = type
        
        super.init()
        self.category = type.category ?? nil
        self.exercises = type.orderedExercises
    }
    
    override func saveCompoundExercise() {
        
        containerType.exercises = nil
        
        for (order, exercise) in exercises.enumerated() {
            let newContainer = Multi_Exercise_Container.create(exercise: exercise, order: order)
            newContainer.parent_container = containerType
        }
        
        
        saveContext()
        
        
    }
    
}

















