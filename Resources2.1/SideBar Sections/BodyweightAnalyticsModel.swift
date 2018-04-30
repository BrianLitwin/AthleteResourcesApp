//
//  BodyweightAnalyticsModel.swift
//  Resources2.1
//
//  Created by B_Litwin on 4/6/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

var calendar = Calendar.current

struct BodyweightGraphModel: ScatterPlotDataSource {
    
    let data: [ScatterPlotDataItem]
    
    let maxY: Double
    
    let minY: Double
    
    let maxX: Double 
    
    let minX: Double
    
    let minDate: Date
    
}


extension BodyweightAnalyticsModel: BodyweightTableViewModel {
    
    var graphDataSource: ScatterPlotDataSource? {
        return bodyweightGraphData
    }
    
    var bodyweightEntries: [BodyweightEntryData] {
        return bodyweightItems
    }
    
    var minBW: BodyweightEntryData? {
        return minBodyweight
    }
    
    var maxBW: BodyweightEntryData? {
        return maxBodyweight
    }
    
    func changeFrom(daysAgo: Int) -> Double {
        guard let current = bodyweightItems.firstItem else { return 0 }
        guard let last = bodyweightsFrom(daysAgo: daysAgo).lastItem else { return 0 }
        return current.bodyweight - last.bodyweight
    }
    
    func updatesBodyweightModel(for bodyweightIndex: Int) -> UpdatesBodyweight {
        let bodyweight = bodyweightItems[bodyweightIndex].bodyweightClass
        return UpdateBodyweightModel(bodyweight: bodyweight)
    }
    
    func newBodyweightModel() -> UpdatesBodyweight {
        return UpdateBodyweightModel(bodyweight: nil)
    }
    
}



class BodyweightAnalyticsModel: ContextObserver, ReloadableModel  {
    
    var needsReload: Bool = true
    
    var bodyweightItems: [BodyweightListItem] = []
    
    var minBodyweight: BodyweightListItem?
    
    var maxBodyweight: BodyweightListItem?
    
    var bodyweightGraphData: BodyweightGraphModel?
    
    init() {
        super.init(context: context)

    }
    
    func loadModel() {
        
        var bodyweights = Bodyweight.fetchAll(ascending: true)
        
        guard let first = bodyweights.firstItem else {
            
            //if there are no bodyweights, especially if the last bodyweight entry is deleted, reset everything 
            //maybe think of a better way to reset all these
            bodyweightItems = []
            minBodyweight = nil
            maxBodyweight = nil
            bodyweightGraphData = nil
            
            return
        }
        
        bodyweights.remove(at: 0)
        let firstItem = BodyweightListItem(first, previous: nil)
        setMinAndMax(with: firstItem)

        bodyweightItems = bodyweights.reduce([firstItem], { items, bodyweight in
            let previous = items.last!
            let newBwItem = BodyweightListItem(bodyweight, previous: previous)
            setMinAndMax(with: newBwItem)
            return items + [newBwItem]
        }).reversed()
        
        let last = bodyweights.lastItem ?? first
        
        let maxX = Date.daysBetween(startDate: first.date, endDate: last.date)
        
        bodyweightGraphData = BodyweightGraphModel(data: bodyweightItems,
                                                    maxY: (maxBodyweight?.bodyweight ?? 0) * 1.01,
                                                    minY: (minBodyweight?.bodyweight ?? 0) * 0.9999,
                                                    maxX: maxX,
                                                    minX: 0,
                                                    minDate: first.date)
        
        
    }
    
    func setMinAndMax(with bodyweight: BodyweightListItem) {
        
        if let minBw = minBodyweight {
            minBodyweight = min(minBw, bodyweight)
        } else {
            minBodyweight = bodyweight
        }
        
        if let maxBw = maxBodyweight {
            maxBodyweight = max(maxBw, bodyweight)
        } else {
            maxBodyweight = bodyweight
        }
        
    }
    
    func bodyweightsFrom(daysAgo: Int) -> [BodyweightListItem] {
        let xDaysAgo = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
        let items = bodyweightItems.filter({ $0.date >= xDaysAgo })
        return items 
    }
    
    
}




class BodyweightListItem: Comparable, BodyweightEntryData {
    
    init(_ bodyweight: Bodyweight, previous: BodyweightListItem?) {
        self.bodyweightClass = bodyweight
        self.prevBodyweight = previous
    }
    
    let prevBodyweight: BodyweightListItem?
    
    let bodyweightClass: Bodyweight
    
    var bodyweight: Double {
        return bodyweightClass.bodyweight
    }
    
    var date: Date {
        return bodyweightClass.date
    }
    
    var marginFromPrev: Double {
        guard let prevBW = prevBodyweight?.bodyweight else { return 0 }
        return bodyweight - prevBW
    }
    
    static func <(lhs: BodyweightListItem, rhs: BodyweightListItem) -> Bool {
        return lhs.bodyweight < rhs.bodyweight
    }
    
    static func ==(lhs: BodyweightListItem, rhs: BodyweightListItem) -> Bool {
        return lhs.bodyweight == rhs.bodyweight
    }
    
}

extension BodyweightListItem: ScatterPlotDataItem {
    var value: Double {
        return bodyweight
    }
}


class UpdateBodyweightModel: UpdatesBodyweight {
    
    let bodyweight: Bodyweight?
    
    var date: Date
    
    var bodyweightValue: Double
    
    init(bodyweight: Bodyweight?) {
        self.bodyweight = bodyweight
        self.date = bodyweight?.date ?? Date()
        self.bodyweightValue = bodyweight?.bodyweight ?? 0
    }
    
    func deleteBWEntry() {
        bodyweight?.delete()
    }
    
    func readyToSave() -> Bool {
        return bodyweightValue != 0
    }
    
    func save() {
        let bodyweightToSave = bodyweight ?? Bodyweight(context: context)
        bodyweightToSave.save(value: bodyweightValue, date: date)
    }
    
    func save(date: Date) {
        self.date = date
    }
    
    func setBodyweight(value: Double) {
        bodyweightValue = value
    }
    
}








