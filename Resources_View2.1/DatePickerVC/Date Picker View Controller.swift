//
//  Date Picker View Controller.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class DatePickerViewController: UIViewController {

    public let datePicker = UIDatePicker()
    
    public override func viewDidLoad() {
        view.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.datePickerMode = .date
    }
    
}


