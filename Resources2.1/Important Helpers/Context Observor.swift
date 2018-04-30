//
//  Context Observor.swift
//  UI Templates
//
//  Created by B_Litwin on 1/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData

//set needsReload to false in 'load model' 





class ContextObserver {
    
    init(context: NSManagedObjectContext) {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(contextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
    
    enum changeType {
    case insert
    case update
    case delete
    }
    
    func objectsDiDChange(type: changeType, entity: NSManagedObject, changedValues: [String: Any]) {
        
    }
    
    @objc func contextObjectsDidChange(notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0
        {
            for insert in inserts {
                objectsDiDChange(type: .insert, entity: insert, changedValues: insert.changedValuesForCurrentEvent())
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            
            for update in updates {
                objectsDiDChange(type: .update, entity: update, changedValues: update.changedValuesForCurrentEvent())
            }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            
            for delete in deletes {
                objectsDiDChange(type: .delete, entity: delete, changedValues: delete.changedValuesForCurrentEvent())
            }
        }
    }
    
}




