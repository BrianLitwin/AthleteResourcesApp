//
//  Extensions.swift
//  exerciseModel1
//
//  Created by B_Litwin on 1/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData


extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach({ addArrangedSubview($0) })
    }
}



extension NSManagedObject {
    
    func delete() {
        context.delete(self)
        try? context.save()
    }
    
}



extension UIViewController {
    
    var isVisible: Bool {
        return self.isViewLoaded && (self.view.window != nil)
    }
}


extension UIButton {
    
    
    convenience init(title: String, tag: Int? = nil) {
        self.init()
        self.setTitle(title, for: .normal)
        
        if tag != nil {
            self.tag = tag!
        }
        
    }
    
    var title: String {
        get {
            return self.title
        }
        set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
    var image: UIImage {
        get {
            return self.image
        }
        set {
            self.setImage(newValue, for: .normal)
        }
    }
    
}



extension UIImage {
    func template() -> UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

extension UIImageView {
    
    func enabled() -> UIImageView {
        self.isUserInteractionEnabled = true
        return self
    }
    
}

extension Array {
    
    func returnCount(_ count: Int) -> [Element] {
        let c = self.count > count ? self.count : count
        var ret = [Element]()
        for (i, element) in self.enumerated() {
            if i == c { break }
            ret.append(element)
        }
        return ret
    }
    
    var lastItem: Element? {
        guard !self.isEmpty else { return nil }
        return self[self.endIndex - 1]
    }
    
    var firstItem: Element? {
        if self.isEmpty {
            return nil
        } else {
            return self[0]
        }
        
    }
    
}

extension Array where Iterator.Element: Exercises {
    
    func sortedWithNumbersLast() -> [Exercises] {
        
        return self.sorted { (s1, s2) -> Bool in
            let matched = matches(for: "[0-9,\\(,\\-]", in: s1.name!)
            let matched2 = matches(for: "[0-9\\(,\\-]", in: s2.name!)
            if matched.isEmpty && matched2.isEmpty {
                return s1.name! < s2.name!
            } else if matched.isEmpty && !matched2.isEmpty {
                return true
            } else if !matched.isEmpty && matched2.isEmpty {
                return false
            } else {
                return matched.first! < matched2.first!
                
            }
            
        }
    }
    
    func sortedByCategory() -> [Exercises] {
        return self.sorted(by: { $0.category!.name! < $1.category!.name! })
    }
    
}



private func matches(for regex: String, in text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let nsString = text as NSString
        let results = regex.matches(in: text, range: NSRange(location: 0,     length: nsString.length))
        return results.map { nsString.substring(with: $0.range)}
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
    
}




extension String {
    
    var double: Double? {
        if let value = Double(self) {
            return value
        } else {
            return nil
        }
    }
}



extension Date {
    
    
    struct Week: Hashable {
        
        init(monday: Date) {
            self.monday = monday
            sunday = monday.add(days: 7).addSeconds(-1)
        }
        
        let monday: Date
        let sunday: Date
        
        func interval() -> DateInterval {
            return DateInterval(start: monday, end: sunday)
        }
        
        var hashValue: Int {
            return interval().hashValue
        }
        
        static func ==(lhs: Date.Week, rhs: Date.Week) -> Bool {
            return lhs.interval() == rhs.interval()
        }
        
    }
    
    struct Month {
        var startDate: Date
        var endDate: Date
    }
    
    func add(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    
    var mondaysDate: Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    var startOfDay: Date {
        return NSCalendar.current.startOfDay(for: self as Date)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.current.date(byAdding: components, to: startOfDay)! as Date
    }
    
    func addSeconds(_ seconds: Int) -> Date {
        var components = DateComponents()
        components.second = seconds
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    static func weeksBetween(currentDate: Date, startDate: Date) -> [Week] {
        
        let firstMonday = startDate.mondaysDate.startOfDay
        var weeks = [Week(monday: firstMonday)]
        
        while weeks.lastItem!.sunday <= currentDate {
            let monday = weeks.lastItem!.sunday.addSeconds(1)
            weeks.append(Week(monday: monday))
        }
        
        return weeks
    }
    
}





extension UIView {
    
    func setBorder(color: UIColor = UIColor.black, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    var yOrigin: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
    
    var maxX: CGFloat {
        get { return frame.maxX }
        set { frame.origin.x = newValue - frame.width }
    }
    
    var maxY: CGFloat {  //FIXME: should be Height
        get { return frame.maxY }
        set { self.frame.size.height = newValue }
    }

    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
    func trailingConstraint(_ view: UIView, constant: CGFloat = 0) {
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    }
    
    func leadingConstraint(_ view: UIView, constant: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
    }

    var widthConstraint: CGFloat {
        get { return self.frame.width }
        set { self.widthAnchor.constraint(equalToConstant: newValue).isActive = true }
    }
    
    
}







