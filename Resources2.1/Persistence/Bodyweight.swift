//
//  Bodyweight.swift
//  Resources2.1
//
//  Created by B_Litwin on 4/30/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import Foundation
import CoreData


//TODO: put saveContext in NSManagedObject class - don't save from outside class

class Bodyweight: NSManagedObject {
    
    class func first() -> Bodyweight? {
        let request: NSFetchRequest<Bodyweight> = Bodyweight.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateSV", ascending: true )]
        request.fetchLimit = 1
        let result = try? context.fetch(request)
        guard result != nil else { return nil }
        guard !result!.isEmpty else { return nil }
        return result![0]
    }
    
    var date: Date {
        return dateSV!
    }
    
    class func fetchAll(ascending: Bool = false) -> [Bodyweight] {
        let request: NSFetchRequest<Bodyweight> = Bodyweight.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateSV", ascending: ascending)]
        let result = try? context.fetch(request)
        guard let bws = result else { return [] }
        return bws
    }
    
    class func create(value: Double, date: Date) -> Bodyweight {
        let newBw = Bodyweight(context: context)
        newBw.bodyweight = value
        newBw.dateSV = date
        saveContext()
        return newBw
    }
    
    func save(value: Double, date: Date) {
        self.bodyweight = value
        self.dateSV = date
        saveContext()
    }
    
}
