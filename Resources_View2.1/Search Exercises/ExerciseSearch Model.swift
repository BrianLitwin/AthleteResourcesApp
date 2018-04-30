//
//  ExerciseSearch Model.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public protocol ExerciseSearchModel {

    var sections: [CategorySection] { get set }
    
    var filteredSections: [CategorySection] { get set }
    
    func filterByExercise(with text: String)
    
    func filterByCategory(with text: String)
        
}

public protocol CategorySection {
    
    typealias ExerciseData = ExerciseCellData & CanSetIsActive
    
    var name: String { get }
    var exercises: [ExerciseData] { get }
    var filteredExercises: [ExerciseData] { get }
    
    func filterExercises(with text: String)
    
}

public protocol CanSetIsActive {
    var isActive: Bool { get }
    func setExerciseIsActive(to bool: Bool)
}

