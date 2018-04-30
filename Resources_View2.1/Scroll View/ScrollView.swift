//
//  ScrollView.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class ScrollView: UIScrollView {
    
    let headerHeight: CGFloat = 44
    
    let footerHeight: CGFloat = 44
    
    lazy public var header: ScrollViewHeader = {
        
        let headerFrame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.width,
                                 height: headerHeight)
        
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
        
        let footerFrame = CGRect(x: 0,
                                 y: contentView.frame.maxY,
                                 width: frame.width,
                                 height: 44)
        
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
        contentView.updateSubviewFrames()
        footer.frame.origin.y = contentView.frame.maxY
        //add 100 for cushion if view is set under navigation bar?
        contentSize = CGSize(width: frame.width, height: footer.frame.maxY + 100)
    }
    
    func insertView(_ view: UIView, at index: Int) {
        contentView.insertSubview(view, at: index)
        view.frame.origin.y = index == 0 ? 0 : contentView.subviews[index-1].frame.maxY
        updateFrames()
    }
    
    func removeView(_ view: UIView) {
        view.removeFromSuperview()
        updateFrames()
    }
    
    public func removeAllSubviewsFromContentView() {
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        updateFrames()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol SetScrollViewFrames {
    func setFrames()
}





