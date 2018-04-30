//
//  Superset.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/30/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData
import Resources_View2_1


class EM_Containers: NSManagedObject {
    
    class func create(exercise: Exercises,
                      sequence: Sequences,
                      order: Int,
                      createFirstExerciseMetric: Bool = true 
        ) -> EM_Containers
    {
        let newContainer = EM_Containers(context: context)
        newContainer.exercise = exercise
        newContainer.sequence = sequence
        newContainer.setOrder(order: order)
        
        if createFirstExerciseMetric {
            _ = Exercise_Metrics.create(container: newContainer, set_number: 0)
        }

        return newContainer
    }
    
    var exerciseMetricsSet: Set<Exercise_Metrics> {
        return exercise_metrics as! Set<Exercise_Metrics>
    }
    
    var exerciseMetrics: [Exercise_Metrics] {
        return exerciseMetricsSet.sortedBySets()
    }
    
    class func fetchAll() -> [EM_Containers] {
        
        let request: NSFetchRequest<EM_Containers> = EM_Containers.fetchRequest()
        let result = try? context.fetch(request)
        guard let emContainers = result else { return [] }
        return emContainers
    }
    
}





