//
//  Exercise Search.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/20/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

import Resources_View2_1

class SearchExercisesModel: ExerciseSearchModel {
    
    var sections: [CategorySection] = []
    
    var filteredSections: [CategorySection] = []
    
    init() {
        
        let categories = Categories.fetchAll()
        var sections: [CategorySection] = []
        
        categories.forEach({
            let exercises = $0.exerciseSet.sortedAlpabetically() as [CategorySection.ExerciseData]
            let compoundExercises = $0.compoundExerciseSet.sorted(by:
            { ($0.name ?? "") < ($1.name ?? "")}) as [CategorySection.ExerciseData]
            let allEx: [CategorySection.ExerciseData] = exercises + compoundExercises
            if !allEx.isEmpty {
                let section = CategorySectionClass($0, exercises: allEx)
                sections.append(section)
            }
        })
        
        self.sections = sections 
        filteredSections = sections
    }
    
    func filterByExercise(with text: String) {
        sections.forEach({
            $0.filterExercises(with: text)
        })
        
        filteredSections = sections.filter({
            !$0.filteredExercises.isEmpty
        })
    }
    
    func filterByCategory(with text: String) {
        sections.filter({
            $0.name.contains(text)
        })
    }
}

class CategorySectionClass: CategorySection {
    
    let name: String
    
    let exercises: [ExerciseData]
    
    var filteredExercises: [ExerciseData] = []
    
    init(_ category: Categories, exercises: [ExerciseData]) {
        self.exercises = exercises
        self.name = category.name ?? ""
        filteredExercises = exercises
    }
    
    func filterExercises(with text: String) {
        
        filteredExercises = exercises.filter({
            ($0.name ?? "").lowercased().contains(text.lowercased())
        })
        
    }
    
}

class SearchExerciseCellDataModel: ExerciseCellData {
    
    let cellData: ExerciseCellData
    
    let type: DataType
    
    var name: String? {
        return cellData.name
    }
    
    var variation: String? {
        return cellData.variation
    }
    
    var categoryName: String {
        return cellData.categoryName
    }
    
    init(cellData: ExerciseCellData, type: DataType) {
        self.cellData = cellData
        self.type = type
    }
    
    enum DataType {
        case exercise(Exercises)
        case compoundExercise(Multi_Exercise_Container_Types)
        
        func save() {
            
            switch self {
                
            case .exercise(let exercise):
                break
                
            case .compoundExercise(let containerType):
                break
                
                
            }
            
        }
        
    }
    
    
}



/*

class ExerciseSearch: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var tableView: UITableView = UITableView()
    var exercises = [Exercises]()
    var filteredExercises = [Exercises]()
    let searchController = UISearchController(searchResultsController: nil)
    let reuseID = "cell"
    private var exerciseSearchText = "Exercises"
    private var categorySearchText = "Categories"
    
    // MARK: - View Setup
    override func viewDidLoad() {
        
        super.viewDidLoad()
        exercises = Exercises.fetch(.all).sortedWithNumbersLast()
        setupSearchBar()
        setupTableView()
        setupNavBarButton()
        
    }
    
    func setupSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Exercises"
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = [exerciseSearchText, categorySearchText]
        searchController.searchBar.delegate = self
        
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseID)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableHeaderView?.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.frame.width,
                                                  height: 60)
        
    }

    
    func setupNavBarButton() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf ))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func dismissSelf() {
        self.navigationController!.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredExercises.count
        }
        return exercises.count
    }
    
    func returnExercise(indexPath: IndexPath) -> Exercises {
        return isFiltering() ? filteredExercises[indexPath.row] : exercises[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SearchCell
        
        let exercise = returnExercise(indexPath: indexPath)
        cell.exercise = exercise
       
        return cell
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        switch  scope {
            
        case exerciseSearchText:
            
            switch isFiltering() {
                
            case true:
                filteredExercises = exercises.filter({( exercise : Exercises ) -> Bool in
                    return exercise.name!.lowercased().contains(searchText.lowercased())
                })
                
            case false:
                exercises = exercises.sortedWithNumbersLast()
            }
            
        case categorySearchText:
            
            switch isFiltering() {
                
            case true:
                filteredExercises = exercises.filter({( exercise : Exercises ) -> Bool in
                    return exercise.category!.name!.lowercased().contains(searchText.lowercased())
                })
                
            case false:
                exercises = exercises.sortedByCategory()
            }
            
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercise = returnExercise(indexPath: indexPath)
        exercise.isActive = !exercise.isActive
        if exercise.isActive {
            exercise.category?.isActive = true
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        checkIfExerciseIsLastActiveInCategory(exercise: exercise)
        try? context.save()
    }
    
    func checkIfExerciseIsLastActiveInCategory(exercise: Exercises) {
        if !exercise.isActive {
            
            var categoryActive = true
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let activeExs = exercise.category!.exerciseSet.active()
                if activeExs.count < 1 {
                    categoryActive = false
                }
                
                DispatchQueue.main.sync { 
                    exercise.category!.isActive = categoryActive
                }
            }
        }
    }
    
    deinit {
        self.searchController.view.removeFromSuperview()
    }

}



extension ExerciseSearch: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ExerciseSearch: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}



class SearchCell: BaseTableViewCell {
    
    //FIX ME: update to use native cell  
    
    let titleAndDetail = TitleAndDetailStackview()
    var categoryLabel: UILabel = {
        let l = UILabel()
        l.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: UILayoutConstraintAxis.horizontal)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    var exercise: Exercises! {
        didSet {
            selectionBox.tintColor = exercise.isActive ? UIColor.yellow : UIColor.darkGray
            titleAndDetail.title = exercise.name!
            titleAndDetail.detail = exercise.variation
            categoryLabel.text = exercise.category!.name!
            categoryLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleAndDetail.trailingAnchor).isActive = true
            
        }
    }
    
    private var selectionBox: UIImageView = {
        let image = #imageLiteral(resourceName: "check").template()
        let iv = UIImageView(image: image).enabled()
        iv.tintColor = UIColor.darkGray
        iv.layer.borderColor = UIColor.darkGray.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    override func setupViews() {
        
    }

}


*/


