//
//  MapViewController.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate {
    let locationManager = LocationController()
    let mapView = MKMapView()
    var currentLocation = CLLocationCoordinate2D()
    var timer : NSTimer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.start()
        addMapView()
        
        print(currentLocation)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "getCurrentCoordinates", userInfo: nil, repeats: true)
        
        
    }
    
    func addMapView() {
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        mapView.frame = self.view.frame
        view.addSubview(mapView)

    }
    
    func updateMapRegion(coordinates: CLLocationCoordinate2D) {
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(spanX, spanY))
        
        mapView.setRegion(newRegion, animated: true)
    }
    
    func timerFunc() {
        print("timerFunc()")
    }
    
    func getCurrentCoordinates() {
        currentLocation = locationManager.retrieveCurrentLocation()
        print(currentLocation)
        updateMapRegion(currentLocation)
    }
}
