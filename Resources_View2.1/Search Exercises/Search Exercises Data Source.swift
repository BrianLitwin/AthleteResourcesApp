//
//  Search Exercises Data Source.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class SearchExercisesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let model: ExerciseSearchModel
    
    let tableView: UITableView
    
    let searchController: UISearchController
    
    private var exerciseSearchText = "Exercises"
    
    private var categorySearchText = "Categories"
    
    init(model: ExerciseSearchModel, searchController: UISearchController, tableView: UITableView) {
        self.model = model;
        self.searchController = searchController
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func section(at section: Int) -> CategorySection {
        if isFiltering() {
            return model.filteredSections[section]
        }
        
        let section = model.sections[section]
        return section
    }
    
    func item(at indexPath: IndexPath) -> CategorySection.ExerciseData {
        if isFiltering() {
            let section = model.filteredSections[indexPath.section]
            return section.filteredExercises[indexPath.row]
        }
        
        let section = model.sections[indexPath.section]
        return section.exercises[indexPath.row]
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.brightTurquoise()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.section(at: section)
        return section.name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return model.filteredSections.count
        }
        
        return model.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            let section = model.filteredSections[section]
            return section.filteredExercises.count
        }
        
        let section = model.sections[section]
        return section.exercises.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchExerciseTableViewCell.reuseID, for: indexPath) as! SearchExerciseTableViewCell
        
        let cellData = item(at: indexPath)
        cell.cell.textLabel?.text = cellData.name
        cell.cell.detailTextLabel?.text = cellData.variation
        cell.checkBox.tintColor = cellData.isActive ? UIColor.brightTurquoise() : UIColor(white: 1, alpha: 0.5)
        return cell
    }
    
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        guard isFiltering() else { return }
        
        switch scope {
            
        case exerciseSearchText: model.filterByExercise(with: searchText)
        case categorySearchText: model.filterByCategory(with: searchText)
        default: break
            
        }
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = item(at: indexPath)
        cellData.setExerciseIsActive(to: !cellData.isActive)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    /*
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
     */
    
    
    
}


