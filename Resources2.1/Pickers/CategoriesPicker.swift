//
//  CategoriesPicker.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData 
import Resources_View2_1

//overkill after realizing that isActive isn't relevant

class CategoriesPicker: FetchedResultsTableViewController<NSManagedObject> {
    
    var categorySelected: ((Categories) -> Void)?
    
    init() {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController<Categories>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        try? fetchedResultsController.performFetch()
        
        super.init(fetchedResultsController: fetchedResultsController as! NSFetchedResultsController<NSManagedObject>)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell" )
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let category = fetchedResultsController.object(at: indexPath) as? Categories {
            cell.textLabel?.text = category.name ?? ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = fetchedResultsController.object(at: indexPath) as? Categories else {
            return
        }
        categorySelected?(category)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






