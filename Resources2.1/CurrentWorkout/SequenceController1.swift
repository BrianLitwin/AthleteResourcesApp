//
//  SequenceController.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

//todolist main:

//if add exercise is on bottom of frame, scroll to bottom when adding a new exercise

//add entire sections of exercises
//remove empty categories from categories in "build complex" feature
//views aren't under navigation bar
//click on exercise rows to select them in search exercises
// in complexes: to use lb or kg?
// when you click on things- light them up
// missed-rep is off the keyboard button
// keyboard is way too small on my phone
//when you add a set : pull up the set editor on auto
//stipulate warm-up sets
//if you click on header, pull up options, don't just use button
// a much easier way to search for exercises
//you have to have a way of deleting thing in the rest_framework
/*
-clean showed up twice after making a complex with it
-when you're selecting a category for creating a new exercise exercise, show ALL categories
-text fields in exercise builder need to be longer to fit all text
 
 -compound exercise builder shows blank categories and isn't updating 
 
-show "complexes" in reactjs
-editing an exercise twice: can't switch back from kg to lbs if the exercise is already in the workout

-get text to overflow in Sequence header if it's a long complex name  - and in exercise list in Exercise Search
-crashed after doing new workout, changing date to a month prior, creating complex, and adding complex
 -there needs to be an option: change unit of measurement for  complexes: how to handle unit of measurement changes on an exercise in a complex
    -complex 90 x (1 x missedRep) shows as 90 x (1 + 0) instead of 90 x (1 + X)
-when you click on a category to choose an exercise, scroll the screen up if the choices are off the screen
 
 -figure out a better way to add exercises to reactjs database
 -figure out a way to delete stuff from database
 
 //resigning keyboard in add bodyweight isn't resigning properly: done btn jumps around
 
 //if you tap the bodyweight field in EnterBodyweight twice, the
 //second time the keyboard won't come up unless you tap the date textfield between taps
 
 the bodyweight chart goes out of view: is covered by the header on top of it: try adding 2 + 30 + 30 (or 28) , and the green line will be
 gone
 
 labels on bodyweight graph are not positioned correctly: too far under navigation bar
 
 have an empty screen for exercises if there are no active exercises
 
 the edit/create exercise looks bad as is: update to previous version 
 
*/


import UIKit

import Resources_View2_1

class WorkoutSequenceModel: SequenceModel {
    
    var sections: [SequenceSectionData] = []
    
    let sequence: Sequences
    
    init(sequence: Sequences) {
        self.sequence = sequence
        sections = sequence.orderedContainers.map({ SequenceSectionDataClass(container: $0) })
    }
    
    func update(with update: SequenceUIHandler.UIUpdate, at indexPath: IndexPath) {
        
        switch update {
            
        case .insertRow:
            
            let newSequence = sequence.insertExerciseMetric(at: indexPath)
            sections[indexPath.section].data.insert( newSequence.displayString() , at: indexPath.row)
            
        case .editRow:
            
            let exerciseMetric = sequence.exerciseMetric(for: indexPath)
            sections[indexPath.section].data[indexPath.row] = exerciseMetric.displayString()
            
        case .reloadSection:
            sections[indexPath.section].loadSectionData()
            
        case .deleteRow:
            
            sequence.removeExerciseMetric(at: indexPath)
            sections[indexPath.section].data.remove(at: indexPath.row)
            
        case .deleteSelf:
            
            //Mark: Unit test that exercise metrics and containers have been deleted
            sequence.delete(sequence: sequence)
            
        }
    }
    
    func masterInfoController(for indexPath: IndexPath) -> MasterInfoController? {
        return sequence.orderedContainers[indexPath.section].exercise?.infoController
    }
    
    func getSequenceModelUpdater(for indexPath: IndexPath) -> ModelUpdater {
        let exerciseMetric = sequence.exerciseMetric(for: indexPath)
        return SequenceModelUpdater(exerciseMetric: exerciseMetric)
    }
    
    deinit {
        print("deallocated")
    }
        
}


class SequenceSectionDataClass: SequenceSectionData {
    
    init(container: EM_Containers) {
        self.emContainer = container
        loadSectionData()
    }
    
    let emContainer: EM_Containers
    
    var name: String {
        return emContainer.exercise?.name ?? ""
    }
    
    var variation: String {
        return emContainer.exercise?.variation ?? ""
    }
    
    var data: [String] = []
    
    func loadSectionData() {
        data = emContainer.exerciseMetrics.map({ $0.displayString() })
    }
    
}










