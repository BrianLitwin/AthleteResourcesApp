//
//  ExerciseInfoMenu.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class ExerciseInfoMenu: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    typealias Cell = ExerciseInfoMenuCell
    
    var masterVC: ContainerViewController?
    
    var infoControllers: [ExerciseInfoController] = []
    
    func setup() {
        delegate = self
        dataSource = self 
        register(Cell.self, forCellWithReuseIdentifier: Cell.reuseID)
        backgroundColor = Colors.ExerciseInfo.Menu.background
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseID, for: indexPath) as! Cell
        let controller = infoControllers[indexPath.row]
        cell.setup(with: controller.menuIcon.withRenderingMode(.alwaysTemplate), menuLabel: controller.menuTitle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Cell.size.width, height: Cell.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        masterVC?.changeViewController(indexPath: indexPath)
    }
    
}






