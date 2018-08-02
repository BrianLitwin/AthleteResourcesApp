//
//  ExerciseMetrics.swift
//  Resources2.1
//
//  Created by B_Litwin on 7/31/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

struct ExerciseMetricValue: Comparable {
    let metric: Metric
    let unitOfMeasurement: UnitOfMeasurement
    let sortAscending: Bool
    let saved: Double
    let converted: Double
    
    init(exercise_metric: Exercise_Metrics, metric_info: Metric_Info) {
        let metric = Metric(metric_info.metricSV!)
        let value = exercise_metric.value(forKey: metric.searchKey) as! Double
        let unitOfMeasurementSymbol = metric_info.unit_of_measurement!
        let unitOfMeasurement = metric.unitOfMeasurement(symbol: unitOfMeasurementSymbol)
        let convertedValue = unitOfMeasurement.convertToDisplayValue(value: value)
        
        self.metric = metric
        self.unitOfMeasurement = unitOfMeasurement
        self.saved = value
        self.converted = convertedValue
        self.sortAscending = metric_info.sort_in_ascending_order
    }
    
    static func < (lhs: ExerciseMetricValue, rhs: ExerciseMetricValue) -> Bool {
        //if sort ascending true for both (eg a sprint time, return lower value)
        if lhs.sortAscending && rhs.sortAscending {
            return lhs.converted > rhs.converted
        } else {
            return lhs.converted < rhs.converted
        }
    }
    
    static func == (lhs: ExerciseMetricValue, rhs: ExerciseMetricValue) -> Bool {
        return lhs.converted == rhs.converted
    }
    
}

struct ExerciseMetric: Comparable {
    //uses default order to sort
    let values: [ExerciseMetricValue]
    let valuesForRecords: [ExerciseMetricValue]
    
    init(with exercise_metric: Exercise_Metrics) {
        let metricInfos = exercise_metric.metricInfoSet.sortedByDefaultOrder
        let values = metricInfos.map {
            return ExerciseMetricValue(exercise_metric: exercise_metric, metric_info: $0)
        }
        
        //assuming we are going to need these every time and mind as well build them at init
        let valuesForRecords = values.sorted(by: {
            $0.metric.primaryMetricOrder < $1.metric.primaryMetricOrder
        })
        
        self.values = values
        self.valuesForRecords = valuesForRecords
    }
    
    func isRecord(over: ExerciseMetric) -> Bool {
        return secondValuesAreRecordOverFirst(valuesForRecords, over.valuesForRecords)
    }
    
    //this is only for sorting purposes, not determining PRs
    static func < (lhs: ExerciseMetric, rhs: ExerciseMetric) -> Bool {
        for (lh, rh) in zip(lhs.valuesForRecords.map({ $0.converted }), rhs.valuesForRecords.map({$0.converted})) {
            if lh < rh { return true }
            if lh > rh { return false }
        }
        
        return false
    }
    
    static func == (lhs: ExerciseMetric, rhs: ExerciseMetric) -> Bool {
        return lhs.values == rhs.values
    }
}




struct PersonalRecorderContainerDataStruct<T> {
    private let data: [[T]]
    
    init(items: [[T]]) {
        self.data = items
    }
    
    func insert(_ element: T) {
        
    }
    
    
    
}




struct PersonalRecordsContainer {
    let allItems: [[ExerciseMetric]]
    let isRecordOver: [Bool]
    
    enum Update {
        case insert(ExerciseMetric)
        case update(ExerciseMetric)
        case delete(ExerciseMetric)
    }
    
    init(with exerciseMetrics: [ExerciseMetric]) {
        self.allItems = sortAndOrganizeIntoRecords(items: exerciseMetrics)
    }
    
    init(allItems: [[ExerciseMetric]]) {
        self.allItems = allItems
    }
    
    //rooting out all empty arrays with compactMap - but there should never be any 
    func getRecords() -> [ExerciseMetric] {
        return allItems.compactMap { $0.first }
    }

    func update(with update: Update) -> [[ExerciseMetric]] {
        let records = getRecords()
        var matrix = self.allItems
        
        func removeDownstreamRecords(from startIndex: Int,
                                     with exerciseMetric: ExerciseMetric)
        {
            let index = startIndex + 1
            var records = matrix.compactMap { $0.first }
            
            while let next = records.element(at: index),
                exerciseMetric.isRecord(over: next) {
                    let absorbedElements = matrix.remove(at: index)
                    records.remove(at: index)
                    matrix[startIndex] += absorbedElements
            }
        }
        
        /*
        //don't insert directly on matrix.. give the opportunity to update other side effects of insert
        */
        
        func insert(_ exerciseMetric: ExerciseMetric, row: Int, col: Int) -> [[ExerciseMetric]] {
            matrix[row].insert(exerciseMetric, at: col)
            removeDownstreamRecords(from: row, with: exerciseMetric)
            return matrix
        }
        
        switch update {
        case .insert(let exerciseMetric):
            guard !allItems.isEmpty else { return [[exerciseMetric]] }
            let insertIndex = findLargestElement(in: records, lessThan: exerciseMetric)
            guard insertIndex != 0 else {
                return insert(exerciseMetric, row: 0, col: 0)
            }
            
            let subtree = matrix[insertIndex - 1]
            let subtreeIndex = findLargestElement(in: subtree, lessThan: exerciseMetric)
            /*
             you can assume its less than the first element in the subtree so the subtree index will not be 0
             */
            let itemOneAhead = subtree[subtreeIndex - 1]
            
            switch itemOneAhead.isRecord(over: exerciseMetric) {
            case true:
                //orint("Insert Item/ Non-PR"
                return insert(exerciseMetric, row: insertIndex-1, col: subtreeIndex)
                
            case false:
                //orint("Insert Item/ PR"
                let split = subtree.split(secondHalfInclusiveOf: subtreeIndex)
                matrix[insertIndex-1] = split.firstHalf
                matrix.insert(split.secondHalf, at: insertIndex)
                return insert(exerciseMetric, row: insertIndex, col: 0)
            }
            
        case .delete(let exerciseMetric):
            break
            
        case .update(let exerciseMetric):
            break
            
        }
        
        return []
    }

}




