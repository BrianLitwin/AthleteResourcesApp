//
//  String.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

extension String {

    var nums: CharacterSet {
        return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ]
    }
    
    var numsSet: Set<Character> {
        return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", ]
    }
    
    var IsEmptyString: Bool {
        guard self.characters.count > 0 else { return true }
        if self.trimmingCharacters(in: .whitespaces) == "" { return true }
        return false
    }
    
    func removeNumericValues() -> String {
        return self.trimmingCharacters(in: CharacterSet.decimalDigits )
    }
    
    func removeNonNumericValues() -> Double? {
        if let num = Double( self.trimmingCharacters(in: nums.inverted) ) {
            return num
        } else {
            return nil
        }
    }

}
