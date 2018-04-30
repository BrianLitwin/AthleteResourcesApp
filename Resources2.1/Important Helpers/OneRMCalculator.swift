//
//  EM_Analytics.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/20/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1


class OneRepMaxManager: ReloadableModel {
    
    var needsReload: Bool = true
    
    func loadModel() {
        mostRecentOneRMEntry  = exercise.exerciseMetrics().getMaxOneRM() ?? nil
        needsReload = false
    }
    
    let exercise: Exercises
    
    var mostRecentOneRMEntry: OneRepMax?
    
    var oneRM: OneRepMax? {
        if needsReload {
            loadModel()
            return mostRecentOneRMEntry
        }
        return mostRecentOneRMEntry
    }
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }
    
}

extension Exercise_Metrics {
    
    func calculateOneRM() -> Double {
        
        guard let primaryMetric: Metric = exercise?.metricInfoSet.primaryMetric.metric else { return 0 }
        
        func OneRepMax() -> Double {
            let weight = value(for: .Weight)
            let reps = value(for: .Reps)
            guard reps > 0 else { return 0 }
            guard reps != 1 else { return weight }
            return weight * ( 1.0 + (reps / 30.0) )
        }
        
        switch primaryMetric {
            
        case .Weight:
            return OneRepMax()
            
        default:
            return value(for: primaryMetric)
            
        }
        
    }
    
}

extension Array where Iterator.Element: Exercise_Metrics {
    
    func getMaxOneRM() -> OneRepMax? {
        
        guard !self.isEmpty else { return nil }
        
        var ems = self
        
        let firstEM = ems.removeFirst()
        
        let firstOneRM = OneRepMax(for: firstEM)
        
        return ems.reduce(firstOneRM, {
            previous, next in
            let nextOneRM = OneRepMax(for: next)
            return nextOneRM.oneRM > previous.oneRM ? nextOneRM : previous
        })
        
    }
    
}

struct OneRepMax: Comparable {
    
    let exerciseMetric: Exercise_Metrics
    
    let oneRM: Double
    
    init(for exerciseMetric: Exercise_Metrics) {
        self.exerciseMetric = exerciseMetric
        oneRM = exerciseMetric.calculateOneRM()
    }
    
    static func <(lhs: OneRepMax, rhs: OneRepMax) -> Bool {
        return lhs.oneRM < rhs.oneRM
    }
    
    static func ==(lhs: OneRepMax, rhs: OneRepMax) -> Bool {
        return lhs.exerciseMetric == rhs.exerciseMetric
    }
    
}



