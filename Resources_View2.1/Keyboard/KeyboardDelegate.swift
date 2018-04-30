//
//  KeyboardDelegate.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol KeyboardDelegate {
    var activeTextField: UITextField? { get }
    func editTextField(editType: KeyboardButtonType)
    
    //effect of this is: save something, b/c resignLastResponder() triggers a database save
    func resignLastResponder()
}


