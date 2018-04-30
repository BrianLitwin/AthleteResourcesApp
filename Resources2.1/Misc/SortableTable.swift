//
//  SortableTable.swift
//  Resources2.1
//
//  Created by B_Litwin on 4/6/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

class SortableTableModel: ContextObserver, ReloadableModel {

    let exercise: Exercises
    
    var needsReload: Bool = true
    
    func loadModel() {
        
    }
    
    init(exercise: Exercises) {
        self.exercise = exercise
        super.init(context: context)
    }
    
}


extension Array where Iterator.Element == Exercise_Metrics {
    
    func sort(by descriptors: [NSSortDescriptor]) -> [Exercise_Metrics] {
        return (self as NSArray).sortedArray(using: descriptors) as! [Exercise_Metrics]
    }
    
}
