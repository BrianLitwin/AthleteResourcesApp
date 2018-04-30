//
//  ExerciseListTableViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/3/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CorePlot 

public class ExerciseListTableViewController: DefaultTableViewController, ReloadableView {
    
    var selectedListItem: ExerciseListItem?
    
    public var reloadableModel: ReloadableModel? {
        return model
    }
    
    public var model: ExerciseListModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ExerciseListCell.self, forCellReuseIdentifier: ExerciseListCell.reuseID)
        setupDefaultColorScheme()
    }


    override public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model?.listItems.count ?? 0
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseListCell.reuseID, for: indexPath) as! ExerciseListCell
        
        cell.accessoryType = .disclosureIndicator
        
        if let item = self.model?.listItems[indexPath.row] {
            cell.setup(with: item)
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedListItem = model?.listItems[indexPath.row]
        performSegue(withIdentifier: "segueToExerciseDetail", sender: self)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ExerciseInfoViewController {
            destination.exerciseInfo = selectedListItem?.infoController
            selectedListItem = nil 
        }
    }

}
