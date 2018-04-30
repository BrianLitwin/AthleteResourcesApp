//
//  UIView Controller.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    func getWindowManagerFromNavControl() -> WindowManager? {
        guard let navController = self.navigationController as? NavigationController else { return nil }
        return navController.windowManager
    }
    
}
