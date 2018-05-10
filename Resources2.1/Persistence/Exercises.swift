//
//  Exercises.swift
//  exerciseModel1
//
//  Created by B_Litwin on 1/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData
import Resources_View2_1


final class Exercises: NSManagedObject, HasAnalyticsController {
    
    lazy var infoController: MasterInfoController = {
       return ExerciseController(exercise: self)
    }()
    
    lazy var personalRecordsManager = {
       return RecordsManager(parentClass: self)
    }()
    
    lazy var oneRepMaxManager = {
       OneRepMaxManager(exercise: self)
    }()
    
    var metricInfoSet: Set<Metric_Info> {
        return metric_info as! Set<Metric_Info>
    }
    
    var metricInfo: [Metric_Info] {
        return metricInfoSet.sortedByDefaultOrder
    }
    
    func fetchFromInterval(_ interval: DateInterval) -> [Exercise_Metrics] {
        let request: NSFetchRequest<Exercise_Metrics> = Exercise_Metrics.fetchRequest()
        request.predicate = NSPredicate(
            format: "exercise = %@ && workout.date >= %@ && workout.date <= %@",
            self, interval.start as CVarArg, interval.end as CVarArg)
        let result = try? context.fetch(request)
        return result!
    }

    func exerciseMetrics() -> [Exercise_Metrics] {
        let request: NSFetchRequest<Exercise_Metrics> = Exercise_Metrics.fetchRequest()
        request.predicate = NSPredicate(format: "container.exercise = %@ ",self)
        let result = try? context.fetch(request)
        guard result != nil else { return [] }
        return result!
    }
    
    func metricInfo(for metric: Metric) -> Metric_Info? {
        guard let mi = metricInfoSet.containsMetric(metric) else { return nil }
        return mi
    }
    
    var namePlusVariation: String {
        return (name ?? "") + " " + (variation ?? "")
    }
    
    class func exerciseAlreadyExistsWith(name: String, variation: String) -> Exercises? {
        let request: NSFetchRequest<Exercises> = Exercises.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@ && variation = %@", name, variation)
        let result = try? context.fetch(request)
        guard result != nil else { return nil }
        return result?.first
    }
    
    class func fetchAll(active: Bool = false) -> [Exercises] {
        
        let request: NSFetchRequest<Exercises> = Exercises.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if active == true {
            request.predicate = NSPredicate(format: "isActive = true")
        }
        
        let result = try? context.fetch(request)
        guard let exercises = result else { return [] }
        return exercises
        
    }
    
}


extension Exercises: ExerciseCellData {
    
    //mark: allow exercisePicker model to pick up name, variation data
    
    var categoryName: String {
        return category?.name ?? "" 
    }
}


extension Exercises: CanSetIsActive {
    
    func setExerciseIsActive(to bool: Bool) {
        isActive = bool
        guard let category = category else { return }
        setCategoryActiveState(itemisActive: isActive, category: category)
        saveContext()
    }
    
}

extension Multi_Exercise_Container_Types: CanSetIsActive {
    
    func setExerciseIsActive(to bool: Bool) {
        isActive = bool
        guard let category = category else { return }
        setCategoryActiveState(itemisActive: isActive, category: category)
        saveContext()
    }
    
}

func setCategoryActiveState(itemisActive: Bool, category: Categories) {
    
    if !itemisActive {
        if category.exerciseSet.isEmpty {
            if category.compoundExerciseSet.isEmpty {
                category.isActive = false
            }
        }
        
    } else {
        category.isActive = true
    }
    
}


class ExerciseController: MasterInfoController {
    
    let exercise: Exercises
    
    let updateExerciseAlertTitle = "Edit Exercise"
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }
    
    func loadExerciseUpdateTableView() -> UpdateExerciseTableViewController {
        
        let tableViewController = UpdateExerciseTableViewController()
        
        if let category = exercise.category {
            tableViewController.model = UpdateExercise(exercise: exercise, category: category)
        }
        
        return tableViewController
    }
    
    lazy var infoControllers: [ExerciseInfoController] = {
        return [
            ExerciseGeneralInfoController(exercise: exercise,
                                          updateExerciseController: loadExerciseUpdateTableView),
            ExerciseRecordsController(exercise: exercise),
            ExerciseProgressChartController(exercise: exercise),
            ExerciseRepMaxesController(exercise: exercise),
            ExerciseHistoryModel(exercise: exercise),
            ExerciseSortableTable(exercise: exercise)
        ]
    }()
    
}

