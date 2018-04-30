//
//  Timer.swift
//  Resources2.1
//
//  Created by B_Litwin on 1/25/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

class TimerView {
    
}


class TimerModel1 {
    
    var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    var displayText: String = ""
 
    func reset() {
        
        // Invalidate timer
        timer?.invalidate()
        
        // Reset timer variables
        startTime = 0
        time = 0
        elapsed = 0
        status = false
        
        // Reset all three labels to 00
        let strReset = String("00")
        displayText = "00:00.00"
        
    }
    
    func start() {
        
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        // Set Start/Stop button to true
        status = true
        
    }
    
    func stop() {
        
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        
        // Set Start/Stop button to false
        status = false
        
    }
    
    func updateStopwatch() {
        
    }
    
    func updateCountdown() {
        
    }
    
    
    @objc func updateCounter() {
        
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt8(time * 100)
        
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        // Add time vars to relevant labels
        displayText = "\(strMinutes):\(strSeconds):\(strMilliseconds)"
        
    }
}














