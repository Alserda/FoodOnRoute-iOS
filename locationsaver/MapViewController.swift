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
import SwiftyJSON

class MapViewController : UIViewController, MKMapViewDelegate {
    let locationManager = LocationController()
    let backend = Backend()
    let mapView = MKMapView()
    var timer : NSTimer? = nil
    var followButton = UIButton()
    var following : Bool = false
    var retrievedData : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        addMapView()
        addSaveButton()
        addFollowButton()
        retrieveRequest()
    }
    
    /* Adds the MapView to the view. */
    func addMapView() {
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .FollowWithHeading
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
    
    func addFollowButton() {
        followButton.frame = CGRectMake(0, 0, 75, 75)
        followButton.center = CGPointMake(self.view.frame.width / 2, CGRectGetMaxY(self.view.frame) - 500)
        followButton.backgroundColor = UIColor.brownColor()
        followButton.setTitle("Follow", forState: UIControlState.Normal)
        followButton.setTitleColor(UIColor(netHex:0x00aced), forState: UIControlState.Normal)
        followButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
        followButton.addTarget(self, action: "followUser:", forControlEvents: .TouchUpInside)
        mapView.addSubview(followButton)
    }
    
    /* Updates the users real-time location on the MapView. */
    func updateMapWithCurrentLocation() {

        let newRegion = MKCoordinateRegionMake(Locations.lastLocation, MKCoordinateSpanMake(0.007, 0.007))
        mapView.setRegion(newRegion, animated: true)
    }
    
    /* Stores this location and adds an annotation to the MapView. */
    func pinThisLocation(sender: UIButton!) {
        locationManager.registerCurrentLocation { (recievedParameters) -> Void in
            if (recievedParameters.success) {
                print(true)
                
                /* Add an annotation to the map if the registration was successful. */
                let annotation = MKPointAnnotation()
                annotation.coordinate = recievedParameters.coordinates
                self.mapView.addAnnotation(annotation)
                
                /* Debug purposes */
                let coordinateLatitude = recievedParameters.coordinates.latitude, coordinateLongitude = recievedParameters.coordinates.longitude
                Debugger.messages.append("Pinned || lat \(coordinateLatitude.format()), long \(coordinateLongitude.format())")
            }
            else {
                /* Do nothing if the registration failed. */
                print(false)
            }
        }
    }
    
    func followUser(sender: UIButton!) {
        if (following) {
            mapView.userTrackingMode = .FollowWithHeading
            followButton.backgroundColor = UIColor.blackColor()
        } else {
            

        mapView.userTrackingMode = .Follow
        following = true
        print("following again")
        followButton.backgroundColor = UIColor.brownColor()
        }
    }
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        print("\(__FUNCTION__)")
        print("stopped following")
        following = false
        followButton.backgroundColor = UIColor.blueColor()
    }
    
    
//    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
////        print("\(__FUNCTION__)")
//    }
//    
//    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
////        print("\(__FUNCTION__)")
//    }
//    
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
////        print("\(__FUNCTION__)")
//    }
    
    func mapViewWillStartLocatingUser(mapView: MKMapView) {
        print("\(__FUNCTION__)")
        following = true
    }
//
//    func mapViewDidStopLocatingUser(mapView: MKMapView) {
//        print("\(__FUNCTION__)")
//    }
//    
//    func mapViewWillStartLoadingMap(mapView: MKMapView) {
//        print("\(__FUNCTION__)")
//    }
//    
//    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
//        print("\(__FUNCTION__)")
//    }
//    
//    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
//        print(error)
//    }
//    
//    func mapViewWillStartRenderingMap(mapView: MKMapView) {
//        print("\(__FUNCTION__)")
//    }
//    
//    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
//        print("\(__FUNCTION__)")
//    }
//    
//    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
//        print("\(__FUNCTION__)")
//    }
//    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
//        print("\(__FUNCTION__)")
//    }
//    
////    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
////    }
//    
//    func mapView(mapView: MKMapView, didAddOverlayRenderers renderers: [MKOverlayRenderer]) {
//        print("\(__FUNCTION__)")
//    }


    
    func retrieveRequest() {
        backend.retrievePath(endpoint.foodOnRouteStandsIndex) { (response) -> () in
            print(response)
        }
        
    }
}
