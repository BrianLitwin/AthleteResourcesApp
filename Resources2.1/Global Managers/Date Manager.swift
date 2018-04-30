//
//  Date Manager.swift
//  UI Templates
//
//  Created by B_Litwin on 1/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData


typealias DateManageableType = DateManageable & NSManagedObject


protocol DateManageable {
    
    var date: Date { get }
    static func getFirstEntry() -> DateManageableType?
    
}

extension Bodyweight: DateManageable {
    class func getFirstEntry() -> DateManageableType? {
        return Bodyweight.first()
    }
}

extension Workouts: DateManageable {
    class func getFirstEntry() -> DateManageableType? {
        return Workouts.fetchFirst() ?? Workouts.createNewWorkout()
    }
}


class DateManager<T:DateManageableType>: ContextObserver {
    
    let managedType: T.Type
    
    init(type: T.Type) {
        self.managedType = type
        super.init(context: context)
        firstEntry = managedType.getFirstEntry() as? T
        setActiveWeeks()
    }
    
    func setActiveWeeks() {
        activeWeeks = firstEntry != nil ? Date.weeksBetween(currentDate: Date(), startDate: firstEntry!.date) : []
    }
    
    var firstEntry: T? {
        didSet {
            setActiveWeeks()
        }
    }
    
    var activeWeeks: [Date.Week] = []
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any]) {
        
        if let newEntry = entity as? T {
            
            if firstEntry == nil {
                firstEntry = newEntry
                return
            }
            
            switch newEntry {
                
            case let n where n == firstEntry:
                
                if type == .delete {
                    firstEntry = managedType.getFirstEntry() as? T
                }
                
                if let prevDate = changedValues["dateSV"] as? Date {
                        
                    if prevDate > firstEntry!.date {
                        
                        activeWeeks = Date.weeksBetween(currentDate: Date(), startDate: firstEntry!.date)
                        
                    }
                    
                    if prevDate < firstEntry!.date {
                        
                        firstEntry = managedType.getFirstEntry() as? T
                        
                    }
                    
                }
             
            case let n where n.date < firstEntry!.date:
                
                firstEntry = n
                
            default:
                break
                
            }
            
        }
        
    }
    
}



























