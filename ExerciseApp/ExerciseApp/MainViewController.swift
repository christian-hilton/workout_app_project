//
//  ViewController.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/15/21.
//

import UIKit
import CoreMotion
import CoreData
import CoreLocation

class MainViewController: UIViewController{
    
    //TODO LIST
    // complete workout
    // print statements

    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var headlineText: UILabel!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var runText: UILabel!
    @IBOutlet weak var bikeText: UILabel!
    var workoutList: WorkoutsCollectionViewController?
    
    var currentWorkout: WorkoutSession?
    var prevWorkouts: [WorkoutSession]?
    
    // For motion data fetching
    let motion = CMMotionManager()
    let pedometer = CMPedometer()
    let location = CLLocation()
    var timer: Timer?
    
    var feedback: String = "0 Workouts this week, let's get started!"
    
    // Time Interval for displaying updates. 1 second by default
    var timeInterval: Double = 1.0 / 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTable.dataSource = self
        self.currentWorkout = WorkoutSession()
        self.headlineText.text = feedback
        
        let tapRun = UITapGestureRecognizer(target: self, action: #selector(self.tapRun))
        runText.isUserInteractionEnabled = true
        runText.addGestureRecognizer(tapRun)
        
        let tapBike = UITapGestureRecognizer(target: self, action: #selector(self.tapBike))
        bikeText.isUserInteractionEnabled = true
        bikeText.addGestureRecognizer(tapBike)
        
        prevWorkouts = []
        }
    
    @objc func tapRun(sender:UITapGestureRecognizer) {
        currentWorkout?.setType(newType: "Run")
        runText.alpha = 1
        bikeText.alpha = 0.2
    }
    
    @objc func tapBike(sender:UITapGestureRecognizer) {
        currentWorkout?.setType(newType: "Bike")
        runText.alpha = 0.2
        bikeText.alpha = 1
    }
    
    
    @IBAction func pressStart(_ sender: Any) {
        self.currentWorkout?.toggle()
        //TODO text switches back to start
        
        pauseButton.isEnabled = true
        startButton.isEnabled = false
        endButton.isEnabled = true
        
        startMotionSensors()
        
        print()
    }
    
    // Pause WorkoutSession / Motion Sensors
    @IBAction func pause(_ sender: Any) {
        pauseButton.isEnabled = false
        stopSensorData()
        currentWorkout?.toggle()
        
        startButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    @IBAction func endWorkout(_ sender: Any) {
        stopSensorData()
        
        currentWorkout?.toggle()
        
        // update buttons
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        endButton.isEnabled = false
        
        //add to workouts
        prevWorkouts?.append(currentWorkout!)
        workoutList?.dataSource = prevWorkouts ?? []
        workoutList?.reload(new: prevWorkouts ?? [])
        
        // Create new blank workout session
        currentWorkout = WorkoutSession()
        dataTable.reloadData()

        headlineText.text = "\(prevWorkouts!.count) Workouts this week, let's get started!"
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
                    print(pedData)
                    
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
                                if let accData = self.motion.accelerometerData {
                                    
                                    print(accData)
                                                                        
                                    let ax = accData.acceleration.x
                                    let ay = accData.acceleration.y
                                    let az = accData.acceleration.z
                                    
                                    print(self.location)
                                    let speed = self.location.speed
                                    self.currentWorkout?.setSpeed(Float(speed))
                                    
                                    let acceleration = sqrt(ax * ax + ay * ay)
                                    
                                    self.currentWorkout?.setAcceleration(Float(acceleration))
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

extension MainViewController: UICollectionViewDelegate {
    func getWorkoutData() -> [WorkoutSession] {
        return prevWorkouts ?? []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! WorkoutsCollectionViewController
        workoutList = nextVC
        nextVC.dataSource = prevWorkouts ?? []
    }
}
