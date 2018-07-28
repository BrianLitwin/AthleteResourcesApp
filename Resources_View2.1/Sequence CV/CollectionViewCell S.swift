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
    
    lazy var gr: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(btnTapped))
    }()
    
    override func setupViews() {
        let rightPane = ViewRightPane(image: .more, tapAction: { [weak self] in self?.btnTapped() })
        rightPane.addToRightPane(superview: self)
        rightPane.expandHitTarget()
    }
    
    @objc func btnTapped() {
        delegate?.cellBtnTap(self)
    }
    
    lazy var tableViewCell: UITableViewCell = {
        let cell = TableViewCellWithSubtitle()
        cell.backgroundColor = UIColor.clear
        return cell
    }()
    
    
}
