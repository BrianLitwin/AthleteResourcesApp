//
//  CollectionViewDataSource.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

// 1. update model 2. update collection view 3. update scroll view



public protocol SequenceModel:  UpdateableModel {
    
    var sections: [SequenceSectionData] { get set }
    
    func update(with update: SequenceUIHandler.UIUpdate, at indexPath: IndexPath)
    
    func getSequenceModelUpdater(for indexPath: IndexPath) -> ModelUpdater
    
    func masterInfoController(for indexPath: IndexPath) -> MasterInfoController?
    
}

public protocol SequenceSectionData {
    var name: String { get }
    var variation: String { get }
    var data: [String] { get set }
    func loadSectionData()
}


public protocol UpdatesExercise {
    func loadExerciseUpdateTableView() -> UpdateExerciseTableViewController
    var updateExerciseAlertTitle: String { get }
}

extension SequenceModel {
    
    public func numberOfItems(in section: Int) -> Int {
        let section = sections[section]
        return section.data.count
    }
    
    public func numberOfSections() -> Int {
        return sections.count
    }
    
    public func cellText(for indexPath: IndexPath) -> String {
        return sections[indexPath.section].data[indexPath.row]
    }
    
}


public protocol ModelUpdater {
    var textfields: [EditExerciseMetricTextField] { get set }
    var textfieldLabels: [String] { get set }
    var nonstandardKeyboardButtons: [KeyboardButtonType: KeyboardButton] { get set }
}

















