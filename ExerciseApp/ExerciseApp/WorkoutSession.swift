//
//  WorkoutSession.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/30/21.
//

import Foundation


class WorkoutSession {
    
    var type: String?
    var duration: Float
    var speed: Float
    var distance: Float
    var status: String
    var acceleration: Float
    var active: Bool
    var completed: Bool
    
    var timer: Timer?
    
    init() {
        self.duration = 0
        self.distance = -1
        self.speed = -1
        self.status = "Starting"
        self.acceleration = 0
        self.active = false
        self.completed = false
    }
    
    func setSpeed(_ newSpeed: Float){
        self.speed = newSpeed
    }
    
    func setDistance(_ newDistance: Float){
        self.distance = newDistance
    }
    
    func getData() -> [(String, Float)] {
        return [("duration", duration), ("speed", speed), ("distance", distance), ("acceleration", acceleration)]
    }
    
    func getDuration() -> Float {
        return duration
    }
    
    func setAcceleration(_ newAcceleration: Float) {
        acceleration = newAcceleration
    }
    
    // ?
    func setDuration(newDuration: Float) {
        duration = newDuration
    }
    
    //
    func toggle() {
        if !active {
        print("starting")
        self.timer = Timer(fire: Date(), interval: (1.0), //(1.0/60.0)
                           repeats: true, block: { (timer) in
                            self.duration += 1
                            print(self.duration)
                           })
        RunLoop.current.add(self.timer!, forMode: .default )
        }
        // if already active, turn off timer
        else {
            self.timer = nil
        }
        self.active = !active
    }
    

    
}


//struct Metric {
//
//    var name: String
//    var number: Double
//
//}
