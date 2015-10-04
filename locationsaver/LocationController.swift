//
//  LocationController.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import Foundation
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
    
    /* Starts the process of retrieving locations. */
    func start() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /* Stops retrieving locations. */
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    /* Triggered each time the users' location gets updated. */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = (manager.location?.coordinate)!
        Debugger.messages.append("Lat: \(currentLocation.latitude) - Long: \(currentLocation.longitude) ")
        print(Debugger.messages.last!)
    }
    
    /* Registers the current coordinate with the rest of the registered coordinates. */
    func registerCurrentLocation(afterLogin: (success: Bool) -> Void) {
        let currentLocationDictionary : NSDictionary = ["latitude": currentLocation.latitude, "longitude": currentLocation.longitude]
        
        if pinnedLocations.containsObject(currentLocationDictionary) {
            afterLogin(success: false)
        }
        else {
            afterLogin(success: true)
            pinnedLocations.addObject(currentLocationDictionary)
            print(pinnedLocations.count)
        }
    }
    
    /* Sends back the last-updated coordinates. */
    func retrieveCurrentLocation() -> CLLocationCoordinate2D {
        return currentLocation
    }
    
}