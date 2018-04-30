//
//  DispatchQeue.swift
//  Resources_View2.1
//
//  Created by B_Litwin on 3/2/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public protocol ExcutableQueue {
    var dispatchQueue: DispatchQueue { get }
}

public extension ExcutableQueue {
    func execute(closure: @escaping () -> Void) {
        dispatchQueue.async { closure() }
    }
}

public enum Queue: ExcutableQueue {
    
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
    
    public var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}

