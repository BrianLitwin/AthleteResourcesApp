//
//  Bodyweight_Testing.swift
//  Unit Tests
//
//  Created by B_Litwin on 4/6/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Bodyweight_Testing: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    func test_bodyweightModel() {
        
        let bw = Bodyweight.create(value: 99.0, date: getDate(daysAgo: 1))
        let bw1 = Bodyweight.create(value: 101, date: getDate(daysAgo: 6))
        let bw2 = Bodyweight.create(value: 102, date: getDate(daysAgo: 14))
        let bw3 = Bodyweight.create(value: 100, date: getDate(daysAgo: 15))
        let bw4 = Bodyweight.create(value: 100, date: getDate(daysAgo: 19))
        let bw5 = Bodyweight.create(value: 110, date: getDate(daysAgo: 26))
        let bw6 = Bodyweight.create(value: 100, date: getDate(daysAgo: 34))
        let bw7 = Bodyweight.create(value: 120, date: getDate(daysAgo: 42))
        
        let model = BodyweightAnalyticsModel()
        model.loadModel()
        
        
        func item(_ i: Int) -> BodyweightListItem {
            return model.bodyweightItems[i]
        }
        
        //first item s hould have no prev bodyweight
        XCTAssertNil(item(7).prevBodyweight)
        
        //test chronilogical order
        XCTAssertEqual(item(0).bodyweight, bw.bodyweight)
        XCTAssertEqual(item(0).date, bw.date)
        XCTAssertEqual(item(1).bodyweight, bw1.bodyweight)
        XCTAssertEqual(item(7).bodyweight, bw7.bodyweight)
        
        
        //test marginFromPrev
        XCTAssertEqual(item(0).marginFromPrev, -2)
        XCTAssertEqual(item(4).marginFromPrev, -10)
        XCTAssertEqual(item(5).marginFromPrev, 10)
        XCTAssertEqual(item(7).marginFromPrev, 0)
        XCTAssertNil(item(7).prevBodyweight)
        
        //test min,max
        XCTAssertEqual(model.maxBodyweight!.bodyweight, 120)
        XCTAssertEqual(model.minBodyweight!.bodyweight, 99)
        
        //test  daysAgo function and change function
        
        XCTAssertEqual(model.bodyweightsFrom(daysAgo: 7).count, 2)
        
        XCTAssertEqual(model.bodyweightsFrom(daysAgo: 15).count, 3)
        
        XCTAssertEqual(model.bodyweightsFrom(daysAgo: 43).lastItem!.bodyweight, 120)
        
        XCTAssertEqual(model.changeFrom(daysAgo: 43), -21)
        
        
    }
    
}
