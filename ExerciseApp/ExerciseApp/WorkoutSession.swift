//
//  WorkoutSession.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/25/21.
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
    
    // Initalize with default values
    init() {
        self.type = "Run🏃‍♂️"
        self.duration = 0
        self.distance = 0
        self.speed = 0
        self.status = "Starting"
        self.acceleration = 0
        self.active = false
        self.completed = false
    }
    
    func setSpeed(_ newSpeed: Float){
        self.speed = newSpeed
    }
    
    func getSpeed() -> String {
        return String(abs(round(speed * 10) / 10.0)) + " m / s"
    }
    
    func setDistance(_ newDistance: Float){
        self.distance = newDistance
    }
    
    func getDistance() -> String {
        return String(abs(round(distance * 10) / 10.0)) + " m"
    }
    
    func getData() -> [(String, String)] {
        return [("duration", getDuration()), ("speed", getSpeed()), ("distance", getDistance()), ("acceleration", getAcceleration())]
    }
    
    func getDuration() -> String {
        let minutes = String(Int(duration) / 60)
        var seconds = String(Int(duration) % 60)
        if seconds.count < 2 {seconds = "0" + seconds}
        return minutes + ":" + seconds
    }
    
    func setAcceleration(_ newAcceleration: Float) {
        acceleration = newAcceleration
    }
    
    func getAcceleration() -> String {
        return String(abs(round(acceleration * 10) / 10.0 )) + " m / s / s"
    }
    
    func setDuration(newDuration: Float) {
        duration = newDuration
    }
    
    func setType(newType: String){
        type = newType
    }
    
    // toggle timer on/off
    func toggle() {
        // if inactive, enable timer
        if !active {
        self.timer = Timer(fire: Date(), interval: (1.0),
                           repeats: true, block: { (timer) in
                            self.duration += 1
                           })
        RunLoop.current.add(self.timer!, forMode: .default )
        }
        
        // if already active, turn off timer
        else {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.active = !active
    }
}
