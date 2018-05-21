//
//  OneRepMaxOverTimeModel.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/23/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1


class OneRepMaxOverTimeModel {
    
    var needsReload: Bool = true
    
    var oneRMWeeks: [OneRMWeek] = []
    
    let exercise: Exercises
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }
    
    func loadModel() {
        
        let weeks = workoutDateManager.activeWeeks
        
        let exerciseMetrics = exercise.exerciseMetrics()
        
        var numberOfWeeks = weeks.count
        
        oneRMWeeks = weeks.enumerated().reduce([OneRMWeek](), { weeksArray, value in
            
            let week = value.element
            let index = value.offset
            
            let ems = exerciseMetrics.filter({
                guard let date = $0.container?.sequence?.workout?.date else { return false }
                return week.interval().contains(date)
            })
            
            let oneRM = ems.getMaxOneRM()
            
            var bestPriorMax: OneRepMax? {
                
                guard let prev = weeksArray.lastItem else { return nil }
                
                if let priorWeeksBest = prev.bestOneRM() { return priorWeeksBest }
                
                for week in weeksArray {
                    if let priorBest = week.bestOneRM() {
                        return priorBest
                    }
                }
                
                return nil
            }
            
            
            
            
            
            return weeksArray + [OneRMWeek(oneRepMax: oneRM,
                                           weekNumber: index + 1,
                                           bestPriorOneRM: bestPriorMax
                )]
        }).reversed()
        
    }
    
}
    
    
    



extension OneRepMaxOverTimeModel: OneRepMaxTableViewModel {
    
    var numberOfWeeks: Int {
        return oneRMWeeks.count
    }
    
    var beginningEstOneRM: Double {
        guard let firstWeek = oneRMWeeks.lastItem else { return 0 }
        return firstWeek.oneRepMax?.oneRM ?? 0
    }
    
    var currentEstOneRM: Double {
        return exercise.oneRepMaxManager.oneRM?.oneRM ?? 0
    }
    
    var totalImprovement: Double {
        return currentEstOneRM - beginningEstOneRM
    }
    
    var averageWeeklyImprovement: Double {
        let totalImprovement = (exercise.oneRepMaxManager.oneRM?.oneRM ?? 0) - beginningEstOneRM
        return totalImprovement / Double(numberOfWeeks)
    }
    
    var graphData: [Double] {
        return weeks.map({ $0.absoluteChange ?? 0 })
    }
    
    var weeks: [Resources_View2_1.OneRMWeek] {
        return oneRMWeeks
    }
    
}



struct OneRMWeek: Resources_View2_1.OneRMWeek  {

    //protocol conformation
    
    var oneRMString: String? {
        guard let em = oneRepMax?.exerciseMetric else { return nil }
        return em.displayString()
    }
    
    var percentageChange: String? {
        
        guard let oneRM = oneRepMax else { return nil }
        
        guard let best = bestPriorOneRM else { return "100%" }
        
        if best.oneRM == 0 {
            return "100%"
        }
        
        if oneRM.oneRM == 0 {
            return nil
        }
        
        let change = oneRM.oneRM / best.oneRM
        
        let value = Int(( change * 100).rounded(toPlaces: 0))
        
        var valueString = ""
        
        if value == 100 {
            
            return "100%"
        }
        
        if value > 100 {
            
            return "+" + String(value - 100) + "%"
        }
        
        if value < 100 {
            
            return String(value) + "%"
            
        }
        
        //should never get here 
        return ""
        
    }
    
    var absoluteChange: Double? {
        guard let oneRM = oneRepMax else { return nil }
        guard oneRM.oneRM != 0 else { return nil }
        return improvement()
    }
    
    let weekNumber: Int
    
    let oneRepMax: OneRepMax?
    
    let bestPriorOneRM: OneRepMax?
    
    init(oneRepMax: OneRepMax?, weekNumber: Int, bestPriorOneRM: OneRepMax?) {
        self.oneRepMax = oneRepMax
        self.bestPriorOneRM = bestPriorOneRM
        self.weekNumber = weekNumber
        
    }
    
    func improvement() -> Double? {
        guard let oneRM = oneRepMax else { return 0 }
        guard let best = bestPriorOneRM else { return 0 }
        return oneRM.oneRM - best.oneRM
    }
    
    func bestOneRM() -> OneRepMax? {
        switch (oneRepMax, bestPriorOneRM) {
            
        case (nil, nil):
            return nil
            
        case (nil, _):
            return bestPriorOneRM!
            
        case (_, nil):
            return oneRepMax!
            
        case (_, _):
            return max(oneRepMax!, bestPriorOneRM!)
            
        }
    }
}













