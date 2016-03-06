//
//  IdleCostCalc.swift
//  IdleCost
//
//  Created by David Chu on 2/19/16.
//  Copyright © 2016 David Chu. All rights reserved.
//

import Foundation

class IdleCostCalc {
    
    var fuelUsed:Double = 0
    var idleTimeMinutes:Double = 0
    var idleTimeSeconds:Double = 0
    var spent:Double = 0
    let fuelCost = 1.80
    let gallonsPerMinute = 0.003333333333
    
    func main() {
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCalc"), userInfo: nil, repeats: true)
    }
    
    @objc func updateCalc() {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        //idleTimeSeconds = abs(timeSinceLast)
        //idleTimeMinutes = idleTimeSeconds / 60
        fuelUsed = gallonsPerMinute * idleTimeMinutes
        spent = fuelCost * fuelUsed
        print("Fuel Used: \(fuelUsed) gallons.")
        print("Idle Time: \(idleTimeSeconds) seconds")
        print("You have spent $ \(formatter.stringFromNumber(spent)!) while idling.")
    }
    
    func updateTime() {
        idleTimeSeconds++
        idleTimeMinutes = idleTimeSeconds / 60
    }
    
    func getFuelUsed() -> Double {
        return fuelUsed
    }
    
    func getIdleTimeMinutes() -> Double {
        return idleTimeMinutes
    }
    
    func getIdleTimeSeconds() -> Double {
        return idleTimeSeconds
    }
    
    func getGallonsPerMinute() -> Double {
        return gallonsPerMinute
    }
    
    func getFuelCost() -> Double {
        return fuelCost
    }
    
    func getSpent() -> Double {
        return spent
    }
    
    func reset() {
        fuelUsed = 0;
        idleTimeMinutes = 0;
        idleTimeSeconds = 0;
        spent = 0;
    }
}