//
//  ViewController.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/15/21.
//

import UIKit
import CoreMotion
import CoreData


class MainViewController: UIViewController{
    
    //TODO LIST
    // truncate decimals
    // complete workout
    // Run + Bike selection
    // fix acceleration
    
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var headlineText: UILabel!
    @IBOutlet weak var endButton: UIButton!
    
    var currentWorkout: WorkoutSession?
    var prevWorkouts: [WorkoutSession]?
    
    // For motion data fetching
    let motion = CMMotionManager()
    let pedometer = CMPedometer()
    var timer: Timer?
    
    var feedback: String = "0 Workouts this week, let's get started!"
    
    // Time Interval for displaying updates. 1 second by default
    var timeInterval: Double = 1.0 / 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTable.dataSource = self
        self.currentWorkout = WorkoutSession()
        self.headlineText.text = feedback
    }
    
    @IBAction func pressStart(_ sender: Any) {
        self.currentWorkout?.toggle()
        //TODO text switches back to start
        
        pauseButton.isEnabled = true
        startButton.isEnabled = false
        endButton.isEnabled = true
        
        startMotionSensors()
    }
    
    // Pause WorkoutSession / Motion Sensors
    @IBAction func pause(_ sender: Any) {
        pauseButton.isEnabled = false
        stopSensorData()
        //acceleration
        currentWorkout?.toggle()
    }
    
    @IBAction func endWorkout(_ sender: Any) {
        stopSensorData()
        //add to workouts
        
        currentWorkout?.toggle()
        
        // Create new blank workout session
        currentWorkout = WorkoutSession()
    }
    
    // Start fetching motion sensors
    func startMotionSensors() {
        if motion.isGyroAvailable, self.motion.isAccelerometerAvailable {
            self.motion.gyroUpdateInterval = timeInterval
            self.motion.accelerometerUpdateInterval = timeInterval
            self.motion.startGyroUpdates()
            self.motion.startAccelerometerUpdates()
            self.pedometer.startUpdates(from: Date(), withHandler: {(data, error) in
                if let pedData = data{
                    let distance = Float(pedData.distance ?? 0)
                    self.currentWorkout?.setDistance(distance)
                    print(pedData)
                    } else {
                        print("Steps: Not Available")
                    }
            })
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0), //(1.0/60.0)
                               repeats: true, block: { (timer) in
                                // rename todo
                                if let data2 = self.motion.accelerometerData {
                                    let ax = data2.acceleration.x
                                    let ay = data2.acceleration.y
                                    let az = data2.acceleration.z
                                    
                                    //3d Acceleration TODO
                                    self.currentWorkout?.setAcceleration(Float(ax))
                                }
                                
                                // Reload data
                                self.dataTable.reloadData()
                               })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default )
        }
    }
    
    // Turn off updates
    func stopSensorData() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            self.motion.stopGyroUpdates()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWorkout?.getData().count ?? 0
    }
        
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
        
        let data = currentWorkout?.getData()
        let curData: (String, String) = data?[indexPath.row] ?? ("", "")
        cell.textLabel!.text = "\(curData.0) \(curData.1)"
        return cell
    }
}
