//
//  Metric.swift
//  exerciseModel1
//
//  Created by B_Litwin on 1/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1


enum Metric: String {

    init(_ metric: String) {
        
        let names = [
            Metric.Weight.rawValue: Metric.Weight,
            Metric.Reps.rawValue:  Metric.Reps,
            Metric.Sets.rawValue: Metric.Sets,
            Metric.Time.rawValue: Metric.Time,
            Metric.Length.rawValue: Metric.Length,
            Metric.Velocity.rawValue: Metric.Velocity,
            //Metric.RestPeriod.rawValue: Metric.RestPeriod
        ]
        
        self = names[metric]!
    }
    
    case Weight
    case Reps
    case Sets
    case Time
    case Length
    case Velocity
    //case RestPeriod
    
    var searchKey: String {
        let name = self.rawValue.lowercased()
        return name + "SV"
    }
    
    static let orderedMetrics = [
        Metric.Weight,
        Metric.Reps,
        Metric.Sets,
        Metric.Time,
        Metric.Length,
        Metric.Velocity,
       // Metric.RestPeriod
    ]
    
    static let defaultOrders: [Metric: Int] = [
        Metric.Weight: 1,
        Metric.Reps: 2,
        Metric.Sets: 3,
        Metric.Time: 4,
        Metric.Length: 5,
        Metric.Velocity: 6,
        //Metric.RestPeriod: 7
    ]
    
    var defaultOrder: Int {
        guard let order = Metric.defaultOrders[self] else { return 0 }
        return order
    }
    
    static let primaryMetricOrders: [Metric: Int] = [
        Metric.Weight: 1,
        Metric.Time: 2,
        Metric.Length: 3,
        Metric.Velocity: 4,
        //Metric.RestPeriod: 5,
        Metric.Reps: 6,
        Metric.Sets: 7,
    ]
    
    var primaryMetricOrder: Int {
        guard let order = Metric.primaryMetricOrders[self] else { return 0 }
        return order 
    }
    
    static let Units: [Metric: [Unit] ] = [
        
        Metric.Weight: [UnitMass.pounds,
                        UnitMass.kilograms,
                        UnitMass.ounces],
        
        Metric.Reps: [UnitReps.reps],
        
        Metric.Sets: [UnitSets.sets],
        
        Metric.Time: [UnitDuration.minutes,
                      UnitDuration.seconds],
        
        Metric.Length: [UnitLength.yards,
                        UnitLength.feet,
                        UnitLength.inches],
        
        Metric.Velocity: [UnitSpeed.milesPerHour,
                          UnitSpeed.metersPerSecond],
        
        //Metric.RestPeriod: [UnitDuration.minutes,
                           // UnitDuration.seconds]
        
    ]
    
    
    func setActiveButtons(for buttonSet: Set<KeyboardButtonType>) {
        
        
        
    }
}












enum Operation {
    case OneRM
    
}


enum Op {
    
    case create
    case save 
    
}
