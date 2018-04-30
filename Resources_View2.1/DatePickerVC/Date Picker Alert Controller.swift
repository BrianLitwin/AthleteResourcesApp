//
//  Date Picker Alert Controller.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class DatePickerAlertController: UIAlertController {

    lazy var viewController = DatePickerViewController()
    
    public weak var delegate: SavesDate?
    
    public override func viewDidLoad() {
        title = "Change Workout Date"
        set(vc: viewController, height: 300)
        addAction(UIAlertAction(title: "Save", style: .default) {
            [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.save(date: strongSelf.viewController.datePicker.date)
        })
        addAction(UIAlertAction(title: "cancel", style: .cancel))
    }
    
    public func configure(with date: Date, delegate: SavesDate) {
        self.delegate = delegate
        viewController.datePicker.date = date
        viewController.datePicker.datePickerMode = .date
    }
    
}

public protocol SavesDate: class {
    func save(date: Date)
}
