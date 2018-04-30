//
//  Orderable.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 1/30/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Orderable: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }

    
    func test() {
        
        for _ in 1...10 {
        
        context = setUpInMemoryManagedObjectContext()
        let container = EM_Containers(context: context)
        
        var eM: [Exercise_Metrics] {
            return container.exerciseMetrics
        }
        
        var weights: [Double] {
            return eM.map({ $0.weightSV })
        }
        
        func getSlice(index: Int) -> Exercise_Metrics {
            return eM.getSlice(after: index).first!
        }
        
        let em = Exercise_Metrics(context: context)
        em.weightSV = 100
        em.setNumber = 0
        em.container = container
        
        let em1 = Exercise_Metrics(context: context)
        em1.weightSV = 5
        em1.setNumber = 1
        em1.container = container
        
        let em2 = Exercise_Metrics(context: context)
        em2.weightSV = 55
        em2.setNumber = 3
        em2.container = container

        // test getSlice()
        
        XCTAssertEqual(getSlice(index: 0), em)
        
        //test get slice with endIndex
        let none = eM.getSlice(after: 3)
        XCTAssertEqual( none, [] )
        
        
        //  adding at beginning
        
        let newEM = Exercise_Metrics(context: context)
        newEM.weightSV = 53
        newEM.setNumber = 0
        newEM.container = container
        
        container.exerciseMetrics.reorder(from: newEM, type: .insert)
        XCTAssertEqual(weights, [53, 100, 5, 55])
        
        //add at end
        
        let newEM1 = Exercise_Metrics(context: context)
        newEM1.weightSV = 23
        newEM1.setNumber = 4
        newEM1.container = container
        
        container.exerciseMetrics.reorder(from: newEM1, type: .insert)
        XCTAssertEqual(weights, [53, 100, 5, 55, 23])
        
        //insert in middle
        
        let newEM2 = Exercise_Metrics(context: context)
        newEM2.weightSV = 2
        newEM2.setNumber = 2
        newEM2.container = container
        
        container.exerciseMetrics.reorder(from: newEM2, type: .insert)
        XCTAssertEqual(weights, [53, 100, 2, 5, 55, 23])
        
        //remove middle item
            
        newEM2.delete()
        container.exerciseMetrics.reorder(from: newEM2, type: .remove)
        XCTAssertEqual(weights, [53, 100, 5, 55, 23])
            
        //remove first item
            
        newEM.delete()
        container.exerciseMetrics.reorder(from: newEM2, type: .remove)
        XCTAssertEqual(weights, [100, 5, 55, 23])
            
        //remove last item
        
        newEM1.delete()
        container.exerciseMetrics.reorder(from: newEM2, type: .remove)
        XCTAssertEqual(weights, [100, 5, 55])
            
        }
        
    }
    
}
