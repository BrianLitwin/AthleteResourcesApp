//
//  ExerciseInfoViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class ExerciseInfoViewController: UIViewController, ContainerViewController {
    
    //fix me: this is inefficient; needs to be a let constant; gets called like 6 times 
    
    public func childVCs() -> [UIViewController] {
        guard let exerciseInfo = self.exerciseInfo else { return [] }
        return exerciseInfo.infoControllers.map({ $0.viewController })
    }
    
    public var exerciseInfo: MasterInfoController? {
        didSet {
            guard let exerciseInfo = self.exerciseInfo else { return }
            menuBar.infoControllers = exerciseInfo.infoControllers
            menuBar.reloadData()
            changeViewController(index: 0)
            menuBar.selectItem(at: [0,0], animated: false, scrollPosition: .bottom)
        }
    }
    
    
    lazy var menuBar: ExerciseInfoMenu = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = ExerciseInfoMenu(frame: .zero, collectionViewLayout: layout)
        cv.setup()
        cv.masterVC = self 
        return cv
    }()
    
    var menuBarHeight: CGFloat {
        return ExerciseInfoMenuCell.size.height
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
        
        //keep view from going under navigation bar
        edgesForExtendedLayout = []
        
    }
    
    public func setupViewControllerFrame(for viewController: UIViewController) {
        viewController.view.frame = CGRect(x: 0,
                                           y: menuBarHeight,
                                           width: view.frame.width,
                                           height: view.frame.height - menuBarHeight)
        
    }
    
    func setupMenuBar() {
        
        view.addSubview(menuBar)
        menuBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: menuBarHeight)
        
        let menuBarWidth = ExerciseInfoMenuCell.size.width * CGFloat(menuBar.infoControllers.count)
        let diff = view.frame.width - menuBarWidth
        if diff > 0 {
            menuBar.contentInset = UIEdgeInsets(top: 0, left: diff / 2, bottom: 0, right: diff / 2)
        }
        
    }
    
    
}

