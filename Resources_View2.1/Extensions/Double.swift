//
//  Double.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func displayString(rounded toPlaces: Int = 1) -> String {
        let value = self.rounded(toPlaces: toPlaces)
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        } else {
            return String(value)
        }
    }
    
    var withDeltaSymbol: String {
        let n = self.rounded(toPlaces: 2)
        if n < 0.0 {
            let minus = "- "
            return minus + String(abs(n))
        } else {
            let add = "+ "
            return add + String(n)
        }
    }
    
}
