//
//  WindowAnimation.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/15/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit


enum WindowAnimation {
    
    case fromTop(height: CGFloat, view: UIView)
    case fromBottom(height: CGFloat, view: UIView)
    case fromRight(width: CGFloat, view: UIView)
    
    var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    var windowHeight: CGFloat {
        return window?.frame.height ?? 0
    }
    
    var windowWidth: CGFloat {
        return window?.frame.width ?? 0
    }
    
    var startFrame: (frame: CGRect, view: UIView) {
        switch self {
            
        case .fromTop(_ , view: let view):
            let startFrame = CGRect(x: 0, y: 0, width: windowWidth, height: 0)
            return (startFrame, view)
            
        case .fromBottom( _ , let view):
            let startFrame = CGRect(x: 0, y: windowHeight, width: windowWidth, height: 0)
            return (startFrame, view)
            
        case .fromRight( _  , let view):
            let startFrame = CGRect(x: windowWidth, y: 0, width: 0, height: windowHeight)
            return (startFrame, view)
        }
    }
    
    var displayFrame: CGRect {
        
        switch self {
            
        case .fromTop(let height, _ ):
            return (CGRect(x: 0, y: height, width: windowWidth, height: height))
            
        case .fromRight(let width, _ ):
            let x = windowWidth - width
            return CGRect(x: x, y: 0, width: width, height: windowHeight)
            
        case .fromBottom(let height, _ ):
            let y = windowHeight - height
            return CGRect(x: 0, y: y, width: windowWidth, height: height)
            
        }
    }
    
    func display(with tintScreen: UIView? = nil) {
        
        if let ts = tintScreen {
            window?.addSubview(ts)
            ts.alpha = 0
        }
        
        let s = startFrame
        window?.addSubview(s.view)
         s.view.frame = s.frame
        
        let dFrame = displayFrame
        UIView.animate(withDuration: 0.25, animations: {
            s.view.frame = dFrame
            tintScreen?.alpha = 1
        })
    }
    
    func resign(tintScreen: UIView) {
        let s = startFrame
        UIView.animate(withDuration: 0.25, animations: {
            s.view.frame = s.frame
            tintScreen.alpha = 0
        }, completion: { Bool in
            s.view.removeFromSuperview()
        })
    }

}



