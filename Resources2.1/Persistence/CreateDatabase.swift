//
//  CreateDatabase.swift
//  Resources2.1
//
//  Created by B_Litwin on 3/10/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import Foundation
import CoreData

func setupExercisesInDatabase() {
    
    let categories = CategoryToAdd.all()
    categories.forEach({ $0.create() })
    
}

private enum CategoryToAdd: String {
    
    case Arms
    case Back
    case Shoulders
    case Core
    case HipHinge = "Hip Hinge"
    case Jumps
    case LowerBodyAccessory = "Lower Body Accessory"
    case OlympicLifts = "Olympic Lifts"
    case SnatchAccessory = "Snatch Accessories"
    case CleanAccessory = "Clean Accessories"
    case Sprints
    case Squats
    case UnilateralLowerBody = "Unilateral Lower Body"
    case UpperBodyPress = "Upper Body Press"
    case Complexes = "Complexes"
    
    static func all() -> [CategoryToAdd] {
        return [
        .Arms,
        .Back,
        .Shoulders,
        .Core,
        .HipHinge,
        .Jumps,
        .LowerBodyAccessory,
        .OlympicLifts,
        .SnatchAccessory,
        .CleanAccessory,
        .Sprints,
        .Squats,
        .UnilateralLowerBody,
        .Complexes,
        .UpperBodyPress
        ]
    }
    
