//
//  Section Data.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/2/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

//
//



import UIKit

public protocol MasterInfoController {
    //probably a misnamed protocol .. just want the display info ie name and variation
    var info: ExerciseCellData { get }
    
    var infoControllers: [ExerciseInfoController] { get }
}


public protocol ExerciseInfoController {
    var model: ExerciseInfoModel? { get }
    var viewController: UIViewController { get }
    var menuIcon: UIImage { get }
    var menuTitle: String { get }
    var displaysInAlertOptions: Bool { get }
    var displaysInExerciseInfo: Bool { get }
}

//this is key: that the views know to reload, because they inherit reloadable view

public protocol ExerciseAnalyticsView: ReloadableView {
    var model: ExerciseInfoModel { get }
    
}

public extension ExerciseAnalyticsView {
    public var reloadableModel: ReloadableModel? {
        return model
    }
}

public class ExerciseAnalyticsTableViewController: DefaultTableViewController, ExerciseAnalyticsView {
    
    public let model: ExerciseInfoModel
    
    public init(model:ExerciseInfoModel) {
        self.model = model 
        super.init(style: .grouped)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = model.sections[section]
        return section.sectionTitle
    }
    
    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        //guard !model.needsReload else { return 0 }
        return model.sections.count
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = model.sections[section]
        return sectionModel.rowCount()
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = model.sections[indexPath.section]
        let cell = section.uiPopulator.returnCell(at: indexPath, for: tableView)
        setCellBackground(cell)
        return cell 
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}











