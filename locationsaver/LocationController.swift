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
    var pinnedLocations = NSMutableArray()
    
    
    /* Starts the process of retrieving locations. */
    func start() {
        print("Start Triggered")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /* Stops retrieving locations. */
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    /* Triggered each time the users' location gets updated. */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LastUpdatedLocation.lastLocation = (manager.location?.coordinate)!
        Debugger.messages.append("Lat: \(LastUpdatedLocation.lastLocation.latitude) - Long: \(LastUpdatedLocation.lastLocation.longitude) ")
        print(LastUpdatedLocation.lastLocation)
    }
    
    /* Registers the current coordinate with the rest of the registered coordinates. */
    func registerCurrentLocation(sentParameters: (success: Bool, coordinates: CLLocationCoordinate2D) -> Void) {
        let lastCoordinates = LastUpdatedLocation.lastLocation
        let currentLocationDictionary : NSDictionary = ["latitude": lastCoordinates.latitude, "longitude": lastCoordinates.longitude]
        
        if pinnedLocations.containsObject(currentLocationDictionary) {
            sentParameters(success: false, coordinates: lastCoordinates)
        }
        else {
            sentParameters(success: true, coordinates: lastCoordinates)
            pinnedLocations.addObject(currentLocationDictionary)
            print(pinnedLocations.count)
        }
    }

}