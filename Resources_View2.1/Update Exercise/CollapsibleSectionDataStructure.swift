//
//  CollapsibleSectionDataStructure.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 5/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit



public class CollapsibleModel {
    
    public var expandedSections = [Bool]()
    
    public var offsetIndexes = [Int]()
    
    public init(count: Int) {
        expandedSections = Array.init(repeating: false, count: count)
        offsetIndexes = expandedSections.enumerated().map({ $0.offset })
    }
    
    public func toggle(section: Int) -> Bool {
        //if the section is a subsection, return
        guard !expandedSections[section] else { return false }
        
        let subSection = section + 1
        let originalIndex = offsetIndexes[section]
        
        func expandSubSection() -> Bool {
            expandedSections.insert(true, at: subSection)
            offsetIndexes.insert(originalIndex, at: subSection)
            return true
        }
        
        func collapseSubSection() -> Bool {
            expandedSections.remove(at: subSection)
            offsetIndexes.remove(at: subSection)
            return false
        }
        
        if subSection >= expandedSections.count {
            return expandSubSection()
        } else if expandedSections[section + 1] == true {
            return collapseSubSection()
        } else {
            return expandSubSection()
        }

    }
    
}


