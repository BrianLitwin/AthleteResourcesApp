//
//  Navigation Controller.swift
//  UI Templates
//
//  Created by B_Litwin on 1/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class NavigationController: UINavigationController {
    
    public lazy var windowManager: WindowManager = {
        return WindowManager()
    }()
    
    override public func viewDidLoad() {
        configureRightBarButton()
        self.navigationBar.isTranslucent = false
        UINavigationBar.appearance().barTintColor = Colors.navBarBgTint
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : Colors.navBarTitle]
    }
    
    func configureRightBarButton() {
        let image = #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate)
        let rightBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showMenu))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationBar.items = [navigationItem]
        rightBarButton.tintColor = Colors.navbarBtnTint 
    }
    
    @objc func showMenu() {
        guard let sideBarDelegate = childViewControllers[0] as? SideBarDelegate else { return }
        windowManager.show(.sideBar(delegate: sideBarDelegate) )
    }

}
