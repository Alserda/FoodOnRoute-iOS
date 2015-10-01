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
        addSaveButton()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateMapWithCurrentLocation", userInfo: nil, repeats: true)
    }
    
    func addMapView() {
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        mapView.frame = self.view.frame
        view.addSubview(mapView)
    }
    
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
        sendLocationButton.addTarget(locationManager, action: "registerCurrentLocation:", forControlEvents: .TouchUpInside)
        mapView.addSubview(sendLocationButton)

        
        
    }
    
    
    
    func updateMapWithCurrentLocation() {9
        let newRegion = MKCoordinateRegionMake(locationManager.retrieveCurrentLocation(), MKCoordinateSpanMake(0.007, 0.007))
        
        mapView.setRegion(newRegion, animated: true)
    }
}
