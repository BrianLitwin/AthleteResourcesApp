//
//  CompoundExercise Records.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/2/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class CompoundExerciseMetricComparisonContainer {
    
    init(ems: [Exercise_Metrics], sequence: Sequences) {
        self.exerciseMetrics = ems
        self.sequence = sequence
    }
    
    let exerciseMetrics: [Exercise_Metrics]
    
    let sequence: Sequences
    
    var reps: [Double] {
        return exerciseMetrics.map({ $0.value(for: .Reps ).converted })
    }
    
    var weight: Double {
        guard !exerciseMetrics.isEmpty else { return 0 }
        return exerciseMetrics[0].value(for: .Weight).converted
    }
    
    var sets: Double {
        guard !exerciseMetrics.isEmpty else { return 0 }
        return exerciseMetrics[0].setsSV
    }
    
    
    func isRecordOver(container: CompoundExerciseMetricComparisonContainer) -> Bool {
        
        if weight < container.weight {
            return false
        }
        
        if weight > container.weight {
        
            return repsAreGreater(than: container.reps)
        }
            
        if weight == container.weight {
            
            if repsAreGreater(than: container.reps) {
                return true
            } else {
                return sets > container.sets
            }
        }
        
        return false
        
    }
    
    func repsAreGreater(than array: [Double]) -> Bool {
        
        for (rep, item) in zip(reps, array) {
            if rep < item {
                return false
            }
        }
        
        return true
        
    }
    
    
}






