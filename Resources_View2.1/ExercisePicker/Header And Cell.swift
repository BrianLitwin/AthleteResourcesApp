//
//  Header And Cell.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/20/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class ExerciseCell: TableViewCellWithSubtitle {
    static var reuseID = "Cell"
}

class ExercisePickerHeader: CollapsibleHeader {
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        contentView.backgroundColor = UIColor.black
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        marginGuideView.addSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true 
        

    }
    
}

class ExercisePickerFooter: BaseView {
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.text = "Go to Search Exercises to add exercises"
        return l
    }()
    
    override func setupViews() {
        centerInContainer(label)
    }
    
}

