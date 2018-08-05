//
//  GenericsTableViewCell.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/30/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

protocol Orderable: Equatable {
    func setOrder(order: Int)
    var order: Int { get }
    static func ==(lhs: Self, rhs: Self) -> Bool
    
}

extension Exercise_Metrics: Orderable {
    
    var order: Int {
        return setNumber
    }
    
    func setOrder(order: Int) {
        setNumber = order
    }
    
    static func ==(lhs: Exercise_Metrics, rhs: Exercise_Metrics) -> Bool {
        return lhs === rhs
    }
    
}

extension Sequences: Orderable {
    
    var order: Int {
        return workoutOrder
    }
    
    func setOrder(order: Int) {
        workoutOrder = order
    }
    
    static func ==(lhs: Sequences, rhs: Sequences) -> Bool {
        return lhs === rhs
    }
    
}

extension EM_Containers: Orderable {
    
    var order: Int {
        return Int(orderSV)
    }
    
    func setOrder(order: Int) {
        self.orderSV = Int16(order)
    }
    
    static func ==(lhs: EM_Containers, rhs: EM_Containers) -> Bool {
        return lhs === rhs
    }
}


enum Reorder {
    case insert
    case remove
}

extension Array where Iterator.Element: Orderable {
    
    func getSlice(after index: Int) -> ArraySlice<Element> {
        guard index - 1 < self.endIndex  else { return [] }
        return self[index..<self.endIndex]
    }
    
    func reorder(from item: Element, type: Reorder) {
        var index = item.order
        let slice = self[index..<self.endIndex]
        if type == .remove { index -= 1 }
        
        for i in slice {
            if i == item { continue }
            index +=  1
            i.setOrder(order: index)
        }
    }
}



