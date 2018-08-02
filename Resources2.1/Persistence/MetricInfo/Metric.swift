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
            Metric.Velocity.rawValue: Metric.Velocity
        ]
        
        guard let foundMetric = names[metric] else {
            fatalError("Could not initialize Metric with given string initializer: \(metric)")
        }
            
        self = foundMetric
    }
    
    case Weight, Reps, Sets, Time, Length, Velocity
    
    var searchKey: String {
        let name = self.rawValue.lowercased()
        return name + "SV"
    }
    
    func unitOfMeasurement(symbol: String) -> UnitOfMeasurement {
        switch self {
        case .Weight: return WeightUnit(symbol: symbol)
        case .Reps: return RepsUnit(symbol: symbol)
        case .Sets: return SetsUnit(symbol: symbol)
        case .Length: return LengthUnit(symbol: symbol)
        case .Time: return TimeUnit(symbol: symbol)
        case .Velocity: return VelocityUnit(symbol: symbol)
        }
    }
    
    static let orderedMetrics = [
        Metric.Weight,
        Metric.Reps,
        Metric.Sets,
        Metric.Time,
        Metric.Length,
        Metric.Velocity
    ]
    
    static let defaultOrders: [Metric: Int] = [
        Metric.Weight: 1,
        Metric.Reps: 2,
        Metric.Sets: 3,
        Metric.Time: 4,
        Metric.Length: 5,
        Metric.Velocity: 6,
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
        Metric.Reps: 5,
        Metric.Sets: 6,
    ]
    
    var primaryMetricOrder: Int {
        guard let order = Metric.primaryMetricOrders[self] else { return 0 }
        return order 
    }
    
    
    enum WeightUnit: UnitOfMeasurement {
        
        init(symbol: String) {
            switch symbol {
            case WeightUnit.pounds.name: self = WeightUnit.pounds
            case WeightUnit.kilograms.name: self = WeightUnit.kilograms
            case WeightUnit.ounces.name: self = WeightUnit.ounces
            default: fatalError("couldn't initialize Weight Unit with symbol: \(symbol)")
            }
        }
        
        case pounds, kilograms, ounces
        
        var dimension: Dimension {
            switch self {
            case .pounds: return UnitMass.pounds
            case .kilograms: return UnitMass.kilograms
            case .ounces: return UnitMass.ounces
            }
        }
        
        var saveDimension: Dimension {
            return WeightUnit.pounds.dimension
        }
    }
        
    enum RepsUnit: UnitOfMeasurement {
        
        init(symbol: String) {
            if symbol == UnitReps.reps.symbol {
                self = RepsUnit.reps
            } else {
                 fatalError("couldn't initialize Reps Unit with symbol: \(symbol)")
            }
        }
        
        case reps
        
        var dimension: Dimension {
            return UnitReps.reps
        }
        
        var saveDimension: Dimension {
            return UnitReps.reps
        }
    }
        
    enum SetsUnit: UnitOfMeasurement {
        init(symbol: String) {
            if symbol == UnitSets.sets.symbol {
                self = SetsUnit.sets
            } else {
                fatalError("couldn't initialize Sets Unit with symbol: \(symbol)")
            }
        }
        
        case sets
        
        var dimension: Dimension {
            return UnitSets.sets
        }
        
        var saveDimension: Dimension {
            return UnitSets.sets
        }
        
    }
    
    enum TimeUnit: UnitOfMeasurement {
        
        init(symbol: String) {
            switch symbol {
            case TimeUnit.minutes.name: self = TimeUnit.minutes
            case TimeUnit.seconds.name: self = TimeUnit.seconds
            default: fatalError("couldn't initialize Time Unit with symbol: \(symbol)")
            }
        }
        
        case minutes, seconds
        
        var dimension: Dimension {
            switch self {
            case .minutes: return UnitDuration.minutes
            case .seconds: return UnitDuration.seconds
            }
        }
        
        var saveDimension: Dimension {
            return TimeUnit.seconds.dimension
        }
        
    }
    
    enum LengthUnit: UnitOfMeasurement {
        
        init(symbol: String) {
            switch symbol {
            case LengthUnit.yards.name: self = LengthUnit.yards
            case LengthUnit.feet.name: self = LengthUnit.feet
            case LengthUnit.inches.name: self = LengthUnit.inches
            default: fatalError("couldn't initialize Length Unit with symbol: \(symbol)")
            }
        }
        
        case yards, feet, inches
        
        var dimension: Dimension {
            switch self {
            case .yards: return UnitLength.yards
            case .feet: return UnitLength.feet
            case .inches: return UnitLength.inches
            }
        }
        
        var saveDimension: Dimension {
            return LengthUnit.inches.dimension
        }
        
    }
    
    enum VelocityUnit: UnitOfMeasurement {
        
        init(symbol: String) {
            switch symbol {
            case VelocityUnit.milesPerHour.name: self = VelocityUnit.milesPerHour
            case VelocityUnit.metersPerSecond.name: self = VelocityUnit.metersPerSecond
            default: fatalError("couldn't initialize Velocity Unit with symbol: \(symbol)")
            }
        }
        
        case milesPerHour, metersPerSecond
        
        var dimension: Dimension {
            switch self {
            case .milesPerHour: return UnitSpeed.milesPerHour
            case .metersPerSecond: return UnitSpeed.metersPerSecond
            }
        }
        
        var saveDimension: Dimension {
            return VelocityUnit.milesPerHour.dimension
        }
        
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
        
    ]

}


protocol UnitOfMeasurement {
    var dimension: Dimension { get }
    var saveDimension: Dimension { get }
}


extension UnitOfMeasurement {
    
    var name: String {
        return dimension.symbol
    }
    
    func convertToSaveValue(value: Double) -> Double {
        let measurement = Measurement(value: value, unit: dimension)
        return measurement.converted(to: saveDimension).value
    }
    
    func convertToDisplayValue(value: Double) -> Double {
        let measurement = Measurement(value: value, unit: saveDimension)
        return measurement.converted(to: dimension).value
    }
    
    func returnUnitOfMeasurement(for symbol: String, metric: Metric) -> UnitOfMeasurement {
        switch metric {
        case .Weight: return Metric.WeightUnit(symbol: symbol)
        default: fatalError()
            
        }
    }
}

