extension Array {
    func split(secondHalfInclusiveOf index: Int) -> (firstHalf: [Element], secondHalf: [Element]) {
        let secondHalf = self[index..<endIndex]
        let firstHalf = self[startIndex..<index]
        return (Array(firstHalf), Array(secondHalf))
    }
    
    func element(at index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

func sortAndOrganizeIntoRecords(items: [ExerciseMetric]) -> [[ExerciseMetric]] {
    let sorted = items.sorted(by: >)
    print(sorted.map{ $0.values.map { $0.converted } })
    
    return sorted.reduce( [[ExerciseMetric]]() , {
        matrix, exerciseMetric in
        
        guard let lastRow = matrix.last else {
            return [[exerciseMetric]]
        }
        
        //the first item is the pr in a row - the one you want to compare it to
        let itemToComp = lastRow.first!
        
        let isRecord = secondValuesAreRecordOverFirst(itemToComp.valuesForRecords, exerciseMetric.valuesForRecords)
        //confused by this -
        if isRecord {
            var newMatrix = matrix
            newMatrix[newMatrix.count-1].append(exerciseMetric)
            return newMatrix
        } else {
            return matrix + [[exerciseMetric]]
        }
    })
}



func secondValuesAreRecordOverFirst<T: Comparable>(_ first: [T], _ second: [T]) -> Bool {
    let count = min(first.count, second.count)
    
    for (index, (lh, rh)) in zip(first, second).enumerated() {
        if lh > rh {
            guard index < count - 1 else { return true }
            if first[index+1] >= second[index+1] { return true }
        } else if lh == rh {
            guard index < count - 1 else { return true }
            if first[index+1] > second[index+1] { return true }
        } else if lh < rh {
            return false
        }
    }
    
    return false
}




func findLargestElement<T: Comparable>(in array: [T], lessThan target: T, startIndex: Int? = nil, endIndex: Int? = nil) -> Int {
    let startIndex = startIndex ?? 0
    let endIndex = endIndex ?? array.count - 1 
    let middleIndex = (startIndex + endIndex) / 2
    
    print(startIndex, middleIndex, endIndex)
    
    //be inclusive
    let middleElement = array[middleIndex]
    
    if middleElement == target {
        return middleIndex
        
    } else if middleElement > target {
        if middleIndex == array.count-1 {
            return array.count 
        }
        
        //found correct spot
        if array[middleIndex+1] <= target {
            return middleIndex + 1
        }
        
        return findLargestElement(in: array, lessThan: target, startIndex: middleIndex + 1, endIndex: endIndex)
        
    } else if middleElement < target {
        if middleIndex == 0 {
            return middleIndex
        }
        
        if array[middleIndex-1] >= target {
            return middleIndex
        }
        
        return findLargestElement(in: array, lessThan: target, startIndex: 0, endIndex: middleIndex-1)
    }
    
    fatalError()
}

func findLargestElement2<T: Comparable>(in array: [T], lessThan target: T) -> Int? {
    //assuming that target is less than first element
    
    guard !array.isEmpty else { return nil }
    
    //start at middle
    var index = array.count/2
    let endIndex = array.endIndex-1
    var prevWasGreater: Bool? = nil
    var iterations = 0
    
    print("target: \(target)")
    
    //looking for a position where the element ahead is greaterThan, and current is lessThan
    
    while index >= 0, index <= endIndex {
        iterations += 1
        print("iterations: \(iterations)")
        print(" index: \(index)")
        
        let element = array[index]
        if element == target { return index }
        
        if element > target {
            // this signals that we found correct element index
            if let p = prevWasGreater, !p {
                return index + 1
            }
            
            prevWasGreater = true
            
            if index == endIndex {
                //append to end 
                return endIndex + 1
            } else {
                index += 1
            }
            
        } else if element < target {
            // this signals that we found correct element index
            if let p = prevWasGreater, p {
                return index
            }
            
            
            prevWasGreater = false
            if index == 0 {
                return 0
            } else {
                index -= 1
            }
        }
    }
    
    return index
}
















