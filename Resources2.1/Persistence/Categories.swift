//
//  subclasses.swift
//  exerciseModel1
//
//  Created by B_Litwin on 1/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import Foundation
import CoreData


class Categories: NSManagedObject {
    
    var exerciseSet: Set<Exercises> {
        return self.exercises as! Set<Exercises> 
    }
    
    class func activeCategories() -> [Categories] {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        
        //Mark: relying on a context observor to update categories as Active or Inactive depending
        //on whether all exercises contained within it are active
        
        request.predicate = NSPredicate(format: "isActive = true")
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true),
        ]
        
        let result = try? context.fetch(request)
        guard result != nil else { return [] }
        return result!
    }
    
    var compoundExerciseSet: Set<Multi_Exercise_Container_Types> {
        return compound_Exercises as! Set<Multi_Exercise_Container_Types>
    }
    
    class func fetchAll() -> [Categories] {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let result = try? context.fetch(request)
        guard let categories = result else { return [] }
        return categories
    }

}



extension Sequence where Iterator.Element == Sequences {
    var ordered: [Sequences] {
        return Array(self).sorted(by: { $0.workout_order < $1.workout_order })
    }
    
}






