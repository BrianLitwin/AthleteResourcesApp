//
//  newWorkout.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit




public class ExerciseSearchViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Properties
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    public var model: ExerciseSearchModel?
    var tableViewDataSource: SearchExercisesDataSource?
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Setup
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        //setupSearchBar()
        setupTableView() 
        
        tableView.backgroundColor = UIColor.lighterBlack()
        tableView.separatorColor = UIColor.init(white: 1, alpha: 0.3)
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        //let leftNavBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(showSearchBar))
        //self.navigationController?.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    @objc func showSearchBar() {
        
        let leftNavBarButton = UIBarButtonItem(customView: searchController.searchBar)
        self.navigationController?.navigationItem.leftBarButtonItem = leftNavBarButton
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = false
        
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Exercises"
        
        // Setup the Scope Bar
        //searchController.searchBar.scopeButtonTitles = [exerciseSearchText, categorySearchText]
        //searchController.searchBar.delegate = self
        
    }
    
    func setupTableView() {
        
        guard let tableViewModel = model else { return }
        tableView.register(SearchExerciseTableViewCell.self, forCellReuseIdentifier: SearchExerciseTableViewCell.reuseID)
        tableViewDataSource = SearchExercisesDataSource(model: tableViewModel,
                                                            searchController: searchController,
                                                            tableView: tableView)
        view.addSubview(tableView)
        tableView.frame = view.bounds
        //tableView.tableHeaderView = searchController.searchBar
        tableView.tableHeaderView?.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.frame.width,
                                                  height: 60)
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
        self.navigationController?.navigationItem.leftBarButtonItem = nil
    }
    
    
}
