//
//  TextfieldCollectionViewCollectionViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

protocol TextFieldCollectionViewModel {
    var textFieldInfos: [TextFieldCollectionViewCellInfo] { get }
}


class TextfieldCollectionView: BaseCollectionView {
    
    var model: TextFieldCollectionViewModel?
    
    override var minimumLineSpacing: CGFloat {
        return 20
    }
    
    override var cellHeight: CGFloat {
        return 60 
    }
    
    override func setup() {
        register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: TextFieldCollectionViewCell.reuseID)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.textFieldInfos.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCollectionViewCell.reuseID, for: indexPath) as! TextFieldCollectionViewCell
        guard let textFieldInfo = model?.textFieldInfos[indexPath.row] else { return cell }
        cell.onTap = textFieldInfo.onTap
        cell.setup(with: textFieldInfo.image, headerText: textFieldInfo.headerText, textFieldText: textFieldInfo.textFieldText)
        
        return cell
    }
    
    
}

struct TextFieldCollectionViewCellInfo {
    let image: UIImage?
    let headerText: String
    let onTap: (() -> Void)?
    let textFieldText: String?
}








