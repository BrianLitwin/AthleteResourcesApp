//
//  Test Exercise Picker.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class EditExerciseMetricView: UIView {
    
    init(keyboard: KeyboardView,
         tableView: ExerciseMetricEditingTableView,
         width: CGFloat,
         keyboardHeight: CGFloat)
    {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.white 
        addSubview(keyboard)
        addSubview(tableView)
        
        let tableHeight = CGFloat(tableView.textFields.count) * tableView.rowHeight + 70
        
        let height = keyboardHeight + tableHeight
        
        frame.size = CGSize(width: width, height: height)
        
        tableView.frame = CGRect(x: 0,
                                               y: 0,
                                               width: frame.width,
                                               height: tableHeight)
        
        keyboard.frame = CGRect(x: 0,
                                y: tableView.frame.maxY,
                                width: frame.width,
                                height: keyboardHeight)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
