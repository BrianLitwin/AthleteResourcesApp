//
//  RepMaxes.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/8/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public protocol ContainsRepMaxInfo {
    var repMaxes: [Double] { get }
    var oneRepMax: Double  { get }
}

public class ExerciseRepMaxesSection: ExerciseAnalyticsSectionUIPopulator, ParentExerciseInfoModel {
    
    public var sectionTitle: String = "Rep Max Chart"
    
    public var uiPopulator: ExerciseAnalyticsCellSetupHandler
    
    let data: ContainsRepMaxInfo
    
    let percentages: [Double] = [100, 90, 80, 70, 60, 50, 40, 30, 20, 10]
    
    public func rowCount() -> Int {
        return data.repMaxes.count
    }
    
    public func configureCell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! RepMaxTableViewCell
        let repMax = String(Int(data.repMaxes[indexPath.row]))
        let reps = String(indexPath.row + 1)
        let percentage = percentages[indexPath.row]
 
        cell.repMax.text = repMax
        
        cell.repMaxLabel.text = reps + "RM:"
        
        cell.percentage.text = String((data.oneRepMax * (percentage/100)).rounded(toPlaces: 2))
        
        cell.percentageLabel.text = String(Int(percentage)) + "%:"
        
        return cell
        
    }
    
    let reuseID = "repMaxcell"
    
    public init(data: ContainsRepMaxInfo) {
        self.data = data
        self.uiPopulator = ExerciseAnalyticsCellSetupHandler(cellTypes: [
            TableViewCellinfo(type: RepMaxTableViewCell.self, reuseID: reuseID)
        ])
        self.uiPopulator.parentModel = self 
    }
    
}


private class RepMaxTableViewCell: BaseTableViewCell {
    
    var repMax: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.brightTurquoise()
        return label
    }()
    
    var repMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.groupedTableText()
        label.textAlignment = .left
        return label
    }()
    
    var percentage: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.brightTurquoise()
        return label
    }()
    
    var percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.groupedTableText()
        label.textAlignment = .left
        return label
    }()
    
    override func setupViews() {
        
        addSubview(repMax)
        addSubview(repMaxLabel)
        addSubview(percentage)
        addSubview(percentageLabel)
        
        let columnWidth = frame.width / 4
        
        repMax.translatesAutoresizingMaskIntoConstraints = false
        repMax.leftAnchor.constraint(equalTo: centerXAnchor, constant: -columnWidth + 5).isActive = true
        repMax.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        repMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        repMaxLabel.rightAnchor.constraint(equalTo: centerXAnchor, constant: -columnWidth).isActive = true
        repMaxLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        percentage.translatesAutoresizingMaskIntoConstraints = false
        percentage.leftAnchor.constraint(equalTo: centerXAnchor, constant: columnWidth + 5).isActive = true
        percentage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.rightAnchor.constraint(equalTo: centerXAnchor, constant: columnWidth).isActive = true
        percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
}










