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
    
    func getSpeed() -> String {
        return String(speed) + " m / s"
    }
    
    func setDistance(_ newDistance: Float){
        self.distance = newDistance
    }
    
    func getDistance() -> String {
        return String(distance) + " m"
    }
    
    func getData() -> [(String, String)] {
        return [("duration", getDuration()), ("speed", getSpeed()), ("distance", getDistance()), ("acceleration", getAcceleration())]
    }
    
    func getDuration() -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(minutes) + ":" + String(seconds)
    }
    
    func setAcceleration(_ newAcceleration: Float) {
        acceleration = newAcceleration
    }
    
    func getAcceleration() -> String {
        return String(acceleration) + " m / s / s"
    }
    
    // ?
    func setDuration(newDuration: Float) {
        duration = newDuration
    }
    
    // toggle timer on/off
    func toggle() {
        // if inactive, enable timer
        if !active {
        print("starting")
        self.timer = Timer(fire: Date(), interval: (1.0),
                           repeats: true, block: { (timer) in
                            self.duration += 1
                            print(self.duration)
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
