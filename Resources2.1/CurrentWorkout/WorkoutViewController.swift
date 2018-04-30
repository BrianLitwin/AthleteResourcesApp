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
    
    var notificationHandler: WorkoutControllerNotificationhandler?
    
    var currentWorkout: Workouts?
    
    var currentlySelectedMasterInfoController: MasterInfoController?
    
    lazy var scrollView: ScrollView =
        ScrollView(frame: view.bounds,
                   footerBtnTap: {
                        [weak self] in
                        guard let strongSelf = self else { return }
                        guard let workout = strongSelf.currentWorkout else { return }
                        strongSelf.showExercisePicker(for: workout.sequenceSet.count) }
    )
    
    lazy var windowManager: WindowManager = {
        getWindowManagerFromNavControl() ?? WindowManager()
    }()
    
    lazy var exercisePickerModel = ExercisePickerDropDownModel(includeMultiExerciseContainer: true)
    
    lazy var exercisePicker = ExercisePickerTableView(model: exercisePickerModel)
    
    var workoutHeaderModel: WorkoutHeaderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.workoutBackground()
        notificationHandler = WorkoutControllerNotificationhandler(viewController: self)
        updateUIHandler = UpdateWorkoutUIClass(workoutController: self)
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
        
        workoutHeaderModel = newHeaderModel
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
    }
    
    
    func insertSequence(withSelection: IndexPath, at sectionNumber: Int) {
        
        let indexPath = withSelection
        
        guard let workout = currentWorkout else { return }
        
        let newEntry = exercisePickerModel.exercises[indexPath.section][indexPath.row]
        
        if let exercise = newEntry as? Exercises {
            
            let newSequence = workout.addNewSequence(at: sectionNumber, with: exercise)
            let sequenceModel = WorkoutSequenceModel(sequence: newSequence)
            addSequenceToView(at: sectionNumber, with: sequenceModel)
            
            
        }
            
        else if let compoundExercise = newEntry as? Multi_Exercise_Container_Types {
            
            let newSequence = workout.addNewSequence(at: sectionNumber,
                                                     multiExerciseType: compoundExercise)
            
            let sequenceModel = CompoundExerciseModel(sequence: newSequence)
            addSequenceToView(at: sectionNumber, with: sequenceModel)
            
        }
        
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
    
    
}











