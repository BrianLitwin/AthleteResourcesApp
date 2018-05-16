//
//  RepMaxesModel_Test.swift
//  Unit Tests
//
//  Created by B_Litwin on 4/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class RepMaxesModel_Test: XCTestCase {
    
    func test_model() {
        let model = RepMaxesModel(oneRepMax: 313)
        model.loadModel()
        
        XCTAssertEqual(model.roundedRepMaxes[0], 313)
        XCTAssertEqual(model.roundedRepMaxes[1], 293)
        XCTAssertEqual(model.roundedRepMaxes[2], 285)
        XCTAssertEqual(model.roundedRepMaxes[3], 276)
        XCTAssertEqual(model.roundedRepMaxes[4], 268)
        XCTAssertEqual(model.roundedRepMaxes[5], 261)
        XCTAssertEqual(model.roundedRepMaxes[6], 254)
        XCTAssertEqual(model.roundedRepMaxes[7], 247)
        XCTAssertEqual(model.roundedRepMaxes[8], 241)
        XCTAssertEqual(model.roundedRepMaxes[9], 235)
        
    }
    
    
}
