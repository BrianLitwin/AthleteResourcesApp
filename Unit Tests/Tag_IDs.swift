//
//  Tag_IDs.swift
//  Unit Tests
//
//  Created by B_Litwin on 3/11/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import XCTest
@testable import Resources2_1

class Tag_IDs: XCTestCase {
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
    }
    
    override func tearDown() {
        XCTAssertNotNil(CoreDataObjects.serializedData())
    }
    
    func test_post() {
        
        let workout = Workouts.createNewWorkout()
        workout.dateSV = getDate(daysAgo: 7)
        let sequence = Sequences(context: context)
        sequence.workout = workout
        sequence.workout_order = 0
        
        sequence.insertContainer(exercise: makeExercise(), section: 0)
        sequence.insertExerciseMetric(at: [0,0])
        
        let exerciseMetric = sequence.exerciseMetric(for: [0,0])
        exerciseMetric.weightSV = 200
        exerciseMetric.repsSV = 2
        
        let exercise = makeExercise()
        
        let urlExpectation = expectation(description: "POST")
        
        postData(env: .development) {
            response in
            XCTAssertEqual(response.statusCode, 200)
            urlExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func test_tag_ids() {
        
        //
        //test that getting last id works
        //
        
        //no exercises in database should return nil 
        XCTAssertNil(Exercises.getLastIDClass())
        
        //test that first id's default value is 0
        let exercise1 = makeExercise()
        XCTAssertEqual(Exercises.getLastIDClass(), 0)
        
        //test that last ID is returned
        let exercise2 = makeExercise()
        exercise2.id = 2
        XCTAssertEqual(Exercises.getLastIDClass(), 2)
        
    }
    
    func test_uniqueValues() {
        
        //
        //Test that the ids are configured to the right object
        //
        
        let bodyweight = Bodyweight(context: context)
        let category = Categories(context: context)
        let em_Container = EM_Containers(context: context)
        let em = Exercise_Metrics(context: context)
        let exercise = makeExercise()
        let multi_exercise_container_type = Multi_Exercise_Container_Types(context: context)
        let sequence = Sequences(context: context)
        //let settings = Settings(context: context)
        let wrkt = Workouts.createNewWorkout()
        let mi = Metric_Info(context: context)
        wrkt.dateSV = Date()
        mi.metricSV = Metric.Weight.rawValue
        
        bodyweight.id = 2
        category.id = 3
        em_Container.id = 4
        em.id = 5
        exercise.id = 6
        multi_exercise_container_type.id = 7
        sequence.id = 8
        //settings doesn't use id in normal fashion
        wrkt.id = 10
        mi.id = 12
        
        //test class func
        XCTAssertEqual(Bodyweight.getLastIDClass(), 2)
        XCTAssertEqual(Categories.getLastIDClass(), 3)
        XCTAssertEqual(EM_Containers.getLastIDClass(), 4)
        XCTAssertEqual(Exercise_Metrics.getLastIDClass(), 5)
        XCTAssertEqual(Exercises.getLastIDClass(), 6)
        XCTAssertEqual(Multi_Exercise_Container_Types.getLastIDClass(), 7)
        XCTAssertEqual(Sequences.getLastIDClass(), 8)
        XCTAssertEqual(Workouts.getLastIDClass(), 10)
        XCTAssertEqual(Metric_Info.getLastIDClass(), 12)
       
        //test
        XCTAssertEqual(bodyweight.getLastID(), 2)
        XCTAssertEqual(category.getLastID(), 3)
        XCTAssertEqual(em_Container.getLastID(), 4)
        XCTAssertEqual(em.getLastID(), 5)
        XCTAssertEqual(exercise.getLastID(), 6)
        XCTAssertEqual(multi_exercise_container_type.getLastID(), 7)
        XCTAssertEqual(sequence.getLastID(), 8)
        XCTAssertEqual(wrkt.getLastID(), 10)
        XCTAssertEqual(mi.getLastID(), 12)
        
    }
    
    func test_creating_ids() {
        
        let exercise = makeExercise()
        let exercise1 = makeExercise()
        let exercise2 = makeExercise()
        let exercise3 = makeExercise()
        let exercise4 = makeExercise()
        
        exercise.id = 0
        exercise1.id = 3
        exercise2.id = 5
        
        CoreDataObjects.All().forEach({ $0.prepareIDs() })
        
        let exercises = Exercises.fetchAll().sorted(by: { $0.id < $1.id })
        
        for (i, e) in exercises.enumerated() {
            switch i {
            case 0:
                XCTAssertEqual(e.id, 3)
            case 1:
                XCTAssertEqual(e.id, 5)
            case 2:
                XCTAssertEqual(e.id, 6)
            case 3:
                XCTAssertEqual(e.id, 7)
            case 4:
                XCTAssertEqual(e.id, 8)
            case 5:
                XCTAssertEqual(e.id, 9)
            default:
                break
            }
        }
        
        
    }
    
    func test_Bodyweight() {
        
        let bodyweight1 = Bodyweight(context: context)
        bodyweight1.bodyweight = 100
        bodyweight1.id = 16
        
        let bodyweight2 = Bodyweight(context: context)
        bodyweight2.bodyweight = 200
       
        XCTAssertEqual(bodyweight1.createPostData()["bodyweight"] as! Double, 100)
        
        XCTAssertEqual(bodyweight1.createPostData()["coreDataID"] as! Int16, 16)
        
        XCTAssertEqual(bodyweight2.createPostData()["bodyweight"] as! Double, 200)
        
        XCTAssertEqual(bodyweight2.createPostData()["coreDataID"] as! Int16, 0)
        
        XCTAssertNotNil(CoreDataObjects.serializedData())
    }
    
    func test_categories() {
        
        let category1 = Categories(context: context)
        let category2 = Categories(context: context)
        
        //TODO
        
    }
    
    
    func test_exercise_metrics() {
        
        let em = Exercise_Metrics(context: context)
        let container = EM_Containers(context: context)
        container.id = 5
        em.container = container
        let exercise = makeExercise()
        exercise.id = 17
        
        em.container!.exercise = exercise
        em.save(double: 15, metric: .Weight)
        em.save(double: 5, metric: .Reps)
        
        
        let postData = em.createPostData()
        
        XCTAssertEqual(postData["em_container"] as! Int16, 5)
        
     
    }
    
    func test_settings() {
        
        //test creating the first settings object if it doesn't exist
        
        var allPostData = CoreDataObjects.returnAllPostData()
        var settingsPostData = allPostData["Settings"] as! [[String: Any]]
        let id = settingsPostData[0]["coreDataID"] as! String
        
        allPostData = CoreDataObjects.returnAllPostData()
        settingsPostData = allPostData["Settings"] as! [[String: Any]]
        let id2 = settingsPostData[0]["coreDataID"] as! String
        
        //make sure it's not creating a new id every post request
        XCTAssertEqual(id, id2)
        
    }
    
    func test_sequences() {
        let workout = Workouts.createNewWorkout()
        workout.id = 17
        let sequence = Sequences(context: context)
        sequence.workout = workout
        
        let postData = sequence.createPostData()
        
        let sequence1 = Sequences(context: context)
        let sequence2 = Sequences(context: context)
        
        let sequences = Sequences.fetchAll()
        XCTAssertEqual(sequences.count, 3)
        
        XCTAssertEqual(postData["workout"] as! Int16, 17)
        
    }
    
    func test_Workouts() {
        let workout = Workouts.createNewWorkout()
        let twoDaysAgo = getDate(daysAgo: 2)
        workout.dateSV = twoDaysAgo
        workout.id = 2
        let dateFormat = pythonDateFormat(date: twoDaysAgo)
        
        let postData = workout.createPostData()
        
        XCTAssertEqual(dateFormat, postData["date"] as! String)
        XCTAssertEqual(2, postData["coreDataID"] as! Int16)
        
        
    }
    
    
    func test_IDs_for_realtedObjects() {
        //test when you send objecst, that their ID's match up i.e. sequence.workout.id = workout.id
        
        let workout = Workouts.createNewWorkout()
        let sequence = Sequences(context: context)
        sequence.workout = workout
        
        let data = CoreDataObjects.returnAllPostData()
        let sequences = data["Sequences"] as! [[String: Any]]
        let workouts = data["Workouts"]! as! [[String: Any]]
        
        XCTAssertEqual(sequences[0]["workout"] as! Int16, 1)
        XCTAssertEqual(workouts[0]["coreDataID"] as! Int16, 1)
        
        
    }
    
    
}


