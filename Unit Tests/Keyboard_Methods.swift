//
//  Keyboard_Methods.swift
//  Unit Tests
//
//  Created by B_Litwin on 4/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources_View2_1

class Keyboard_Methods: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    func test() {
        
        let textField = UITextField()
        
        XCTAssert(textField.text == "" )
        
        // Test backspace won't crash w/ empty textField
        KeyboardButtonType.backspace.editTextField(textField)
        XCTAssert(textField.text == "")
        
        //Test Missed Reps
        KeyboardButtonType.addMissedRep.editTextField(textField)
        XCTAssertEqual(textField.text, "X")
        
        //Test  that backspace clears "X"
        KeyboardButtonType.backspace.editTextField(textField)
        XCTAssertEqual(textField.text, "")
        
        KeyboardButtonType.number(5).editTextField(textField)
        XCTAssert(textField.text == "5")
        
        KeyboardButtonType.backspace.editTextField(textField)
        KeyboardButtonType.decimal.editTextField(textField)
        XCTAssertEqual(textField.text, ".")
        
        KeyboardButtonType.backspace.editTextField(textField)
        KeyboardButtonType.number(4).editTextField(textField)
        XCTAssertEqual(textField.text, "4")
        
        KeyboardButtonType.decimal.editTextField(textField)
        XCTAssertEqual(textField.text, "4.") // TODO: make sure number isn't saved in this State
        
        KeyboardButtonType.number(3).editTextField(textField)
        XCTAssertEqual(textField.text, "4.3")
        
        //test that not more than one decimal can be appended
        KeyboardButtonType.decimal.editTextField(textField)
        XCTAssertEqual(textField.text, "4.3")
        
        //Test appending Missed Reps
        KeyboardButtonType.addMissedRep.editTextField(textField)
        XCTAssertEqual(textField.text, "4.3 + X")
        
        //Test that backspace clears "+ X"
        KeyboardButtonType.backspace.editTextField(textField)
        XCTAssertEqual(textField.text, "4.3")
        
        //repeat
        textField.text = "9"
        KeyboardButtonType.addMissedRep.editTextField(textField)
        XCTAssertEqual(textField.text, "9 + X")
        KeyboardButtonType.backspace.editTextField(textField)
        XCTAssertEqual(textField.text, "9")
        
        
        //Test Bodyweight
        KeyboardButtonType.bodyweight.editTextField(textField)
        XCTAssertEqual(textField.text, "BW")
        
        //Test that bodyweight clears on backspace
        KeyboardButtonType.backspace.editTextField(textField)
        XCTAssertEqual(textField.text, "")
        
    }
    
    
    func test_nonStandardCases() {
        
        let textField = UITextField()
        
        //test entering a number that already has missed reps or bodyweight in it
        
        KeyboardButtonType.bodyweight.editTextField(textField)
        KeyboardButtonType.number(1).editTextField(textField)
        XCTAssertEqual(textField.text, "1")
        
        KeyboardButtonType.backspace.editTextField(textField)
        KeyboardButtonType.addMissedRep.editTextField(textField)
        KeyboardButtonType.number(1).editTextField(textField)
        XCTAssertEqual(textField.text, "1")
        
        //test "5 + X" and adding another number
        KeyboardButtonType.backspace.editTextField(textField)
        KeyboardButtonType.number(5).editTextField(textField)
        KeyboardButtonType.addMissedRep.editTextField(textField)
        
        XCTAssertEqual(textField.text, "5 + X") //check
        
        KeyboardButtonType.number(2).editTextField(textField)
        XCTAssertEqual(textField.text, "52")
        
        
        //test
        
        
    }
    
    func test_possible_mistakes() {
        
        let textField = UITextField()
        
        //test hitting the bw button twice
        
        KeyboardButtonType.bodyweight.editTextField(textField)
        KeyboardButtonType.bodyweight.editTextField(textField)
        XCTAssertEqual(textField.text, "BW")
        
        
    }
    
    func test_zeroIsFirstCharacter() {
        
        let textField = UITextField()
        
        KeyboardButtonType.number(5).editTextField(textField)
        XCTAssertEqual(textField.text, "5")
        
        
    }
    
    
}
