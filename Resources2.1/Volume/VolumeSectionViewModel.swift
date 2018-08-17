//
//  VolumeStruct.swift
//  Resources2.1
//
//  Created by B_Litwin on 8/6/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData
import IGListKit
import Resources_View2_1

/*
 the values at play are:
 total reps
 total sets
 total volume
 
 1. decide what metrics to find so you don't have to recalculate that in each exerciseMetric
 
*/






class VolumeSectionViewModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return title as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? VolumeSectionViewModel {
            return object.title == self.title && object.values == self.values
        } else {
            return false
        }
    }
    
    let title: String
    let values: [Double]
    
    init(title: String, values: [Double]) {
        self.title = title
        self.values = values
    }
    
}

