//
//  RestAPI_Get.swift
//  Resources2.1
//
//  Created by B_Litwin on 5/17/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit
import CoreData 
import Resources_View2_1

private enum URLS: String {
    case production = "http://django-env.m5brm3c9jn.us-east-1.elasticbeanstalk.com/data/getWorkoutData/2/"
}

class GetWorkoutsFromServer {
    
    //
    //Mark: Keeping a strong reference for right now, may not be the tight thing to do
    //

    func getWorkoutsFromBackend() {
        let urlString = URLS.production.rawValue
        guard let url = URL(string: urlString) else { return }
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let task = defaultSession.dataTask(with: url) { data, response, error in
            if let error = error {
                
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                Queue.main.execute {
                    self.handleResponse(data)
                }
            }
        }
        task.resume()
    }
    
    func handleResponse(_ responseData: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) else { return }
        guard let workouts = json as? NSArray else { return }
        for data in workouts {
            //fix me
            let workoutData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let workout = try! JSONDecoder().decode(Workout_JSON.self, from: workoutData!)
            workout.save()
        }
    }
}



struct Bodyweight_JSON {
    var date: String
    var id: Int16
    var bodyweight: Double
    
    func save() {
        
    }
    
}

struct Workouts_JSON: Codable {
    var workouts: [Workout_JSON]
}

struct Workout_JSON: Codable {
    var date: String
    var id: Int16
    var name: String
    func save() {
        print(id)
        if let workout = Workouts.checkIfExists(for: id) {
            
        } else {
            let workoutDate = convertDate(from: date)
            let newWorkout = Workouts.createNewWorkout(date: workoutDate)
            newWorkout.id = id
            newWorkout.name = name
            print(newWorkout.date)
        }
    }
}

struct Sequence_JSON: Codable {
    var id: Int16
    var order: Int16
    
    var workoutID: Int16
}

struct EM_Container_JSON: Codable {
    var id: Int16
    var order: Int16
    
    var exerciseID: Int16
    var sequenceID: Int16
}

struct Exercises_JSON: Codable {
    var id: Int16
    var name: String
    var variation: String
    var instructions: String
    var isActive: Bool
    
    var categoryID: Int16
}

struct Metric_Info_JSON: Codable {
    var id: Int16
    var metricSV: String
    var output_label: String
    var sort_in_ascending_order: Bool
    var unit_of_measurement: String
    
    var exerciseID: Int16
}

struct Exercise_Metrics_JSON {
    var id: Int16
    var set_number: Int16 
    var weight: Double
    var reps: Double
    var sets: Double
    var time: Double
    var length: Double
    var velocity: Double
    
    var emContainerID: Int16
}

struct Category_JSON: Codable {
    var id: Int16
    var isActive: Bool
    var name: String
}



private func convertDate(from string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: string) else {
        fatalError()
    }
    return date
}

extension Bodyweight {
    class func checkIfExists(for id: Int16) -> Bodyweight? {
        let request: NSFetchRequest<Bodyweight> = Bodyweight.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one workout with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
}

extension Categories {
    class func checkIfExists(for id: Int16) -> Categories? {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one workout with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
}


extension EM_Containers {
    class func checkIfExists(for id: Int16) -> EM_Containers? {
        let request: NSFetchRequest<EM_Containers> = EM_Containers.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one workout with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
}

extension Exercise_Metrics {
    class func checkIfExists(for id: Int16) -> Exercise_Metrics? {
        let request: NSFetchRequest<Exercise_Metrics> = Exercise_Metrics.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one workout with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
}

extension Exercises {
    //use: exercise already exists
}



extension Metric_Info {
    class func checkIfExists(for id: Int16) -> Metric_Info? {
        let request: NSFetchRequest<Metric_Info> = Metric_Info.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one workout with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
}

extension Multi_Exercise_Container_Types {
    class func checkIfExists(for id: Int16) -> Multi_Exercise_Container_Types? {
        let request: NSFetchRequest<Multi_Exercise_Container_Types> = Multi_Exercise_Container_Types.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one workout with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
}

extension Sequences {
    class func checkIfExists(for id: Int16) -> Sequences? {
        let request: NSFetchRequest<Sequences> = Sequences.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one workout with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
}


extension Workouts {
    class func checkIfExists(for id: Int16) -> Workouts? {
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let workouts = result else { return nil }
        guard workouts.count < 2 else { fatalError("more than one workout with same id")}
        guard let workout = workouts.first else { return nil }
        return workout
    }
}









