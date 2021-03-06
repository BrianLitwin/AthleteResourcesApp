//
//  TestPersonalRecordsContainer.swift
//  Unit Tests
//
//  Created by B_Litwin on 8/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class A_TestPersonalRecordsContainer: XCTestCase {
    var data = [[Double]]()
    var exercise: Exercises!
    
    func getRecords() -> [[Double]] {
        let sorted = data.sorted(by: { sortValuesForRecords(
            firstGroup: $0,
            secondGroup: $1
        )})
        
        return sorted.reduce([[Double]](), { list, next in
            guard let last = list.last else { return [next] }
            let firstIsRecord = secondValuesAreRecordOverFirst(last, next)
            if firstIsRecord {
                return list
            } else {
                return list + [next]
            }
        })
    }
    
    func isRecordsOverInfo(container: PersonalRecordsContainer) -> [Bool] {
        let allItems = container.allItems.flatMap { $0.compactMap { $0.item } }
        var retArray: [Bool] = []
        
        for (index, item) in allItems.enumerated() {
            if index == allItems.count - 1 {
                retArray.append(false)
            } else {
                retArray.append(item.isRecord(over: allItems[index + 1]))
            }
        }
        
        return retArray
    }
    
    
    func makeExerciseMetrics() -> [ExerciseMetric] {
        return data.map {
            let e = Unit_Tests.makeEM(with: exercise)
            e.weightSV = $0[0]
            e.repsSV = $0[1]
            e.setsSV = $0[2]
            return ExerciseMetric(with: e)
        }
    }
    
    func makeEM(with: [Double]) -> ExerciseMetric {
        let e = Unit_Tests.makeEM(with: exercise)
        e.weightSV = with[0]
        e.repsSV = with[1]
        e.setsSV = with[2]
        return ExerciseMetric(with: e)
    }

    /*
     idea is to get PRs by brute force and test against the insert/delete operations of
     PersonalRecordsContainer
 
    */
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
        exercise = makeExercise()
    }
    
func test() {
        data = [
            [300, 2, 1],  //pr
            [290, 3, 1],  //pr
            [280, 2, 1],
            [280, 1, 1],
            [279, 2, 1],
            [270, 5, 1],  //pr
            [260, 4, 10],
            [254, 7, 2],  //pr
            [254, 7, 1],
        ]
        
        var exerciseMetrics = makeExerciseMetrics()
        var personalRecords = PersonalRecordsContainer(with: exerciseMetrics)
        
        var prValues: [[Double]] {
            return personalRecords.getRecords().map { $0.values.map { $0.converted }}
        }
    
        var isRecordOverValues: [Bool] {
            return personalRecords.allItems.flatMap { $0.compactMap { $0.isRecordOverSucceedingNode }}
        }
        
        func insert(_ num: Double...) {
            var nums = [Double]()
            for n in num {
                nums.append(n)
            }
            let e = makeEM(with: nums)
            let m = personalRecords.update(with: .insert(e))
            personalRecords = PersonalRecordsContainer(allItems: m)
            data.append(num)
        }
        
       // initial conditions
        XCTAssertEqual(getRecords(), prValues)
        XCTAssertEqual(isRecordsOverInfo(container: personalRecords), isRecordOverValues)
    
        insert( 301, 1, 1  )
        XCTAssertEqual(getRecords(), prValues)
        XCTAssertEqual(isRecordsOverInfo(container: personalRecords), isRecordOverValues)

        insert( 280, 4, 2 )
        XCTAssertEqual(getRecords(), prValues)
        //XCTAssertEqual(isRecordsOverInfo(container: personalRecords), isRecordOverValues)

        insert( 180, 4, 2 )
        XCTAssertEqual(getRecords(), prValues)
        //XCTAssertEqual(isRecordsOverInfo(container: personalRecords), isRecordOverValues)

        insert( 180, 10, 2 )
        XCTAssertEqual(getRecords(), prValues)
        //XCTAssertEqual(isRecordsOverInfo(container: personalRecords), isRecordOverValues)

        insert( 275, 8, 2 )
        XCTAssertEqual(getRecords(), prValues)
        //XCTAssertEqual(isRecordsOverInfo(container: personalRecords), isRecordOverValues)

        insert( 275, 8, 1 )
        XCTAssertEqual(getRecords(), prValues)

        insert( 275, 6, 25 )
        XCTAssertEqual(getRecords(), prValues)
    
        insert( 275, 6, 15 )
        XCTAssertEqual(getRecords(), prValues)

        insert( 301, 10, 25 )
        XCTAssertEqual(getRecords(), prValues)

        print(personalRecords.getRecords().map { $0.values.map { $0.converted } })

        data = [
            [300, 10, 1],
            [290, 3, 1],
            [280, 6, 2],
            [280, 4, 1],
            [280, 4, 2],
            [280, 4, 3],
            [280, 4, 4]
        ]

        personalRecords = PersonalRecordsContainer(with: makeExerciseMetrics())
        XCTAssertEqual(getRecords(), prValues)
    }
    
}
