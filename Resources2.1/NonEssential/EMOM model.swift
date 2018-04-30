//
//  EMOM model.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

//density model: max reps in given time, min time to get to given reps, single exercise vs multiple exercises


class EMOMModel {
    
    let exercise: Exercises
    let activeMetricInfos: [Metric_Info]
    var sections: [EMOMSection] = []
    
    init(exercise: Exercises) {
        self.exercise = exercise
        self.activeMetricInfos = exercise.metricInfo.filter({ $0.metric != Metric.Sets })
    }
    
    var totalRounds: Int {
        return sections.reduce(0, { a, b in a + b.rounds })
    }
    
    func setAllExerciseMetricSetNumbers() {
        var i = 0
        for section in sections {
            for exerciseMetric in section.exerciseMetrics {
                exerciseMetric.setNumber = i
                i += 1
            }
        }
    }
    
}

class EMOMSection {
    
    var exerciseMetrics: [Exercise_Metrics] = []
    
    init(exerciseMetric: Exercise_Metrics) {
        self.exerciseMetrics = [exerciseMetric]
    }
    
    var rounds: Int {
        return exerciseMetrics.count
    }
    
    func addRound() {
        guard let new = exerciseMetrics.first?.copy() as? Exercise_Metrics else { return }
        exerciseMetrics.append(new)
    }
    
    func removeRound() {
        let emToDelete = exerciseMetrics.popLast()
        emToDelete?.delete()
    }
    
}

/*

protocol EmomMethods1 {
    var container: EM_Containers { get }
}

extension EmomMethods1 {
    
    var rounds: Int {
        return container.exerciseMetrics.count
    }
    
    var nextSetNumber: Int {
        guard let lastSet = container.exerciseMetrics.last else { return 0 }
        return lastSet.setNumber + 1
    }
    
    var previousRepCount: Double {
        guard container.exerciseMetrics.count > 0 else { return 0 }
        return container.exerciseMetrics[container.exerciseMetrics.endIndex-1].reps
    }
    
    var previousWeight: Double {
        guard container.exerciseMetrics.count > 0 else { return 0 }
        return container.exerciseMetrics[container.exerciseMetrics.endIndex-1].weight
    }
    
    func append(weight: Double? = nil, rounds: Int = 1, reps: Double? = nil) {
        for _ in 0..<rounds {
            Exercise_Metrics.create(container: container, weight: weight ?? previousWeight, reps: reps ?? previousRepCount, setNumber: nextSetNumber)
        }
    }
    
    var displayString: String {
        let stringArray = container.exerciseMetrics.reduce([], { a, b in a + [b.weight.displayString + " x " + b.reps.displayString]  } )
        return stringArray.joined(separator: ", ")
    }
    
    func removeLast() {
        guard let exerciseMetricToRemove = container.exerciseMetrics.last else { return }
        exerciseMetricToRemove.delete()
    }
    
}

private extension Exercise_Metrics {
    
    class func create(container: EM_Containers, weight: Double, reps: Double, setNumber: Int) {
        let newEm = create(container: container, set_number: setNumber)
        newEm.weight = weight
        newEm.repsSV = reps
        saveContext()
    }
    
}

 */
