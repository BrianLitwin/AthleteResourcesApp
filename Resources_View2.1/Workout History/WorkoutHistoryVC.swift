//
//  WorkoutHistoryTableViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//


//
//Unit Test these different scenarios
//

//FIXME: Don't allow people to
//todo: search exercises doesn't work - doesn't let you exit
//create exercise doesn't let you exit
//no option to use ascending or descending order on top 


import UIKit

public class WorkoutHistoryTableViewController: DefaultTableViewController, ReloadableView, TrashButtonTableViewDelegate {

    public var reloadableModel: ReloadableModel?
    
    var trashButton: UIBarButtonItem?
    
    var trashButtonColor: UIColor?
    
    public var segueHandler: WorkoutHistorySegueHandler?
    
    override public func viewWillAppear(_ animated: Bool) {
        trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonPress))
        self.navigationController?.navigationItem.leftBarButtonItem = trashButton
        trashButtonColor = trashButton?.tintColor
    }
    
    public func setup(with model: WorkoutHistoryModel) {
        segueHandler = model.segueHandler
        let tableView = WorkouthistoryTableView(model: model, trashButtonDelegate: self)
        self.tableView = tableView
        tableView.delegate = tableView
        tableView.dataSource = tableView
        tableView.viewController = self 
        reloadableModel = model 
    }
    
    func setTrashButtonTintColor(for isEditing: Bool) {
        trashButton?.tintColor = isEditing ? UIColor.red : trashButtonColor ?? Color.Blue.medium.color
    }
    
    
    @objc func trashButtonPress() {
        tableView.isEditing = !tableView.isEditing
        setTrashButtonTintColor(for: tableView.isEditing)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tableView.isEditing = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationItem.leftBarButtonItem = nil
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        segueHandler?.prepareForSegue(with: segue.destination)
    }
    
}








