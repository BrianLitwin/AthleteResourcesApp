//
//  ExerciseListCell.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class ExerciseListCell: TableViewCellWithSubtitle {

    static var reuseID = "ExListCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func setup(with exercise: ExerciseListItem) {
        textLabel?.text = exercise.name
        detailTextLabel?.text = exercise.variation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

