//
//  TableViewController.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/4/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public class UpdateExerciseTableViewController: DefaultTableViewController {

    public var updateWorkoutUIAfterSave: (() -> Void)?
    
    public var model: UpdateExerciseModel? {
        didSet {
            guard let model = self.model else { return }
            let exerciseName = model.exerciseInfo.exerciseInfo.name
            title = exerciseName.IsEmptyString ? "Create Exercise" : "Edit Exercise"
            collapsibleSectionModel = CollapsibleModel(count: model.pendingUpdateModels.count)
        }
    }
    
    var doneBtn: UIBarButtonItem?
    
    var collapsibleSectionModel: CollapsibleModel?
    
    public init() {
        
        super.init(style: .grouped)
        tableView.separatorInset = .zero
        setupDefaultColorScheme()
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.register(UpdateExerciseMetricTableViewCell.self, forCellReuseIdentifier: UpdateExerciseMetricTableViewCell.reuseID)
        tableView.register(UpdateExerciseMetricDropdownTableViewCell.self, forCellReuseIdentifier: UpdateExerciseMetricDropdownTableViewCell.reuseID)
        tableView.register(UpdateExerciseNVITableViewCell.self, forCellReuseIdentifier: UpdateExerciseNVITableViewCell.reuseID)
        tableView.register(UpdateExerciseInstructionsHeader.self, forHeaderFooterViewReuseIdentifier: UpdateExerciseInstructionsHeader.reuseID)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //a little padding at the bottom 
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200))
        
        //Mark: IOS 11 work around
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTap))
        doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTap))
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = doneBtn
        cancelBtn.tintColor = Colors.UpdateExerciseInfo.cancelBtnTint
        doneBtn?.tintColor = Colors.UpdateExerciseInfo.doneBtnTint 
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setDefaultColorScheme()
        
        //short term fix for resetting the views
        tableView.reloadData()
    }
    
    override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return 75
        default: return 44
        }
    }
    
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        guard section == 1 else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: UpdateExerciseInstructionsHeader.reuseID) as! UpdateExerciseInstructionsHeader
        return header

    }
    
    @objc func cancelBtnTap() {
        dismiss(animated: true)
    }
    
    @objc func doneBtnTap() {
        if let unableToSequeReason = model?.incompleteInformation() {
            let alert = UIAlertController(title: unableToSequeReason, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            
        } else {
            model?.saveAllChanges()
            updateWorkoutUIAfterSave?()
            dismiss(animated: true)
            
        }
        
    }
    
    @objc func systemKeyboardWillShow() {
        doneBtn?.isEnabled = false
    }
    
    @objc func systemKeyboardWillHide() {
        doneBtn?.isEnabled = true
    }
    

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return collapsibleSectionModel?.expandedSections.count ?? 0
        default: return 0
        }
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UpdateExerciseNVITableViewCell.reuseID, for: indexPath) as! UpdateExerciseNVITableViewCell
            
            cell.selectionStyle = .none
            
            guard let exerciseInfo = model?.exerciseInfo else { return cell }
            
            switch indexPath.row {
                
            case 0:
                cell.textfield.text = exerciseInfo.exerciseInfo.name
                cell.setTextfieldPlaceholder("Exercise Name")
                cell.saveText = {
                    text in
                    exerciseInfo.updateName(with: text)
                }
                
            case 1:
                cell.textfield.text = exerciseInfo.exerciseInfo.variation
                cell.setTextfieldPlaceholder("Exercise Variation")
                cell.saveText = {
                    text in
                    exerciseInfo.updateVariation(with: text)
                }
                
            case 2:
                cell.textfield.text = exerciseInfo.exerciseInfo.instructions
                cell.setTextfieldPlaceholder("Exercise Instructions")
                cell.saveText = {
                    text in
                    exerciseInfo.updateInstructions(with: text)
                }
                
                
            default:
                break
                
            }
            return cell
            
        } else {
            return configureCollapsibleSectionCell(for: indexPath)
        }
    }
    
    func configureCollapsibleSectionCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let sectionModel = collapsibleSectionModel else { return UITableViewCell() }
        let row = indexPath.row
        let isSubsection = sectionModel.expandedSections[row]
        let originalIndex = sectionModel.offsetIndexes[row]
        let cellDelegate = model?.pendingUpdateModels[originalIndex]
        
        switch isSubsection {
            
        case true:
            let cell = tableView.dequeueReusableCell(withIdentifier: UpdateExerciseMetricDropdownTableViewCell.reuseID, for: indexPath) as! UpdateExerciseMetricDropdownTableViewCell
            cell.delegate = cellDelegate
            return cell 
            
        case false:
            let cell = tableView.dequeueReusableCell(withIdentifier: UpdateExerciseMetricTableViewCell.reuseID, for: indexPath) as! UpdateExerciseMetricTableViewCell
            cell.selectionStyle = .none
            cell.delegate = cellDelegate
            cell.moreInfoDelegate = self
            return cell
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UpdateExerciseNVITableViewCell {
            cell.textfield.becomeFirstResponder()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



extension UpdateExerciseTableViewController: DropDownButtonDelegate {
    
    func cellDropDownPressed(for cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let sectionModel = collapsibleSectionModel else { return }
        let expandSubSection = sectionModel.toggle(section: indexPath.row)
        let indexPaths: [IndexPath] = [[indexPath.section, indexPath.row + 1]]
        
        if expandSubSection {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } else {
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
}























