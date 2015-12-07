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

class MapViewController : UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    let locationManager = LocationController()
    let backend = Backend()
    let mapView = MKMapView()
    var followButton = UIButton()
    var following : Bool = false
    let realm = try! Realm()
    let searchBar : UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()

        mapView.delegate = self
        searchBar.delegate = self
        
        /* Prints the Realm file location */
        print(Realm.Configuration.defaultConfiguration.path!)
        
        
        retrieveAndCacheStands()
        addMapView()
        addSearchField()
        addFollowButton()
        placeAnnotations(false)
        print("Available fonts: \(UIFont.familyNames())")
    }
    
    func addSearchField() {
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .Default
        searchBar.tintColor = UIColor.greenColor() //TODO Get right color (Hex: #979797)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.setImage(UIImage(named: "searchMagnifier"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal);

        
        let searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
        searchTextField!.textColor = UIColor.orangeColor() //TODO Get right color (Hex: #979797)
        searchTextField?.font = UIFont(name: "PT Sans", size: 16)
        searchTextField!.attributedPlaceholder = NSAttributedString(string: "Wat wil je eten?", attributes: [NSForegroundColorAttributeName: UIColor.purpleColor()])  //TODO Get right color (Hex: #979797)
        
    
        mapView.addSubview(searchBar)
        
        searchBar.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor, constant: 0).active = true
        searchBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        let widthConstraint = searchBar.widthAnchor.constraintEqualToAnchor(nil, constant: 250)
        let heightConstraint = searchBar.heightAnchor.constraintEqualToAnchor(nil, constant: 44)
        NSLayoutConstraint.activateConstraints([heightConstraint, widthConstraint])
    }
    
    /* Adds the MapView to the view. */
    func addMapView() {
        mapView.mapType = .Standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .FollowWithHeading
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        mapView.frame = self.view.frame
        mapView.tintColor = Colors.getDarkBlueColor()
        view.addSubview(mapView)
    }
    
    func addFollowButton() {
        followButton.frame = CGRectMake(0, 0, 108, 94)
        followButton.setImage(UIImage(named: "LocationTrackerFollow"), forState: UIControlState.Normal)
        followButton.addTarget(self, action: "followUser:", forControlEvents: .TouchUpInside)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(followButton)
        
        followButton.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.bottomAnchor).active = true
        followButton.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
        
        let widthConstaint = followButton.widthAnchor.constraintEqualToAnchor(nil, constant: 79)
        let heightConstaint = followButton.heightAnchor.constraintEqualToAnchor(nil, constant: 67)
        NSLayoutConstraint.activateConstraints([heightConstaint, widthConstaint])
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
            followButton.setImage(UIImage(named: "LocationTrackerFollowDirection"), forState: UIControlState.Normal)
        } else {
            mapView.userTrackingMode = .Follow
            following = true
            print("following again")
            followButton.setImage(UIImage(named: "LocationTrackerFollow"), forState: UIControlState.Normal)
        }
    }
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        print("\(__FUNCTION__)")
        print("stopped following")
        following = false
        followButton.setImage(UIImage(named: "LocationTrackerStopFollow"), forState: UIControlState.Normal)
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("\(__FUNCTION__)")
        
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        print("\(__FUNCTION__)")
    }
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        print("\(__FUNCTION__)")
    }
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("\(__FUNCTION__)")
        if let mapPin = view as? MapPin {
            if mapPin.preventDeselection {
                mapView.selectAnnotation(view.annotation!, animated: false)
            }
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("\(__FUNCTION__)")
        if let mapPin = view as? MapPin {
            updatePinPosition(mapPin)
            
        }
    }
    
    func updatePinPosition(pin:MapPin) {
        let defaultShift:CGFloat = 50
        let pinPosition = CGPointMake(pin.frame.midX, pin.frame.maxY)
        
        let y = pinPosition.y - defaultShift
        
        let controlPoint = CGPointMake(pinPosition.x, y)
        let controlPointCoordinate = mapView.convertPoint(controlPoint, toCoordinateFromView: mapView)
        
        mapView.setCenterCoordinate(controlPointCoordinate, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("\(__FUNCTION__)")
        
        // Check if an annotation is member of MKUserLocation
        if annotation is MKUserLocation {
            // Return nil to reset User location icon to default
            return nil
        }
        
        // Change current annotationView to a custom annotation image
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named:"AnnotationsView")
            
            //let calloutButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
            //annotationView!.rightCalloutAccessoryView = calloutButton
            
        } else {
            annotationView!.annotation = annotation
        }
        
        // Return annotations with new annotation image
        return annotationView
    }
    
    func retrieveAndCacheStands() {
        backend.retrievePath(endpoint.foodOnRouteStandsIndex, completion: { (response) -> () in
//            print(response)
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
            annotation.title = value.name
            annotation.subtitle = "Appels, Peren, Bananen, Duiven" //TODO: get ingredients from JSON
            self.mapView.addAnnotation(annotation)
//            print("Pin placed on \(value.id)")
        }
    }
}
