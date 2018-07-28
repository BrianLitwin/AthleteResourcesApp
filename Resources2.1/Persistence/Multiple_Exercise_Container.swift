//
//  Multiple_Exercise_Container.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/26/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData
import Resources_View2_1


enum MultiExerciseContainerType: Int16 {
    case compoundExercise = 0
}


final class Multi_Exercise_Container_Types: NSManagedObject, HasAnalyticsController {
    
    lazy var infoController: MasterInfoController = {
        return MultiExerciseContainerController(containerType: self)
    }()
    
    lazy var personalRecordsManager: RecordsManager = {
        return RecordsManager(parentClass: self)
    }()
    
    class func create(category: Categories, with exercises: [Exercises], active: Bool = true) -> Multi_Exercise_Container_Types {
        
        let newType = Multi_Exercise_Container_Types(context: context)
        newType.category = category 
        
        for (order, exercise) in exercises.enumerated() {
            let newContainer = Multi_Exercise_Container.create(exercise: exercise, order: order)
            newContainer.parent_container = newType
        }
        
        newType.isActive = active 
        saveContext()
        return newType
    }
    
    
    var orderedExerciseContainers: [Multi_Exercise_Container] {
        let exerciseContainers = exercises as! Set<Multi_Exercise_Container>
        return exerciseContainers.sorted(by: { $0.order < $1.order })
    }
    
    var orderedExercises: [Exercises] {
        return orderedExerciseContainers.compactMap({ $0.exercise })
    }
    
    class func fetchAll(active: Bool = true) -> [Multi_Exercise_Container_Types] {
        let request: NSFetchRequest<Multi_Exercise_Container_Types> =
            Multi_Exercise_Container_Types.fetchRequest()
        //no sort descriptors because can't think of one
        let result = try? context.fetch(request)
        
        if active == true {
            request.predicate = NSPredicate(format: "isActive = true")
        }
        
        guard let containers = result else { return [] }
        
        //todo: temporary fix, predicate not working
        //unit test this
        return containers.filter({ $0.isActive })
        
        //return containers
    }
    
}



extension Multi_Exercise_Container_Types: ExerciseCellData {
    
    var name: String? {
        let exercises: [String] = orderedExercises.map({
            let name = ($0.name ?? "")
            let variation = ($0.variation ?? "")
            return variation.IsEmptyString ? name : name + " " + variation
        })
        return exercises.joined(separator: " + ")
    }
    
    var variation: String? {
        return ""
    }
    
    var categoryName: String {
        return category?.name ?? ""
    }
}




class MultiExerciseContainerController: MasterInfoController {
    var info: ExerciseCellData { return containerType }
    
    let containerType: Multi_Exercise_Container_Types
    
    init(containerType: Multi_Exercise_Container_Types) {
        self.containerType = containerType
    }
    
    lazy var infoControllers: [ExerciseInfoController] = {
        return [
            CompoundExerciseRecordsController(containerType: containerType)
        ]
    }()
}

class CompoundExerciseRecordsController: ExerciseInfoController {
    
    let containerType: Multi_Exercise_Container_Types
    
    lazy var model: ExerciseInfoModel? = RecordsDisplayModel(type: containerType)
    
    lazy var viewController: UIViewController = {
        guard let model = self.model else { return UIViewController() }
        return ExerciseAnalyticsTableViewController(model: model)
    }()
    
    let alertTitle: String = "Personal Records"
    
    let menuIcon: UIImage = #imageLiteral(resourceName: "trending")
    
    var menuTitle: String = "Records"
    
    var displaysInAlertOptions: Bool = true
    
    var displaysInExerciseInfo: Bool = true
    
    init(containerType: Multi_Exercise_Container_Types) {
        self.containerType = containerType
    }
    
}













class Multi_Exercise_Container: NSManagedObject {
    
    //sets the order of exercises in the container 
    
    class func create(exercise: Exercises, order: Int) -> Multi_Exercise_Container {
        let newContainer = Multi_Exercise_Container(context: context)
        newContainer.exercise = exercise
        newContainer.order = Int16(order)
        saveContext()
        return newContainer
    }
    
}


