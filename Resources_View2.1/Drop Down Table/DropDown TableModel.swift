//
//  DropDownTableViewDataSource.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/17/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol TableDataPopulator {
    
    func numberOfSections() -> Int 
    
    func numberOfItems(in section: Int) -> Int
    
    func configureCell(at indexPath: IndexPath, for tableView: UITableView) -> UITableViewCell
    
    func configure(header: CollapsibleHeader, at section: Int)
    
}


public protocol DropDownTableModel {
    
    var collapsedSections: [Bool] { get set }
    
    //Mark: return the number of items in uncollapsed state
    func numberOfItems(in section: Int) -> Int
    
    func setAllSectionsToCollapsed()
    
}

public extension DropDownTableModel {
    
    func numberOfSections() -> Int {
        return collapsedSections.count // collapsed sections and dataSource should be equal
    }
    
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return collapsedSections[section] ? 0 : numberOfItems(in: section)
    }
    
}
