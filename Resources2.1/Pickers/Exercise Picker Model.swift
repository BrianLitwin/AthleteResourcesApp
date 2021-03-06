//
//  EP Model.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/20/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData
import Resources_View2_1

class ExerciseList {
    
}



class ExercisePickerDropDownModel: ContextObserver, DropDownTableModel, ExerciseTableViewModel, TableDataPopulator, ReloadableModel  {
    var data: [[ExerciseCellData]] = [[]]
    var exercises: [[Any]] = [[]]
    var collapsedSections: [Bool] = []
    var needsReload = true
    
    //in case you want to use this while building a compound exercise
    //is prob any easier way to achieve this
    let includeMultiExerciseContainer: Bool
    
    init(includeMultiExerciseContainer: Bool) {
        self.includeMultiExerciseContainer = includeMultiExerciseContainer
        super.init(context: context)
        setAllSectionsToCollapsed()
    }
    
    func setAllSectionsToCollapsed() {
        collapsedSections = Array.init(repeating: true, count: data.count)
    }
    
    func loadModel() {
        let data = returnExerciseCellData(includingCompoundExercises: includeMultiExerciseContainer)
        self.exercises = data
        self.data = data
        setAllSectionsToCollapsed()
        needsReload = false
    }
    
    override func objectsDiDChange(type: ContextObserver.changeType, entity: NSManagedObject, changedValues: [String : Any]) {
        if entity is Exercises || entity is Multi_Exercise_Container_Types || entity is Categories {
            needsReload = true
            // isActive is an update 
        }
    }
}

func returnExerciseCellData(includingCompoundExercises: Bool) -> [[ExerciseCellData]] {
    
    //temporary hack
    //unit test that compound exercises are included in categories that ret, especially if category only has compound exercsies 
    let categories = Categories.activeCategories().filter({ !$0.exerciseSet.isEmpty || !$0.compoundExerciseSet.isEmpty })
    
    switch includingCompoundExercises {
        
    case true:
        
        return categories.map( {
            let exercises = $0.exerciseSet.active() as [ExerciseCellData]
            let compoundExercises = $0.compoundExerciseSet.active() as [ExerciseCellData]
            let ret: [ExerciseCellData] = exercises + compoundExercises
            return ret.sorted(by: { ($0.name ?? "") < ($1.name ?? "") })
        })
        
    case false:
        
        let qualifiedMetricInfoSet: Set<Metric> = [Metric.Weight, Metric.Reps, Metric.Sets]
        
        let categoryData: [[ExerciseCellData]] = categories.map( {
            let exercises = $0.exerciseSet.filter({
                Set($0.metricInfoSet.map({$0.metric})) == qualifiedMetricInfoSet
            })
            return exercises.active().sortedAlpabetically()
        })
        
        //filter out categories with no valid exercises 
        return categoryData.filter { !$0.isEmpty }
    }
}




extension Collection where Iterator.Element: Exercises {
    
    func sortedAlpabetically() -> [Exercises] {
        return self.sorted(by: { ($0.name ?? "") > ($1.name ?? "") })
    }
    
    func active() -> [Exercises] {
        return self.filter({ $0.isActive })
    }
    
}

extension Collection where Iterator.Element: Multi_Exercise_Container_Types {
    func active() -> [Multi_Exercise_Container_Types] {
        return self.filter({ $0.isActive })
    }
}

extension Collection where Iterator.Element: Exercise_Metrics {
    
    func sortedBySets() -> [Exercise_Metrics] {
        return self.sorted(by: { $0.set_number < $1.set_number })
    }
    
}








