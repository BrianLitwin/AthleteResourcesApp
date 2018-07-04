//
//  Collapsible Header.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/17/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol CollapsibleHeaderDelegate: class {
    func toggleSection(_ section: Int)
}

extension TableWithDropDownHeaders: CollapsibleHeaderDelegate {
    public func toggleSection(_ section: Int) {
        let collapsed = model.collapsedSections[section]
        model.collapsedSections[section] = !collapsed
        reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}


public class CollapsibleHeader: BaseTableViewHeaderFooterView {
    static var reuseID = "header"
    var section: Int = 0
    
    weak var delegate: CollapsibleHeaderDelegate?
    
    override func setupViews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped) ) )
    }
    
    @objc func selfTapped() {
        delegate?.toggleSection(section)
    }
    
}
