//
//  Update Metric.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

class PendingUpdate: UpdateExerciseModelSection {
    
    let metric: Metric
    let initialState: PendingUpdateState
    let pendingState: PendingUpdateState
    let unitOptions: [Unit]
    
    init(metric: Metric, with preexistingMetricInfo: Metric_Info?) {
        
        self.metric = metric
        self.unitOptions = Metric.Units[metric] ?? []
        
        if preexistingMetricInfo != nil {
            
            let unitOptionStrings = unitOptions.map({ $0.symbol })
            
            let unitSelection = unitOptionStrings.index(of:
                preexistingMetricInfo!.unit_of_measurement ?? "") ?? 0
            
            self.initialState = PendingUpdateState(metricInfo: preexistingMetricInfo!,
                                      unitSelection: unitSelection)
            
            self.pendingState = PendingUpdateState(metricInfo: preexistingMetricInfo!,
                                      unitSelection: unitSelection)
            
        } else {
            
            self.initialState = PendingUpdateState(sortInAscendingOrder: metric == .Time ? true : false)
            
            self.pendingState = PendingUpdateState(sortInAscendingOrder: metric == .Time ? true : false)
            
        }
        
    }
    
    var selectedUnitIndex: Int? {
        return pendingState.isActive ? pendingState.unitSelection : nil
    }
    
    var metricName: String {
        return metric.rawValue
    }
    
    func dataWasUpdated() -> Bool {
        return pendingState != initialState
    }
    
    func metricIs(active: Bool) {
        pendingState.isActive = active
    }
    
    func unitSelectionChanged(to selection: Int) {
        pendingState.unitSelection = selection
    }
    
    func sortInAscendingOrder(update: Bool) {
        pendingState.sortInAscendingOrder = update
    }
    
    func selectedUnitOfMeasurement() -> String {
        return unitOptions[pendingState.unitSelection].symbol
    }
    
    
}

class PendingUpdateState: Equatable {
    
    init(metricInfo: Metric_Info, unitSelection: Int) {
        self.isActive = true
        self.sortInAscendingOrder = metricInfo.sort_in_ascending_order
        self.unitSelection = unitSelection
    }
    
    init(sortInAscendingOrder: Bool) {
        self.isActive = false
        self.sortInAscendingOrder = sortInAscendingOrder
        self.unitSelection = 0
    }
    
    var isActive: Bool
    var sortInAscendingOrder: Bool
    var unitSelection: Int
    
    static func ==(lhs: PendingUpdateState,
                   rhs: PendingUpdateState) -> Bool
    {
        return
            lhs.isActive ==             rhs.isActive &&
                lhs.sortInAscendingOrder == rhs.sortInAscendingOrder &&
                lhs.unitSelection ==        rhs.unitSelection
    }
    
}





