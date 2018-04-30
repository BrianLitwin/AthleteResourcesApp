//
//  GeneralInfo.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/8/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public class ExGeneralInfoSection: ExerciseAnalyticsSectionUIPopulator, ParentExerciseInfoModel {
    
    public enum GeneralInfo {
        case name(String)
        case variation(String)
        case edit((()->Void)?)
    }
    
    public var sectionTitle: String = "General Info"
    
    public var uiPopulator: ExerciseAnalyticsCellSetupHandler
    
    var info: [GeneralInfo] = []
    
    let cellID = "Cell"
    
    let editCellID = "EditCell"
    
    public init(info: [GeneralInfo]) {
        self.info = info
        
        uiPopulator = ExerciseAnalyticsCellSetupHandler(cellTypes: [
            TableViewCellinfo(type: UITableViewCell.self, reuseID: cellID),
            TableViewCellinfo(type: UITableViewCellWithTapGesture.self, reuseID: editCellID),
        ])
        
        uiPopulator.parentModel = self
    }
    
    public func rowCount() -> Int {
        return info.count
    }
    
    public func configureCell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        let cellInfo = info[indexPath.row]
        
        var textLabel = ""
        
        switch cellInfo {
            
        case .edit(let editExercise):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: editCellID, for: indexPath) as! UITableViewCellWithTapGesture
            cell.isUserInteractionEnabled = true
            cell.cellTap = editExercise
            return cell
            
        
        case .name(let name):           textLabel = name
        case .variation(let variation): textLabel = variation
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = textLabel
        cell.isUserInteractionEnabled = false
        return cell
        
    }
    
}

class UITableViewCellWithTapGesture: BaseTableViewCell {
    
    var cellTap: (()->Void)?
    
    override func setupViews() {
        textLabel?.text = "Edit"
        accessoryType = .disclosureIndicator
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGestureRec)
    }
    
    @objc func cellTapped() {
        cellTap?()
    }
    
}


