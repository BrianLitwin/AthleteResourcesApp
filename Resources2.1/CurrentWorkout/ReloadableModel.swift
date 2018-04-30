


import UIKit

import Resources_View2_1

//use this to reload an exercise name or variation after it's edited 


protocol ReloadableSequenceModel {
    
    func sectionsContaining(exercise: Exercises) -> [Int]
    
}

extension WorkoutSequenceModel: ReloadableSequenceModel {
    
    func sectionsContaining(exercise: Exercises) -> [Int] {
        
        var indexes: [Int] = []
        
        sequence.orderedContainers.forEach({
            if $0.exercise == exercise { indexes.append($0.order) }
        })
        
        return indexes
        
    }
    
}

extension CompoundExerciseModel: ReloadableSequenceModel {
    
    func sectionsContaining(exercise: Exercises) -> [Int] {
        //assuming only 1 section
        guard !sections.isEmpty else { return [] }
        for container in exerciseContainers {
            if container.exercise == exercise {
                return [0]
            }
        }
        return []
    }
    
}
