//
//  Volume+ViewController.swift
//  Resources2.1
//
//  Created by B_Litwin on 8/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import IGListKit
import Resources_View2_1


class VolumeMetricsViewController: UIViewController, ListAdapterDataSource {
    
    let controllerModel: VolumeMetricsModel
    
    lazy var collectionView: ListCollectionView = {
        let layout = ListCollectionViewLayout.basic()
        return ListCollectionView(frame: .zero, listCollectionViewLayout: layout)
    }()
    
    lazy var adapter: ListAdapter = { return ListAdapter(updater: ListAdapterUpdater(), viewController: self) }()
    
    init(exercise: Exercises) {
        self.controllerModel = VolumeMetricsModel(exercise: exercise)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.dataSource = self
        adapter.collectionView = self.collectionView
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return controllerModel.volumeSections
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return VolumeSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}

extension ListCollectionViewLayout {
    static func basic() -> ListCollectionViewLayout {
        return ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
    }
}



/*
hate having to conform to this, but for now, it seems like a small price to pay
*/



extension VolumeMetricsViewController: Resources_View2_1.ExerciseInfoController  {
    var model: ExerciseInfoModel? {
        return self.controllerModel
    }
    
    var viewController: UIViewController {
        return self
    }
    
    var menuIcon: UIImage {
        return #imageLiteral(resourceName: "more")
    }
    
    var menuTitle: String {
        return "Volume"
    }
    
    var displaysInAlertOptions: Bool {
        return false
    }
    
    var displaysInExerciseInfo: Bool {
        return true
    }
    
}

extension VolumeMetricsViewController: Resources_View2_1.ReloadableView {
    func reloadView() {
        loadModelOffTheMainQueueIfNeeded(spinnerFrame: view.frame) 
    }
    
    
    var reloadableModel: ReloadableModel? {
        return self.model
    }

}









