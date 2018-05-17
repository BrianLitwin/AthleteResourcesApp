//
//  Workouts.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData


class Workouts: NSManagedObject {
    
    var date: Date {
        return dateSV! as Date 
    }
    
    class func createNewWorkout() -> Workouts {
        let workout = Workouts(context: context)
        workout.dateSV = Date()
        saveContext()
        return workout
    }
    
    class func createNewWorkout(date: Date) -> Workouts {
        let workout = Workouts(context: context)
        workout.dateSV = date
        saveContext()
        return workout
    }
    
    var sequenceSet: Set<Sequences> {
        return (sequences as! Set<Sequences>)
    }
    
    var orderedSequences: [Sequences] {
        return sequenceSet.ordered
    }
    
    var exerciseMetricsSet: Set<Exercise_Metrics> {
        
        return sequenceSet.reduce(Set<Exercise_Metrics>()) {
            set, sequence in
            let exerciseMetrics = sequence.containerSet.reduce(Set<Exercise_Metrics>()) {
                set, container in
                return set.union(container.exerciseMetricsSet)
            }
            return set.union(exerciseMetrics)
        }
        
    }
    
    
    func addNewSequence(at order: Int, multiExerciseType: Multi_Exercise_Container_Types) -> Sequences {
        let newS = Sequences.createNewSequence(workout: self, workoutOrder: order, type: multiExerciseType)
        return newS
    }
    
    func addNewSequence(at order: Int, with exercise: Exercises) -> Sequences {
        
        let newSequence = Sequences(context: context)
        newSequence.workout = self
        newSequence.workoutOrder = order
        orderedSequences.reorder(from: newSequence, type: .insert)
        
        //Mark: Default implementation for adding a new sequence ///
        
        let newContainer = EM_Containers(context: context)
        newContainer.exercise = exercise
        newContainer.sequence = newSequence
        newContainer.setOrder(order: 0)
        
        let newEM = Exercise_Metrics(context: context)
        newEM.container = newContainer
        newEM.set_number = 0
        
        saveContext()
        
        return newSequence
        
    }
    
    class func fetchLast() -> Workouts? {
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "dateSV", ascending: false)]
        let result = try? context.fetch(request)
        guard let workout = result?.first else { return nil }
        return workout
    }
    
    class func fetchFirst() -> Workouts? {
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "dateSV", ascending: true)]
        let result = try? context.fetch(request)
        guard let workout = result?.first else { return nil }
        return workout
    }
    
    class func fetchAll() -> [Workouts] {
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateSV", ascending: false)]
        let result = try? context.fetch(request)
        guard let workouts = result else { return [] }
        return workouts
    }
    
}



