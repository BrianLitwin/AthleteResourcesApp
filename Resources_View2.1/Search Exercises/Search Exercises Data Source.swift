//
//  Search Exercises Data Source.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

//todo: search not working correctly

import UIKit

class SearchExercisesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let model: ExerciseSearchModel
    
    let tableView: UITableView
    
    let searchBar: UISearchBar
    
    private var exerciseSearchText = "Exercises"
    
    private var categorySearchText = "Categories"
    
    init(model: ExerciseSearchModel, tableView: UITableView, searchBar: UISearchBar) {
        self.model = model
        self.tableView = tableView
        self.searchBar = searchBar
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    //search bar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.filterByExercise(with: searchBar.text ?? "")
        tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        model.filterByExercise(with: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        //search w/ empty text i.e. clear search
        model.filterByExercise(with: "")
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
        header.textLabel?.textColor = Colors.TableView.sectionHeader
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath) as! TableViewCellWithSubtitle
        let cellData = item(at: indexPath)
        cell.textLabel?.text = cellData.name
        cell.detailTextLabel?.text = cellData.variation
        cell.accessoryType = .checkmark
        cell.tintColor = Colors.SearchExercises.checkmarkTint(highlighted: cellData.isActive)
        return cell
    }
    
    //
    // redundant
    //
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
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



