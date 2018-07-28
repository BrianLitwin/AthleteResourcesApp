//
//  TableViewCell Edit EM.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class EditExerciseMetricTableViewCell: BaseTableViewCell {
    typealias TextField = EditExerciseMetricTextField
    let label = UILabel()
    var textField: TextField?
    
    func setupTextField(with textField: TextField) {
        self.textField = textField
        //configure textfield
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        //set labels trailing constraint
        label.trailingAnchor.constraint(lessThanOrEqualTo: textField.leadingAnchor, constant: -15).isActive = true
    }
    
    static var reuseID = "cell"
    
    override func setupViews() {
        //configure text label
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.adjustsFontSizeToFitWidth = true 
    }
}
