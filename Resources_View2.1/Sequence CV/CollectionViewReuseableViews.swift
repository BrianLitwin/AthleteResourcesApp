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
    let extraHitTarget = UIView()
    
    lazy var tableViewCell: UITableViewCell = {
        let cell = TableViewCellWithSubtitle()
        cell.backgroundColor = UIColor.clear
        return cell
    }()
    
    
    func setupLabels(name: String, variation: String) {
        
        //configure right pane
        let rightPane = ViewRightPane(image: .more, tapAction: { [weak self] in self?.btnTapped() })
        rightPane.addToRightPane(superview: self)
        rightPane.expandHitTarget()
        
        let cell = tableViewCell
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = variation
        marginGuideView.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        cell.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cell.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cell.trailingAnchor.constraint(equalTo: rightPane.leadingAnchor, constant: -15).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //add a little extra space to tap
        //could not do this conventionally b/c the cell was screwing it up?
        
//        addSubview(extraHitTarget)
//        extraHitTarget.addGestureRecognizer(gr)
//        extraHitTarget.frame = CGRect(x: frame.width - 80, y: 0, width: 80, height: frame.height)
    }
    

    @objc func btnTapped() {
        delegate?.headerBtnTap(self)
    }
}

class CVFooter: BaseCollectionReusableView {
    static let reuseID = "footer"
    weak var delegate: SubviewUIHander?
    
    override func setupViews() {
        let rightPane = ViewRightPane(image: .add, tapAction: { [weak self] in self?.btnTapped() })
        rightPane.addToRightPane(superview: self)
        rightPane.expandHitTarget(by: -50)
    }
    
    @objc func btnTapped() {
        delegate?.footerBtnTap(self)
    }
}









