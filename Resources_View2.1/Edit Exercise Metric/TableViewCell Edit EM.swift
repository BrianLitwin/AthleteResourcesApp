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
    
    lazy var textfieldLabel: UILabel = {
       return UILabel()
    }()
    
    var textField: TextField?
    
    func setupTextField(with textField: TextField) {
        self.textField = textField
        centerRight(textField, width: 150, trailingConstraint: 12)
    }
    
    static var reuseID = "cell"
    
    override func setupViews() {
        centerLeft(textfieldLabel)
    }

    
}
