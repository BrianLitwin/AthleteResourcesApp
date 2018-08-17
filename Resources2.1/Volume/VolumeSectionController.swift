//
//  VolumeSectionController.swift
//  Resources2.1
//
//  Created by B_Litwin on 8/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import IGListKit


final class VolumeSectionController: ListBindingSectionController<VolumeSectionViewModel>, ListBindingSectionControllerDataSource {
    
    override init() {
        super.init()
        dataSource = self
    }
    
    // Mark: ListBindingSectionControllerDataSource
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? VolumeSectionViewModel else { fatalError() }
        let results: [ListDiffable] = [
            object
        ]
        
        return results
    }
    
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        sizeForViewModel viewModel: Any,
        at index: Int
        ) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { fatalError() }
        return CGSize(width: width, height: 44)
    }
    
    func sectionController(
        _ sectionController: ListBindingSectionController<ListDiffable>,
        cellForViewModel viewModel: Any,
        at index: Int
        ) -> UICollectionViewCell & ListBindable {
        guard let cell = collectionContext?.dequeueReusableCell(of: VolumeMetricCollectionViewCell.self, for: self, at: index) as? VolumeMetricCollectionViewCell else { fatalError() }
        
        return cell
    }
}
