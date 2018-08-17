//
//  Reloadable UIViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/3/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol ReloadableModel {
    var needsReload: Bool { get }
    func loadModel()
}

public protocol ReloadableView {
    var reloadableModel: ReloadableModel? { get }
    func loadModelOffTheMainQueueIfNeeded(spinnerFrame: CGRect)
    func reloadView()
}

public extension ReloadableView where Self: UIViewController {
    
    func getActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.backgroundColor = UIColor(white: 0, alpha: 0.5)
        spinner.color = UIColor.black
        spinner.hidesWhenStopped = true
        return spinner
    }
    
    func loadModelOffTheMainQueueIfNeeded(spinnerFrame: CGRect) {
        guard let model = reloadableModel else { return }
        
        if model.needsReload {
            let spinner = getActivityIndicator()
            spinner.frame = spinnerFrame
            view.addSubview(spinner)
            spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                model.loadModel()
                
                //for _ in 0...100_000_000 {
                    //let x = 5 + 1
                //}
                
                DispatchQueue.main.async { [weak self] in
                    spinner.removeFromSuperview()
                    self?.reloadView()
                }
            }
        }
    }
}


public extension ReloadableView where Self: UITableViewController {
    
    public func reloadView() {
        tableView.reloadData()
    }
}






















