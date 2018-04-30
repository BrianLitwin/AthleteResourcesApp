//
//  Workout Header Model.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol WorkoutHeaderInfo: SavesDate {
    var date: Date? { get }
    var bodyweight: Double? { get }
    var notes: String? { get }
    func showEditOptions()
}

public protocol ReloadsWorkoutHeader: class {
    func setupHeaderInfo()
}

