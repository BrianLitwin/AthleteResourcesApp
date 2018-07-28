//
//  MasterVCViewController.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/19/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

import Resources_View2_1

class MasterVC: UIViewController, ContainerViewController {
    var currentVCIndex = 0
    let exampleD =  GetWorkoutsFromServer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
        if firstLaunch != true {
            setupExercisesInDatabase()
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
        
        //exampleD.getWorkoutsFromBackend()
        let exampleData = ExampleData()
        changeViewController(index: currentVCIndex)
    }
    
    func childVCs() -> [UIViewController] {
        return [currentWorkout, createNewWorkout, searchExercises, createMenu, exerciseList, workoutHistory, bodyweight]
    }
    
    func setupViewControllerFrame(for viewController: UIViewController) {
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    lazy var dashboard: DashboardTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "DashboardTableViewController") as! DashboardTableViewController
        return viewController
    }()
    
    lazy var currentWorkout: WorkoutViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "WorkoutViewController") as! WorkoutViewController
        return viewController
    }()
    
    lazy var createMenu: CreateMenuTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var tableViewController = storyboard.instantiateViewController(withIdentifier: "CreateMenu") as! CreateMenuTableViewController
        return tableViewController
    }()
    
    lazy var workoutHistory: WorkoutHistoryTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var tableViewController = storyboard.instantiateViewController(withIdentifier: "WorkoutHistoryTableViewController") as! WorkoutHistoryTableViewController
        let model = WorkoutHistoryModel()
        tableViewController.setup(with: model)
        return tableViewController
    }()
    
    lazy var createNewWorkout: CreateNewWorkoutAlertController = {
        let alertController = CreateNewWorkoutAlertController(title: "Start New Workout?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "New Workout", style: .default){
            
            [weak self] action in //imperfect
            
            guard let strongSelf = self else { return }
            
            guard let index = strongSelf.childVCs().index(where: {
                [weak self]
                in $0 === self?.currentWorkout
                
            }) else { return }
        
            let newWorkout = Workouts.createNewWorkout()
            strongSelf.currentWorkout.setup(for: newWorkout)
            strongSelf.changeViewController(index: 0)
            
            //do this for editing workout info too 
            
        })
        
        return alertController
    }()
    
    lazy var searchExercises: ExerciseSearchViewController = {
        let viewController = ExerciseSearchViewController()
        let model = SearchExercisesModel()
        viewController.model = model
        return viewController
    }()
    
    lazy var exerciseList: ExerciseListTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var tableVC = storyboard.instantiateViewController(withIdentifier: "ExerciseListTableViewController") as! ExerciseListTableViewController
        let model = ExerciseListModel()
        tableVC.model = model
        return tableVC
    }()
    
    lazy var bodyweight: BodyweightViewController = {
        let vc = BodyweightViewController(style: .grouped)
        vc.model = BodyweightAnalyticsModel()
        return vc
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let vc = childViewControllers.first, let child = vc as? ChildVC {
            self.navigationController?.title = child.name
        } else {
            self.navigationController?.title = ""
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.title = ""
    }
    
}



extension WorkoutViewController: ChildVC {
    
    var menuBarImage: UIImage {
        return #imageLiteral(resourceName: "dumbell")
    }
    
    var name: String {
        return "Current Workout"
    }
    
}

extension CreateMenuTableViewController: ChildVC {
    var menuBarImage: UIImage {
       return #imageLiteral(resourceName: "create")
    }
    
    public var name: String {
        return "Manage Exercises"
    }
}

extension DashboardTableViewController: ChildVC {
    public var menuBarImage: UIImage {
       return #imageLiteral(resourceName: "history")
    }
    
    public var name: String {
        return "Dashboard"
    }
}

extension WorkoutHistoryTableViewController: ChildVC {
    public var menuBarImage: UIImage {
       return #imageLiteral(resourceName: "history")
    }
    
    public var name: String {
        return "Workout History"
    }
}

extension CreateNewWorkoutAlertController: ChildVC {
    var menuBarImage: UIImage {
       return #imageLiteral(resourceName: "add_circle")
    }
    
    public var name: String {
        return "New Workout"
    }
}

extension ExerciseSearchViewController: ChildVC {
    public var menuBarImage: UIImage {
       return #imageLiteral(resourceName: "search")
    }
    
    public var name: String {
        return "Search Exercises"
    }
}

extension ExerciseListTableViewController: ChildVC {
    public var menuBarImage: UIImage {
        return #imageLiteral(resourceName: "folder")
    }
    
    public var name: String {
        return "Exercise List"
    }
}

extension BodyweightViewController: ChildVC {
    public var menuBarImage: UIImage {
       return #imageLiteral(resourceName: "create")
    }
    
    public var name: String {
        return "Bodyweight"
    }
}


class CreateNewWorkoutAlertController: UIAlertController {
    
}




