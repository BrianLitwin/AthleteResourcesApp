//
//  Edit ExerciseMetric Keyboard.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class EditExerciseMetricKeyboard: KeyboardView {
    
    var nonStandardButtons: [KeyboardButtonType: KeyboardButton] = [:]
    
    var modelUpdater: ModelUpdater? {
        
        didSet {
            
            modelUpdater?.nonstandardKeyboardButtons = [
                KeyboardButtonType.bodyweight: bodyweightBtn,
                KeyboardButtonType.addMissedRep: addMissedRepBtn
            ]
            
        }
    }
    
    lazy var bodyweightBtn: KeyboardButton = {
        let btn = KeyboardButton(btnTap: btnTapAction(type: .bodyweight ) )
        btn.title = "BW"
        return btn
    }()
    
    lazy var addMissedRepBtn: KeyboardButton = {
        var btn = KeyboardButton(btnTap: btnTapAction(type: .addMissedRep) )
        btn.title = "+ Missed Rep"
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.shrinkTextToFit()
        btn.titleLabel?.frame =
            CGRect(x: 2, y: 0, width: btn.frame.width - 4, height: btn.frame.height)
        return btn
    }()
    
    override init() {
        super.init()
        
        let dummyButton = UIButton()
        dummyButton.backgroundColor = UIColor.clear 
        
        let row = KeyboardRow(arrangedSubviews: [bodyweightBtn, addMissedRepBtn, dummyButton])
        
        guard let masterStackView = subviews[1] as? MasterKeyboardStackView else { return }
        
        masterStackView.addArrangedSubview(row)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
