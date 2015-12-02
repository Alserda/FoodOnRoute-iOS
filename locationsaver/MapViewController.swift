//
//  MapViewController.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//
// Push test

import UIKit
import RealmSwift
import Mapbox

class MapViewController : UIViewController, MGLMapViewDelegate {
    let locationManager = LocationController()
    let backend = Backend()
    let mapView = MGLMapView()
    var followButton = UIButton()
    var following : Bool = false
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        /* Prints the Realm file location */
        print(Realm.Configuration.defaultConfiguration.path!)
        
        
//        retrieveAndCacheStands()
        addMapView()
        addFollowButton()
        placeAnnotations(false)

//        postStands()

    }
    
    /* Adds the MapView to the view. */
    func addMapView() {
        self.mapView.frame = view.bounds
        self.mapView.styleURL = NSURL(string: "foodonroutemap.json")
//        self.mapView.styleURL = MGLStyle.darkStyleURL()
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .FollowWithHeading
        view.addSubview(self.mapView)
    }
    
    func addFollowButton() {
        followButton.frame = CGRectMake(0, 0, 75, 75)
        followButton.center = CGPointMake(self.view.frame.width / 2, CGRectGetMaxY(self.view.frame) - 500)
        followButton.backgroundColor = UIColor.brownColor()
        followButton.setTitle("Follow", forState: UIControlState.Normal)
        followButton.setTitleColor(UIColor(netHex:0x00aced), forState: UIControlState.Normal)
        followButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
        followButton.addTarget(self, action: "followUser:", forControlEvents: .TouchUpInside)
        self.mapView.addSubview(followButton)
    }
    
    /* Stores this location and adds an annotation to the MapView. */
    func pinThisLocation(sender: UIButton!) {
        locationManager.registerCurrentLocation { (recievedParameters) -> Void in
            if (recievedParameters.success) {
                print(true)
                
                /* Add an annotation to the map if the registration was successful. */
                let annotation = MGLPointAnnotation()
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
            self.mapView.userTrackingMode = .FollowWithHeading
            followButton.backgroundColor = UIColor.blackColor()
        } else {
            self.mapView.userTrackingMode = .Follow
            following = true
            print("following again")
            followButton.backgroundColor = UIColor.brownColor()
        }
    }
    
    func mapView(mapView: MGLMapView, didChangeUserTrackingMode mode: MGLUserTrackingMode, animated: Bool) {
        print("\(__FUNCTION__)")
        print("stopped following")
        following = false
        followButton.backgroundColor = UIColor.blueColor()
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("pisa")
        
        if annotationImage == nil {
            let image = UIImage(named: "pisa")
            annotationImage = MGLAnnotationImage(image: image!, reuseIdentifier: "pisa")
        }
        return annotationImage
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

            })
//            self.placeAnnotations(true)
            
            }) { (error) -> () in
                print(error)
                // Show the user that new stands could not be loaded
        }

    }

    func placeAnnotations(refresh: Bool) {
        if (refresh && self.mapView.annotations?.count >= 1) {
            self.mapView.removeAnnotations(self.mapView.annotations!)
        }
        for value in self.realm.objects(Stand) {
            let annotation = MGLPointAnnotation()
            annotation.coordinate.latitude = value.latitude as CLLocationDegrees
            annotation.coordinate.longitude = value.longitude as CLLocationDegrees
            annotation.title = value.name
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
