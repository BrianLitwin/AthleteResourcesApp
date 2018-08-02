//
//  SideBar.swift
//  UI Templates
//
//  Created by B_Litwin on 1/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


class SideBarView: UIView {
    let collectionView: SideBar
    let resignSelf: () -> Void
    
    init(sidebar: SideBar) {
        self.resignSelf = sidebar.resignSelf
        self.collectionView = sidebar
        super.init(frame: .zero)
        backgroundColor = .white
        
        //setupheader
        let label = UILabel()
        addSubview(label)
        label.numberOfLines = 2
        label.textAlignment = .center

        let titleAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        let attributedTitle = NSMutableAttributedString(string: "Athlete ", attributes: titleAttributes)

        let subtitle = NSMutableAttributedString(string: "Resources")
        let subtitleRange = NSRange(location: 0, length: subtitle.length - 1)
        subtitle.addAttribute(NSAttributedStringKey.kern, value: 1.15, range: subtitleRange)
        attributedTitle.append(subtitle)
        label.attributedText = attributedTitle
        
        //configure label size
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //configure sidebar collectionView
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        isUserInteractionEnabled = true
        
        //configure swipe gesture 
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipe.direction = .right
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }
    
    @objc func swipeRight() {
        resignSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


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

        //configure swipe gesture recognizer
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
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(headerLabel)
        addConstraintsWithFormat("H:|-20-[v0(25)]-20-[v1]|", views: imageView, headerLabel)
        addConstraintsWithFormat("V:|-12.5-[v0(25)]-12.5-|", views: imageView)
        addConstraintsWithFormat("V:|[v0]|", views: headerLabel)
    }
    
    func setColor(isSelected cellIsSelected: Bool) {
        backgroundColor = cellIsSelected ? Colors.Sidebar.Primary.bg : Colors.Sidebar.Secondary.bg
        imageView.tintColor = cellIsSelected ? Colors.Sidebar.Primary.icon : Colors.Sidebar.Secondary.icon
    }
    
    override var isSelected: Bool {
        didSet { setColor(isSelected: isSelected) }
    }
}
