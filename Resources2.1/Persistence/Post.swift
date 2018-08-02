//
//  Post.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

//think about exercise ID's and having to keep ten billion of them in the database
//


import UIKit
import CoreData



enum DevMode: String {
    
    case production = "http://reactproject-env.ceymrx49ta.us-east-1.elasticbeanstalk.com/data/workout_data/"
    case development = "http://localhost:8000/data/workout_data/"
    
    var url: NSURL {
        return NSURL(string: self.rawValue)!
    }
    
}

func postData(env: DevMode = .production, completion: @escaping (HTTPURLResponse) -> Void) {
    
    guard let jsonData = CoreDataObjects.serializedData() else { return }
    
    let url = env.url 
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
                
                completion(httpResponse)
                
                if httpResponse.statusCode != 200 {
                   print(httpResponse)
                }
            }
            //ADD A RESPONSE IF THEY GET A 500 Status Code
            
            //let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
            
            //completion(json as! [String : Any])
            
        }
        catch {
            
            }
        }
    }
    task.resume()
}



enum CoreDataObjects: String {
    
    case BodyweightDB = "Bodyweight"
    case CategoriesDB = "Categories"
    case EM_ContainersDB = "EM_Containers"
    case Exercise_MetricsDB = "Exercise_Metrics"
    case ExercisesDB = "Exercises"
    case MetricInfo = "Metric_Info"
    case Multi_Exercise_ContainersDB = "Multi_Exercise_Containers"
    case SequencesDB = "Sequences"
    case SettingsDB = "Settings"
    case WorkoutsDB = "Workouts"
    
    static func serializedData() -> Data? {
        
        let data = returnAllPostData()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data,
                                                         options: .prettyPrinted) else { return nil }
        return jsonData
    }
    
    static func returnAllPostData() -> [String: Any] {
        
        var data = [String: [[String: Any]] ]()
        
        //have to make sure ID's align before sending
        
        All().forEach({
            $0.prepareIDs()
        })
        
        All().forEach({
            data[$0.rawValue] = $0.prepareToSend()
        })
        
        return data
    }
    
    static func All() -> [CoreDataObjects] {
        return [
            .BodyweightDB,
            .CategoriesDB,
            .EM_ContainersDB,
            .Exercise_MetricsDB,
            .ExercisesDB,
            .MetricInfo,
            .Multi_Exercise_ContainersDB,
            .SequencesDB,
            .SettingsDB,
            .WorkoutsDB
        ]
    }
    
    func prepareIDs() {
            
        let objects = getAllObjects()
        
        objects.forEach({
            if $0.id == 0 {
                let lastID = $0.getLastID() ?? 0
                $0.set(id: lastID + 1)
            }
        })
        saveContext()
        
    }
    
    
    func prepareToSend() -> [[String: Any]] {
        
        let objects = getAllObjects()
        return objects.map({ $0.createPostData() })
    }
    
    
    func getAllObjects() -> [Postable] {
        
        switch self {
            
        case .BodyweightDB:
            return Bodyweight.fetchAll()
            
        case .CategoriesDB:
            return Categories.fetchAll()
            
        case .EM_ContainersDB:
            return EM_Containers.fetchAll()
            
        case .Exercise_MetricsDB:
            return Exercise_Metrics.fetchAll()
            
        case .ExercisesDB:
            return Exercises.fetchAll()
            
        case .MetricInfo:
            return Metric_Info.fetchAll()
            
        case .Multi_Exercise_ContainersDB:
            return Multi_Exercise_Container_Types.fetchAll()
            
        case .SequencesDB:
            return Sequences.fetchAll()
            
        case .SettingsDB:
            let settings = Settings.fetchAll()
            let ret = settings.isEmpty ? [Settings(context: context)] : [ settings[0] ]
            saveContext()
            return ret 

        case .WorkoutsDB:
            return Workouts.fetchAll()
        }
        
    }

}



func pythonDateFormat(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
    
    return dateFormatter.string(from: date)
    
    
}

protocol Postable {
    var id: Int16 { get }
    static func getLastIDClass() -> Int16?
    func getLastID() -> Int16?
    func set(id: Int16)
    func createPostData() -> [String: Any]
}


extension Bodyweight: Postable {
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<Bodyweight> = Bodyweight.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return Bodyweight.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func createPostData() -> [String: Any] {
        var dict = [String: Any]()
        dict["coreDataID"] = id
        dict["bodyweight"] = bodyweight
        return dict
    }
    
}


