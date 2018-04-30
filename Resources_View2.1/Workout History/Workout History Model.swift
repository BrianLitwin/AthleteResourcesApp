//
//  Workout History Model.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

//FIX ME: Exercise picker not updating 

import UIKit

public protocol WorkoutHistorySegueHandler {
    func prepareForSegue(with viewController: UIViewController)
    func setIndexPath(_ indexPath: IndexPath)
}

public protocol WorkoutHistoryModel: ReloadableModel {
    var sections: [WorkoutHistoryModelSection] { get }
    func deletItem(at indexPath: IndexPath)
    var segueHandler: WorkoutHistorySegueHandler? { get }
}

public protocol WorkoutHistoryModelSection {
    var dateInterval: DateInterval { get }
    var items: [WorkoutHistoryItem] { get set }
}

public protocol WorkoutHistoryItem {
    var date: Date { get }
    //var exerciseCount: Int { get }
}

