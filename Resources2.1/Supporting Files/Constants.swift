//
//  Constants.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/6/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


var appDelegate = UIApplication.shared.delegate as! AppDelegate
var context = appDelegate.persistentContainer.viewContext


func saveContext() {
    try? context.save()
}

let workoutDateManager = DateManager(type: Workouts.self)
let bodyweightDateManager = DateManager(type: Bodyweight.self)


/*
 
 let invalidNumericEntryNotification = "invalidNumbericEntry Notification"
 
 NotificationCenter.default.addObserver(self, selector: #selector(self.setSection(notification:)), name: NSNotification.Name(rawValue: categoryChangeNotification), object: nil)
 
 NotificationCenter.default.post(name: NSNotification.Name(rawValue: showEditExerciseTableViewController), object: nil, userInfo: userInfo)
 
 deinit {
 NotificationCenter.default.removeObserver(self)
 }
 
 */

