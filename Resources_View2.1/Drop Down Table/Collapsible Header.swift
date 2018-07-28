//
//  Collapsible Header.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/17/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol CollapsibleHeaderDelegate: class {
    func toggleSection(_ section: Int, header: CollapsibleHeader)
}



public class CollapsibleHeader: BaseTableViewHeaderFooterView {
    weak var delegate: CollapsibleHeaderDelegate?
    var section: Int = 0
    
    override func setupViews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped) ) )
    }
    
    @objc func selfTapped() {
        delegate?.toggleSection(section, header: self)
    }
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}
