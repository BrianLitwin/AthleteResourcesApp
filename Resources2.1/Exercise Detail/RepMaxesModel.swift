//
//  RepMaxesModel.swift
//  Resources2.1
//
//  Created by B_Litwin on 4/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

class RepMaxesModel: ReloadableModel, ContainsRepMaxInfo {

    var needsReload: Bool = true
    
    var repMaxes: [Double] = []
    
    var oneRepMax: Double
    
    var roundedRepMaxes: [Int] {
        return repMaxes.map({ repMax in
            return Int(repMax.rounded(.toNearestOrEven))
        })
    }
    
    init(oneRepMax: Double) {
        self.oneRepMax = oneRepMax
    }
    
    func loadModel() {
        let range = 2...10
        repMaxes = range.reduce([oneRepMax], { list, reps in
            let repMax = calculateRepMax(reps: Double(reps), oneRepMax: oneRepMax)
            return list + [repMax]
        })
    }
    
    func calculateRepMax(reps: Double, oneRepMax: Double) -> Double {
        return oneRepMax / ( 1 + (reps / 30))
    }
    
}





















