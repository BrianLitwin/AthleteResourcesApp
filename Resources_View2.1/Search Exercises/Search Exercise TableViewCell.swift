//
//  Search Exercise TableViewCell.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class SearchExerciseTableViewCell: BaseTableViewCell {

    static let reuseID = "Scell"
    
    lazy var cell: TableViewCellWithSubtitle = {
        let cell = TableViewCellWithSubtitle()
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.groupedTableText()
        cell.detailTextLabel?.textColor = UIColor.groupedTableText()
        return cell
    }()
    
    //todo: can use the default apple checkmarks here 
    lazy var checkBox: UIImageView = {
        let image = #imageLiteral(resourceName: "check").withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(cell)
        addSubview(checkBox)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cell.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cell.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cell.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -10).isActive = true
        
        backgroundColor = UIColor.lighterBlack()
        
    }
    
    
    
}
