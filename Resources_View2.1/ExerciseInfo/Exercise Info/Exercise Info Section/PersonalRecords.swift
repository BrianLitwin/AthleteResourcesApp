//
//  PersonalRecords.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/8/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit



public class PersonalRecordsSection: ExerciseAnalyticsSectionUIPopulator, ParentExerciseInfoModel {
    
    public var sectionTitle = "Personal Records"
    
    var rows: [PersonalRecordsRowData] = []
    
    public let uiPopulator: ExerciseAnalyticsCellSetupHandler
    
    public init(rows: [PersonalRecordsRowData]) {
        let celltypes = [TableViewCellinfo(type: TableViewCellWithRightDetail.self, reuseID: "rightCell")]
        uiPopulator = ExerciseAnalyticsCellSetupHandler(cellTypes: celltypes)
        uiPopulator.parentModel = self
        self.rows = rows
    }
    
    public func rowCount() -> Int {
        return rows.count
    }
    
    public func configureCell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath) as! TableViewCellWithRightDetail
        let row = rows[indexPath.row]
        cell.textLabel?.text = row.displayString
        cell.detailTextLabel?.text = row.date
        return cell
    }
    
    public class PersonalRecordsRowData {
        
        let displayString: String
        
        let date: String
        
        public init(displayString: String, date: String) {
            self.displayString = displayString
            self.date = date
        }
    }
}


