//
//  LocationController.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController : NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var pinnedLocations = NSMutableArray()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func start() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = (manager.location?.coordinate)!
    }
    
    func registerCurrentLocation(sender: UIButton!) {
        let currentLocationDictionary : NSDictionary = ["latitude": currentLocation.latitude, "longitude": currentLocation.longitude]
        
        if pinnedLocations.containsObject(currentLocationDictionary) {
            print("Already contains this coordinate")
        }
        else {
            print("Does not contain yet, adding it now!")
            self.pinnedLocations.addObject(currentLocationDictionary)
            print(pinnedLocations.count)
        }
    }
    
    func retrieveCurrentLocation() -> CLLocationCoordinate2D {
        return currentLocation
    }
    
}