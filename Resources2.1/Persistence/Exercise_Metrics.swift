//
//  Exercise_Metrics.swift
//  exerciseModel1
//
//  Created by B_Litwin on 1/1/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import Foundation
import CoreData



//put getters and setters on metrics to convert in and out of database


//default sets == 1, if sets == 1, don't show sets 



class Exercise_Metrics: NSManagedObject {
    
    struct Value {
        let saved: Double
        let converted: Double
    }
    
    static func dateSortDescriptor(ascending: Bool = false) -> NSSortDescriptor {
        return NSSortDescriptor(key: "container.sequence.workout.dateSV", ascending: ascending)
    }
    
    var exercise: Exercises? {
        return container?.exercise
    }
    
    var metricInfoSet: Set<Metric_Info> {
        guard let e = exercise else { return [] }
        return e.metricInfoSet
    }
    
    var metricInfos: [Metric_Info] {
        guard let e = exercise else { return [] }
        return e.metricInfo
    }
    
    class func create(container: EM_Containers, set_number: Int) -> Exercise_Metrics {
        let newEM = Exercise_Metrics(context: context)
        newEM.container = container
        newEM.set_number = Int16(set_number)
        saveContext()
        return newEM
    }
    
    
    var date: Date {
        return container?.sequence?.workout?.date ?? Date()
    }
    
    var multiExerciseContainer: Multi_Exercise_Container_Types? {
        return container?.sequence?.multi_exercise_container_type
    }
    
    class func fetchAll() -> [Exercise_Metrics] {
        
        let request: NSFetchRequest<Exercise_Metrics> = Exercise_Metrics.fetchRequest()
        let result = try? context.fetch(request)
        guard let exerciseMetrics = result else { return [] }
        return exerciseMetrics
    }

    
    class func fetchLocalRecords(for exercise: Exercises, before date: Date) {
        
    }
    
    func setRecordType(personalRecord: Bool, localRecord: Bool) {
        is_personal_record = personalRecord
        is_local_record = localRecord
    }
    
}

extension Sequence where Iterator.Element: Exercise_Metrics {
    
    func setRecordType(personalRecord: Bool, localRecord: Bool) {
        self.forEach({
            $0.setRecordType(personalRecord: personalRecord, localRecord: localRecord)
        })
    }
    
}


extension Exercise_Metrics {
    
    //
    // Mark: retrieval methods
    //
    
    func value(for metric: Metric) -> Exercise_Metrics.Value {
        if let mi = metricInfos.containsMetric(metric) {
            return value(for: mi)
        } else {
            let saveValue = value(forKey: metric.searchKey) as! Double
            //this means there is not unit to convert it to/ the exercise doesn't have that unit of measurement
            return Exercise_Metrics.Value(saved: saveValue, converted: saveValue)
        }
    }
    
    func metricInfo(for metric: Metric) -> Metric_Info? {
        guard let mi = exercise?.metricInfo(for: metric) else { return nil }
        return mi
    }
    
    func value(for metricInfo: Metric_Info) -> Exercise_Metrics.Value {
        let searchKey = metricInfo.metric.searchKey
        let unit = metricInfo.unitOfMeasurement
        return value(for: searchKey, unit: unit)
    }
    
    func value(for searchKey: String, unit: Dimension) -> Exercise_Metrics.Value {
        let val = value(forKey: searchKey) as! Double
        return unit.convertToDisplayUnit(val)
    }
    
    //
    // Mark: Display Value
    //
    
    
    func displayValue(for metric: Metric) -> String {
        if let nonStan = displayStringNonStandard(for: metric) {
            return nonStan
        }
        
        let val = value(for: metric)
        
        switch metric {

        case .Length:
        guard let unitOfMeasurement = metricInfo(for: .Length)?.unitOfMeasurement else { break }
        if unitOfMeasurement == UnitLength.feet {
            let feet = Int(wholeFeet)
            let inches = Int(remainderInches)
            return "\(feet)' \(inches)\""
        } else {
            return val.converted.displayString()
        }
        
        case .Time:
        guard let unitOfMeasurement = metricInfo(for: .Time)?.unitOfMeasurement else { break }
        if unitOfMeasurement == UnitDuration.minutes {
            let minutes = Int(wholeMinutes)
            let seconds = Int(remainderSeconds)
            if seconds <= 9 {
                 return "\(minutes):0\(seconds)"
            } else {
                return "\(minutes):\(seconds)"
            }
        } else {
            return val.converted.displayString(rounded: 2)
        }
        
        default:
            break
        }
        
        return val.converted.displayString()
    }
    