    func create() {
        
        let category = createCategory(name: self.rawValue)
        
        var exercises: [Exercises] = []
        
        var complexes: [[Exercises]] = [[]]
        
        switch self {
            
        case .Arms:
            exercises = [
            createExercise(name: "Hammer Curl"),
            createExercise(name: "Barbell Curl"),
            createExercise(name: "Cable Tricep Extension"),
            createExercise(name: "Skull Crusher"),
            createExercise(name: "Overhead Tricep Extension"),
            createExercise(name: "Dumbell Curl"),
            ]
            
        case .Back:
            exercises = [
                
            createExercise(name: "Pullup"), //make bodyweight
            createExercise(name: "Chinup", variation: "Weighted"), //make bodyweight
            createExercise(name: "Inverted Row", variation: "Weighted"), //make bodyweight
            createExercise(name: "Seated Cable Row"),
            createExercise(name: "Neutral-Grip Chinup"),
            createExercise(name: "1-Arm Dumbell Row"),
            createExercise(name: "Barbell Row"),
            createExercise(name: "T-Bar Row"),
            createExercise(name: "Dumbell Pullover"),
            createExercise(name: "Lat Pulldown"),
            
            createExercise(name: "Pullup", variation: "Bodyweight", metricType: .setReps),
            createExercise(name: "Chinup", variation: "Bodyweight", metricType: .setReps),
            createExercise(name: "Neutral-Grip Chinup", variation: "Bodyweight", metricType: .setReps)
            
            ]
            
        case .SnatchAccessory:
            
            exercises = [
                
                //Mark: Snatch Variations
                createExercise(name: "Power Snatch"),
                createExercise(name: "Snatch Pull"),
                createExercise(name: "Snatch Pull", variation: "From Podium"),
                createExercise(name: "Snatch Grip Deadlift"),
                createExercise(name: "Snatch Grip Deadlift", variation: "From Podium"),
                createExercise(name: "Snatch", variation: "From Podium"),
                createExercise(name: "Snatch", variation: "From Hang"),
                createExercise(name: "Snatch", variation: "From High Hang"),
                createExercise(name: "Snatch", variation: "Hang From Below Knee"),
                createExercise(name: "Snatch", variation: "Pause At Knee"),
                createExercise(name: "Snatch", variation: "From  Block"),
                createExercise(name: "Snatch", variation: "No Feet / No Hook-Grip"),
                createExercise(name: "Power Snatch", variation: "From Block"),
                createExercise(name: "Snatch", variation: "Clean-Grup"),
                createExercise(name: "Muscle Snatch"),
                createExercise(name: "Drop Snatch"),
                
                //other
                createExercise(name: "Drop Snatch"),
                createExercise(name: "Snatch Grip Push Press"),
                createExercise(name: "BTN Snatch-Grip Press")
                
            ]
            
        case .CleanAccessory:
            
            exercises = [
            
            //Mark: clean Variations
            createExercise(name: "Power Clean"),
            createExercise(name: "Clean Pull"),
            createExercise(name: "Clean Pull", variation: "From Podium"),
            createExercise(name: "Clean", variation: "From Podium"),
            createExercise(name: "Clean", variation: "From Hang"),
            createExercise(name: "Clean", variation: "From High Hang"),
            createExercise(name: "Clean", variation: "Hang From Below Knee"),
            createExercise(name: "Clean", variation: "Pause At Knee"),
            createExercise(name: "Clean", variation: "From  Block"),
            createExercise(name: "Clean", variation: "No Feet / No Hook-Grip"),
            createExercise(name: "Power Clean", variation: "From Block"),
            createExercise(name: "Muscle Clean"),
            
            ]
            
        case .Shoulders:
            
            exercises = [
            createExercise(name: "YTL Raises"),
            createExercise(name: "Bent-Over Lateral Raises"),
            createExercise(name: "Dumbell Front Raises"),
            createExercise(name: "Dumbell Lateral Raises"),
            createExercise(name: "Cable Face-Pull"),
            
            createExercise(name: "Band Pull-Apart", variation: "", metricType: .setReps)
            ]
            
        case .Core:
            
            let sixInches = createNameAndVarOnly(name: "Six Inches", variation: "")
            Metric_Info.create(metric: .Time, unitOfM: UnitDuration.seconds, exercise: sixInches)
            
            exercises = [
            
            createExercise(name: "Plank", variation: "Weighted"),
            createExercise(name: "Decline Situp", variation: "Weighted"),
            
            
            //mark: unweighted
            createExercise(name: "Hanging Leg-Raise", variation: "Bent Legs"),
            createExercise(name: "Hanging Leg-Raise", variation: "Straight Legs"),
            createExercise(name: "Situps", variation: "", metricType: .setReps),
            createExercise(name: "Leg Raises", variation: "", metricType: .setReps),
            createExercise(name: "Plank", variation: "Bodyweight", metricType: .setReps),
            createExercise(name: "Side Plank", variation: "", metricType: .setReps),
            createExercise(name: "Decline Situp", variation: "", metricType: .setReps),
            
            ]
            
        case .HipHinge:
            
            exercises = [
            
            createExercise(name: "Straight-Legged Deadlift"),
            createExercise(name: "Romanian Deadlift"),
            createExercise(name: "Sumo Deadlift"),
            createExercise(name: "Deadlift"),
            createExercise(name: "Hip Thrust", variation: "Barbell"),
            createExercise(name: "Hip Thrust", variation: "Band-Tension"),
            createExercise(name: "Deadlift", variation: "From Podium")
            
            ]
            
        case .Jumps:
            exercises = JumpEx.All().map({ $0.create() })
            
        case .LowerBodyAccessory:
            
            exercises = [
            
            createExercise(name: "Nordic Curl"),
            createExercise(name: "Leg Press"),
            createExercise(name: "45 Degree Back Extension"),
            createExercise(name: "Back Extension"),
            createExercise(name: "Hamstring Curl"),
            createExercise(name: "Leg Extension"),
            createExercise(name: "Hack Squat"),
            createExercise(name: "Glute-Ham Raise"),

            createExercise(name: "45 Degree Back Extension", variation: "Bodyweight", metricType: .setReps)
            
            ]
            
        case .OlympicLifts:
            
            exercises = [
                snatch,
                clean,
                jerk,
                splitJerk,
                pushJerk,
                squatJerk
            ]
            
            complexes = [
                
                [clean, jerk],
                [clean, splitJerk],
                [clean, pushJerk],
                [clean, squatJerk],
                
            ]
            
            complexes.forEach({ //FixME 
                _ = Multi_Exercise_Container_Types.create(category: category, with: $0, active: false)
            })
            
            
        case .Sprints:
            
            let sprints = [
                
            "10 yd Sprint",
            "10m Sprint",
            "20 yd Sprint",
            "20m Sprint",
            "30 yd Sprint",
            "30m Sprint",
            "40 yd Sprint",
            "40m Sprint",
            "60 yd Sprint",
            "60m Sprint",
            "100 yd Sprint",
            "100m Sprint",
            "200m",
            ]
            
            sprints.forEach({
                let exercise = Exercises.create(name: $0, variation: "")
                Metric_Info.create(metric: .Time, unitOfM: UnitDuration.seconds, exercise: exercise)
                exercises.append(exercise)
            })
            
            let fourHundedMeter = Exercises.create(name: "400m", variation: "")
            Metric_Info.create(metric: .Time, unitOfM: UnitDuration.seconds, exercise: fourHundedMeter)
            exercises.append(fourHundedMeter)
            
            let eightHundredMeter = Exercises.create(name: "800m", variation: "")
            Metric_Info.create(metric: .Time, unitOfM: UnitDuration.seconds, exercise: eightHundredMeter)
            exercises.append(eightHundredMeter)
            
            
            
        case .Squats:
            
            exercises = [
            
            createExercise(name: "Back Squat"),
            frontSquat,
            createExercise(name: "Back Squat", variation: "With Pause"),
            createExercise(name: "Front Squat Squat", variation: "With Pause"),
            createExercise(name: "Goblet Squat"),
            overheadSquat,
            createExercise(name: "Box Squat")
            
            ]
            
        case .UnilateralLowerBody:
            
            exercises = [
               
            createExercise(name: "Reverse Lunge", variation: "Barbell"),
            createExercise(name: "Reverse Lunge", variation: "Dumbell"),
            createExercise(name: "Walking Lunge", variation: "Barbell"),
            createExercise(name: "Walking Lunge", variation: "Dumbell"),
            createExercise(name: "Step-Up", variation: "Barbell"),
            createExercise(name: "Step-Up", variation: "Dumbell"),
            createExercise(name: "Bulgarian Split-Squat", variation: "Barbell"),
            createExercise(name: "Bulgarian Split-Squat", variation: "Dumbell"),
            createExercise(name: "Lateral Lunge", variation: "Dumbell")
            
            ]
            
        case .UpperBodyPress:
            exercises = [
            
             createExercise(name: "Pushups", variation: "Weighted"),
             createExercise(name: "Pushups", variation: "Feet-Elevated"),
             createExercise(name: "Incline Bench Press", variation: "Barbell"),
             createExercise(name: "Incline Bench Press", variation: "Dumbell"),
             createExercise(name: "Overhead Press", variation: "Barbell"),
             createExercise(name: "Overhead Press", variation: "Dumbell"),
             createExercise(name: "Bench Press", variation: "Barbell"),
             createExercise(name: "Bench Press", variation: "Dumbell"),
             createExercise(name: "Close-Grip Bench Press"),
             createExercise(name: "Dips", variation: "Weighted"),

             //mark nonStandard
            createExercise(name: "Pushups", variation: "Band-Resisted", metricType: .setReps),
            createExercise(name: "Dips", variation: "Bodyweight", metricType: .setReps),
            createExercise(name: "Pushups", variation: "Bodyweight", metricType: .setReps)
                
            ]
            
        case .Complexes:
            
            complexes = [
                
                [clean, frontSquat, jerk],
                [snatch, overheadSquat]
            ]
            
            complexes.forEach({
                _ = Multi_Exercise_Container_Types.create(category: category, with: $0, active: false)
            })
        
        }
 
        
        exercises.forEach({
            category.addToExercises($0)
        })
        
    }
}


