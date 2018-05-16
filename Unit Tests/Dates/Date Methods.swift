//
//  methods.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/22/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Date_Methods: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_Metthods() {
        
        var date = Date() //test current data
        
        let today = Date().mondaysDate.startOfDay
        
        var weeksSince: [Date.Week] { return Date.weeksBetween(currentDate: today, startDate: date) }
        
        XCTAssertEqual(weeksSince.count, 1)
        
        //test 1 week
        
        date = createDate(startDate: today, daysAgo: 1)
        
        XCTAssertEqual(weeksSince.count, 2)
        
        date = createDate(startDate: today, daysAgo: 7)
        
        XCTAssertEqual(weeksSince.count, 2)
        
        //test 2 week
        
        date = createDate(startDate: today, daysAgo: 8)
        
        XCTAssertEqual(weeksSince.count, 3)
        
        date = createDate(startDate: today, daysAgo: 14)
        
        XCTAssertEqual(weeksSince.count, 3)
        
        
        //test 3 weeks
        date = createDate(startDate: today, daysAgo: 16)
        XCTAssertEqual(weeksSince.count, 4)
        
        //test dates
        
        date = createDate(startDate: today, daysAgo: 136)
        
        let weeks = Date.weeksBetween(currentDate: today, startDate: date)
        
        for week in weeks {
            XCTAssertEqual(week.monday.day, "Mon")
            XCTAssertEqual(week.monday.timeLong, "00:00:00")
            
            XCTAssertEqual(week.sunday.day, "Sun")
            XCTAssertEqual(week.sunday.timeLong, "23:59:59")
        }
        
    }
    
}
