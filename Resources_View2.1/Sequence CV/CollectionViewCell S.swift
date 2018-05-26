//
//  CollectionViewCell.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit



class CollectionViewCell: BaseCollectionViewCell {
    
    static let reuseID = "cell"
    
    weak var delegate: SubviewUIHander?
    
    let button = ButtonWithImage(type: .more)
    
    let btnTapArea = UIView()
    
    override func setupViews() {
        
        //configure tap label
        //add label behind btn that triggers button tap so that btn can be small but easy to press
        addSubview(btnTapArea)
        addConstraintsWithFormat("H:[v0(95)]|", views: btnTapArea)
        addConstraintsWithFormat("V:|[v0]|", views: btnTapArea)
        btnTapArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnTapped)))
        btnTapArea.isUserInteractionEnabled = true
        
        //configure btn with "more icon"
        btnTapArea.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 18).isActive = true
        button.trailingAnchor.constraint(equalTo: btnTapArea.trailingAnchor, constant: -18).isActive = true
        button.centerYAnchor.constraint(equalTo: btnTapArea.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(btnTapped), for: .touchDown)
        button.tintColor = Colors.CurrentWorkout.iconTint
    }
    
    @objc func btnTapped() {
        delegate?.cellBtnTap(self)
    }
    
}
