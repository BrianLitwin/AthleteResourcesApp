//
//  Converting To Dict Values.swift
//  exerciseModel1
//
//  Created by B_Litwin on 1/6/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData

public func postAllWorkoutData() {
    
    /*
    let workout = Workouts(context: context)
    workout.dateSV = NSDate()
    
    let category = Categories(context: context)
    let exercise = Exercises(context: context)
    exercise.category = category
    
    let em = Exercise_Metrics(context: context)
    em.weightSV = 200
    em.repsSV = 10
    em.setsSV = 3
    em.workout = workout
    em.exercise = exercise
    
    let mi1 = Metric_Info(context: context)
    let mi2 = Metric_Info(context: context)
    let mi3 = Metric_Info(context: context)
    
    mi1.metricSV = "Weight"
    mi2.metricSV = "Reps"
    mi3.metricSV = "Sets"
    mi1.exercise = exercise
    mi2.exercise = exercise
    mi3.exercise = exercise
    mi1.unit_of_measurement = UnitMass.pounds.symbol
    mi2.unit_of_measurement = UnitReps.reps.symbol
    mi3.unit_of_measurement = UnitSets.sets.symbol
    
    updateAllIds()
    let data = retrieveDictionaryValuesForPostRequest()
    PostRequest(dict: data)
    */
    
}


func retrieveDictionaryValuesForPostRequest() -> [String: Any] {
    
    return ["workouts": convertObjects(Workouts.self),
            "user": 1,
            "categories": convertObjects(Categories.self),
            "exercises": convertObjects(Exercises.self),
            "exercise_metrics": convertObjects(Exercise_Metrics.self),
            "metric_info": convertObjects(Metric_Info.self)
    
    ]
    
}


private func convertObjects<T: NSManagedObject>(_ type: T.Type) -> [[String: Any]] {
    
    var dicts = [[String: Any]]()
    
    switch type {
        
    case is Exercises.Type:
        
        let exercises = fetchAll(type: Exercises.self)
        for e in exercises {
            var dict = [String: Any]()
            dict["id"] = e.id
            dict["categoryID"] = e.category!.id
            dict["name"] = e.name ?? ""
            dict["variation"] = e.variation ?? ""
            dict["instructions"] = e.instructions ?? ""
            dicts.append(dict)
        }
        
    case is Metric_Info.Type:
        
        let metricInfos = fetchAll(type: Metric_Info.self)
        for mi in metricInfos {
            var dict = [String: Any]()
            dict["id"] = mi.id
            dict["exerciseID"] = mi.exercise!.id
            dict["name"] = mi.metricSV!
            dict["unit_of_measurement"] = mi.unit_of_measurement ?? ""
            dict["sort_in_ascending_order"] = mi.sort_in_ascending_order
            dicts.append(dict)
        }
        
    case is Exercise_Metrics.Type:
        
        let exerciseMetrics = fetchAll(type: Exercise_Metrics.self)
        
        /*
        for e in exerciseMetrics {
            var dict = [String: Any]()
            dict["id"] = e.id
            dict["exerciseID"] = e.exercise!.id
            dict["set_number"] = e.set_number
            dict["weight"] = e.weight
            dict["reps"] = e.reps
            dict["sets"] = e.sets
            dict["time"] = e.time
            dict["length"] = e.length
            dict["velocity"] = e.velocity
            dict["rest_period"] = e.restPeriod
            dicts.append(dict)
        }
         */
        
    case is Workouts.Type:
        
        let workouts = fetchAll(type: Workouts.self)
        
        for workout in workouts {
            var dict = [String: Any]()
            let date = pythonDateFormat(date: workout.dateSV!)
            dict["date"] = date
            dict["id"] = workout.id
            dict["name"] = workout.name ?? ""
            dicts.append(dict)
        }
    
    case is Categories.Type:
        
        let categories = fetchAll(type: Categories.self)
        for c in categories {
            var dict = [String: Any]()
            dict["name"] = c.name ?? "Unnamed"
            dict["id"] = c.id
            dicts.append(dict)
        }
        
    default: break
        
    }
    
    return dicts
    
}

/*
private func pythonDateFormat(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
    
    return dateFormatter.string(from: date)
    
}
*/
 
private func PostRequest(dict: Dictionary<String, Any>) {
    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
        
        let url = NSURL(string: "http://localhost:8000/workout_data/")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            
            if error != nil {
                //self!.postErrorAlert()
                return
            } else {
                do {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode != 200 {
                            //self!.postErrorAlert()
                        }
                    }
                    //ADD A RESPONSE IF THEY GET A 500 Status Code
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    //completion(json as! [String : Any])
                    
                }
                catch {
                }
            }
        }
        
        task.resume()
    }
}




private func lastID<T: NSManagedObject>( type: T.Type ) -> Int16? {
    
    if let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> {
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1
        let result = try? context.fetch(request)
        guard result != nil else { return nil }
        guard !result!.isEmpty else { return nil }
        return result![0].value(forKey: "id") as! Int16?
    } else {
        return nil
    }
}

func fetchAll<T: NSManagedObject>(type: T.Type) -> [T] {
    if let request: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> {
        let result = try? context.fetch(request)
        return result!
    } else
    {
        return [] }
}

private func updateAllIds() {
    addNewIDs( Exercises.self )
    addNewIDs( Exercise_Metrics.self )
    addNewIDs( Workouts.self )
    addNewIDs( Bodyweight.self )
    addNewIDs( Categories.self )
    addNewIDs( Metric_Info.self )
    addNewIDs( Settings.self )
}

private func addNewIDs<T: NSManagedObject>(_ T: T.Type) {
    
    let allEm = fetchAll(type: T)
    
    if let lastId = lastID(type: T) {
        
        var ID = lastId
        for v in allEm {
            if v.value(forKey: "id") as! Int16 > 0 { continue }
            ID += 1
            v.setValue(ID, forKey: "id")
            
        }
    }
}






