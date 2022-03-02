//
//  ViewController.swift
//  Lab5
//
//  Created by Arturo on 15/10/21.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    var max = 0
    var dis:Double = 0
    var lastL: CLLocation!
    var lastS:Double = 0
    var speedList:[Double]! = []
    var disList:[Double]! = []
    var maxAcc:Double = 0
    var first:Bool = true
    
    @IBOutlet weak var box1: UILabel!
    @IBOutlet weak var box2: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var maxAcceleration: UILabel!
    @IBOutlet weak var avgSpeed: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var maxSpeed: UILabel!
    @IBOutlet weak var currentSpeed: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        currentSpeed.text = "0 km/h"
    }

    @IBAction func startTrip(_ sender: Any) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            max=0
            dis=0
            maxAcc=0
            speedList.removeAll()
            disList.removeAll()
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 10
            box2.backgroundColor = UIColor.green
            
            
        }else{
            
            print("Location Not Enabled")
        }
    }
    
    @IBAction func stopTrip(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        box2.backgroundColor = UIColor.gray
        box1.backgroundColor = UIColor.clear
        currentSpeed.text = "0 km/h"
        mapView.showsUserLocation = false
        first = true
        box1.text=""
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get current location
        let userLocation = locations[0] as CLLocation
        
        //mapView.setRegion(MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
        let camera = MKMapCamera(lookingAtCenter: userLocation.coordinate, fromDistance: 900, pitch: 60, heading: userLocation.course)
        mapView.camera=camera
        mapView.showsUserLocation = true
        
        let speedD:Double = userLocation.speed //initial speed
        let speed = Int(speedD * 3.6) //speed in km/h
        speedList.append(speedD)
        currentSpeed.text = "\(speed) km/h"
        if (speed > 115){
            box1.backgroundColor = UIColor.red
        }else{
            box1.backgroundColor = UIColor.clear
        }
        //max speed
        if(speed>max){
            max=speed
            maxSpeed.text = "\(max) km/h"
        }
        //distance
        if(lastL != nil){
            let tmp = lastL.distance(from: userLocation) //distance between two points
            dis += tmp //accumulated distance
            distance.text = "\(String(format: "%.2f", dis/1000)) km"
            disList.append(tmp)
            avgSpeed(spdL: speedList)
            maxAccel(distance: tmp, vf: lastS, vi: speedD)
        }
        lastL = locations.last
        lastS = lastL.speed //last speed
        //display distance when riched 115 km/h
        if(first && speed>=115){
            box1.text="\(String(format: "%.2f", dis/1000)) km when 115 km/h reached"
            first=false
        }
        
    
    }
    //spdL in m/s, disL in m
    func avgSpeed(spdL: [Double]){
        var total:Double=0
        for s in spdL{
            total += s
        }
        avgSpeed.text = "\(String(format: "%.0f", total/Double(spdL.count)*3.6)) km/h"
        }
        
        
    func maxAccel(distance:Double,vf:Double,vi:Double){
        
        let finalSpeed:Double = vf * vf
        let initSpeed:Double = vi * vi
        let displacement:Double = 2 * distance
        let avgAcc = (finalSpeed-initSpeed) / (2 * displacement)
        if(avgAcc>0 && avgAcc>maxAcc){
            maxAcc=avgAcc
            maxAcceleration.text = "\(String(format: "%.3f", maxAcc)) m/s^2"
        }
        pow(firstArg: 5)
    }
        
    func pow(firstArg a:Int)->Int{
        return a*a
        
    }
    
}

