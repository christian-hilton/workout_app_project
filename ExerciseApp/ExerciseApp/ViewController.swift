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


class ViewController: UIViewController, CLLocationManagerDelegate{
    
    
    
    //TODO LIST
    
    //UI
    // Run + Bike selection
    // unit labels, digits
    
    //BE
    //    // fix distance
    // fix acceleration
    // magnet??
    
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var headlineText: UILabel!
    
    var currentWorkout: WorkoutSession?
    
    // For motion getting
    let motion = CMMotionManager()
    let locationManager = CLLocationManager()
    var timer: Timer?
    
    var locations: [CLLocation] = [] //?
    
    var feedback: String = "0 Workouts this week, let's get started!"
    
    var timeInterval: Double = 1.0 / 60.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTable.dataSource = self
        self.currentWorkout = WorkoutSession()
        self.headlineText.text = feedback
    }
    
    @IBAction func pressStart(_ sender: Any) {
        self.currentWorkout?.toggle()
        startButton.titleLabel?.text = "End"
        //TODO text switches back to start
        
        pauseButton.isHidden = false
        
        startMotionSensors()
    }
    
    // Pause WorkoutSession / Motion Sensors
    @IBAction func pause(_ sender: Any) {
        
        pauseButton.isEnabled = false
        stopGyros()
        
    }
    
    
    // TODO clean up
    func startMotionSensors() {
        if motion.isGyroAvailable, self.motion.isAccelerometerAvailable {
            self.motion.gyroUpdateInterval = timeInterval //1.0 / 60.0
            self.motion.accelerometerUpdateInterval = timeInterval //1.0 / 60.0
            self.motion.startGyroUpdates()
            self.motion.startAccelerometerUpdates()
            
            //
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0), //(1.0/60.0)
                               repeats: true, block: { (timer) in
                                // rename
                                if let data = self.motion.gyroData {
                                    print(self.motion.gyroData)
                                    let x = data.rotationRate.x
                                    let y = data.rotationRate.y
                                    let z = data.rotationRate.z
                                }
                                
                                
                                if let data2 = self.motion.accelerometerData {
                                    let ax = data2.acceleration.x
                                    let ay = data2.acceleration.y
                                    let az = data2.acceleration.z
                                    
                                    //3d Acceleration TODO
                                    self.currentWorkout?.setAcceleration(Float(ax))
                                }
                                self.dataTable.reloadData()
                                
                               })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default )
        }
    }
    
    // TODO clean up
    func stopGyros() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
            
            self.motion.stopGyroUpdates()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // "locations" contain the arrays of Data, in order to get the latest data we have to use the last one so,
        // the last Data will be locations[locations.count - 1]
        let location = locations[locations.count - 1]
        self.locations.append(location)
        
        // To know if the Data that our device is correct, The "horizontalAccuracy" value should be grater then ZERO for valid GPS coordinate Data
        if location.horizontalAccuracy > 0 {
            
            //TODO: Step 7 ####################################################################
            // Time to stop collecting GPS data, as it will keep updating and will kill the battry of Device if we don't
            //           locationManager.stopUpdatingLocation()
            
            
            // Getting coordinate
            let Longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            
            // Getting Speed
            // The instantaneous speed of the device, measured in meters per second.
            let speed = location.speed
            print(location)
            currentWorkout?.setSpeed(Float(speed))
            //print("speed " + String(speed))
            
            // Getting The when the GPS data was taken
            //            let timeStamp = location.timestamp
            
            // The direction in which the device is traveling.
            //            let courseDirection = location.course
            
            // The altitude, measured in meters.
            // Positive values indicate altitudes above sea level. Negative values indicate altitudes below sea level.
            let hightFromSeaLevel = location.altitude
            
            
            //        let loc = locations + locations[0]
            //        print(loc.count)
            //        let loc2: [CLLocationCoordinate2D] = loc.map({(x: CLLocation) -> CLLocationCoordinate2D in
            //                                                            return x.coordinate}).suffix(2)
            //
            
            let distance = getDistance(locations: self.locations)
            currentWorkout?.setDistance(Float(distance))
            
            //            print("distance" + String(distance))
        }
    }
    
    
    //    func computeDistance(from points: [CLLocationCoordinate2D]) -> Double {
    //        guard let first = points.first else { return 0.0 }
    //        var prevPoint = first
    //        return points.reduce(0.0) { (count, point) -> Double in
    //            let newCount = count + CLLocation(latitude: prevPoint.latitude, longitude: prevPoint.longitude).distance(
    //                from: CLLocation(latitude: point.latitude, longitude: point.longitude))
    //            prevPoint = point
    //            return newCount
    //        }
    
    //todo distance goes down
    func getDistance(locations: [CLLocation]) -> CLLocationDistance {
        // By Aviel Gross
        // https://stackoverflow.com/questions/11077425/finding-distance-between-cllocationcoordinate2d-points
        if let from = locations.first,
           let to = locations.last {
            //            print(from.coordinate.latitude)
            //            print(to.coordinate.latitude)
            //            print("distance " + String(from.distance(from: to)))
            return from.distance(from: to)
        }
        else {return -1}
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWorkout?.getData().count ?? 0
    }
        
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
        
        // Configure the cell’s contents with the row and section number.
        // The Basic cell style guarantees a label view is present in textLabel.
        let data = currentWorkout?.getData()
        let curData = data?[indexPath.row] ?? ("", 0.0)
        cell.textLabel!.text = "\(curData.0) \(curData.1)"
        return cell
    }
}



