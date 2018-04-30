//
//  ExerciseHistory.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public class ExerciseHistorySection: ExerciseAnalyticsSectionUIPopulator, ParentExerciseInfoModel {
    
    public let sectionTitle: String
    
    public var exerciseMetrics: [String]
    
    public let uiPopulator: ExerciseAnalyticsCellSetupHandler
    
    public func rowCount() -> Int {
        return exerciseMetrics.count
    }
    
    public func configureCell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normCell", for: indexPath)
        cell.textLabel?.text = exerciseMetrics[indexPath.row]
        return cell
    }
    
    public init(date: Date, exerciseMetrics: [String]) {
        sectionTitle = date.monthDayYear
        self.exerciseMetrics = exerciseMetrics
        uiPopulator = ExerciseAnalyticsCellSetupHandler(cellTypes:
            [TableViewCellinfo(type: UITableViewCell.self, reuseID: "normCell")]
        )
        
        uiPopulator.parentModel = self
    }
    
}
