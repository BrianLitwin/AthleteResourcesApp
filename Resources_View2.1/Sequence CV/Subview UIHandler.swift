//
//  UIAction_Manager.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit




protocol SubviewUIHander: class {
    func cellBtnTap(_ cell: UICollectionViewCell)
    func headerBtnTap(_ header: UICollectionReusableView)
    func footerBtnTap(_ footer: UICollectionReusableView)
}

extension SequenceCollectionView: SubviewUIHander {
    
    func cellBtnTap(_ cell: UICollectionViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        if numberOfItems(inSection: indexPath.section) <= 1 {
            uiHandler.handleUIAction(for: .rowBtnTapForRowWithSingleItem, at: indexPath)
        } else {
            uiHandler.handleUIAction(for: .rowBtnTap, at: indexPath)
        }
    }
    
    func headerBtnTap(_ header: UICollectionReusableView) {
        
        let indexPaths = indexPathsForVisibleSupplementaryElements(ofKind: UICollectionElementKindSectionHeader)
        
        for indexPath in indexPaths {
            if let _ = supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: indexPath) {
                uiHandler.handleUIAction(for: .headerBtnTap, at: indexPath)
            }
            
        }
        
    }
    
    func footerBtnTap(_ footer: UICollectionReusableView) {
        
        let indexPaths = indexPathsForVisibleSupplementaryElements(ofKind: UICollectionElementKindSectionFooter)
        
        for indexPath in indexPaths {
            if let _ = supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: indexPath) {
                let lastRow = self.collectionView(self, numberOfItemsInSection: indexPath.section)
                
                //Mark: Return the indexPath to append 
                
                let lastIndexPath = [indexPath.section, lastRow] as IndexPath
                uiHandler.handleUIAction(for: .footerBtnTap, at: lastIndexPath)
            }
            
        }
        
    }
    
}




