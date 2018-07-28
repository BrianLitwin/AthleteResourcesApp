//
//  CurrentWorkout ViewObject.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/15/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1




class WorkoutViewController: UIViewController, WorkoutController, ReloadWorkoutDelegate {
    var reloadWorkoutHandler: WorkoutReloadHandler?
    var updateUIHandler: ReloadsWorkoutUI?
    var currentWorkout: Workouts?
    var currentlySelectedMasterInfoController: MasterInfoController?
    var lefthandNavbarBtn: UIBarButtonItem?
    
    lazy var floatingDumbell: FloatingDumbellView = {
        return FloatingDumbellView()
    }()
    
    lazy var scrollView: ScrollView =
        ScrollView(frame: view.bounds,
                   footerBtnTap: {
                        [weak self] in
                        guard let strongSelf = self else { return }
                        guard let workout = strongSelf.currentWorkout else { return }
                        strongSelf.showExercisePicker(for: workout.sequenceSet.count) }
    )
    
    lazy var windowManager: WindowManager = { getWindowManagerFromNavControl() ?? WindowManager() }()
    lazy var exercisePickerModel = ExercisePickerDropDownModel(includeMultiExerciseContainer: true)
    lazy var exercisePicker = ExercisePickerTableView(model: exercisePickerModel)
    
    var workoutHeaderModel: WorkoutHeaderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.CurrentWorkout.background 
        view.insertSubview(scrollView, at: 0)
        reloadWorkoutHandler = WorkoutReloadHandler(delegate: self)
        
        let workout = currentWorkout ??
            Workouts.fetchLast() ??
            Workouts.createNewWorkout()
       
        setup(for: workout)
    }
    
    func setup(for workout: Workouts) {
        currentWorkout = workout
        scrollView.removeAllSubviewsFromContentView()
        let newHeaderModel = WorkoutHeaderModel(workout: workout,
                                                delegate: scrollView.header)
        
        //send the header the delegate so that it will update when you change the workout date .
        workoutHeaderModel = newHeaderModel
        let header = scrollView.header
        scrollView.header.setup(info: newHeaderModel)

        workout.orderedSequences.forEach({
            if $0.multi_exercise_container_type == nil {
                let model = WorkoutSequenceModel(sequence: $0)
                addSequenceToView(at: $0.workoutOrder, with: model)
            } else {
                let model = CompoundExerciseModel(sequence: $0)
                addSequenceToView(at: $0.workoutOrder, with: model)
            }
        })
        
        
        if let sequences = workout.sequences, sequences.count == 0 {
            setEmptyView(add: true)
        }
    }
    
    
    func setEmptyView(add: Bool = false) {
        
        func addView() {
            view.addSubview(floatingDumbell)
            floatingDumbell.translatesAutoresizingMaskIntoConstraints = false
            floatingDumbell.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            floatingDumbell.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            floatingDumbell.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            floatingDumbell.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
        
        if !add {
            if scrollView.subviews.count <= 3 {
                addView()
            } else {
                floatingDumbell.removeFromSuperview()
            }
        } else {
            addView()
        }
    }

    
    func insertSequence(withSelection: IndexPath, at sectionNumber: Int) {
        let indexPath = withSelection
        guard let workout = currentWorkout else { return }
        
        //make sure array indexes don't crash
        guard exercisePickerModel.exercises.indices.contains(indexPath.section) else { return }
        guard exercisePickerModel.exercises[indexPath.section].indices.contains(indexPath.row) else { return }
        let newEntry = exercisePickerModel.exercises[indexPath.section][indexPath.row]
        
        if let exercise = newEntry as? Exercises {
            
            let newSequence = workout.addNewSequence(at: sectionNumber, with: exercise)
            let sequenceModel = WorkoutSequenceModel(sequence: newSequence)
            addSequenceToView(at: sectionNumber, with: sequenceModel)
            
        } else if let compoundExercise = newEntry as? Multi_Exercise_Container_Types {
            
            let newSequence = workout.addNewSequence(at: sectionNumber,
                                                     multiExerciseType: compoundExercise)
            let sequenceModel = CompoundExerciseModel(sequence: newSequence)
            addSequenceToView(at: sectionNumber, with: sequenceModel)
        }
        
        setEmptyView()
    }
    
    func segueToExerciseDetail(with exerciseInfo: MasterInfoController) {
        currentlySelectedMasterInfoController = exerciseInfo
        performSegue(withIdentifier: "segueToExerciseDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let exerciseDetail = segue.destination as? ExerciseInfoViewController {
            exerciseDetail.exerciseInfo = currentlySelectedMasterInfoController
            currentlySelectedMasterInfoController = nil 
        }
    }
    
    @objc func currentWorkoutSettings() {
        workoutHeaderModel?.showEditOptions()
    }
    
    //setup and tear down the navigationBar lefthand item
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationItem.leftBarButtonItem = lefthandNavbarBtn
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.leftBarButtonItem = nil
    }
}


func twoLineNavBarTitle(firstLine: String, secondLine: String) -> UILabel {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = .center
    label.text = "\(firstLine) \(secondLine)"
    return label
}






