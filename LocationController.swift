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
        
        print("\(__FUNCTION__)")
        
    }
    
    func start() {
        print("\(__FUNCTION__)")
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        print("\(__FUNCTION__)")
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("\(__FUNCTION__)")

        currentLocation = (manager.location?.coordinate)!
        
//        print(currentLocation)


    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\(__error())")
    }
    
    func retrieveCurrentLocation() -> CLLocationCoordinate2D {
        return currentLocation

    }
    
}