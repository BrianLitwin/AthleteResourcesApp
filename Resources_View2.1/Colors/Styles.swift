//
//  Styles.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 5/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


public struct Colors {
    //try to keep this where all the navbar btn tints are tied
    static let navbarBtnTint = UIColor.black 
    static let navBarBgTint =  UIColor.white  //UIColor.color(53, 71, 88)
    static let navBarTitle = UIColor.black
    
    static let blueHighlight = Color.Blue.light.color
    
    public struct Textfield {
        public static let borderDefault = Color.Gray.light.color 
        public static let borderHighlight = Color.Blue.medium.color
    }
    
    public struct Keyboard {
        public static let primaryBg = UIColor.white 
        public static let secondaryBg = UIColor.init(white: 0.00, alpha: 0.15)
    }
    
    public struct EditExerciseMetricPopup {
        public static let doneBtnTint = Color.Blue.medium.color
    }
    
    public struct TableView {
        public static let sectionHeader = Color.Blue.medium.color
        public static let background = UIColor.white
    }
    
    public struct Sidebar {
        public struct Primary {
            static let icon = Color.Blue.medium.color
            static let bg = UIColor.groupTableViewBackground
        }
        public struct Secondary {
            static let icon = Color.Blue.medium.color
            static let bg = UIColor.init(white: 0.0, alpha: 0.0)
        }
    }
    
    public struct WorkoutHistory {
        static func trashbarTint(highlighted: Bool) -> UIColor {
            return highlighted ? Color.Red.medium.color : Colors.navbarBtnTint
        }
    }
    
    public struct ExerciseInfo {
        static let navbarTitle = Color.Gray.dark.color 
        static let navbarSubtitle = Color.Gray.light.color
        
        public struct Menu {
            static let background = UIColor.white
            static let unhighlightedIcon =  Color.Gray.light.color
            static let highlightedIcon = Color.Blue.medium.color
        }
    }
    

    
    public struct SearchExercises {
        static let searchBarCancel = Color.Blue.medium.color 
        static func checkmarkTint(highlighted: Bool) -> UIColor {
            return highlighted ? Color.Blue.medium.color : Color.Gray.light.color
        }
    }
    
    public struct CurrentWorkout {
        public static let background: UIColor = .groupTableViewBackground
        public static let iconTint = Color.green
        public static let sectionBg = UIColor.white
        public static let workoutHeaderBg = Color.green
        public static let addExerciseBg = Color.green
        public static let dateLabel = UIColor.white
        public static let addExerciseLabel = UIColor.white
        public static let editDateIcon = Color.Blue.medium.color
        public static let border = Color.Gray.light.color
        public static let settingsNavBarBtn = Colors.navbarBtnTint
    }
    
    public struct BarChart {
        public static let barTint = Color.Blue.medium.color
    }
    
    public struct UpdateExerciseInfo {
        public static let disclosureBtnTint = Color.Blue.medium.color 
        public static let doneBtnTint = Colors.navbarBtnTint
        public static let cancelBtnTint = Colors.navbarBtnTint
    }
    
    public struct CreateMenus {
        public struct CompoundExercise {
            public static let navbarTint = UIColor.black
        }
    }
    
    public struct OneRMWeekCell {
        public static let percentageImprovement = Color.Blue.medium.color 
        public static let detailText = Color.Gray.light.color
    }
    
    public struct ExercisePicker {
        public static let headerBg = UIColor.clear
        public static let arrow = Color.Gray.light.color
        public static let dismiss = Color.Blue.medium.color 
    }
    
    public struct BodyweightVC {
        public static let addBtn = Colors.navbarBtnTint
        public static let weightChangeBtn = Color.Blue.medium.color
        public static let headerTabBG = Color.darkBlue
        public static let headerTabTitle = UIColor.white
        public static let headerTabSubtitle = Color.offWhite
        
        public struct LineChart {
            //public static let primaryColor = "3f88f7".color
            public static let lineColor = Color.Blue.medium.color
            public static let fillColor = Color.Blue.light.color
        }
    }
}


fileprivate enum Color {

    static let background = Color.Gray.lighter.color
    static let purple = "6f42c1"
    static let blueGray = "8697af"
    static let orange =  "f9bd5f"
    
    static let teal = "107e7d"
    static let brightBlue = "04457f"
    static let green = Green.medium.color  //UIColor.color(32, 181, 88)
    static let darkBlue = UIColor.color(25, 45, 70)
    static let offWhite = UIColor.color(231, 231, 239)
    
    //UIColor.color(95, 11, 44)
    
    static let offGren = "ad1457"
    
    enum Red {
        //static let medium = "cb2431"
        static let medium = "53162f"
        static let light = "ffeef0"
    }
    
    enum Green {
        static let medium = "28a745"
        static let light = "e6ffed"
    }
    
    enum Blue {
        static let medium = "0366d6"
        static let light = "f1f8ff"
    }
    
    enum Gray {
        static let dark = "24292e"
        static let medium = "586069"
        static let light = "a3aab1"
        static let lighter = "f6f8fa"
        static let border = "bcbbc1"
        static let alphaLighter = UIColor(white: 0, alpha: 0.10)
    }
    
    enum Yellow {
        static let medium = "f29d50"
        static let light = "fff5b1"
    }
    
}

extension String {
    
    public var color: UIColor {
        return UIColor.fromHex(self)
    }
}

extension UIColor {
    
    public class func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green:  green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    public static func fromHex(_ hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return .gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}










