//
//  WorkoutHistoryTableView.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/3/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class WorkouthistoryTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let model: WorkoutHistoryModel
    
    var viewController: UIViewController?
    
    var trashButtonDelegate: TrashButtonTableViewDelegate?
    
    override public var isEditing: Bool {
        didSet {
            trashButtonDelegate?.setTrashButtonTintColor(for: isEditing)
        }
    }
    
    init(model: WorkoutHistoryModel, trashButtonDelegate: TrashButtonTableViewDelegate) {
        self.model = model
        super.init(frame: .zero, style: .grouped)
        self.trashButtonDelegate = trashButtonDelegate
        register(WorkoutHistoryCell.self, forCellReuseIdentifier: WorkoutHistoryCell.reuseID)
        register(EmptyWorkoutHistoryCell.self, forCellReuseIdentifier: EmptyWorkoutHistoryCell.reuseID)
        backgroundColor = UIColor.lighterBlack()
    }
    
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if model.sections.count > 0 {
            let mon = model.sections[section].dateInterval.start
            let sun = model.sections[section].dateInterval.end
            return "\(mon.monthDay) - \(sun.monthDay)"
        } else {
            return "No Workouts In Workout History"
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        let count = model.sections.count
        return count > 0 ? count : 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard model.sections.count > 0 else { return 0 }
        let section = model.sections[section]
        return section.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = model.sections[indexPath.section]
        
        if section.items.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyWorkoutHistoryCell.reuseID) as! EmptyWorkoutHistoryCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutHistoryCell.reuseID) as! WorkoutHistoryCell
        
        let item = section.items[indexPath.row]
        cell.textLabel?.text = item.date.weekdayDay
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = tableView.backgroundColor
        cell.textLabel?.textColor = UIColor.groupedTableText()
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //FIX ME: disable tableview animations when uialert controller shows
            
            let alert = UIAlertController(title: "Delete Workout From History?",
                                          message: nil,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete",
                                          style: .destructive) {
                                            [weak self] action in
                                            self?.model.deletItem(at: indexPath)
                                            self?.deleteRows(at: [indexPath], with: .automatic)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default){
                action in tableView.isEditing = false
                
            })
            
            alert.show()
            
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //FIX ME don't let people segue to current workout
        
        guard let vc = viewController else { return }
        model.segueHandler?.setIndexPath(indexPath)
        vc.performSegue(withIdentifier: "segueToPreviousWorkout", sender: vc)
        deselectRow(at: indexPath, animated: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol TrashButtonTableViewDelegate {
    func setTrashButtonTintColor(for isEditing: Bool) 
}


class WorkoutHistoryCell: TableViewCellWithRightDetail {
    static var reuseID = "cell"
}

class EmptyWorkoutHistoryCell: UITableViewCell {
    
    static var reuseID = "cell1"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.text = "No Workouts This Week"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
