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
        Locations.lastLocation = (manager.location?.coordinate)!
        print(Locations.lastLocation)
    }
    
    /* Registers the current coordinate with the rest of the registered coordinates. */
    func registerCurrentLocation(sentParameters: (success: Bool, coordinates: CLLocationCoordinate2D) -> Void) {
        let lastCoordinates : CLLocationCoordinate2D = Locations.lastLocation

        if (Locations.pinnedLocations.contains {$0.equals(lastCoordinates)}) {
            sentParameters(success: false, coordinates: lastCoordinates)
        }
        else {
            Locations.pinnedLocations.append(lastCoordinates)
            print(Locations.pinnedLocations.count)
            sentParameters(success: true, coordinates: lastCoordinates)
        }
    }

}



