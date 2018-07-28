//
//  newWorkout.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/9/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit




public class ExerciseSearchViewController: UIViewController, UITableViewDelegate {
    
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    public var model: ExerciseSearchModel?
    var tableViewDataSource: SearchExercisesDataSource?
    private let searchBar = UISearchBar()

    override public func viewDidLoad() {
        
        super.viewDidLoad()
        //setupSearchBar()
        setupTableView() 
        
        tableView.separatorColor = UIColor.init(white: 1, alpha: 0.3)
        //give a little cushion in bottom
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        
        //configure search bar
        searchBar.delegate = tableViewDataSource
        searchBar.placeholder = "Search Exercises"
        searchBar.backgroundColor = .clear
        searchBar.searchBarStyle = .minimal
        
//        set searchBar's text color
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = UIColor.white
        
        //set search bar's cancel button color
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = Colors.SearchExercises.searchBarCancel
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //doing this here apparently lets the navbar adjust the size of the searchbar to accomodate the ham menu
        navigationController?.navigationItem.titleView = searchBar
    }
    

    func setupTableView() {
        
        guard let tableViewModel = model else { return }
        tableView.register(TableViewCellWithSubtitle.self, forCellReuseIdentifier: "subtitleCell")
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



extension UISearchBar {
    
    func resignWhenKeyboardHides() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resignFirstResponder),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    
}


