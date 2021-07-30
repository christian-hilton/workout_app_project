//
//  ViewController.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/28/21.
//

import UIKit
import CoreMotion
import CoreData
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource {

    
    
    //TODO LIST
    
    //UI
    //Boost
    //Acceleration
    //time
    //start
    //stop
    // Run + Bike
    
    //BE
    //time period
    // magnet??
    
    // location
    // speed
    // acceleration
    
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var uilabelx: UILabel!
    
    // For motion getting
    let motion = CMMotionManager()
    let locationManager = CLLocationManager()
    var timer: Timer?
    var locations: [CLLocation] = []
    var data = [("run", 0)]
//    var speed: Double
    
//    init(){
//        self.speed = -1
//        super.init(nibName: nil, bundle: nil)
//
//    }
    
    func dataList() -> [(String, Double)] {
        return [("speed", 0)]
    }
    
//    required init?(coder: NSCoder) {
//        self.speed = -1
//        super.init(nibName: nil, bundle: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("hello")
        startGyros()
        dataTable.dataSource = self
    }
    
    //    func startFetchData() {
    //        if self.motion.isAccelerometerAvailable, self.motion.isGyroAvailable, self.motion.isMagnetometerAvailable {
    //            print("MOTION!")
    //            self.motion.gyroUpdateInterval = 1.0 / 60.0
    //            self.motion.startGyroUpdates()
    //            if let dataGyro = self.motion.gyroData {
    //                var x = dataGyro.rotationRate.x
    //                uilabelx.text = String(x)
    //            }
    //
    //
    //
    //        }
    //        else {
    //            print("no motion")
    
    
    // TODO clean up
    func startGyros() {
        if motion.isGyroAvailable, self.motion.isAccelerometerAvailable {
            self.motion.gyroUpdateInterval = 10 //1.0 / 60.0
            self.motion.accelerometerUpdateInterval = 1 //1.0 / 60.0
            self.motion.startGyroUpdates()
            self.motion.startAccelerometerUpdates()
            
            //
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            //            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
            
            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0), //(1.0/60.0)
                               repeats: true, block: { (timer) in
                                // Get the gyro data.
                                if let data = self.motion.gyroData {
                                    let x = data.rotationRate.x
                                    let y = data.rotationRate.y
                                    let z = data.rotationRate.z
                                    
                                    //                    print("x " + String(x) + " y " + String(y) + " z " + String(z))
                                    
                                    // SPEED
                                    //                    var speed2: CLLocationSpeed
                                    //                    speed2 = self.locationManager.location?.speed ?? -1
                                    //                    print("other speed" + String(speed2))
                                    
                                    self.uilabelx.text = String(x)
                                    
                                    // Use the gyroscope data in your app.
                                }
                                
                                
                                if let data2 = self.motion.accelerometerData {
                                    let ax = data2.acceleration.x
                                    let ay = data2.acceleration.y
                                    let az = data2.acceleration.z
                                    
                                    // Use the accelerometer data in your app.
                                    print("ax " + String(ax) + " ay " + String(ay) + " az " + String(az))
                                    
                                }
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
    
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                
                               })
            
            
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default)
        }
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
            //print("speed " + String(speed))
            // Getting no. of floor
            // The logical floor of the building in which the user is located.
            let floor = location.floor
            
            // Getting The when the GPS data was taken
            let timeStamp = location.timestamp
            
            // The direction in which the device is traveling.
            let courseDirection = location.course
            
            // The altitude, measured in meters.
            // Positive values indicate altitudes above sea level. Negative values indicate altitudes below sea level.
            let hightFromSeaLevel = location.altitude
            
            
            //        let loc = locations + locations[0]
            //        print(loc.count)
            //        let loc2: [CLLocationCoordinate2D] = loc.map({(x: CLLocation) -> CLLocationCoordinate2D in
            //                                                            return x.coordinate}).suffix(2)
            //
            
            let distance = getDistance(locations: self.locations)
            
            print("distance" + String(distance))
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
    func getDistance(locations: [CLLocation]) -> CLLocationDistance {
        // By Aviel Gross
        // https://stackoverflow.com/questions/11077425/finding-distance-between-cllocationcoordinate2d-points
        if let from = locations.first,
           let to = locations.last {
            print(from.coordinate.latitude)
            print(to.coordinate.latitude)
            print("distance " + String(from.distance(from: to)))
            return from.distance(from: to)
        }
        else {return -1}
    }
    
    
    
    // when there is an Error while collecting GPS coordinate data by "locationManager" this method is called
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    
    
    
    
    
    // TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList().count
    }
    
    
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
        
        // Configure the cell’s contents with the row and section number.
        // The Basic cell style guarantees a label view is present in textLabel.
        let data = dataList()
        let curData = data[indexPath.row]
        cell.textLabel!.text = "\(curData.0) \(curData.1)"
        return cell
    }
}

