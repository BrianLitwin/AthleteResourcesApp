//
//  Compound Exercise Model.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1




class CompoundExerciseModel: SequenceModel {
    
    let containerType: Multi_Exercise_Container_Types
    
    let sequence: Sequences
    
    var sections: [SequenceSectionData]
    
    let section: CompoundExerciseSections
    
    let exerciseContainers: [Multi_Exercise_Container]
    
    let exercises: [Exercises]
    
    //
    //Mark: there's an assumption that there will only be one Section in this collection view i.e.
    // you can't do a superset or circuit with compoundExercises
    
    
    init(sequence: Sequences) {
        
        self.sequence = sequence 
        
        self.containerType = sequence.multi_exercise_container_type ?? Multi_Exercise_Container_Types(context: context) //FIXME
        
        self.exerciseContainers = containerType.orderedExerciseContainers
        
        self.exercises = exerciseContainers.flatMap({ $0.exercise })
        
        self.section = CompoundExerciseSections(sequence: sequence)
        
        self.sections = [section]
        
    }
    
    func update(with update: SequenceUIHandler.UIUpdate, at indexPath: IndexPath) {
        section.update(with: update, at: indexPath)
        
    }
    
    func masterInfoController(for indexPath: IndexPath) -> MasterInfoController? {
        return containerType.infoController
    }
    
    func getSequenceModelUpdater(for indexPath: IndexPath) -> ModelUpdater {
        return section.getSequenceModelUpdater(for: indexPath)
    }
    
}




class CompoundExerciseSections: SequenceSectionData {
    
    var name: String  {
        return containerType.name ?? ""
    }
    
    var variation = ""
    
    var sections: [CompoundExerciseSection] = []
    
    var data: [String] = []
    
    let sequence: Sequences
    
    let containerType: Multi_Exercise_Container_Types
    
    let exercises: [Exercises]
    
    init(sequence: Sequences) {
        
        self.sequence = sequence
        
        self.containerType = sequence.multi_exercise_container_type ?? Multi_Exercise_Container_Types(context: context) //FIXME
        
        self.exercises = containerType.orderedExerciseContainers.flatMap({ $0.exercise })
        
        let exerciseMetricCount = sequence.containerSet.reduce(0, { count, sequence in
            count + sequence.exerciseMetricsSet.count
        })
        
        let rowCount = exerciseMetricCount / exercises.count
        
        (0..<rowCount).forEach({
            row in
            let ems = exerciseMetrics(at: row)
            let newSection = CompoundExerciseSection(exerciseMetrics: ems)
            sections.append(newSection)
        })
        
        loadSectionData()
        
    }
    
    func update(with update: SequenceUIHandler.UIUpdate, at indexPath: IndexPath) {
        
        switch update {
            
        case .insertRow:
            
            for (containerOrder, _ ) in exercises.enumerated() {
                _ = sequence.insertExerciseMetric(at: [containerOrder, indexPath.row])
            }
            
            let ems = exerciseMetrics(at: indexPath.row)
            let newSection = CompoundExerciseSection(exerciseMetrics: ems)
            sections.insert(newSection, at: indexPath.row)
            data.insert( newSection.displayString(), at: indexPath.row)
            
        case .editRow:
            
            let section = sections[indexPath.row]
            data[indexPath.row] = section.displayString()
            
        case .reloadSection:
            
            loadSectionData()
            
        case .deleteRow:
            
            for (containerOrder, _ ) in exercises.enumerated() {
                _ = sequence.removeExerciseMetric(at: [containerOrder, indexPath.row])
            }
            
            sections.remove(at: indexPath.row)
            data.remove(at: indexPath.row)
            
        case .deleteSelf:
            
            sequence.delete(sequence: sequence)
            
        }
        
    }
    
    func loadSectionData() {
        data = sections.map({ $0.displayString() })
    }
    
    func exerciseMetrics(at row: Int) -> [Exercise_Metrics] {
        return sequence.orderedContainers.map({ $0.exerciseMetrics[row] })
    }
    
    func getSequenceModelUpdater(for indexPath: IndexPath) -> ModelUpdater {
        let ems = exerciseMetrics(at: indexPath.row)
        return SequenceModelUpdater(exerciseMetrics: ems)
    }
    
}


class CompoundExerciseSection: Hashable {
    
    let exerciseMetrics: [Exercise_Metrics]
    
    var weight: Double {
        guard let first = exerciseMetrics.first else { return 0 }
        return first.weight
    }
    
    var reps: [Double] {
        return exerciseMetrics.map({ $0.repsSV })
    }
    
    var sets: Double {
        guard let first = exerciseMetrics.first else { return 0 }
        return first.setsSV
    }
    
    let hashValue: Int
    
    init(exerciseMetrics: [Exercise_Metrics]) {
        self.exerciseMetrics = exerciseMetrics
        self.hashValue = exerciseMetrics.isEmpty ? 0 : exerciseMetrics.first!.hashValue //no two exerciseMetrics should be in the same container
        
    }
    
    static func ==(lhs: CompoundExerciseSection, rhs: CompoundExerciseSection) -> Bool {
        guard let firstLHS = lhs.exerciseMetrics.first else { return false }
        guard let firstRHS = rhs.exerciseMetrics.first else { return false }
        return firstLHS == firstRHS
    }
    
    func displayString() -> String {
        return displayStringForCompoundExerciseMetrics(ems: exerciseMetrics) 
    }
    
}



func displayStringForCompoundExerciseMetrics(ems: [Exercise_Metrics]) -> String {
    guard !ems.isEmpty else { return "" }
    let weight = ems[0].displayString(for: .Weight)
    let reps: String? = "(" + ems.map({ $0.repsSV.displayString }).joined(separator: " + ") + ")"
    let sets = ems[0].displayString(for: .Sets)
    return [weight, reps, sets].flatMap({$0}).joined(separator: " x ")
}






