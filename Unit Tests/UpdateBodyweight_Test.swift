//
//  UpdateBodyweight_Test.swift
//  Unit Tests
//
//  Created by B_Litwin on 4/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1


class UpdateBodyweight_Test: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    override func tearDown() {
        context = setUpInMemoryManagedObjectContext()
        super.tearDown()
    }
    
    func test_BodyweightUpdateModel_okayToSave() {
        
        //these are kind of useless
        
        //test okay to save
        
        let model = UpdateBodyweightModel(bodyweight: nil)
        
        XCTAssertFalse(model.readyToSave())
        
        let date = getDate(daysAgo: 2)
        let BW = 520.0
        
        model.setBodyweight(value: BW)
        
        XCTAssertFalse(model.readyToSave())
        
        model.date = date
        
        XCTAssertTrue(model.readyToSave())
        
        //test save
        
        model.save()
        
        let bodyweight = Bodyweight.fetchAll()[0]
        
        XCTAssertEqual(bodyweight.date, date)
        
        XCTAssertEqual(bodyweight.bodyweight, BW)
        
        
    }
    
}
