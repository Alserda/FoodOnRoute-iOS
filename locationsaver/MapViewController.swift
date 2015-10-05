//
//  MapViewController.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//
// Push test

import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate {
    let locationManager = LocationController()
    let mapView = MKMapView()
    var timer : NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        
        addMapView()
        addSaveButton()
        
        /* A timer which retrieves the current location and updates it to the MapView. */
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateMapWithCurrentLocation", userInfo: nil, repeats: true)
    }
    
    /* Adds the MapView to the view. */
    func addMapView() {
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        mapView.frame = self.view.frame
        view.addSubview(mapView)
    }
    
    /* Adds a button to save locations with. */
    func addSaveButton() {
        let sendLocationButton = UIButton(frame: CGRectMake(0, 0, 75, 75))
        sendLocationButton.center = CGPointMake(self.view.frame.width / 2, CGRectGetMaxY(self.view.frame) - 100)
        sendLocationButton.backgroundColor = UIColor.whiteColor()
        sendLocationButton.layer.borderColor = UIColor(netHex:0x00aced).CGColor
        sendLocationButton.layer.borderWidth = 5
        sendLocationButton.layer.cornerRadius = 37.5
        sendLocationButton.setTitle("Save", forState: UIControlState.Normal)
        sendLocationButton.setTitleColor(UIColor(netHex:0x00aced), forState: UIControlState.Normal)
        sendLocationButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
        sendLocationButton.addTarget(self, action: "pinThisLocation:", forControlEvents: .TouchUpInside)
        mapView.addSubview(sendLocationButton)
    }
    
    /* Updates the users real-time location on the MapView. */
    func updateMapWithCurrentLocation() {

        let newRegion = MKCoordinateRegionMake(LastUpdatedLocation.lastLocation, MKCoordinateSpanMake(0.007, 0.007))
//        print("New Region: \(newRegion)")
        mapView.setRegion(newRegion, animated: true)
    }
    
    /* Stores this location and adds an annotation to the MapView. */
    func pinThisLocation(sender: UIButton!) {
        locationManager.registerCurrentLocation { (success) -> Void in
            if (success) {
                print(true)
                
                /* Add an annotation to the map if the registration was successful. */
                let annotation = MKPointAnnotation()
                annotation.coordinate = LastUpdatedLocation.lastLocation
                self.mapView.addAnnotation(annotation)
            }
            else {
                /* Do nothing if the registration failed. */
                print(false)
            }
        }
    }
}
