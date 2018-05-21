//
//  Alerts.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/16/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

protocol ExercisePicker {
    var insertHandler: ((IndexPath) -> Void)? { get set }
}


public class ExercisePickerTableView: TableWithDropDownHeaders, ExercisePicker, Resignable {
    
    public typealias modelType = TableWithDropDownHeaders.modelType
    
    public var insertHandler: ((IndexPath) -> Void)?
    
    public var resignSelf: (() -> Void)?
    
    public init(model: modelType) {
        //Mark: initialize the dropDownTableView
        super.init(model: model)
        register(ExerciseCell.self, forCellReuseIdentifier: ExerciseCell.reuseID)
        register(ExercisePickerHeader.self,
                 forHeaderFooterViewReuseIdentifier: ExercisePickerHeader.reuseID)
    }
    
    @objc func swipeDown() {
        resignSelf?()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        insertHandler?(indexPath)
        resignSelf?()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(  "Deinited"  )
    }
    
}




