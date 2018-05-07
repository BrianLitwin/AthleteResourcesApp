//
//  HeaderInstructionsView.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 5/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class UpdateExerciseInstructionsHeader: BaseTableViewHeaderFooterView {
    
    static var reuseID = "InstrsReuseID"
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text =  "Tap the More Info icon beside the metric label for unit of measurement options"
        label.textAlignment  = .center
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.color(185, 185, 185)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupViews() {
        contentView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, constant: -55).isActive = true
    }
    
}
