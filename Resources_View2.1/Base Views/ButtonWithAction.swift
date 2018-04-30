//
//  ButtonWithAction.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class ButtonWithAction: UIButton {

    let btnTap: (() -> Void)?
    
    init(btnTap: (() -> Void)? ) {
        self.btnTap = btnTap
        super.init(frame: .zero)
        addTarget(self, action: #selector(btnTapped), for: .touchDown)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnTapped() {
        btnTap?()
    }

}
