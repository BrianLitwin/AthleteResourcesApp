//
//  MasterVC.swift
//  UI Templates
//
//  Created by B_Litwin on 1/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//
//1 . create variable
//2 . name bundle identifier 
//3 . put in childVCs 
//4 . change name in Name protocol

import UIKit


public protocol ContainerViewController: SideBarDelegate {
    func childVCs() -> [UIViewController]
    func setupViewControllerFrame(for viewController: UIViewController)
}

public extension ContainerViewController where Self: UIViewController {
    
    func changeViewController(index: Int) {
        
        let viewController = childVCs()[index]
        
        if let alertController = viewController as? UIAlertController {
            alertController.show()
            return 
        }
        
        reloadViewControllerIfNeeded(vc: viewController)
        
        add(asChildViewController: viewController)
        
    }
    
    //
    //might be able to put this in viewDidAppear instead 
    //
    
    private func reloadViewControllerIfNeeded(vc: UIViewController) {
        guard let viewController = vc as? ReloadableView else { return }
        viewController.loadModelOffTheMainQueueIfNeeded(spinnerFrame: view.frame)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        if !self.childViewControllers.isEmpty {
            let currentVC = self.childViewControllers[0]
            remove(asChildViewController: currentVC)
        }
        
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        setupViewControllerFrame(for: viewController)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    //Mark: SideBarDelegate Adoption 
    
    var itemCount: Int {
        return childVCs().count
    }
    
    func header(for indexPath: IndexPath) -> String {
        guard let childVC = childVCs()[indexPath.row] as? ChildVC else { return "" }
        return childVC.name
    }
    
    func icon(for indexPath: IndexPath) -> UIImage? {
        guard let childVC = childVCs()[indexPath.row] as? ChildVC else { return nil }
        return childVC.menuBarImage 
    }
    
    func changeViewController(indexPath: IndexPath) {
        changeViewController(index: indexPath.row)
    }

}























