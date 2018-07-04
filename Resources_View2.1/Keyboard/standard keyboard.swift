//
//  Keyboard.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class KeyboardView: UIView, DoneButtonDelegate {
    
    var delegate: KeyboardDelegate? 
    
    var doneBtnTap: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        let row1 = KeyboardRow()
        let row2 = KeyboardRow()
        let row3 = KeyboardRow()
        let row4 = KeyboardRow()
        
        for i in 1...9 {
            
            let button = KeyboardButton(btnTap: btnTapAction(type: .number(i) ) )
            button.title = String(i)
            
            switch i {
            case 1...3: row1.addArrangedSubview(button)
            case 4...6: row2.addArrangedSubview(button)
            case 7...9: row3.addArrangedSubview(button)
            default: break
                
            }
        }
        
        let decimal = KeyboardButton(btnTap: btnTapAction(type: .decimal) )
        decimal.title = "."
        decimal.isPrimaryColor = false
        
        let zeroButton = KeyboardButton(btnTap: btnTapAction(type: .number(0) ) )
        zeroButton.title = "0"
        
        let backspace = KeyboardButton(btnTap: btnTapAction(type: .backspace) )
        let image = #imageLiteral(resourceName: "backspace").withRenderingMode(.alwaysTemplate)
        backspace.setImage(image, for: .normal)
        backspace.tintColor = UIColor.black
        backspace.isPrimaryColor = false 
        
        row4.addArrangedSubviews(decimal, zeroButton, backspace)
        
        let masterStackView = MasterKeyboardStackView(rows: row1, row2, row3, row4)
        
        //not sure doneBtn is active
        let doneBtn = KeyboardDoneButton(delegate: self)
        let doneBtnView = UIView()
        doneBtnView.backgroundColor = UIColor.clear
        doneBtnView.addSubview(doneBtn)
        doneBtnView.addConstraintsWithFormat("H:[v0(60)]|", views: doneBtn)
        doneBtnView.addConstraintsWithFormat("V:|[v0(40)]|", views: doneBtn)
        
        addSubview(doneBtnView)
        addSubview(masterStackView)
        addConstraintsWithFormat("H:|[v0]|", views: doneBtnView)
        addConstraintsWithFormat("H:|[v0]|", views: masterStackView)
        addConstraintsWithFormat("V:|[v0(40)]-1.5-[v1]-1.5-|", views: doneBtnView, masterStackView)
    }
    
    func btnTapAction(type: KeyboardButtonType) -> () -> Void {
        func btnTap() { delegate?.editTextField(editType: type) }
        return btnTap
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

