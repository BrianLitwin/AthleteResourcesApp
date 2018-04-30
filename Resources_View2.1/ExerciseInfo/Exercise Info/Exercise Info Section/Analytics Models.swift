//
//  Analytics Models.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/2/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


//
// the idea is to be able to access the analytics model
// from different places, e.g., from a uiAlert in the workout
// or from the exerciseListTableViewController
// Update: Can't get this to work: i.e. can't put a tableViewController in a UIAlertController and then use it elsewhere 
//



//
//conform to this protocol to populate the ExerciseAnalytics TableViewController
//

public protocol ExerciseInfoModel: ReloadableModel {
    var sections: [ExerciseAnalyticsSectionUIPopulator] { get }
}

//
// each section should conform to following to configure the cells
//

public protocol ParentExerciseInfoModel {
    func configureCell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}

//
//
//


public protocol ExerciseAnalyticsSectionUIPopulator {
    var sectionTitle: String { get }
    var uiPopulator: ExerciseAnalyticsCellSetupHandler { get }
    //func registerCells(for tableView: UITableView)
    //func returnCell(at indexPath: IndexPath, for tableView: UITableView) -> UITableViewCell
    func rowCount() -> Int
}



public extension ExerciseAnalyticsSectionUIPopulator {
    
    func registerCells(for tableView: UITableView) {
        uiPopulator.registerCells(for: tableView)
    }
    
    func returnCell(at indexPath: IndexPath, for tableView: UITableView) -> UITableViewCell {
        return uiPopulator.returnCell(at: indexPath, for: tableView)
    }
    
}


public class ExerciseAnalyticsCellSetupHandler {
    
    //
    // Hand this class a Cell Type and reuse ID and don't have to worry
    // about registering or returning cells for individual classes
    //
    
    let cellTypes: [TableViewCellinfo]
    
    var parentModel: ParentExerciseInfoModel?
    
    var cellsRegistered = false
    
    public func registerCells(for tableView: UITableView) {
        cellTypes.forEach({ $0.register(with: tableView) })
    }
    
    init(cellTypes: [TableViewCellinfo]) {
        self.cellTypes = cellTypes
    }
    
    public func returnCell(at indexPath: IndexPath, for tableView: UITableView) -> UITableViewCell {
        
        if !cellsRegistered {
            registerCells(for: tableView)
            cellsRegistered = true
        }
    
        return parentModel?.configureCell(tableView: tableView, at: indexPath) ?? UITableViewCell()
    }
    
}

struct TableViewCellinfo {
    let type: UITableViewCell.Type
    let reuseID: String
    func register(with tv: UITableView) {
        tv.register(type, forCellReuseIdentifier: reuseID)
    }
}










