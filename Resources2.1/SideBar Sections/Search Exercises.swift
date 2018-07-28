//
//  Exercise Search.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/20/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

import Resources_View2_1

class SearchExercisesModel: ExerciseSearchModel {
    
    typealias CategoryViewSection = Resources_View2_1.CategorySection
    
    var sections: [CategoryViewSection] = []
    
    var filteredSections: [CategoryViewSection] = []
    
    init() {
        
        let categories = Categories.fetchAll()
        var sections: [CategorySection] = []
        
        categories.forEach({
            let exercises = $0.exerciseSet.sortedAlpabetically() as [CategoryViewSection.ExerciseData]
            let compoundExercises = $0.compoundExerciseSet.sorted(by:
            { ($0.name ?? "") < ($1.name ?? "")}) as [CategoryViewSection.ExerciseData]
            let allEx: [CategoryViewSection.ExerciseData] = exercises + compoundExercises
            if !allEx.isEmpty {
                let section = CategorySection($0, exercises: allEx)
                sections.append(section)
            }
        })
        
        self.sections = sections 
        filteredSections = sections
    }
    
    func filterByExercise(with text: String) {
        sections.forEach({
            $0.filterExercises(with: text)
        })
        
        filteredSections = sections.filter({
            !$0.filteredExercises.isEmpty
        })
    }
    
    func filterByCategory(with text: String) {
        sections.filter({
            $0.name.contains(text)
        })
    }
}

class CategorySection: Resources_View2_1.CategorySection {
    
    let name: String
    
    let exercises: [ExerciseData]
    
    var filteredExercises: [ExerciseData] = []
    
    init(_ category: Categories, exercises: [ExerciseData]) {
        self.exercises = exercises
        self.name = category.name ?? ""
        filteredExercises = exercises
    }
    
    func filterExercises(with text: String) {
        
        filteredExercises = exercises.filter({
            ($0.name ?? "").lowercased().contains(text.lowercased())
        })
        
    }
    
}

class SearchExerciseCellDataModel: ExerciseCellData {
    let cellData: ExerciseCellData
    let type: DataType
    
    var name: String? {
        return cellData.name
    }
    
    var variation: String? {
        return cellData.variation
    }
    
    var categoryName: String {
        return cellData.categoryName
    }
    
    init(cellData: ExerciseCellData, type: DataType) {
        self.cellData = cellData
        self.type = type
    }
    
    enum DataType {
        case exercise(Exercises)
        case compoundExercise(Multi_Exercise_Container_Types)
        
        func save() {
            
            switch self {
                
            case .exercise(let exercise):
                break
                
            case .compoundExercise(let containerType):
                break
                
            }
        }
    }
}

