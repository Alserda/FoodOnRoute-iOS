//
//  LocationManager.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: CLLocationManagerDelegate {
    
    
    var locationManager:CLLocationManager!
    var myLocations: [CLLocation] = []
    var locationDict = NSDictionary()
    var registeredLocations = NSMutableArray()
    
    func start() {
        self.startLocationManager()
    }
    
    
    
    
    
    func startLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
 

    func locationManager(manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print("\(locations[0])")
        myLocations.append(locations[0])
        
        let lat : NSNumber = NSNumber(double: manager.location!.coordinate.latitude)
        let lng : NSNumber = NSNumber(double: manager.location!.coordinate.longitude)
        
        self.locationDict = ["lat": lat, "lng": lng]
    }

    func sendLocationToBackend(sender: UIButton!) {
        //        print(self.locationDict)
        
        if self.registeredLocations.containsObject(self.locationDict) {
            print("Already contains \(self.locationDict)")
        }
        else {
            print("Does not contain yet, adding it now!")
            self.registeredLocations.addObject(self.locationDict)
            print("registerLocations:, \(self.registeredLocations)")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = self.locationDict["lat"] as! CLLocationDegrees
            annotation.coordinate.longitude = self.locationDict["lng"] as! CLLocationDegrees
            mapView.addAnnotation(annotation)
            
        }
}
