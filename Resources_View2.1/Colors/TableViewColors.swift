//
//  Colors.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 4/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public extension UITableViewController {
    func setupDefaultColorScheme() {
        //tableView.backgroundColor = UIColor.lighterBlack()
        //tableView.separatorColor = UIColor.init(white: 1, alpha: 0.3)
    }
}

public extension UITableView {
    
    func setupDefaultColorScheme() { }
    
    @objc public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        //header.textLabel?.textColor = UIColor.brightTurquoise()
    }
}

public class DefaultTableViewController: UITableViewController {
    override public init(style: UITableViewStyle) {
        super.init(style: style)
        setupDefaultColorScheme()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = Colors.TableView.sectionHeader 
    }
    
    func setCellBackground(_ cell: UITableViewCell) {
        cell.backgroundColor = self.tableView.backgroundColor
        //cell.textLabel?.textColor = UIColor.groupedTableText()
    }
}

public extension UIColor {
    
//    public class func brightTurquoise() -> UIColor {
//        return color(80, 214, 202)
//    }
//
//    public class func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
//        return UIColor(red: red / 255.0, green:  green / 255.0, blue: blue / 255.0, alpha: 1.0)
//    }
//
//    public class func lighterBlack() -> UIColor {
//        return color(37, 40, 44)
//    }
//
//    public class func groupedTableText()  -> UIColor {
//        return color(241, 245, 250)
//    }
//
//    public class func workoutBackground() -> UIColor {
//        return color(59, 60, 71)
//    }
    
}
