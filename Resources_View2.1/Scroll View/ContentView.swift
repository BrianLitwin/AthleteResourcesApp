//
//  ContentView.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class ScrollViewContentView: UIView, LayoutGuide {
    
    func updateSubviewFrames(sectionSpacing: CGFloat, widthOfSuperview: CGFloat) {
        
        for (index, subview) in subviews.enumerated() {
            if index == 0 {
                subview.frame =
                    ScrollView.calculateFrameOfSubview(prevViewMaxY: nil,
                                                       widthOfSuperview: widthOfSuperview,
                                                       height: subview.frame.height,
                                                       sectionSpacing: sectionSpacing)
            } else {
                let prevView = subviews[index - 1]
                subview.frame =
                    ScrollView.calculateFrameOfSubview(prevViewMaxY: prevView.frame.maxY,
                                                       widthOfSuperview: widthOfSuperview,
                                                       height: subview.frame.height,
                                                       sectionSpacing: sectionSpacing)
            }
        }
        
        if let lastView = subviews.last {
            frame.size.height = lastView.frame.maxY
        } else {
            frame.size.height = 0
        }
        
    }
    
}



















