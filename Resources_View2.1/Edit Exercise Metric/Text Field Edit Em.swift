//
//  Text Field Edit Em.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public enum TextFieldEditingState {
    case beginning
    case ending
}


public class EditExerciseMetricTextField: UITextField, UITextFieldDelegate {
    
    public var setTextForEditingState: ((TextFieldEditingState) -> String)?
    public var saveValue: ((String) -> Void)?
    public var underline: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        inputView = UIView()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setBorder(highlighted: true)
        text = setTextForEditingState?(.beginning)
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        setBorder(highlighted: false)
        text = setTextForEditingState?(.ending)
        saveValue?(text ?? "")
    }
    
    func setBorder(highlighted: Bool) {
        underline?.backgroundColor = highlighted ? Colors.Textfield.underlineHighlight : Colors.Textfield.underlineDefault
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
