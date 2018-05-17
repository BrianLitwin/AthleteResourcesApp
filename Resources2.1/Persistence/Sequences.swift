//
//  Sequences.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/12/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData


class Sequences: NSManagedObject {

    var workoutOrder: Int {
        
        get {
            return Int(workout_order)
        }
        set {
            workout_order = Int16(newValue)
        }
    }
    
    
    var containerSet: Set<EM_Containers> {
        return containers as! Set<EM_Containers>
    }
    
    var orderedContainers: [EM_Containers] {
        return containerSet.sorted(by: { $0.order < $1.order })
    }
    
    class func createNewSequence(workout: Workouts,
                                 workoutOrder: Int,
                                 type: Multi_Exercise_Container_Types) -> Sequences
        {
        let newSequence = Sequences(context: context)
        newSequence.workout = workout
        newSequence.workoutOrder = workoutOrder
            
        type.orderedExerciseContainers.forEach({
            
            guard $0.exercise != nil else { return }
            
            _ = EM_Containers.create(exercise: $0.exercise!,
                                     sequence: newSequence,
                                     order: Int($0.order))
            
        })
            
        type.addToSequences(newSequence)
        
        saveContext()
        return newSequence
    }
    
    class func fetchAll() -> [Sequences] {
        let request: NSFetchRequest<Sequences> = Sequences.fetchRequest()
        let result = try? context.fetch(request)
        guard let sequences = result else { return [] }
        return sequences
    }
    
    
    
}


extension Sequences {
    
    //if there is one exercise, you will have one container

    //Mark: CollectionViewAttachment Methods 
    
    func exerciseMetric(for indexPath: IndexPath) -> Exercise_Metrics {
        let container = orderedContainers[indexPath.section]
        return container.exerciseMetrics[indexPath.row]
    }
    
    func insertContainer(exercise: Exercises, section: Int) {
        let newContainer = EM_Containers.create(exercise: exercise, sequence: self, order: section)
        orderedContainers.reorder(from: newContainer, type: .insert)
    }
    
    func removeContainer(at section: Int) {
        guard containerSet.count > 1 else { return }
        let container = orderedContainers[section]
        container.delete()
        orderedContainers.reorder(from: container, type: .remove)
    }
    
    func insertExerciseMetric(at indexPath: IndexPath) -> Exercise_Metrics {
        let container = orderedContainers[indexPath.section]
        let newEM = Exercise_Metrics.create(container: container, set_number: indexPath.row)
        container.exerciseMetrics.reorder(from: newEM, type: .insert)
        return newEM
    }
    
    func removeExerciseMetric(at indexPath: IndexPath) {
        let container = orderedContainers[indexPath.section]
        guard container.exerciseMetricsSet.count > 1 else { return }
        let EM = container.exerciseMetrics[indexPath.row]
        EM.delete()
        container.exerciseMetrics.reorder(from: EM, type: .remove)
    }
    
    func delete(sequence: Sequences) {
        guard let workout = sequence.workout else { return }
        sequence.delete()
        workout.orderedSequences.reorder(from: sequence, type: .remove)
    }
    
}


