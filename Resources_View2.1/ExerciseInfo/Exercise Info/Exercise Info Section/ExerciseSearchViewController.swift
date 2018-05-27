//
//  ExerciseSearchViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/8/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public protocol ExerciseSortableTableModel: ReloadableModel {
    var tableMenuHeaders: [String] { get }
    var tableData: [(date: Date, dataItems: [Double])] { get }
    func reloadData(for num: Int)
}

public protocol ExerciseTableMenuDelegate {
    func reloadData(for indexPath: IndexPath)
}


public class ExerciseSortableTableViewController: UIViewController, ReloadableView, ExerciseTableMenuDelegate {
    

    public var reloadableModel: ReloadableModel? {
        return model
    }
    
    public var model: ExerciseSortableTableModel?
    
    lazy var table: ExerciseTableData = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = ExerciseTableData(frame: .zero, collectionViewLayout: layout)
        cv.delegate = cv
        cv.dataSource = cv
        cv.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.reuseID)
        return cv
    }()
    
    lazy var menuBar: ExerciseTableMenu = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = ExerciseTableMenu(frame: .zero, collectionViewLayout: layout)
        cv.delegate = cv
        cv.dataSource = cv
        cv.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.reuseID)
        cv.sortingDelegate = self
        return cv
    }()
    
    override public func viewDidLoad() {
        view.addSubview(menuBar)
        view.addSubview(table)
        menuBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        table.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 50)
        menuBar.model = model
        table.model = model 
    }
    
    public func reloadView() {
        model?.loadModel()
        table.reloadData()
        menuBar.reloadData()
    }
    
    public func reloadData(for indexPath: IndexPath) {
        model?.reloadData(for: indexPath.row)
        table.reloadData()
        menuBar.reloadData()
    }
    
}




class ExerciseTableMenu: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var sortingDelegate: ExerciseTableMenuDelegate?
    
    var model: ExerciseSortableTableModel?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.tableMenuHeaders.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.reuseID, for: indexPath) as! MenuCell
        let label = model?.tableMenuHeaders[indexPath.row]
        cell.label.text = label
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sortingDelegate?.reloadData(for: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / CGFloat((model?.tableMenuHeaders.count ?? 0))
        return CGSize(width: width, height: 50)
    }
    

}

class ExerciseTableData: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var model: ExerciseSortableTableModel?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model?.tableData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = model?.tableData[section].dataItems.count else { return 0 }
        return items + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.reuseID, for: indexPath) as! MenuCell
        
        guard let rowData = model?.tableData[indexPath.section] else { return cell }
        
        switch indexPath.row {
            
        case 0:
            cell.label.text = rowData.date.monthDayYear
            
        default:
            let item = rowData.dataItems[indexPath.row - 1]
            cell.label.text = String(item)
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / CGFloat((model?.tableMenuHeaders.count ?? 0))
        return CGSize(width: width, height: 50)
    }
    
    
}








private class MenuCell: BaseCollectionViewCell {
    
    let label = UILabel()
    
    static var reuseID = "MCell"
    
    override func setupViews() {
        centerInContainer(label)
    }
    
}

