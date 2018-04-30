//
//  ExerciseInfoMenuCell.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/7/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class ExerciseInfoMenuCell: BaseCollectionViewCell {
    
    static var reuseID = "ExerciseMenuCell"
    
    override func setupViews() {
        addSubview(outline1)
        addSubview(label)
        
        outline1.layer.cornerRadius = cellSize.boxSize / 2
        
        outline1.frame = CGRect(x: cellSize.sideMargin,
                                y: cellSize.sideMargin + (cellSize.sideMargin / 2),
                                width: cellSize.boxSize,
                                height: cellSize.boxSize)
        
        label.frame = CGRect(x: 0,
                             y: cellSize.height - cellSize.sideMargin - cellSize.labelHeight,
                             width: cellSize.width,
                             height: cellSize.labelHeight)
        
        outline1.addSubview(imageView)
        
        imageView.frame = CGRect(x: 8,
                                 y: 8,
                                 width: outline1.frame.width - 16,
                                 height: outline1.frame.width - 16)
        
        backgroundColor = UIColor.clear
        
    }
    
    func setup(with icon: UIImage, menuLabel: String) {
        imageView.image = icon
        label.text = menuLabel
    }
    
    //Todo: dubious 
    static var size = ExerciseInfoMenuCellSize()
    var cellSize = ExerciseInfoMenuCell.size
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        //iv.tintColor = UIColor.workoutBackground2()
        return iv
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    var circleView = CircleGraphicView()
    
    var outline1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        //view.layer.cornerRadius = 33
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 3
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            
        }
    }
    

}