let clean = createExercise(name: "Clean")
let snatch = createExercise(name: "Snatch")
let jerk = createExercise(name: "Jerk")
let splitJerk = createExercise(name: "Split Jerk")
let pushJerk = createExercise(name: "Push Jerk")
let squatJerk = createExercise(name: "Squat Jerk")
let frontSquat = createExercise(name: "Front Squat")
let overheadSquat = createExercise(name: "Overhead Squat")





private enum JumpEx {
    
    case hurdleJumpSingle
    case hurdleJumpRepetitive
    case broadJump
    case verticalLeap
    case weightedBoxJump
    case boxJump
    case tripleJump
    
    static func All() -> [JumpEx] {
        return  [
            .hurdleJumpSingle,
            .hurdleJumpRepetitive,
            .broadJump,
            .verticalLeap,
            .weightedBoxJump,
            .boxJump,
            tripleJump,
        ]
    }
    
    func create() -> Exercises {
        
        var exercise: Exercises!
        
        func addLength() {
            Metric_Info.create(metric: .Length, unitOfM: UnitLength.feet, exercise: exercise)
        }
        
        switch self {
            
        case .hurdleJumpSingle:
            exercise = createExercise(name: "Hurdle Jump", variation: "Single", metricType: .setReps)
            addLength()
            
        case .hurdleJumpRepetitive:
            exercise = createExercise(name: "Hurdle Jump", variation: "Repetitive", metricType: .setReps)
            addLength()
            
        case .broadJump:
            exercise = createNameAndVarOnly(name: "Broad Jump", variation: "")
            addLength()
            
        case .verticalLeap:
            exercise = createNameAndVarOnly(name: "Vertical Leap", variation: "")
            addLength()
            
        case .weightedBoxJump:
            exercise = createExercise(name: "Box Jump", variation: "Weighted")
            addLength()
            
        case .boxJump:
            exercise = createExercise(name: "Box Jump", variation: "", metricType: .setReps)
            addLength()
            
        case .tripleJump:
            exercise = createNameAndVarOnly(name: "Triple Jump", variation: "")
            addLength()
            
        }
        
        return exercise
    }
    
}



