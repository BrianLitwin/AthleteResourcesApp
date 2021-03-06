//
//  Int.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

extension Int {
    func upTo(max: Int) -> Int {
        return self >= max ? max : self
    }
}
