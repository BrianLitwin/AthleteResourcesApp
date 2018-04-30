//
//  Text Field Manager.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class EditExerciseMetricTextFieldManager: KeyboardDelegate {

    let textFields: [UITextField]
    
    init(textFields: [UITextField]) {
        self.textFields = textFields 
    }
    
    var activeTextField: UITextField? {
        for textField in textFields {
            if textField.isFirstResponder {
                return textField
            }
        }
        return nil 
    }
    
    func editTextField(editType: KeyboardButtonType) {
        guard activeTextField != nil else { return }
        editType.editTextField(activeTextField!)
    }
    
    func resignLastResponder() {
        activeTextField?.resignFirstResponder()
    }

}

