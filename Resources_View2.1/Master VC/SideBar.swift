//
//  SideBar.swift
//  UI Templates
//
//  Created by B_Litwin on 1/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class SideBar: BaseCollectionView {
    var masterVC: SideBarDelegate?
    let resignSelf: () -> Void
    var currentlySelectedCellIndex = 0
    
    override var cellHeight: CGFloat {
        return 50
    }
    
    init(resignSelf: @escaping () -> Void)
    {
        self.resignSelf = resignSelf
        super.init()
        backgroundColor = .white
        register(SideBarCell.self, forCellWithReuseIdentifier: reuseID)
        contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        configureSwipeGestureRecognizer()
    }
    
    func configureSwipeGestureRecognizer() {
        let gr = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        gr.direction = .right
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    
    @objc func swipeRight() {
        resignSelf()
    }
    
    override var numberOfItemsInSection: Int {
        return masterVC?.itemCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! SideBarCell
        cell.headerText = masterVC?.header(for: indexPath) ?? ""
        cell.imageView.image = masterVC?.icon(for: indexPath)?.withRenderingMode(.alwaysTemplate)
        cell.setColor(isSelected: indexPath.row == currentlySelectedCellIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        masterVC?.changeViewController(indexPath: indexPath)
        resignSelf()
        currentlySelectedCellIndex = indexPath.row
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SideBarCell: BaseCollectionViewCell {
    let primaryBgColor = UIColor.init(white: 0.0, alpha: 0.15)
    let secondaryBgColor = UIColor.init(white: 0.0, alpha: 0.0)
    let primaryIconColor = Color.Blue.medium.color
    let secondaryIconColor = Color.Gray.light.color
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(headerLabel)
        addConstraintsWithFormat("H:|-15-[v0(20)]-25-[v1]|", views: imageView, headerLabel)
        addConstraintsWithFormat("V:|-15-[v0(20)]-15-|", views: imageView)
        addConstraintsWithFormat("V:|[v0]|", views: headerLabel)
    }
    
    func setColor(isSelected cellIsSelected: Bool) {
        backgroundColor = cellIsSelected ? primaryBgColor : secondaryBgColor
        imageView.tintColor = cellIsSelected ? primaryIconColor : secondaryIconColor
    }
    
    override var isSelected: Bool {
        didSet { setColor(isSelected: isSelected) }
    }
}