class ExerciseGeneralInfoController: ExerciseInfoController, ExerciseInfoModel {
    
    typealias GeneralInfo = ExGeneralInfoSection.GeneralInfo
    
    lazy var model: ExerciseInfoModel? = { return self }()
    
    lazy var viewController: UIViewController = ExerciseAnalyticsTableViewController(model: self)
    
    var updateExerciseController: () -> UpdateExerciseTableViewController
    
    var menuIcon: UIImage = #imageLiteral(resourceName: "list")
    
    var menuTitle: String = "Info"
    
    var displaysInAlertOptions: Bool = false
    
    var displaysInExerciseInfo: Bool = true
    
    var sections: [ExerciseAnalyticsSectionUIPopulator] = []
    
    var needsReload: Bool = true
    
    func loadModel() {
        
        var info: [GeneralInfo] = []
        
        if let name = exercise.name {
            info.append(GeneralInfo.name(name))
        }
        
        if let variation = exercise.variation {
            if !variation.IsEmptyString {
                info.append(GeneralInfo.variation(variation))
            }
        }
        
        info.append(GeneralInfo.edit(showEditExercise))
        
        sections = [ExGeneralInfoSection(info: info)]
        
    }
    
    let exercise: Exercises
    
    init(exercise: Exercises, updateExerciseController: @escaping ()-> UpdateExerciseTableViewController) {
        self.updateExerciseController = updateExerciseController
        self.exercise = exercise
    }
    
    func showEditExercise() {
        
        let tableViewController = updateExerciseController()
        let navControl = UINavigationController()
        navControl.viewControllers = [tableViewController]
        
        tableViewController.updateWorkoutUIAfterSave = { [weak self] in
            //ugly
            if let tableViewC = self?.viewController as? UITableViewController {
                self?.loadModel()
                tableViewC.tableView.reloadData()
            }
        }
        
        viewController.present(navControl, animated: true)
    }

}




class ExerciseRecordsController: ExerciseInfoController {
    
    let exercise: Exercises
    
    lazy var model: ExerciseInfoModel? = RecordsDisplayModel(type: exercise)
    
    lazy var viewController: UIViewController = {
        guard let model = self.model else { return UIViewController() }
        return ExerciseAnalyticsTableViewController(model: model)
    }()
    
    let alertTitle: String = "Personal Records"
    
    let menuIcon: UIImage = #imageLiteral(resourceName: "trending")
    
    var menuTitle: String = "Records"
    
    var displaysInAlertOptions: Bool = true
    
    var displaysInExerciseInfo: Bool = true 
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }

}

class ExerciseProgressChartController: ExerciseInfoController {
    
    lazy var model: ExerciseInfoModel? = nil
    
    let exercise: Exercises
    
    lazy var viewController: UIViewController = {
        let model = OneRepMaxOverTimeModel(exercise: exercise)
        let viewController = OneRMTableViewController(style: .grouped)
        viewController.model = model
        return viewController
    }()
    
    var menuIcon: UIImage = #imageLiteral(resourceName: "chart-1")
    
    var menuTitle: String = "Progress"
    
    var displaysInAlertOptions: Bool = false
    
    var displaysInExerciseInfo: Bool = true
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }
    
    
}


class ExerciseRepMaxesController: ExerciseInfoController, ExerciseInfoModel {
    
    lazy var model: ExerciseInfoModel? = { return self }()
    
    lazy var viewController: UIViewController = { ExerciseAnalyticsTableViewController(model: self) }()

    var menuIcon: UIImage = #imageLiteral(resourceName: "dumbell")
    
    var menuTitle: String = "Rep Maxes"
    
