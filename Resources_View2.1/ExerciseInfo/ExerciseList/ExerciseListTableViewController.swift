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
    var sortType = SortType.byFrequency
    
    enum SortType {
        case byFrequency
        case byCategory
    }
    
    public var reloadableModel: ReloadableModel? {
        return model
    }
    
    public var model: ExerciseListModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ExerciseListCell.self, forCellReuseIdentifier: ExerciseListCell.reuseID)
        setupDefaultColorScheme()
        
        //configure table header
        let header = ExerciseListSegmentedControlHeader(delegate: self)
        tableView.tableHeaderView = header
        header.frame = CGRect(x: view.frame.minX,
                              y: view.frame.minY,
                              width: view.frame.width,
                              height:60)
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        switch sortType {
        case .byFrequency: return 1
        case .byCategory: return model?.sections.count ?? 1
        }
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model else { return 0 }
        switch sortType {
        case .byFrequency: return model.listItems.count ?? 0
        case .byCategory: return model.sections[section].items.count
        }
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sortType {
        case .byFrequency: return "Exercises"
        case .byCategory: return model?.sections[section].category ?? ""
        }
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseListCell.reuseID, for: indexPath) as! ExerciseListCell
        guard let model = self.model else { return cell }
        
        switch sortType {
        case .byFrequency: cell.setup(with: model.listItems[indexPath.row])
        case .byCategory: cell.setup(with: model.sections[indexPath.section].items[indexPath.row] )
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

extension ExerciseListTableViewController: ExerciseListSegmentedControlDelegate {
    func update(to segment: Int) {
        
        switch segment {
        case 0:
            sortType = .byFrequency
            //don't have to sort because they are already sorted in init()
            //model?.listItems.sort(by: { $0.workoutsUsed > $1.workoutsUsed })
            
        case 1:
            sortType = .byCategory
            model?.sortByCategory()
            
        default:
            return
        }
        
        tableView.reloadData()
    }
}


protocol ExerciseListSegmentedControlDelegate: class {
    func update(to segment: Int)
}

class ExerciseListSegmentedControlHeader: UIView {
    let segmentedControl = UISegmentedControl(items: ["Frequency", "Category"])
    let label = UILabel()
    weak var delegate: ExerciseListSegmentedControlDelegate?
    
    init(delegate: ExerciseListSegmentedControlDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        
        //configure label
        label.text = "Sort by:"
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
        //configure segmented control
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlTap(sender:)), for: .valueChanged)
        segmentedControl.backgroundColor = .white
    }
    
    @objc func segmentedControlTap(sender:UISegmentedControl) {
        delegate?.update(to: sender.selectedSegmentIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}









