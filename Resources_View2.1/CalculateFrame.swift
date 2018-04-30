//
//  CalculateFrame.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/17/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

protocol CalculateFrame {
    func updateFrame()
}

extension CalculateFrame {
    
    var cellHeight: CGFloat {
        return 44
    }
    
    var headerHeight: CGFloat {
        return 44
    }
    
    var footerHeight: CGFloat {
        return 44
    }

}
    
extension SequenceCollectionView: CalculateFrame {
    
    func updateFrame() {
        
        let sections = numberOfSections(in: self)
        let numberOfCells = (0..<sections).reduce(0, { a, b in a + numberOfItems(inSection: b) } )
        
        let height = (CGFloat(sections) * (headerHeight + footerHeight))
            + CGFloat(numberOfCells) * cellHeight
        
        let width = superview?.frame.width ?? frame.width
        
        self.frame.size = CGSize(width: width, height: height )
        
    }
    
}
