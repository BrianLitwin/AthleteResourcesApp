//
//  Compound Creator Cell.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class CompoundExerciseCreatorCell: ExerciseCell, LayoutGuide {

    weak var delegate: CompoundExerciseCreatorModel?
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.shrinkTextToFit()
        return label
    }()
    
    lazy var stepBackButton: UIButton = {
        let button = ButtonWithEnabledConfiguration(enabledTextColor: .green,
                                                    disabledTextColor: .blue,
                                                    isHighlightedColor: .orange)
        
        let image = #imageLiteral(resourceName: "backspace").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        return button
    }()
    
    override func setupViews() {
        
        centerLeft(leftLabel)
        centerRight(stepBackButton)
        leftLabel.trailingAnchor.constraint(equalTo: stepBackButton.leadingAnchor, constant: -15).isActive = true
        stepBackButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        stepBackButton.addTarget(self, action: #selector(stepBackBtnPressed), for: .touchDown)
        
    }
    
    @objc func stepBackBtnPressed() {
        delegate?.stepBack()
    }
    
}

class ButtonWithEnabledConfiguration: UIButton {
    
    var enabledTextColor: UIColor?
    
    var disabledTextColor: UIColor?
    
    var isHighlightedColor: UIColor?
    
    init(enabledTextColor: UIColor, disabledTextColor: UIColor, isHighlightedColor: UIColor) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            let titleColor = isEnabled ? enabledTextColor : disabledTextColor
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            let titleColor = isHighlighted ? isHighlightedColor : enabledTextColor
            setTitleColor(titleColor, for: .normal)
        }
    }
    
}












