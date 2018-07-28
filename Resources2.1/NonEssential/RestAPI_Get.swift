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
    case dev = "http://localhost:8000/api/getWorkoutData/2/"
}

class GetWorkoutsFromServer {
    var dataLoaded = false
    
    //
    //Mark: Keeping a strong reference for right now, may not be the tight thing to do
    //

    func loadPreviousWorkouts() -> Data? {
        if let path = Bundle.main.path(forResource: "PreviousWorkouts", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
                    
                
            } catch {
                
            }
        }
        return nil
    }
    
    func getWorkoutsFromBackend() {
        guard !dataLoaded else { return }
        if let data = loadPreviousWorkouts() {
            handleResponse(data)
            dataLoaded = true
        }
        return
        
        let urlString = URLS.dev.rawValue
        guard let url = URL(string: urlString) else { return }
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        let defaultSession = URLSession(configuration: config)
        let task = defaultSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                Queue.main.execute {
                    self.handleResponse(data)
                }
            } else {
                print(response.debugDescription)
            }
        }
        task.resume()
    }
    
    func handleResponse(_ responseData: Data) {
        //guard let json = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) else { return }
        
        let data = try! JSONDecoder().decode(Get_Data.self, from: responseData)
        data.save()
    }
}

struct Get_Data: Codable {
    var categories: [Category_JSON]
    var exercises: [Exercise_JSON]
    var workouts: [Workout_JSON]
    var sequences: [Sequence_JSON]
    var em_containers: [EM_Container_JSON]
    var metric_info: [Metric_Info_JSON]
    var exercise_metrics: [Exercise_Metrics_JSON]
    
    func save() {
        categories.forEach({ $0.save() })
        exercises.forEach({ $0.save(categories: categories) })
        workouts.forEach({ $0.save() })
        sequences.forEach({ $0.save(workouts: workouts) })
        em_containers.forEach({ $0.save(exercises: exercises, sequences: sequences) })
        metric_info.forEach({ $0.save(exercises: exercises) })
        exercise_metrics.forEach({ $0.save(containers: em_containers)})
    }
}


struct Bodyweight_JSON {
    var date: String
    var id: Int16
    var bodyweight: Double
    
    func save() {
        
    }
    
}


struct Workout_JSON: Codable {
    var id: Int16
    var coreDataID: Int16
    var date: String
    var name: String
    func save() {
        if let workout = Workouts.checkIfExists(for: coreDataID) {
            
        } else {
            let workoutDate = convertDate(from: date)
            let newWorkout = Workouts.createNewWorkout(date: workoutDate)
            newWorkout.id = coreDataID
            newWorkout.name = name
        }
    }
}


struct Sequence_JSON: Codable {
    var id: Int16
    var coreDataID: Int16
    var workout_order: Int16
    var workout: Int16
    
    func save(workouts: [Workout_JSON]) {
        var sequence = Sequences.checkIfExists(for: coreDataID) ?? Sequences(context: context)
        sequence.id = coreDataID
        sequence.workout_order = workout_order
        
        //
        //Hack
        //
        
        func findWorkout(id: Int16) -> Workouts {
            for workout in workouts {
                if workout.id == id {
                    return Workouts.checkIfExists(for: workout.coreDataID)!
                }
            }
            fatalError("coudln't find workout with id \(id)")
        }
        
        sequence.workout = findWorkout(id: workout)
    }
}

struct EM_Container_JSON: Codable {
    var coreDataID: Int16
    var order: Int16
    var id: Int16
    var exercise: Int16
    var sequence: Int16
    
    func save(exercises: [Exercise_JSON], sequences: [Sequence_JSON]) {
        func findExercise(id: Int16) -> Exercises {
            for exercise in exercises {
                if exercise.id == id {
                    return Exercises.exerciseAlreadyExistsWith(name: exercise.name, variation: exercise.variation ?? "")!
                }
            }
            fatalError("coudln't find exercise with id \(id)")
        }
        
        func findSequence(id: Int16) -> Sequences {
            for s in sequences {
                if s.id == id {
                    return Sequences.checkIfExists(for: s.coreDataID)!
                }
            }
            fatalError("coudln't find exercise with id \(id)")
        }
        
        if EM_Containers.checkIfExists(for: coreDataID) == nil {
            let container = EM_Containers(context: context)
            container.id = coreDataID
            container.orderSV = order
            container.sequence = findSequence(id: sequence)
            container.exercise = findExercise(id: exercise)
        }
    }
}

struct Exercise_JSON: Codable {
    var id: Int16
    var coreDataID: Int16
    var name: String
    var variation: String?
    var instructions: String?
    var isActive: Bool
    
    //category ID
    var category: Int16
    
