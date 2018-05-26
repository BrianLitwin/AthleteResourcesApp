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
        UINavigationBar.appearance().tintColor = UIColor.groupedTableText()
        navigationBar.backgroundColor = UIColor.lighterBlack()
        configureRightBarButton()
        setupColors()
        self.navigationBar.isTranslucent = false 
    }
    
    func configureRightBarButton() {
        let image = #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate)
        let rightBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showMenu))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationBar.items = [navigationItem]
        rightBarButton.tintColor = UIColor.brightTurquoise()
    }
    
    func setupColors() {
        UINavigationBar.appearance().tintColor = UIColor.groupedTableText()
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.groupedTableText()
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    @objc func showMenu() {
        guard let sideBarDelegate = childViewControllers[0] as? SideBarDelegate else { return }
        windowManager.show(.sideBar(delegate: sideBarDelegate) )
    }

}
