//
//  ExerciseListModel.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/3/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol ExerciseListModel: ReloadableModel {
    var listItems: [ExerciseListItem] { get set }
    var sections: [ExerciseListSectionsByCategory] { get set }
    func sortByCategory()
}

public protocol ExerciseListSectionsByCategory {
    var category: String { get }
    var items: [ExerciseListItem] { get }
}

public protocol HasAnalyticsController {
    var infoController: MasterInfoController { get }
}

public protocol ExerciseListItem: ExerciseCellData, HasAnalyticsController {
    var workoutsUsed: Int { get }
}
