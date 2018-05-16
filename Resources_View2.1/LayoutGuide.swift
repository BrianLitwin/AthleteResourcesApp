//
//  LayoutGuide.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

protocol LayoutGuide {
    var marginGuide: UILayoutGuide { get }
    var marginGuideView: UIView { get }
}

extension LayoutGuide {
    var marginGuide: UILayoutGuide {
        return marginGuideView.layoutMarginsGuide
    }
}

extension LayoutGuide where Self: UICollectionReusableView {
    var marginGuideView: UIView {
        return self
    }
}

extension LayoutGuide where Self: UICollectionViewCell {
    var marginGuideView: UIView {
        return contentView
    }
}

extension LayoutGuide where Self: UIView {
    var marginGuideView: UIView {
        return self
    }
}

extension LayoutGuide where Self: UITableViewCell {
    var marginGuideView: UIView {
        return contentView
    }
}

extension LayoutGuide where Self: UITableViewHeaderFooterView {
    var marginGuideView: UIView {
        return contentView
    }
}



extension LayoutGuide where Self: UIView {
    
    func centerVertically(_ view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        marginGuideView.addSubview(view)
        view.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
    }
    
    func centerLeft(_ view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        marginGuideView.addSubview(view)
        view.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: marginGuideView.leadingAnchor, constant: 15).isActive = true
        view.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
    }
    
    func centerRight(_ view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        marginGuideView.addSubview(view)
        view.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: marginGuideView.trailingAnchor, constant: -14).isActive = true
        view.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    }
    
    func centerRight(_ view: UIView, width: CGFloat, trailingConstraint: CGFloat) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        marginGuideView.addSubview(view)
        view.trailingAnchor.constraint(equalTo: marginGuideView.trailingAnchor, constant: -trailingConstraint).isActive = true
        view.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true 
        
    }
    
    func centerInContainer(_ view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        marginGuideView.addSubview(view)
        view.centerYAnchor.constraint(equalTo: marginGuideView.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: marginGuideView.centerXAnchor).isActive = true 
        
    }
    
    func pinToEdges(_ view: UIView, withMargin: CGFloat = 0) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        marginGuideView.addSubview(view)
        view.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: withMargin).isActive = true
        view.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: withMargin).isActive = true
        view.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: withMargin).isActive = true
        view.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: withMargin).isActive = true
        
    }
    
    
}





















