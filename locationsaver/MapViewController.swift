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
import RealmSwift

class MapViewController : UIViewController, MKMapViewDelegate {
    let locationManager = LocationController()
    let backend = Backend()
    let mapView = MKMapView()
    var followButton = UIButton()
    var following : Bool = false
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        /* Prints the Realm file location */
        print(Realm.Configuration.defaultConfiguration.path!)
        
        
        retrieveAndCacheStands()
        addMapView()
        addSaveButton()
        addFollowButton()
        placeAnnotations(false)

//        postStands()

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
    
    
    
    func viewForAnnotation(annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func retrieveAndCacheStands() {
        backend.retrievePath(endpoint.foodOnRouteStandsIndex, completion: { (response) -> () in
            print(response)
            try! self.realm.write({ () -> Void in
                for (_, value) in response {
                    let stand = Stand()
                    stand.id = value["id"].intValue
                    stand.name = value["name"].string!
                    stand.latitude = value["latitude"].double!
                    stand.longitude = value["longitude"].double!
                    self.realm.create(Stand.self, value: stand, update: true)
                }
                self.placeAnnotations(true)
            })
            }) { (error) -> () in
                print(error)
                // Show the user that new stands could not be loaded
        }
    }

    func placeAnnotations(refresh: Bool) {
        if (refresh) {
            mapView.removeAnnotations(mapView.annotations)
        }
        for value in self.realm.objects(Stand) {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = value.latitude as CLLocationDegrees
            annotation.coordinate.longitude = value.longitude as CLLocationDegrees
            annotation.title = "Henk"
            annotation.subtitle = "Holtrop"
            self.mapView.addAnnotation(annotation)
            print("Pin placed on \(value.id)")
        }
    }
    
    
    func postStands() {
        let parameters = [
            "stand": [
                "name": "Anne",
                "street": "Zegge4",
                "housenumber": 4,
                "postalcode": "9285LS"
            ]
        ]
        backend.postRequest(endpoint.foodOnRouteStandsIndex, params: parameters) { (response) -> () in
            print(response)
        }
    }
}
