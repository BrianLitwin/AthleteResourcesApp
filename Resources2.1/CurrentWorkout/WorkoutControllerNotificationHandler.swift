//
//  WorkoutControllerNotificationHandler.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

class WorkoutControllerNotificationhandler {
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        
        self.viewController = viewController
        
        NotificationCenter.default.addObserver(self, selector: #selector(showExerciseTVC), name: NSNotification.Name(rawValue: showEditExerciseTableViewController), object: nil)
        
    }
    
    @objc func showExerciseTVC(_ notification: Notification) {
        
        guard viewController.isVisible else { return }
        
        guard let navControl = notification.userInfo?["UINavigationController"] as? UINavigationController else {
            return
        }
        
        viewController.present(navControl, animated: true)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
