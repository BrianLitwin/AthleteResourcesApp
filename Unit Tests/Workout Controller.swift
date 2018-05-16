//
//  Workout Controller.swift
//  Resources2.1Test
//
//  Created by B_Litwin on 2/13/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

@testable import Resources2_1
@testable import Resources_View2_1
import XCTest


//
// WIP 
//

class Workout_Controller: XCTestCase {
    
    override func setUp() {
        context = setUpInMemoryManagedObjectContext()
        
    }
    
    func test_Initial_State() {
        
        
        
    }
    
    func test_withStoryboard() {
        
        let keyWindow: UIWindow = UIApplication.shared.keyWindow!
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //this will setup the exercises to choose from
        
        let navControl = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
        navControl.viewDidLoad()
        
        let currentWorkoutController = storyboard.instantiateViewController(withIdentifier: "WorkoutViewController") as! WorkoutViewController
        currentWorkoutController.viewDidLoad()
        
        XCTAssert(currentWorkoutController.view.subviews[0] is ScrollView)
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