extension Categories: Postable {
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return Categories.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func createPostData() -> [String: Any] {
        var dict = [String: Any]()
        dict["coreDataID"] = id
        dict["exercises"] = exerciseSet.map({ $0.id })
        return dict
    }
    
}

extension EM_Containers: Postable {
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<EM_Containers> = EM_Containers.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return EM_Containers.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func createPostData() -> [String: Any] {
        var dict = [String: Any]()
        dict["coreDataID"] = id
        dict["order"] = orderSV
        dict["exercise"] = exercise?.id ?? 0
        dict["sequence"] = sequence?.id ?? 0
        return dict
    }
    
}

extension Exercise_Metrics: Postable {
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<Exercise_Metrics> = Exercise_Metrics.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return Exercise_Metrics.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func isPersonalRecord() -> Bool {
        guard let _ =  container?.exercise?.personalRecordsManager.personalRecords.contains(self) else { return false }
        return true
    }
    
    func createPostData() -> [String: Any] {
        
        var dict = [String: Any]()
        dict["coreDataID"] = id
        dict["em_container"] = container?.id ?? 0
        dict["set_number"] = set_number
        dict["weight"] = value(for: .Weight)
        dict["reps"] = value(for: .Reps)
        dict["sets"] = value(for: .Sets)
        dict["time"] = value(for: .Time)
        dict["length"] = value(for: .Length)
        dict["velocity"] = value(for: .Velocity)
        dict["display_string"] = displayString()
        dict["personal_record"] = isPersonalRecord() ?  self.exercise?.id ?? 0 : ""
        return dict
    }
    
}

extension Exercises: Postable {
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<Exercises> = Exercises.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return Exercises.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func createPostData() -> [String: Any] {
        
        oneRepMaxManager.loadModel()
        
        var dict = [String: Any]()
        dict["coreDataID"] = id
        dict["name"] = name ?? ""
        dict["variation"] = variation ?? ""
        dict["oneRepMax"] = oneRepMaxManager.oneRM
        return dict
    }
    
}

extension Metric_Info: Postable {
    
    class func getLastIDClass() -> Int16? {
        let request: NSFetchRequest<Metric_Info> = Metric_Info.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
    }
    
    func getLastID() -> Int16? {
        return Metric_Info.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func createPostData() -> [String: Any] {
        var dict = [String: Any]()
        dict["coreDataID"] = id
        dict["exercise"] = exercise?.id ?? 0 
        dict["metric"] = metricSV
        dict["unit_of_measurement"] = unit_of_measurement
        dict["sort_in_ascending_order"] = sort_in_ascending_order
        return dict
    }
    
}


extension Multi_Exercise_Container_Types: Postable {
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<Multi_Exercise_Container_Types> = Multi_Exercise_Container_Types.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return Multi_Exercise_Container_Types.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func createPostData() -> [String: Any] {
        var dict = [String: Any]()
        dict["coreDataID"] = id
        return dict
    }
    
}

extension Settings: Postable {
    
    var id: Int16 {
        return 1 //shouldn't ever use this //set to one so that it's not reset every time
    }
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return 1
    }
    
    func set(id: Int16) {
         //don't use this 
    }
    
    class func fetchAll() -> [Settings] {
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        let result = try? context.fetch(request)
        guard let settings = result else { return [] }
        return settings
    }
    
    func createPostData() -> [String: Any] {
        
        var dict = [String: Any]()
        
        if let uniqueID = unique_id {
            dict["coreDataID"] = uniqueID
        } else {
            let uniqueID = UUID.init().uuidString
            unique_id = uniqueID
            dict["coreDataID"] = uniqueID
        }
        
        dict["coreDataID"] = unique_id!
        return dict
    }
    
}

extension Sequences: Postable {
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<Sequences> = Sequences.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return Sequences.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func createPostData() -> [String: Any] {
        var dict = [String: Any]()
        dict["coreDataID"] = id
        dict["workout_order"] = workout_order
        dict["workout"] = workout?.id ?? 0 
        return dict
    }
    
}

extension Workouts: Postable {
    
    class func getLastIDClass() -> Int16? {
        
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let results = try? context.fetch(request)
        guard let first = results?.firstItem else { return nil }
        return first.id
        
    }
    
    func getLastID() -> Int16? {
        return Workouts.getLastIDClass()
    }
    
    func set(id: Int16) {
        self.id = id
    }
    
    func createPostData() -> [String: Any] {
        var dict = [String: Any]()
        dict["coreDataID"] = id
        dict["name"] = name ?? ""
        guard let date = self.date else { fatalError() }
        dict["date"] = pythonDateFormat(date: date)
        return dict
    }
}




