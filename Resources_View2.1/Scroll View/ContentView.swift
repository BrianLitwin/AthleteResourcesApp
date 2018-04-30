//
//  ContentView.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class ScrollViewContentView: UIView, LayoutGuide {
    
    func updateSubviewFrames() {
        
        for (i, subview) in subviews.enumerated() {
            if i == 0 {
                subview.frame.origin.y = 0
            } else {
                let prevView = subviews[i-1]
                subview.frame.origin.y = prevView.frame.maxY
            }
        }
        
        if let lastView = subviews.last {
            frame.size.height = lastView.frame.maxY
        } else {
            frame.size.height = 0
        }
        
    }
    
}



