//
//  Dashboard TableViewController.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1

class DashboardModelClass: DashboardModel {
    
    var sectionModels: [DashboardSectionModel] = [
        DashboardBodyweightSection(),
        DashboardPersonalRecordsSection(),
        DashboardOneRmProgressSection()
    ]
    
    
    
}


class DashboardPersonalRecordsSection: DashboardSectionModel {
    
    let title = "Personal Records"
    
    let emptyDisplayText  = "No Records Set This Week"
    
    var collapsed: Bool = true
    
    var displayData: [String] = []
    
}


class DashboardOneRmProgressSection: DashboardSectionModel {
    
    let title = "Top Set Progress"
    
    let emptyDisplayText = "No Data Entered Yet"
    
    var collapsed: Bool = true
    
    var displayData: [String] = []
    
}



class DashboardBodyweightSection: DashboardSectionModel {
    
    let title = "Bodyweight"
    
    let emptyDisplayText  = "No Bodyweight Entries Entered Yet"
    
    var collapsed: Bool = true
    
    var displayData: [String] = []
    
}