    func save(categories: [Category_JSON]) {
        
        let exercise = Exercises.exerciseAlreadyExistsWith(name: name, variation: variation ?? "") ?? Exercises(context: context)
        exercise.id = coreDataID
        exercise.name = name
        exercise.variation = variation
        exercise.instructions = instructions
        exercise.isActive = isActive
        
        //
        //tempory hack
        //
        
        func findCategory(id: Int16) -> Category_JSON {
            for category in categories {
                if category.id == id {
                    return category
                }
            }
            fatalError("coudln't find category with id \(id)")
        }
        
        func findCategory(name: String) -> Category_JSON {
            for category in categories {
                if category.name == name {
                    return category
                }
            }
            fatalError("coudln't find category with id \(name)")
        }
        
        
        let category_json = findCategory(id: self.category)
        
        if let category = Categories.query(id: category_json.coreDataID) {
            exercise.category = category
        } else {
            let name = category_json.name
            exercise.category = Categories.checkIfExists(name: name)!
        }
        
        // temporary 
        exercise.category?.isActive = true
        saveContext()
    }
}



struct Metric_Info_JSON: Codable {
    var coreDataID: Int16
    var metric: String
    var output_label: String
    var sort_in_ascending_order: Bool
    var unit_of_measurement: String
    var exercise: Int16
    
    func save(exercises: [Exercise_JSON]) {
        guard Metric_Info.checkIfExists(for: coreDataID) == nil else {
            return 
        }
        
        func findExercise(id: Int16) -> Exercises {
            for exercise in exercises {
                if exercise.id == id {
                    return Exercises.exerciseAlreadyExistsWith(name: exercise.name, variation: exercise.variation ?? "")!
                }
            }
            fatalError("coudln't find exercise with id \(id)")
        }
        
        let exercise = findExercise(id: self.exercise)
        
        // ignores the idea of updating
        guard !exercise.metricInfoSet.contains(where: { $0.metricSV == metric }) else {
            return
        }
        
        if exercise.name == "Back Squat" {
            
        }
        
        let metricInfo = Metric_Info(context: context)
        var metricToSave = metric
        metricToSave = metricToSave == "Distance" ? "Length" : metricToSave
        metricInfo.metricSV = metricToSave
        metricInfo.id = coreDataID
        metricInfo.output_label = output_label
        metricInfo.sort_in_ascending_order = sort_in_ascending_order
       
        // Mark: Change metric if it = distance
        var uom = unit_of_measurement
        if uom == "Distance" {
            uom = "length"
        }
        
        metricInfo.unit_of_measurement = uom
        metricInfo.exercise = exercise
    }
}

struct Exercise_Metrics_JSON: Codable {
    var id: Int16
    var coreDataID: Int16
    var set_number: Int16 
    var weight: Double
    var reps: Double
    var sets: Double
    var time: Double
    var length: Double
    var velocity: Double
    
    var container: Int16
    
    func save(containers: [EM_Container_JSON]) {
        guard Exercise_Metrics.checkIfExists(for: coreDataID) == nil else {
            return
        }
        
        let newEM = Exercise_Metrics(context: context)
        newEM.id = coreDataID
        newEM.set_number = set_number
        newEM.weightSV = weight
        newEM.repsSV = reps
        newEM.setsSV = sets
        newEM.timeSV = time
        newEM.lengthSV = length
        newEM.velocitySV = velocity
        
        if time > 0 {
            
        }
        
        func findContainer(id: Int16) -> EM_Containers {
            for container in containers {
                if container.id == id {
                    return EM_Containers.checkIfExists(for: container.coreDataID)!
                }
            }
            fatalError("coudln't find exercise with id \(id)")
        }
        
        newEM.container = findContainer(id: self.container)
    }
    
    
}

struct Category_JSON: Codable {
    var id: Int16
    var coreDataID: Int16
    var isActive: Bool
    var name: String
    
    func save() {
        if let category = Categories.checkIfExists(name: name)  {
            
        } else {
            let category = Categories(context: context)
            category.id = coreDataID
            category.name = name
            category.isActive = isActive
            saveContext()
        }
    }
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
        guard returnValues.count < 2 else { fatalError("more than one item with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
}

extension Categories {
    class func checkIfExists(name: String) -> Categories? {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one item with same id")}
        guard let first = returnValues.first else { return nil }
        return first
    }
    
    class func query(id: Int16) -> Categories? {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        let result = try? context.fetch(request)
        guard let returnValues = result else { return nil }
        guard returnValues.count < 2 else { fatalError("more than one item with same id")}
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
        guard returnValues.count < 2 else { fatalError("more than one item with same id")}
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
        guard returnValues.count < 2 else { fatalError("more than one item with same id")}
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
        guard returnValues.count < 2 else { fatalError("more than one item with same id")}
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
        guard returnValues.count < 2 else { fatalError("more than one item with same id")}
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
        guard returnValues.count < 2 else { fatalError("more than one item with same id")}
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
        guard workouts.count < 2 else { fatalError("more than one item with same id")}
        guard let workout = workouts.first else { return nil }
        return workout
    }
}









