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
    var arrowImage = #imageLiteral(resourceName: "arrow_right")
    let imageView = UIImageView()
    static var reuseID = "headerView"

    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.ExercisePicker.headerBg
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        marginGuideView.addSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
        
        imageView.image = #imageLiteral(resourceName: "arrow_right").withRenderingMode(.alwaysTemplate)
        contentView.addSubview(imageView)
        imageView.tintColor = Colors.ExercisePicker.arrow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollapsed(_ collapsed: Bool) {

        if !collapsed {
            imageView.rotate(.pi / 2)
        } else {
            imageView.rotate(0.0)
        }
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

