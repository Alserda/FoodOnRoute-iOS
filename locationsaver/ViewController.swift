//
//  ViewController.swift
//  locationsaver
//
//  Created by Peter Alserda on 10/09/15.
//  Copyright (c) 2015 Peter Alserda. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager:CLLocationManager!
    var locationDict = NSDictionary()
    var registeredLocations = NSMutableArray()
    
    let mapView = MKMapView()
    let sendLocationButton = UIButton(frame: CGRectMake(0, 0, 100, 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start the locationManager
        self.startLocationManager()
        
        // Add the mapview to the view.
        self.addMapView()
        self.addLocationButton()
        
        
    }

    func startLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func addMapView() {
        // MapView setup
        mapView.mapType = .Standard
        mapView.frame = self.view.frame
        mapView.rotateEnabled = true
        mapView.showsUserLocation = true
        view.addSubview(mapView)
    }
    
    func addLocationButton() {
        // Adds the button to send the current location
        sendLocationButton.center = CGPointMake(self.view.frame.width / 2, CGRectGetMaxY(self.view.frame) - 100)
        sendLocationButton.backgroundColor = UIColor.whiteColor()
        sendLocationButton.layer.borderColor = UIColor(netHex:0x00aced).CGColor
        sendLocationButton.layer.borderWidth = 5
        sendLocationButton.layer.cornerRadius = 50
        sendLocationButton.setTitle("Save!", forState: UIControlState.Normal)
        sendLocationButton.setTitleColor(UIColor(netHex:0x00aced), forState: UIControlState.Normal)
        sendLocationButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
        sendLocationButton.addTarget(self, action: "sendLocationToBackend:", forControlEvents: .TouchUpInside)
        mapView.addSubview(sendLocationButton)
    }
    
    func sendLocationToBackend(sender: UIButton!) {
//        print(self.locationDict)
        
        if self.registeredLocations.containsObject(self.locationDict) {
            print("Already contains \(self.locationDict)")
        }
        else {
            print("Does not contain yet, adding it now!")
            self.registeredLocations.addObject(self.locationDict)
            print("registerLocations:, \(self.registeredLocations)")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = self.locationDict["lat"] as! CLLocationDegrees
            annotation.coordinate.longitude = self.locationDict["lng"] as! CLLocationDegrees
            mapView.addAnnotation(annotation)
        }
    }
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("\(locations[0])")
        
        let lat : NSNumber = NSNumber(double: manager.location!.coordinate.latitude)
        let lng : NSNumber = NSNumber(double: manager.location!.coordinate.longitude)
        
        self.locationDict = ["lat": lat, "lng": lng]
  
        let spanX = 0.007
        let spanY = 0.007
        
//        let currentCoordinate : CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        let newRegion = MKCoordinateRegionMake((manager.location?.coordinate)!, MKCoordinateSpanMake(spanX, spanY))
        
        mapView.setRegion(newRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