    var displaysInAlertOptions: Bool = false
    
    var displaysInExerciseInfo: Bool = true
    
    var sections: [ExerciseAnalyticsSectionUIPopulator] = []
    
    var needsReload: Bool = true
    
    let exercise: Exercises
    
    func loadModel() {
        let oneRM = exercise.oneRepMaxManager.oneRM?.oneRM ?? 0
        let repMaxModel = RepMaxesModel(oneRepMax: oneRM)
        repMaxModel.loadModel()
        sections = [ExerciseRepMaxesSection(data: repMaxModel)]
    }
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }
    
}



class ExerciseSortableTable: ExerciseInfoController, ExerciseSortableTableModel {
    
    lazy var model: ExerciseInfoModel? = nil
    
    lazy var viewController: UIViewController = {
        let viewController = ExerciseSortableTableViewController()
        viewController.model = self
        return viewController
    }()

    var menuIcon: UIImage = #imageLiteral(resourceName: "search")
    
    var menuTitle: String = "Search"
    
    var displaysInAlertOptions: Bool = false
    
    var displaysInExerciseInfo: Bool = true
    
    //unnecessary 
    //var sections: [ExerciseAnalyticsSectionUIPopulator] = []
    
    var needsReload: Bool = true
    
    var tableMenuHeaders: [String] = []
    
    var tableData: [(date: Date, dataItems: [Double])] = []
    
    func loadModel() {
        let metrics = exercise.metricInfoSet.sortedByDefaultOrder
        tableMenuHeaders = ["Date"] + metrics.map({ $0.metric.rawValue })
        exerciseMetrics = exercise.exerciseMetrics()
        reloadData(for: 0)
    }
    
    func reloadData(for num: Int) {
        
        let metrics = exercise.metricInfoSet.sortedByDefaultOrder
        let metricsSortDescriptors = metrics.map({ $0.sortDescriptor })
        var dateSortDescriptor = Exercise_Metrics.dateSortDescriptor()
        sortDescriptors = [dateSortDescriptor] + metricsSortDescriptors
        
        switch num {
            
        case 0 :
            break
            
        default:
            
            let firstSortDescriptor = sortDescriptors[num]
            guard let index = sortDescriptors.index(of: firstSortDescriptor) else { return }
            sortDescriptors.remove(at: index)
            dateSortDescriptor = sortDescriptors.removeFirst()
            sortDescriptors.insert(firstSortDescriptor, at: 0)
            sortDescriptors.append(dateSortDescriptor)
            
        }
        
        exerciseMetrics = exerciseMetrics.sort(by: sortDescriptors)
        tableData = exerciseMetrics.map({ (date: $0.date, dateItems: $0.valuesSortedByDefaultOrder) })
        
    }
    
    let exercise: Exercises
    
    var exerciseMetrics: [Exercise_Metrics] = []
    
    var sortDescriptors: [NSSortDescriptor] = []
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }
    
    
}

class ExerciseHistoryModel: ExerciseInfoController, ExerciseInfoModel {
    
    var model: ExerciseInfoModel? { return self }

    lazy var viewController: UIViewController = { ExerciseAnalyticsTableViewController(model: self) }()
    
    var alertTitle: String = "Exercise History"
    
    var menuIcon: UIImage = #imageLiteral(resourceName: "history")
    
    var menuTitle: String = "History"
    
    var displaysInAlertOptions: Bool = false
    
    var displaysInExerciseInfo: Bool = true
    
    var sections: [ExerciseAnalyticsSectionUIPopulator] = []
    
    var needsReload: Bool = true
    
    func loadModel() {
        sections = []
        let workouts = Workouts.fetchAll()
        workouts.forEach({
            let em = $0.exerciseMetricsSet.sorted(by: { $0.set_number < $1.set_number })
            let emDisplayStrings = em.map({ $0.displayString() })
            sections.append(ExerciseHistorySection(date: $0.date, exerciseMetrics: emDisplayStrings))
        })
        
    }
    
    let exercise: Exercises
    
    init(exercise: Exercises) {
        self.exercise = exercise
    }
    
}













