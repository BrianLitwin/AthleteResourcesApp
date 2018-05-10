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
    private let searchBar = UISearchBar()
    
    // MARK: - View Setup
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        //setupSearchBar()
        setupTableView() 
        
        tableView.backgroundColor = UIColor.lighterBlack()
        tableView.separatorColor = UIColor.init(white: 1, alpha: 0.3)
        //give a little cushion in bottom
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        
        //configure search bar
        searchBar.delegate = tableViewDataSource
        searchBar.placeholder = "Search Exercises"
        searchBar.tintColor = UIColor.brightTurquoise()
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //doing this here apparently lets the navbar adjust the size of the searchbar to accomodate the ham menu
        navigationController?.navigationItem.titleView = searchBar
        //let leftNavBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(showSearchBar))
        //self.navigationController?.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    

    func setupTableView() {
        
        guard let tableViewModel = model else { return }
        tableView.register(SearchExerciseTableViewCell.self, forCellReuseIdentifier: SearchExerciseTableViewCell.reuseID)
        tableViewDataSource = SearchExercisesDataSource(model: tableViewModel,
                                                        tableView: tableView,
                                                        searchBar: searchBar)
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationItem.titleView = nil
    }
    
    
}
