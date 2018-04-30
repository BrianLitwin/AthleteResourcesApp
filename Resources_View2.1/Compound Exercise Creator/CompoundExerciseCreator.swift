//
//  CompoundExerciseCreator.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit



public class MultiExerciseBuilderTableViewController: UITableViewController {
    
    var model: CompoundExerciseCreatorModel!
    
    var doneBtn: UIBarButtonItem?
    
    var cellLabel: UILabel?
    
    var stepBackButton: UIButton?
    
    public init(model: CompoundExerciseCreatorModel) {
        self.model = model
        super.init(style: .grouped)
        self.model.uiUpdateHandler = self
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CompoundExerciseCreatorCell.self, forCellReuseIdentifier: CompoundExerciseCreatorCell.reuseID)
        tableView.tableHeaderView = Header(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        tableView.rowHeight = 44
        tableView.allowsSelection = false 
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompoundExerciseCreatorCell.reuseID, for: indexPath) as! CompoundExerciseCreatorCell
        cell.leftLabel.text = model.displayString ?? ""
        cellLabel = cell.leftLabel
        cell.delegate = model
        stepBackButton = cell.stepBackButton
        setStepBackButtonEnabledState(with: cell.leftLabel)
        return cell
    }
    
    func setStepBackButtonEnabledState(with label: UILabel) {
        guard let labelText = label.text else { return }
        stepBackButton?.isEnabled = !labelText.IsEmptyString
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
   
}

public protocol TableUIUpdateHandler: class {
    func update()
}

extension MultiExerciseBuilderTableViewController: TableUIUpdateHandler {
    
    public func update() {
        
        guard let label = cellLabel else { return }
        label.text = model.displayString ?? ""
        setStepBackButtonEnabledState(with: label)
        
    }
    
}


private class Header: BaseView {
    
    override func setupViews() {
        let label = UILabel()
        label.text = "Create Compound Exercise"
        addSubview(label)
        centerInContainer(label)
    }
    
}



