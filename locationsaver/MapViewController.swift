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
    var timer : NSTimer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.start()
        addMapView()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateMapWithCurrentLocation", userInfo: nil, repeats: true)
    }
    
    func addMapView() {
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        mapView.frame = self.view.frame
        view.addSubview(mapView)

    }
    
    func updateMapWithCurrentLocation() {
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegionMake(locationManager.retrieveCurrentLocation(), MKCoordinateSpanMake(spanX, spanY))
        
        mapView.setRegion(newRegion, animated: true)
    }
}
