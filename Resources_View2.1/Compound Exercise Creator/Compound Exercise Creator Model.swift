//
//  Compound Exercise Creator Model.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol CompoundExerciseCreatorModel: class {
    var uiUpdateHandler: TableUIUpdateHandler? { get set }
    var displayString: String? { get }
    func stepBack()
}


