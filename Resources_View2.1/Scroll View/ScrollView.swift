//
//  ScrollView.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class ScrollView: UIScrollView {
    
    static let sectionSpacing: CGFloat = 5
    
    lazy public var header: ScrollViewHeader = {
        let headerFrame = ScrollView.calculateFrameOfSubview(prevViewMaxY: nil,
                                                             widthOfSuperview: frame.width,
                                                             height: 44,
                                                             sectionSpacing: ScrollView.sectionSpacing)
        
        return ScrollViewHeader(frame: headerFrame)
    }()
    
    lazy public var contentView: ScrollViewContentView = {
        let contentViewFrame = CGRect(x: 0,
                                      y: header.frame.maxY,
                                      width: frame.width,
                                      height: 0)
        
        return ScrollViewContentView(frame: contentViewFrame)
    }()
    
    lazy var footer: ScrollViewFooter = {
        let footerFrame = ScrollView.calculateFrameOfSubview(prevViewMaxY: contentView.frame.maxY,
                                                             widthOfSuperview: frame.width,
                                                             height: 44,
                                                             sectionSpacing: ScrollView.sectionSpacing)
        
        return ScrollViewFooter(frame: footerFrame)
    }()
    
    public init(frame: CGRect, footerBtnTap: @escaping () -> Void ) {
        super.init(frame: frame)
        insertSubview(header, at: 0)
        insertSubview(contentView, at: 1)
        insertSubview(footer, at: 2)
        footer.btnTap = footerBtnTap
    }
    
    func updateFrames() {
        contentView.updateSubviewFrames(sectionSpacing: ScrollView.sectionSpacing,
                                        widthOfSuperview: frame.width)
        
        footer.frame =
            ScrollView.calculateFrameOfSubview(prevViewMaxY:contentView.frame.maxY,
                                               widthOfSuperview: frame.width,
                                               height: footer.frame.height,
                                               sectionSpacing: ScrollView.sectionSpacing)
        
        //add 100 for cushion if view is set under navigation bar?
        contentSize = CGSize(width: frame.width, height: footer.frame.maxY + 100)
    }
    
    func insertView(_ view: UIView, at index: Int, updateFrames: Bool = true) {
        contentView.insertSubview(view, at: index)
        view.frame.origin.y = index == 0 ? 0 : contentView.subviews[index-1].frame.maxY
        if updateFrames { self.updateFrames() }
    }
    
    func removeView(_ view: UIView) {
        view.removeFromSuperview()
        updateFrames()
    }
    
    public func removeAllSubviewsFromContentView() {
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        updateFrames()
    }
    
    static func calculateFrameOfSubview(prevViewMaxY: CGFloat?, widthOfSuperview: CGFloat, height: CGFloat, sectionSpacing: CGFloat) -> CGRect {
        var y: CGFloat
        
        if let maxY = prevViewMaxY {
            y = maxY + sectionSpacing
        } else {
            y = sectionSpacing
        }
   
        let frame = CGRect(x: sectionSpacing,
                           y: y,
                           width: widthOfSuperview - (sectionSpacing * 2),
                           height: height)
        
        return frame
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol SetScrollViewFrames {
    func setFrames()
}





