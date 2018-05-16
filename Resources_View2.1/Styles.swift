//
//  Styles.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 5/14/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

enum Colors {
    
    static let background = Colors.Gray.lighter.color
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









