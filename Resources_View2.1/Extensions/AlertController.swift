//
//  AlertController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/19/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit



public extension UIAlertController {
    
    func show() {
        rootViewController?.present(self, animated: true)
    }
    
    func doneAction(title: String = "Done") -> UIAlertAction {
        return UIAlertAction(title: title, style: .cancel)
    }
    
    func cancelAction(title: String = "Cancel") -> UIAlertAction {
        return UIAlertAction(title: title, style: .cancel)
    }
    
    func addDoneAction() {
        self.addAction(doneAction() )
    }
    
    func addCancelAction() {
        self.addAction(cancelAction())
    }
    
    
    var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    class func defaultActionSheet(actions: UIAlertAction...) -> UIAlertController{
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction( UIAlertAction(title: "Cancel", style: .cancel) )
        for action in actions {
            alertController.addAction(action)
        }
        
        return alertController
    }
    
    func set(vc: UIViewController, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        setValue(vc, forKey: "contentViewController")
        
        if let height = height {
            vc.preferredContentSize.height = height
            preferredContentSize.height = height
        }
        
    }
    
    class func showDeleteWorkoutFromHistoryAlert(deleteHandler: @escaping () -> Void ) {
        
        let alert = UIAlertController(title: "Delete Workout From History?",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { action in deleteHandler() } ))
        
        alert.show()
        
    }
    
    
    
}