private extension Exercises {
    class func create(name: String, variation: String) -> Exercises {
        if let exercise = exerciseAlreadyExistsWith(name: name, variation: variation) {
            return exercise
        } else {
            let exercise = Exercises(context: context)
            exercise.name = name
            exercise.variation = variation
            return exercise
        }
    }
}



private func createExercise(name: String, variation: String, metricType: MetricType) -> Exercises {
    let exercise = Exercises.create(name: name, variation: variation)
    metricType.addTo(exercise: exercise)
    return exercise
}


private func createNameAndVarOnly(name: String, variation: String) -> Exercises {
    return Exercises.create(name: name, variation: variation)
}



private enum MetricType {
    case setReps
    case time(ascendingOrder: Bool, unitOfM: Dimension)
    case length(unitOfM: Dimension)
    
    func addTo(exercise: Exercises) {
        
        switch self {
            
        case .setReps:
            Metric_Info.create(metric: Metric.Reps, unitOfM: UnitReps.reps, exercise: exercise)
            Metric_Info.create(metric: Metric.Sets, unitOfM: UnitSets.sets, exercise: exercise)
            
        case .time(let ascendingOrder, let unitofM):
            Metric_Info.create(metric: Metric.Time, unitOfM: unitofM, exercise: exercise, sortInAscendingOrder: ascendingOrder)
            
        case .length(let unitOfM):
            Metric_Info.create(metric: Metric.Length, unitOfM: unitOfM, exercise: exercise)
            
        }
        
    }
    
}





private func createExercise(name: String, variation: String? = nil) -> Exercises {
    
    let exercise = Exercises.create(name: name, variation: variation ?? "")
    Metric_Info.create(metric: Metric.Weight, unitOfM: UnitMass.pounds, exercise: exercise)
    Metric_Info.create(metric: Metric.Reps, unitOfM: UnitReps.reps, exercise: exercise)
    Metric_Info.create(metric: Metric.Sets, unitOfM: UnitSets.sets, exercise: exercise)
    return exercise
    
}


private func createCategory(name: String) -> Categories {
    return Categories.addOrCreate(name)
}

private extension Categories {
    
    class func addOrCreate(_ name: String) -> Categories {
        
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        let results = try? context.fetch(request)
        
        if results!.count > 1 {
            return handleDuplicateCategories(results!)
        }
        
        if results!.count == 1 {
            return results![0]
        }
        
        let newCat = Categories(context: context)
        newCat.name = name
        return newCat
        
    }
    
    class func handleDuplicateCategories(_ categories: [Categories]) -> Categories {
        
        let categoryName = categories[0].name
        var exercises: [Exercises] = []
        
        for category in categories {
            
            for exercise in category.exercises as! Set<Exercises> {
                exercises.append(exercise)
            }
            context.delete(category)
        }
        
        let newCategory = Categories(context: context)
        newCategory.name = categoryName
        newCategory.exercises = Set(exercises) as NSSet
        return newCategory
        
    }
    
}










