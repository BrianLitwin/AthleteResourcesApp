//
//  Test_ScrollView.swift
//  Unit Tests
//
//  Created by B_Litwin on 5/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources_View2_1

class Test_ScrollView: XCTestCase {
    
    func test() {
        
        //test that method calculates frames correctly
        
        let contentView = ScrollViewContentView()
        
        //test nil i.e. first view
        var ret = ScrollView.calculateFrameOfSubview(prevViewMaxY: nil,
                                             widthOfSuperview: 50,
                                             height: 50,
                                             sectionSpacing: 5)
        
        var expected = CGRect(x: 5, y: 5, width: 40, height: 50)
        XCTAssertEqual(ret, expected)
        
        //test prevMaxY not nil
        ret = ScrollView.calculateFrameOfSubview(prevViewMaxY: 50,
                                                     widthOfSuperview: 50,
                                                     height: 50,
                                                     sectionSpacing: 5)
        
        expected = CGRect(x: 5, y: 55, width: 40, height: 50)
        XCTAssertEqual(ret, expected)
        
        
        
    }
    
    
    
}
