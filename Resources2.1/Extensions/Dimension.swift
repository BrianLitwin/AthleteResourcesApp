//
//  Units.swift
//  ExerciseFramework
//
//  Created by B_Litwin on 12/23/17.
//  Copyright © 2017 B_Litwin. All rights reserved.
//

import Foundation


extension Dimension {
    
    @objc var saveUnit: Dimension {
        return self
    }
    
    func convertToDisplayUnit(_ value: Double) -> Double {
        
        let y = Measurement(value: value, unit: saveUnit)
        return y.converted(to: self).value
        
    }
    
    func convertToSaveUnit(_ value: Double) -> Double {
        
        let y = Measurement(value: value, unit: self)
        return y.converted(to: saveUnit).value
        
    }


}


class UnitReps: Dimension {
    
    override var saveUnit: Dimension {
        return UnitReps.reps
    }
    
    override init(symbol: String, converter: UnitConverter) {
        super.init(symbol: symbol, converter: converter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static var reps: UnitReps = UnitReps(symbol: "Reps",
                                         converter: UnitConverterLinear(coefficient: 1))
    
}

class UnitSets: Dimension {
    
    override var saveUnit: Dimension {
        return UnitSets.sets
    }
    
    override init(symbol: String, converter: UnitConverter) {
        super.init(symbol: symbol, converter: converter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static var sets: UnitSets = UnitSets(symbol: "Sets",
                                         converter: UnitConverterLinear(coefficient: 1))
    
    
}

extension UnitMass {
    override var saveUnit: Dimension {
        return UnitMass.pounds
    }
}

extension UnitLength {
    override var saveUnit: Dimension {
        return UnitLength.inches
    }
}

extension UnitSpeed {
    override var saveUnit: Dimension {
        return UnitSpeed.milesPerHour
    }
}

extension UnitDuration {
    override var saveUnit: Dimension {
        return UnitDuration.seconds
    }
}



let unitDictionary = [
    
    UnitMass.pounds.symbol: UnitMass.pounds,
    UnitMass.kilograms.symbol: UnitMass.kilograms,
    UnitMass.ounces.symbol: UnitMass.ounces,
    
    UnitReps.reps.symbol: UnitReps.reps,
    UnitSets.sets.symbol: UnitSets.sets,
    
    UnitLength.feet.symbol: UnitLength.feet,
    UnitLength.inches.symbol: UnitLength.inches,
    UnitLength.yards.symbol: UnitLength.yards,
    
    UnitSpeed.milesPerHour.symbol: UnitSpeed.milesPerHour,
    UnitSpeed.metersPerSecond.symbol: UnitSpeed.metersPerSecond,
    
    UnitDuration.seconds.symbol: UnitDuration.seconds,
    UnitDuration.minutes.symbol: UnitDuration.minutes
    
]







