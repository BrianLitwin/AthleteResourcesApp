//
//  base CollectionView.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/13/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cvlayout = UICollectionViewFlowLayout()
    var scrollDirection: UICollectionViewScrollDirection {
        return .vertical
    }
    
    var minimumLineSpacing: CGFloat {
        return 0
    }
    
    var minimumInteritemSpacing: CGFloat {
        return 0
    }
    
    var numberOfItemsInSection: Int {
        return 1
    }
    
    override var numberOfSections: Int {
        return 1
    }
    
    var cellHeight: CGFloat {
        return 44
    }
    
    var headerHeight: CGFloat {
        return 44
    }
    
    var footerHeight: CGFloat {
        return 44
    }
    
    let reuseID = "cell"
    let headerID = "headerID"
    let footerID = "footerID"
    
    func registerCell(_ cell: AnyClass?) {
        register(cell, forCellWithReuseIdentifier: reuseID)
    }
    
    func registerHeader(_ header: AnyClass?) {
        register(header, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
    func registerFooter(_ footer: AnyClass?) {
        register(footer, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerID)
    }
    
    
    init() {
        super.init(frame: .zero, collectionViewLayout: cvlayout)
        cvlayout.scrollDirection = scrollDirection
        cvlayout.minimumInteritemSpacing = minimumInteritemSpacing
        dataSource = self
        delegate = self
        setup()
    }
    
    
    func setup() {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width
        let height = cellHeight
        return CGSize(width: width, height: height)
    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: frame.width, height: headerHeight)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: frame.width, height: footerHeight)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
}
