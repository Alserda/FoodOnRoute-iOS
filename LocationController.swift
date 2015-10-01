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
    var currentLocation = NSDictionary()
    var pinnedLocations = NSMutableArray()
    
    override init() {
        super.init()
        locationManager.delegate = self
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
        print("\(locations[0])")
        
        let currentLocationLatitiude : Double = (manager.location?.coordinate.latitude)!
        let currentLocationLongitude : Double = (manager.location?.coordinate.longitude)!
        
        let currentCoordinate : CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        currentLocation = ["latitude": currentLocationLatitiude, "longitude": currentLocationLongitude]
        
        print(currentLocation)
        

        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\(__error())")
    }
    
}