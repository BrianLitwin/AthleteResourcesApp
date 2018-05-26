//
//  UICollCollectionViewController.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

public protocol ReturnsSequenceModelAndUIUpdater {
    var model: SequenceModel { get }
    var uiHandler: SequenceUIHandler! { get }
}

class SequenceCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ReturnsSequenceModelAndUIUpdater {
    
    let model: SequenceModel
    
    var uiHandler: SequenceUIHandler!
    
    init(model: SequenceModel,
         workoutController: WorkoutController)
    {

        self.model = model
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.uiHandler = SequenceUIHandler(collectionView: self,
                                            model: model,
                                            delegate: workoutController)
        
        delegate = self
        dataSource = self
        layout.scrollDirection = .vertical
        
        register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        register(CVHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CVHeader.reuseID)
        register(CVFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CVFooter.reuseID)
        backgroundColor = Colors.CurrentWorkout.sectionBg
        layer.cornerRadius = 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        cell.headerText = model.cellText(for: indexPath)
        cell.centerLeft(cell.headerLabel) 
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        uiHandler.handleUIAction(for: .rowSelected, at: indexPath)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let section = model.sections[indexPath.section]
            let header = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CVHeader.reuseID, for: indexPath) as! CVHeader
            header.delegate = self
            header.setupLabels(name: section.name, variation: section.variation)
            return header
            
            
        case UICollectionElementKindSectionFooter:
            
            let footer = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CVFooter.reuseID, for: indexPath) as! CVFooter
            footer.delegate = self
            return footer 
            
        default:
            break

            
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    deinit {
        print("deallocated")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


















