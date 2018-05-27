//
//  Styles.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 5/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public struct Colors {
    
    static let navbarBtnTint = Color.Blue.medium.color 
    
    public struct CurrentWorkout {
        public static let background = Color.Blue.light.color
        public static let iconTint = Color.Blue.medium.color
        public static let sectionBg = UIColor.white
        public static let workoutHeaderBg = Color.Blue.medium.color
        public static let addExerciseBg = Color.Blue.medium.color
    }
    
    public struct BarChart {
        public static let barTint = Color.Blue.medium.color
    }
    
    public struct ScatterPlot {
        public static let primaryColor = Color.Blue.medium.color 
    }
    
    public struct UpdateExerciseInfo {
        public static let disclosureBtnTint = Color.Blue.medium.color
    }
    
}

enum Color {
    
    static let background = Color.Gray.lighter.color
    static let purple = "6f42c1"
    static let blueGray = "8697af"
    
    enum Red {
        static let medium = "cb2431"
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










