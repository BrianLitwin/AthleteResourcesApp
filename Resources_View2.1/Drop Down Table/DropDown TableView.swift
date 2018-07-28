//
//  TableViewController.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/17/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class TableWithDropDownHeaders: UITableView, UITableViewDataSource, UITableViewDelegate {
    public typealias modelType = DropDownTableModel & TableDataPopulator & ReloadableModel
    
    var model: modelType

    init(model: modelType, style: UITableViewStyle = .grouped) {
        self.model = model
        super.init(frame: .zero, style: style)
        delegate = self
        dataSource = self
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 900) )
        tableFooterView = footerView
        
        //Mark: IOS 11 work around 
        estimatedRowHeight = 0;
        estimatedSectionHeaderHeight = 0;
        estimatedSectionFooterHeight = 0;
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.collapsedSections.isEmpty {
            return 0
        }
        return model.numberOfItemsToDisplay(in: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return model.configureCell(at: indexPath, for: tableView)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //tempoorary hack
        if headers[section] == nil {
            headers[section] = ExercisePickerHeader()
        }
        
        let header: ExercisePickerHeader = headers[section]!
        header.delegate = self
        header.section = section
        model.configure(header: header, at: section)
        return header
    }
    
    var headers: [Int: ExercisePickerHeader] = [:]
    
    var headersDict: [String: Bool] = [:]
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableWithDropDownHeaders: CollapsibleHeaderDelegate {
    public func toggleSection(_ section: Int, header: CollapsibleHeader) {
        let collapsed = model.collapsedSections[section]
        model.collapsedSections[section] = !collapsed
        reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
