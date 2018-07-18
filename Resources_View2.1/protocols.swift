//
//  ViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/19/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData

public protocol Resignable {
    var resignSelf: (() -> Void)? { get }
}

public protocol ChildVC {
    var name: String { get }
    var menuBarImage: UIImage { get }
}



public protocol UpdateableModel {
    func update(with update: SequenceUIHandler.UIUpdate, at indexPath: IndexPath)
}








