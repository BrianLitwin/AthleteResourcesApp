//
//  CollectionViewReuseableViews.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class CVHeader: BaseCollectionReusableView {
    
    static let reuseID = "header"  
    
    weak var delegate: SubviewUIHander?
    
    let button = ButtonWithImage(type: .expandMore)
    
    func setupLabels(name: String, variation: String) {
        let cell = tableViewCell
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = variation
        marginGuideView.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        cell.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cell.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cell.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -15).isActive = true
        cell.textLabel?.textColor = UIColor.groupedTableText()
    }
    
    override func setupViews() {
        button.addTarget(self, action: #selector(btnTapped), for: .touchDown)
        button.frame.size = CGSize(width: 25, height: 25)
        centerRight(button)
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.tintColor = UIColor.brightTurquoise()
    }
    
    @objc func btnTapped() {
        delegate?.headerBtnTap(self)
    }
    
    lazy var tableViewCell: UITableViewCell = {
        let cell = TableViewCellWithSubtitle()
        cell.backgroundColor = UIColor.clear
        return cell
    }()
    
}

class CVFooter: BaseCollectionReusableView {
    
    static let reuseID = "footer"
    
    weak var delegate: SubviewUIHander?
    
    var button = ButtonWithImage(type: .add)
    
    let btnTapArea = UIView()
    
    override func setupViews() {
        
        //configure tap label
        //add label behind btn that triggers button tap so that btn can be small but easy to press
        addSubview(btnTapArea)
        addConstraintsWithFormat("H:|[v0(95)]", views: btnTapArea)
        addConstraintsWithFormat("V:|[v0]|", views: btnTapArea)
        btnTapArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(btnTapped)))
        btnTapArea.isUserInteractionEnabled = true
        
        //configure plus btn
        button.translatesAutoresizingMaskIntoConstraints = false
        btnTapArea.addSubview(button)
        button.heightAnchor.constraint(equalToConstant:24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.leadingAnchor.constraint(equalTo: btnTapArea.leadingAnchor, constant: 9).isActive = true
        button.centerYAnchor.constraint(equalTo: btnTapArea.centerYAnchor).isActive = true
        
        button.addTarget(self, action: #selector(btnTapped), for: .touchDown)
        button.tintColor = UIColor.brightTurquoise()
    }
    
    @objc func btnTapped() {
        delegate?.footerBtnTap(self)
    }
    
}
