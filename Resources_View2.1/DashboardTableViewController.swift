//
//  DashboardTableViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class DashboardTableViewController: UITableViewController {

    public var model: DashboardModel?
    
    var reuseID = "cell"
    
    public func setup(week: Int) {
        
        let header = Header(week: week,
                            frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        
        tableView.tableHeaderView = header
            
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseID)
        
        title = "Dashboard"
        
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return model?.sectionModels.count ?? 0
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = model?.sectionModels[section] {
            return model.collapsed ? 1 : model.displayData.count.upTo(max: 3)
        }
        return 1
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseID, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        
        if let sectionModel = model?.sectionModels[indexPath.section] {
            
            guard !sectionModel.displayData.isEmpty else {
                cell.emptyDisplayText = sectionModel.emptyDisplayText
                return cell
            }
            
            cell.displayText = sectionModel.displayData[indexPath.row]
            
        }
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model?.sectionModels[section].title
    }

}

private class Header: UIView, LayoutGuide {
    
    init(week: Int, frame: CGRect) {
        super.init(frame: frame)
        label.text = "Week \(week)"
        centerInContainer(label)
    }

    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private class Cell: UITableViewCell {
    
    static var reuseID = "cell"
    
    var label: UILabel? {
        return textLabel
    }
    
    var displayText = "" {
        didSet {
            if let l = label {
                l.text = displayText
                l.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }
    
    var emptyDisplayText = "" {
        didSet {
            if let l = label {
                l.text = emptyDisplayText
                l.font = UIFont.italicSystemFont(ofSize: 14)
            }
        }
    }
    
}



public protocol DashboardModel {
    var sectionModels: [DashboardSectionModel] { get }
}

public protocol DashboardSectionModel {
    var title: String { get }
    var emptyDisplayText: String { get }
    var collapsed: Bool { get set }
    var displayData: [String] { get }
}










