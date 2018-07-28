//
//  Analytics.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import Resources_View2_1
import CoreData




class RecordsDisplayModel<T: HasRecords>: ExerciseInfoModel {
    
    let type: T
    
    var sections: [ExerciseAnalyticsSectionUIPopulator] = []
    
    var needsReload: Bool {
        return type.personalRecordsManager.needsReload
    }
    
    init(type: T) {
        self.type = type
    }
    
    func loadModel() {
        type.personalRecordsManager.updateRecords()
        let sectionData = type.personalRecordsManager.personalRecords
        let rows: [PersonalRecordsSection.PersonalRecordsRowData] = sectionData.map({
            let data = type.displayInfo(for: $0)
            return PersonalRecordsSection.PersonalRecordsRowData(displayString: data.displayString, date: data.date.monthDay)
        })
        
        sections = [PersonalRecordsSection(rows: rows)]
    }
}

/*
 
 possible analytics:
 
 volume, total reps, avg reps per set, total sets, avg weight per rep,

//higher avg weight per rep at more total reps
//higher avg weight per rep at more total reps and fewer sets


*/






