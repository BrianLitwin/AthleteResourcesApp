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
    let accessoryLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //configure image view
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "arrow_right").withRenderingMode(.alwaysTemplate)
        contentView.addSubview(imageView)
        imageView.tintColor = Colors.ExercisePicker.arrow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        //configure label to count workouts used
        contentView.addSubview(accessoryLabel)
        accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
        accessoryLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -5).isActive = true
        accessoryLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        accessoryLabel.font = UIFont.systemFont(ofSize: 14)
        accessoryLabel.textColor = imageView.tintColor
    }

    func setup(with exercise: ExerciseListItem) {
        textLabel?.text = exercise.name
        detailTextLabel?.text = exercise.variation
        accessoryLabel.text = String(exercise.workoutsUsed)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

