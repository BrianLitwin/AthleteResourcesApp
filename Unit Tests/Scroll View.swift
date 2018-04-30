//
//  Scroll View.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 1/29/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources_View2_1

class Scroll_View: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testScrollview() {
        
        let scrollView = ScrollView(frame: .zero, footerBtnTap: {} )
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let view3 = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        //append view
        scrollView.insertView(view, at: 0)
        
        XCTAssert( scrollView.contentView.frame.maxY == scrollView.header.frame.maxY + 40 )
        XCTAssert( scrollView.footer.frame.minY == scrollView.contentView.frame.maxY )
        XCTAssert( scrollView.contentView.subviews.count == 1)
        
        //append view
        scrollView.insertView(view1, at: 1)
        
        XCTAssert( scrollView.contentView.frame.minY == scrollView.header.frame.maxY )
        XCTAssert( scrollView.contentView.frame.maxY == scrollView.header.frame.maxY + 80 )
        XCTAssert( scrollView.footer.frame.minY == scrollView.contentView.frame.maxY )
        XCTAssert( scrollView.contentView.subviews.count == 2 )
        XCTAssert( scrollView.contentView.frame.height == 80 )
        
        //remove top view
        scrollView.removeView(view1)
        XCTAssert( scrollView.contentView.frame.maxY == scrollView.header.frame.maxY + 40 )
        XCTAssert( scrollView.footer.frame.minY == scrollView.contentView.frame.maxY )
        XCTAssert( scrollView.contentView.frame.height == 40 )
        
        scrollView.insertView(view1, at: 1)
        
        //remove bottom view
        scrollView.removeView(view)
        XCTAssertEqual(scrollView.contentView.frame.maxY, scrollView.header.frame.maxY + 40)
        XCTAssert( scrollView.footer.frame.minY == scrollView.contentView.frame.maxY )
        XCTAssertEqual(scrollView.contentView.frame.height, 40)
        XCTAssertEqual(view1.frame.height, 40)
        XCTAssertEqual(view1.frame.maxY, 40)
        
        scrollView.insertView(view, at: 0)
        scrollView.insertView(view2, at: 2)
        
        //remove middle view
        scrollView.removeView(view1)
        XCTAssertEqual(scrollView.contentView.frame.maxY, scrollView.header.frame.maxY + 80)
        XCTAssert( scrollView.footer.frame.minY == scrollView.contentView.frame.maxY )
        XCTAssertEqual(scrollView.contentView.frame.height, 80)
        XCTAssertEqual(view2.frame.height, 40)
        XCTAssertEqual(view2.frame.maxY, 80)
        
        //insert first view
        scrollView.insertView(view1, at: 0)
        XCTAssertEqual(scrollView.contentView.frame.maxY, scrollView.header.frame.maxY + 120)
        XCTAssert( scrollView.footer.frame.minY == scrollView.contentView.frame.maxY )
        XCTAssertEqual(view1.frame.maxY, 40)
        XCTAssertEqual(view.frame.maxY, 80)
        XCTAssertEqual(view2.frame.maxY, 120)
        
        //insert view in middle
        scrollView.insertView(view3, at: 1)
        XCTAssertEqual(scrollView.contentView.frame.maxY, scrollView.header.frame.maxY + 160)
        XCTAssert( scrollView.footer.frame.minY == scrollView.contentView.frame.maxY )
        XCTAssertEqual(view1.frame.maxY, 40)
        XCTAssertEqual(view3.frame.maxY, 80)
        XCTAssertEqual(view.frame.maxY, 120)
        XCTAssertEqual(view2.frame.maxY, 160)
        
        
    }
    
    
}
