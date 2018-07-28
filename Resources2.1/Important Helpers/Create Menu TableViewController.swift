
//
//  Create Menu TableViewController.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/27/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

//creating a lot of the same resources for both of these

//work on this

//make more organized

//this is all pretty terrible

//selecting a category is broken

//todo: compound exerciseBuilder: no categories to choose from

//todo: categories picker should not be grouped table view

//does "select a category" make sense for a complex?

//isn't complex it's own category?


class CreateMenuTableViewController: UITableViewController {
    
    let reuseID = "cell"
    
    var headers = ["Exercise", "Compound Exercise"]
    
    lazy var categoriesPicker = CategoriesPicker()
    
    lazy var updateExerciseTableViewController: UpdateExerciseTableViewController = {
       return UpdateExerciseTableViewController()
    }()
    
    lazy var updateExerciseNavControl: UINavigationController = {
       return UINavigationController(rootViewController: updateExerciseTableViewController)
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.separatorColor = UIColor.init(white: 1, alpha: 0.3)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Create"
        case 1: return "Delete"
        default: return ""
        }
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        cell.textLabel?.text = headers[indexPath.row]
        return cell
    }
 
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //clear cell highlighting
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.isSelected = false
        }
        
        switch indexPath.row {
            
        case 0:
            
            //let updateExercise = UpdateExerciseTableViewController() // could clear out all daya from all table and use a constant, but will do for now
            
            let alert = UIAlertController(title: "Select a category", message: nil, preferredStyle: .alert)
            alert.set(vc: categoriesPicker, height: 400)
            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .default,
                                          handler: { action in self.dismiss(animated: true)}
            ))
            
            alert.show()
            
            categoriesPicker.categorySelected = {
                [weak self]  category in
                guard let strongSelf = self else { return }
                alert.dismiss(animated: true) {
                    
                    let model = UpdateExercise(exercise: nil, category: category)
                    strongSelf.updateExerciseTableViewController.model = model
                    strongSelf.present(strongSelf.updateExerciseNavControl, animated: true)
                    
                }

            }
            
        case 1:
            
            let navControl = CompoundExerciseBuilderNavivagationController()
            navControl.setup(windowManager: WindowManager(), preExistingType: nil)
            navControl.navigationBar.tintColor = Colors.CreateMenus.CompoundExercise.navbarTint 
            present(navControl, animated: true)
            
        case 2:
            postData() {
                response in
                return 
            }
            
        default:
            break 
            
        }

    }
    
    override public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = Colors.TableView.sectionHeader
    }

}




class CompoundExerciseBuilderNavivagationController: UINavigationController {
    var preExistingType: Multi_Exercise_Container_Types?
    weak public var reloadUIDelegate: ReloadsWorkoutUI?
    var windowManager: WindowManager?
    var doneBtn: UIBarButtonItem?
    lazy var categoriesPicker = CategoriesPicker()
    
    lazy var tableViewController =
        MultiExerciseBuilderTableViewController(model: compoundExerciseBuilderModel)
    
    lazy var compoundExerciseBuilderModel = CompoundExerciseBuilderModel()
    
    lazy var exercisePickerModel =
        ExercisePickerDropDownModel(includeMultiExerciseContainer: false)
    
    lazy var exercisePicker =
        ExercisePickerTableView(model: exercisePickerModel)
    
    func setup(windowManager: WindowManager, preExistingType: Multi_Exercise_Container_Types?) {
        self.preExistingType = preExistingType
        self.windowManager = windowManager
    }
    
    override func viewDidLoad() {
        
        setupNavBarBtns()
        
        viewControllers = [tableViewController]
        
        exercisePicker.insertHandler = {
            [weak self] indexPath in
            guard let strongSelf = self else { return }
            guard let exercise =
                strongSelf.exercisePickerModel.exercises[indexPath.section][indexPath.row] as? Exercises else { return }
            strongSelf.compoundExerciseBuilderModel.add(exercise: exercise)
            strongSelf.exercisePicker.resignSelf = nil
        }
    }
    
    func setupNavBarBtns() {
        doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTap))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doneBtnTap))
        tableViewController.navigationItem.rightBarButtonItem = doneBtn
        tableViewController.navigationItem.leftBarButtonItem = cancelBtn
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if preExistingType != nil {
            setupForPreExistingType()
        } else {
            setupForNewType()
        }
    }
    
    func setupForNewType() {
        let alert = UIAlertController(title: "Select a category", message: nil, preferredStyle: .alert)
        alert.set(vc: categoriesPicker, height: 400)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .default,
                                      handler: { action in self.dismiss(animated: true)}
        ))
        
        categoriesPicker.categorySelected = {
            
            [weak self] category in
            
            guard let strongSelf = self else { return }
            strongSelf.compoundExerciseBuilderModel.categorySelected(category)
            strongSelf.categoriesPicker.categorySelected = nil
            alert.dismiss(animated: true)
            strongSelf.showExercisePicker()
        }
        
        present(alert, animated: true)
    }
    
    func setupForPreExistingType() {
        showExercisePicker()
    }
    
    func showExercisePicker() {
        windowManager?.show(.exercisePicker(view: exercisePicker,
                                            showTintScreen: false,
                                            addSwipeDownGestureRecognizer: false))
    }

    
    @objc func cancelBtnTap() {
        windowManager?.resignCurrentView()
        dismiss(animated: true)
    }
    
    @objc func doneBtnTap() {
        compoundExerciseBuilderModel.saveCompoundExercise()
        windowManager?.resignCurrentView()
        dismiss(animated: true)
        
    }
}

















































