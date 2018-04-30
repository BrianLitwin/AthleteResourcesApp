//
//  Date.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 2/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public extension Date {
    
    //Mark: Formatting Methods
    
    var weekdayMonthDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM dd"
        return dateFormatter.string(from: self)
    }
    
    var monthDayYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.string(from: self)
    }
    
    var monthDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }
    
    var weekdayDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E dd"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self)
    }
    
    var dayMonthYearTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MM-dd-yyyy h:mm a"
        return dateFormatter.string(from: self)
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        return dateFormatter.string(from: self)
    }
    
    
    var timeLong: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    static func daysBetween(startDate: Date, endDate: Date) -> Double {
        let components = Calendar.current.dateComponents([.second], from: startDate, to: endDate)
        return Double(components.second!) / 86400
    }
    
}



