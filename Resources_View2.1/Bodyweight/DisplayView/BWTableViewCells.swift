//
//  BWTableViewCells.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class TableViewCellWithRightAndLeftLabel: BaseTableViewCell {
    
    static var reuseID: String = "cellWithRLLabels"
    
    lazy var leftLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var rightLabel: UILabel = {
        return UILabel()
    }()
    
    override func setupViews() {
        //configure left label
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftLabel)
        leftLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
        centerRight(rightLabel)
    }
    
}



class BodyweightTVCell: BaseTableViewCell {
    
    var date: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bodyweight: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var wChange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.BodyweightVC.weightChangeBtn
        return label
    }()
    
    static var reuseID = "String"
    
    override func setupViews() {
        
        addSubview(date)
        addSubview(bodyweight)
        addSubview(wChange)
        
        bodyweight.textAlignment = .right
        wChange.textAlignment = .left
        date.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        bodyweight.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        wChange.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        date.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        bodyweight.rightAnchor.constraint(equalTo: rightAnchor, constant: -75).isActive = true
        wChange.leftAnchor.constraint(equalTo: rightAnchor, constant: -55).isActive = true
        
    }
    
}
