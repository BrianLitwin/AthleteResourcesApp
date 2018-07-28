//
//  ExercisePickerModel.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/19/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public protocol ExerciseCellData {
    var name: String? { get }
    var variation: String? { get }
    var categoryName: String { get }
}

public protocol ExerciseHeaderData {
    var name: String? { get }
    var variation: String? { get }
}


public protocol ExerciseTableViewModel: DropDownTableModel {
    var data: [[ExerciseCellData]] { get set }
}

public extension ExerciseTableViewModel {
    
    func numberOfSections() -> Int {
        return data.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return data[section].count
    }
    
    func configureCell(at indexPath: IndexPath, for tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCell.reuseID,
                                                 for: indexPath) as! ExerciseCell

        let exercise = data[indexPath.section][indexPath.row]
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = exercise.variation
        return cell
        
    }
    
    public func configure(header: CollapsibleHeader, at section: Int) {
        
        //not an ideal implementation
        let sectionNumber = section
        guard let pickerHeader = header as? ExercisePickerHeader else { return }
        let section = data[section]
        guard !section.isEmpty else { return  }
        pickerHeader.categoryLabel.text = section[0].categoryName
        pickerHeader.setCollapsed(collapsedSections[sectionNumber])
    }
}
















