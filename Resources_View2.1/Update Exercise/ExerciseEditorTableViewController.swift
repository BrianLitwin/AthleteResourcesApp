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
        //patch for now - put a method in protocol to set view controller's title
        didSet {
            guard let model = self.model else { return }
            let exerciseName = model.exerciseInfo.exerciseInfo.name
            title = exerciseName.IsEmptyString ? "Create Exercise" : "Edit Exercise"
        }
    }
    
    var doneBtn: UIBarButtonItem?
    
    public init() {
        
        super.init(style: .grouped)
        setupDefaultColorScheme()
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.register(UpdateExerciseMetricTableViewCell.self, forCellReuseIdentifier: UpdateExerciseMetricTableViewCell.reuseID)
        tableView.register(UpdateExerciseNVITableViewCell.self, forCellReuseIdentifier: UpdateExerciseNVITableViewCell.reuseID)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTap))
        
        doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTap))
        
        self.navigationItem.leftBarButtonItem = cancelBtn

        self.navigationItem.rightBarButtonItem = doneBtn
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setDefaultColorScheme()
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
        case 1: return model?.pendingUpdateModels.count ?? 0
        default: return 0
        }
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UpdateExerciseNVITableViewCell.reuseID, for: indexPath) as! UpdateExerciseNVITableViewCell
            
            cell.backgroundColor = UIColor.lighterBlack()
            
            cell.selectionStyle = .none
            
            guard let exerciseInfo = model?.exerciseInfo else { return cell }
            
            switch indexPath.row {
                
            case 0:
                
                cell.textField.text = exerciseInfo.exerciseInfo.name
                
                cell.setTextfieldPlaceholder("Exercise Name")
                
                cell.saveText = {
                    text in
                    exerciseInfo.updateName(with: text)
                }
                
            case 1:
                
                cell.textField.text = exerciseInfo.exerciseInfo.variation
                
                cell.setTextfieldPlaceholder("Exercise Variation")
                
                cell.saveText = {
                    text in
                    exerciseInfo.updateVariation(with: text)
                }
                
            case 2:
                
                cell.textField.text = exerciseInfo.exerciseInfo.instructions
                
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
        
            let cell = tableView.dequeueReusableCell(withIdentifier: UpdateExerciseMetricTableViewCell.reuseID, for: indexPath) as! UpdateExerciseMetricTableViewCell
            
            cell.backgroundColor = UIColor.lighterBlack()
            
            cell.label.textColor = UIColor.groupedTableText()
            
            cell.selectionStyle = .none
            
            cell.delegate = model?.pendingUpdateModels[indexPath.row]

            return cell
            
        }
        
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UpdateExerciseNVITableViewCell {
            cell.textField.becomeFirstResponder()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
