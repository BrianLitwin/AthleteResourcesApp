//
//  Exercise info Helpers.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class CircleGraphicView: BaseView {
    var outline1 = UIView()
    
    override func setupViews() {
        addSubview(outline1)
        outline1.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        outline1.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}

struct ExerciseInfoMenuCellSize {
    
    var height: CGFloat = 90
    var width: CGFloat {
        return height - labelHeight - sideMargin
    }
    var sideMargin: CGFloat = 8
    var labelHeight: CGFloat = 16
    var boxSize: CGFloat {
        return width - (sideMargin * 2)
    }
    
}
