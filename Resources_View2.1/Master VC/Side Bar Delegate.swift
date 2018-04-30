//
//  MasterVCDelegate.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/13/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol SideBarDelegate {
    var itemCount: Int { get }
    func header(for indexPath: IndexPath) -> String
    func icon(for indexPath: IndexPath) -> UIImage? 
    func changeViewController(indexPath: IndexPath)
}


