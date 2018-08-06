//
//  Test Exercise Picker.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class EditExerciseMetricView: UIView {
    
    var doneBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Colors.EditExerciseMetricPopup.doneBtnTint , for: .normal)
        btn.setTitle("Done", for: .normal)
        return btn
    }()
    
    let doneBtnTap: ()->Void
    
    init(keyboard: KeyboardView,
         tableView: ExerciseMetricEditingTableView,
         width: CGFloat,
         keyboardHeight: CGFloat,
         doneBtnTap: @escaping ()->Void
         )
    {
        self.doneBtnTap = doneBtnTap
        super.init(frame: .zero)
        backgroundColor = UIColor.white 
        addSubview(keyboard)
        addSubview(tableView)
        let tableHeight = CGFloat(tableView.textFields.count) * tableView.rowHeight + 20
        let height = keyboardHeight + tableHeight
        frame.size = CGSize(width: width, height: height + 20)
        
        tableView.frame = CGRect(x: 0,
                                 y: 20,
                                 width: frame.width,
                                 height: tableHeight)

        keyboard.frame = CGRect(x: 0,
                                y: tableView.frame.maxY,
                                width: frame.width,
                                height: keyboardHeight)
        
        addSubview(doneBtn)
        let keyboardBtnWidth = keyboard.frame.width / 3
        let doneBtnCenterX = keyboardBtnWidth * 2
        let doneBtnCenterY = tableView.frame.maxY
        let doneBtnOrigin = CGPoint(x: doneBtnCenterX, y: doneBtnCenterY)
        doneBtn.frame = CGRect(origin: doneBtnOrigin, size: CGSize(width: keyboardBtnWidth, height: 40))
        doneBtn.addTarget(self, action: #selector(doneBtnTapped), for: .touchDown)
    }
    
    @objc func doneBtnTapped() {
        doneBtnTap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
