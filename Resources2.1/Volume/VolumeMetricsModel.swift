//
//  VolumeMetricsModel.swift
//  Resources2.1
//
//  Created by B_Litwin on 8/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1





enum VolumeMetric {
    case totalReps((Exercise_Metrics)->Double)
    case totalSets((Exercise_Metrics)->Double)
    case volume((Exercise_Metrics)->Double)
    
    func value(with exerciseMetric: Exercise_Metrics) -> Double {
        switch self {
        case .totalReps(let calc): return calc(exerciseMetric)
        case .totalSets(let calc): return calc(exerciseMetric)
        case .volume(let calc): return calc(exerciseMetric)
        }
    }
    
    var headerTitle: String {
        switch self {
        case .totalReps: return "Total Reps"
        case .totalSets: return "Total Sets"
        case .volume: return "Volume"
        }
    }
}



class VolumeMetricsModel: Resources_View2_1.ExerciseInfoModel {
    
    public var volumeSections: [VolumeSectionViewModel] = []
    private var workouts: [Workouts] = []
    private let timeSpans: [TimeSpan] = [.week, .workout]
    private var timeSpan: TimeSpan = .week
    private var volumeMetrics: [VolumeMetric] = []
    private var sectionCache = [TimeSpan: [VolumeSectionViewModel]]()
    private let exercise: Exercises
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }
    
    private enum TimeSpan: Hashable {
        //TODO: ADD Month
        case week
        case workout
        
        func sort(workouts: [Workouts], volumeMetrics: [VolumeMetric]) -> [VolumeSectionViewModel] {
            
            func convertExerciseMetricsToValues(exerciseMetrics: [Exercise_Metrics]) -> [Double] {
                let values = exerciseMetrics.reduce(Array.init(repeating: 0.0, count: volumeMetrics.count),
                                                    { total, nextExerciseMetric in
                                                        return volumeMetrics.enumerated().map { next in
                                                            let index = next.offset
                                                            let volumeMetric = next.element
                                                            print(volumeMetric.value(with: nextExerciseMetric))
                                                            return total[index] + volumeMetric.value(with: nextExerciseMetric)
                                                        }
                })
                return values
            }
            
            switch self {
                
            case .week:
                let weeks = workoutDateManager.activeWeeks
                return weeks.compactMap { week in
                    let workouts = workouts.filter({ week.interval().contains($0.date ) })
                    guard workouts.isEmpty == false else { return nil }
                    let exerciseMetrics = workouts.flatMap { $0.exerciseMetricsSet } //flatMap b/c its a set of sets
                    let values = convertExerciseMetricsToValues(exerciseMetrics: exerciseMetrics)
                    let dateTitle = week.monday.monthDay + " - " + week.sunday.monthDay
                    return VolumeSectionViewModel(title: dateTitle, values: values)
                }
                
            case .workout:
                return workouts.flatMap {
                    let exerciseMetrics = $0.exerciseMetricsSet
                    let values = convertExerciseMetricsToValues(exerciseMetrics: Array(exerciseMetrics))
                    let title = $0.date!.monthDay
                    return VolumeSectionViewModel(title: title, values: values)
                }
            }
        }
    }
    
    //MARK: public API
    
    func setTimeSpan(with index: Int) {
        timeSpan = timeSpans[index]
        sort(by: timeSpan)
    }
    
    //Mark: ExerciseInfoModel
    
    var sections: [ExerciseAnalyticsSectionUIPopulator] = [] //satisfy protocol
    
    var needsReload: Bool = true
    
    func loadModel() {
        //can probably be more efficient about re-loading these every time
        
        volumeMetrics = getVolumeMetrics(for: exercise)
        workouts = exercise.workouts()
        sort(by: timeSpan)
    }
    
    private func sort(by timeSpan: TimeSpan) {
        if let cachedSections = sectionCache[timeSpan] {
            volumeSections = cachedSections
        } else {
            volumeSections = timeSpan.sort(workouts: workouts, volumeMetrics: volumeMetrics)
            sectionCache[timeSpan] = volumeSections
        }
    }
}








func getVolumeMetrics(for exercise: Exercises) -> [VolumeMetric] {
    var metrics = [VolumeMetric]()
    let containsWeight = exercise.metricInfoSet.containsMetric(.Weight) != nil
    let containsReps = exercise.metricInfoSet.containsMetric(.Reps) != nil
    let containsSets = exercise.metricInfoSet.containsMetric(.Sets) != nil
    
    func weight(_ em: Exercise_Metrics) -> Double {
        return em.value(for: .Weight).converted
    }
    
    func reps(_ em: Exercise_Metrics) -> Double {
        return em.value(for: .Reps).converted
    }
    
    func sets(_ em: Exercise_Metrics) -> Double {
        return em.value(for: .Sets).converted
    }
    
    func totalRepsCalc() -> (Exercise_Metrics) -> Double {
        switch (containsReps, containsSets) {
        case (true, true):
            return { (em: Exercise_Metrics) -> Double in return reps(em) * sets(em) }
            
        case (false, true):
            return { (em: Exercise_Metrics) -> Double in return reps(em) }
            
        case (true, false):
            return { (em: Exercise_Metrics) -> Double in return sets(em) }
            
        case (false, false):
            return { (em: Exercise_Metrics) -> Double in return 1 }
        }
    }
    
    func volumeCalc() -> (Exercise_Metrics) -> Double {
        if containsWeight {
            return { (em: Exercise_Metrics) -> Double in
                let weight = em.value(for: .Weight).converted
                let totalReps = totalRepsCalc()(em)
                return weight * totalReps
            }
        } else {
            //default is to return total reps if there is no weight
            return {
                (em: Exercise_Metrics) -> Double in return totalRepsCalc()(em)
            }
        }
    }
    
    func totalSets() -> (Exercise_Metrics) -> Double {
        return { (em: Exercise_Metrics) -> Double in return em.value(for: .Sets).converted }
    }
    
    var volumeMetric: VolumeMetric {
        return VolumeMetric.volume(volumeCalc())
    }
    
    var totalRepsMetric: VolumeMetric {
        return VolumeMetric.totalReps(totalRepsCalc())
    }
    
    var totalSetsMetric: VolumeMetric {
        return VolumeMetric.totalSets(totalSets())
    }
    
    
    switch (containsWeight, containsReps, containsSets) {
    case (true, true, true): return [volumeMetric, totalRepsMetric, totalSetsMetric]
    case (false, true, true): return [totalRepsMetric, totalSetsMetric]
    case ( _ , true, false): return [totalRepsMetric]
    default: return []
    }
}






