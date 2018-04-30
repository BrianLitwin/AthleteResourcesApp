//
//  UpdateExercise NVI TableViewCell.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class UpdateExerciseNVITableViewCell: BaseTableViewCell, UITextFieldDelegate {
    
    var saveText: ((String) -> Void)?
    
    static var reuseID = "NIVcell"
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.tintColor = UIColor.brightTurquoise()
        textField.delegate = self
        textField.textColor = UIColor.groupedTableText()
        return textField
    }()
    
    override func setupViews() {
        addSubview(textField)
        centerLeft(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveText?(textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
    
    func setTextfieldPlaceholder(_ text: String) {
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes:[NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    }
    
    deinit {
        print("textfielD De-inited")
    }
    
}
