//
//  Edit Exericise Metric Table VIew.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

//Figure out

class ExerciseMetricEditingTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    typealias Cell = EditExerciseMetricTableViewCell
    typealias TextFields = [EditExerciseMetricTextField]
    let textFields: TextFields
    let modelUpdater: ModelUpdater
    
    init(modelUpdater: ModelUpdater)
    {
        self.modelUpdater = modelUpdater
        self.textFields = modelUpdater.textfields
        super.init(frame: .zero, style: .plain)
        
        isScrollEnabled = false
        register(Cell.self, forCellReuseIdentifier: Cell.reuseID)
        delegate = self
        dataSource = self
        rowHeight = 50
        separatorColor = .clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: Cell.reuseID) as! Cell
        cell.label.text = modelUpdater.textfieldLabels[indexPath.row]
        let textField = textFields[indexPath.row]
        cell.setupTextField(with: textField)
        if indexPath.row == 0 { cell.textField?.becomeFirstResponder() }
        cell.selectionStyle = .none 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = cellForRow(at: indexPath) as? Cell else { return }
        cell.textField?.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
