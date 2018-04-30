//
//  ExerciseListModel.swift
//  Resources2.1
//
//  Created by B_Litwin on 4/3/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData
import Resources_View2_1

class ExerciseListModel: ContextObserver, Resources_View2_1.ExerciseListModel, ReloadableModel {
    
    var needsReload: Bool = true
    
    var listItems: [ExerciseListItem] = []
    
    init() {
        super.init(context: context)
    }
    
    func loadModel() {
        
        let activeExercises: [ExerciseListItem] = Exercises.fetchAll(active: true) as [ExerciseListItem]
        
        let activeMultiExerciseContainers: [ExerciseListItem] = Multi_Exercise_Container_Types.fetchAll(active: true) as [ExerciseListItem]
        
        var listItems: [ExerciseListItem] = activeExercises + activeMultiExerciseContainers
        
        listItems.sort(by: { $0.workoutsUsed < $1.workoutsUsed } )
        
        self.listItems = listItems
        
    }
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any]) {
        //TODO 
    }
    
}





extension Exercises: ExerciseListItem {
    
    var workoutsUsed: Int {
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        request.predicate = NSPredicate(format: "SUBQUERY(sequences, $x, SUBQUERY($x.containers, $y, $y.exercise = %@).@count > 0).@count > 0", self)
        request.sortDescriptors = [NSSortDescriptor(key: "dateSV", ascending: false)]
        let result = try? context.fetch(request)
        return result?.count ?? 0
    }
    
    
}

extension Multi_Exercise_Container_Types: ExerciseListItem {
    
    var workoutsUsed: Int {
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        request.predicate = NSPredicate(format: "SUBQUERY(sequences, $x, SUBQUERY($x.multi_exercise_container_type, $y, $y = %@).@count > 0).@count > 0", self)
        request.sortDescriptors = [NSSortDescriptor(key: "dateSV", ascending: false)]
        let result = try? context.fetch(request)
        return result?.count ?? 0
    }
    
    
}


