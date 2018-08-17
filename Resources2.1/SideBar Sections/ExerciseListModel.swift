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
    typealias SectionType = Resources_View2_1.ExerciseListSectionsByCategory
    var needsReload: Bool = true
    var listItems: [ExerciseListItem] = []
    var sections: [SectionType] = []
    
    init() {
        super.init(context: context)
    }
    
    func loadModel() {
        let activeExercises: [ExerciseListItem] = Exercises.fetchAll(active: true) as [ExerciseListItem]
        let activeMultiExerciseContainers: [ExerciseListItem] = Multi_Exercise_Container_Types.fetchAll(active: true) as [ExerciseListItem]
        var listItems: [ExerciseListItem] = activeExercises + activeMultiExerciseContainers

        //no good 
        listItems = listItems.filter({ $0.workoutsUsed > 0 })
        listItems.sort(by: { $0.workoutsUsed > $1.workoutsUsed })
        self.listItems = listItems
    }
    
    func sortByCategory() {
        guard sections.isEmpty, needsReload == true else { return }
        
        var categories: [String: [ExerciseListItem]] = [:]
        
        for item in listItems {
            let name = item.categoryName
            categories[name] = (categories[name] ?? []) + [item]
        }

        self.sections = categories.map({ k,v in
            return ExerciseListSectionsByCategory(category: k, items: v)
        }).sorted(by: { $0.category < $1.category })
    }
    
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any]) {
        //TODO 
    }
    
    struct ExerciseListSectionsByCategory: SectionType {
        let category: String
        let items: [ExerciseListItem]
        init(category: String, items: [ExerciseListItem] ) {
            self.category = category
            self.items = items
        }
    }
}





extension Exercises {
    func workouts(sortedAscending: Bool = false) -> [Workouts] {
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        request.predicate = NSPredicate(format: "SUBQUERY(sequences, $x, SUBQUERY($x.containers, $y, $y.exercise = %@).@count > 0).@count > 0", self)
        request.sortDescriptors = [NSSortDescriptor(key: "dateSV", ascending: sortedAscending)]
        let result = try? context.fetch(request)
        return result ?? []
    }
}




extension Exercises: ExerciseListItem {
    
    var categoryName: String {
        return category?.name ?? ""
    }
    
    var workoutsUsed: Int {
        return workouts().count
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


