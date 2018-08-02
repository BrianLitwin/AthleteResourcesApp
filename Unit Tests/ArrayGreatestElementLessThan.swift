//
//  ArrayGreatestElementLessThan.swift
//  Unit Tests
//
//  Created by B_Litwin on 8/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class ArrayGreatestElementLessThan: XCTestCase {
    
    func test_Ints() {
        let array = [12, 10, 9, 8, 7, 6, 4, 3, 1]
        
        var returnIndex = findLargestElement(in: array, lessThan: 11)
        print("return index found at \(returnIndex)")
        XCTAssertEqual(returnIndex, 1)
        
        returnIndex = findLargestElement(in: array, lessThan: 5)
        XCTAssertEqual(returnIndex, 6)
        
        returnIndex = findLargestElement(in: array, lessThan: 2)
        XCTAssertEqual(returnIndex, 8)
        
        returnIndex = findLargestElement(in: array, lessThan: 14)
        XCTAssertEqual(returnIndex, 0)
        
        returnIndex = findLargestElement(in: array, lessThan: 0)
        XCTAssertEqual(returnIndex, 9)
    }
    
    func test_randomInts() {
        
        var cumulativeArray = [10, 16, 35, 31, 99, 43].sorted(by: > )
        
        for i in -10...100 {
            
            var array = [9, 12, 3, 4, 44, 5, 5, 6, 3, 5, 6, 4, 1, 12, 14, 15, 16, 17, 18, 99, 34, 5, 32, 2].sorted(by: >)
            var newElement = i
            print(newElement)
            let newIndex = findLargestElement(in: array, lessThan: newElement)
            
            //create new array using index from function
            //test against an append + sort to make sure element is inserted in correct spot
            var newArray = array
            newArray.insert(newElement, at: newIndex)
            array.append(newElement)
            XCTAssertEqual(array.sorted(by: >), newArray)
            
            
            var newCumulativeArray = cumulativeArray
            newCumulativeArray.insert(newElement, at: findLargestElement(in: newCumulativeArray, lessThan: newElement))
            
            cumulativeArray.append(newElement)
            cumulativeArray.sort(by: > )
            XCTAssertEqual(newCumulativeArray, cumulativeArray)

            cumulativeArray.sort(by: > )
            
        }
    }
}





