    func displayValue(for metricInfo: Metric_Info) -> String {
        return displayValue(for: metricInfo.metric)
    }
    
    
    func displayString(for metric: Metric) -> String? {
        let value = displayValue(for: metric)

        switch metric {
        case .Weight:
            if used_bodyweight { return "BW" }
            
        case .Reps:
            return value
            
        case .Sets:
            if value == "0" || value == "1" { return nil }
            return value //Mark: Don't show sets if they equal 1
            
        default: break
        }
        
        let unitOfMeasurement = metricInfo(for: metric)?.unitOfMeasurement.symbol ?? ""
        return value + " " + unitOfMeasurement
    }

    
    func displayString() -> String {
        let mi = metricInfoSet.sortedByMetricPriority
        let strings = mi.flatMap { displayString(for: $0.metric) }
        return strings.joined(separator: " x ")
    }
    
    
    
    //
    // Mark: Save Methods
    //
    
    func save(string: String, metricInfo: Metric_Info) {
        if customSaveForNonstand(string, metric: metricInfo.metric) {
            return
        }
        
        if let double = Double(string) {
            save(double: double, metricInfo: metricInfo)
        }
    }
    
    func save(double: Double, metric: Metric) {
        if let metricInfo = exercise!.metricInfo.containsMetric(metric) {
            save(double: double, metricInfo: metricInfo)
        } else {
            setValue(double, forKey: metric.searchKey)
            saveContext()
        }
    }
    
    func save(double: Double, metricInfo: Metric_Info) {
        let unit = metricInfo.unitOfMeasurement
        let saveValue = unit.convertToSaveUnit(double)
        setValue(saveValue, forKey: metricInfo.metric.searchKey)
        saveContext()
    }
    
    //
    //Mark: CHecking for nonstandard values
    //
    //
    
    func displayStringNonStandard(for metric: Metric) -> String? {
        
        switch metric {
            
        case .Weight:
            if used_bodyweight {
                return "BW"
            }
            
        case .Reps:
            
            if missed_reps {
                if repsSV > 0 {
                    return repsSV.displayString() + " + X"
                } else {
                    return "X"
                }
            }
            
        default:
            break
        }

        return nil
    }
    
    func customSaveForNonstand(_ string: String, metric: Metric) -> Bool {
        
        switch metric {
        case .Weight:
            if string == "BW" {
                used_bodyweight = true
                weightSV = 0
                saveContext()
                return true
            }
            
        case .Reps:
            if string.characters.contains("X") {
                
                missed_reps = true
                
                if let nums = string.removeNonNumericValues() {
                    repsSV = nums
                    
                } else {
                    repsSV = 0
                }
                
                saveContext()
                return true
            }
            
        default:
            break
        }
        
        return false
    }
    
}




extension Exercise_Metrics {
    
    var weight: Double {
        get {
            return value(for: .Weight).converted
        }
        set {
            save(double: newValue, metric: .Weight)
        }
    }
    
    var setNumber: Int {
        get {
            return Int(set_number)
        }
        set {
            set_number = Int16(newValue)
        }
        
    }
    
    var wholeMinutes: Double {
        get { return Double(Int(timeSV / 60)) }
        set {
            timeSV = (newValue * 60) + remainderSeconds
            saveContext()
        }
    }
    
    var remainderSeconds: Double {
        get { return timeSV.truncatingRemainder(dividingBy: 60) }
        set {
            timeSV = newValue + (wholeMinutes * 60)
            saveContext()
        }
    }
    
    var wholeFeet: Double {
        get { return Double(Int(lengthSV / 12 )) }
        set {
            lengthSV = (newValue * 12) + remainderInches
            saveContext()
        }
    }
    
    var remainderInches: Double {
        get { return lengthSV.truncatingRemainder(dividingBy: 12) }
        set {
            lengthSV = newValue + (wholeFeet * 12)
            saveContext()
        }
    }
    
}












