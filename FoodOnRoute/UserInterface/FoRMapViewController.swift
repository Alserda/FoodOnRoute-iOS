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

class MapViewController : UIViewController, MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    let locationManager = LocationController()
    let backend = Backend()
    let mapView = MKMapView()
    var followButton = UIButton()
    var following : Bool = false
    let realm = try! Realm()
    let searchBar : UISearchBar = UISearchBar()
    var activeFilter = false
    var searchResults : Results<(Stand)>?
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()

        mapView.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        /* Prints the Realm file location */
        print(Realm.Configuration.defaultConfiguration.path!)
        
        
        retrieveAndCacheStands()
        addMapView()
        addSearchField()
        addFollowButton()
        placeAnnotations(false, forStands: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        let duration = aNotification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let keyboardSize = (aNotification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().height
        print(aNotification)
        print(keyboardSize)

        animateShowingKeyboardWithDuration(duration, keyboardHeight: keyboardSize!)
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        let duration = aNotification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        animateHidingKeyboardWithDuration(duration)
    }
    
    func animateShowingKeyboardWithDuration(duration: NSTimeInterval, keyboardHeight: CGFloat) {
//        let animationOptions : UIViewAnimationOptions = UIViewAnimationOptions
        
        UIView .animateWithDuration(duration, delay: 0, options: [.CurveEaseInOut], animations: { () -> Void in
            self.followButton.removeConstraints(self.followButton.constraints)
            self.followButton.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.bottomAnchor).active = true
            self.followButton.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
            
            let widthConstaint = self.followButton.widthAnchor.constraintEqualToAnchor(nil, constant: 79)
            let heightConstaint = self.followButton.heightAnchor.constraintEqualToAnchor(nil, constant: (keyboardHeight * 2) + 67)
            NSLayoutConstraint.activateConstraints([heightConstaint, widthConstaint])
            }) { (finished) -> Void in
                print(true)
        }
    }
    
    func animateHidingKeyboardWithDuration(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
            self.followButton.removeConstraints(self.followButton.constraints)
            self.followButton.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.bottomAnchor).active = true
            self.followButton.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor).active = true
            
            let widthConstaint = self.followButton.widthAnchor.constraintEqualToAnchor(nil, constant: 79)
            let heightConstaint = self.followButton.heightAnchor.constraintEqualToAnchor(nil, constant: 67)
            NSLayoutConstraint.activateConstraints([heightConstaint, widthConstaint])

            }) { (finished) -> Void in
                print(true)
        }
    }
    
    

    
    
    
    func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(tableView)
        
        tableView.topAnchor.constraintEqualToAnchor(searchBar.bottomAnchor, constant: 0).active = true
        tableView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        let widthConstraint = tableView.widthAnchor.constraintEqualToAnchor(nil, constant: 250)
        let heightConstraint = tableView.heightAnchor.constraintEqualToAnchor(nil, constant: 100)
        NSLayoutConstraint.activateConstraints([heightConstraint, widthConstraint])
        
        
        
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount = 0
        
        if searchResults?.count >= 1 {
            cellCount = (searchResults?.count)!
        }

        return cellCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        if searchResults?.count >= 1 {
            cell.textLabel?.text = searchResults?[indexPath.row].name
        }

        return cell
    }
    
    
    
    
    
    
    
    
    
    // MARK: Views
    
    func addSearchField() {
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .Default
        searchBar.tintColor = foodOnRouteColor.lightGrey
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.setImage(UIImage(named: "searchMagnifier"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal);

        
        let searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
        searchTextField!.textColor = foodOnRouteColor.lightGrey
        searchTextField?.font = UIFont(name: "PT Sans", size: 16)
        searchTextField!.attributedPlaceholder = NSAttributedString(string: "Wat wil je eten?", attributes: [NSForegroundColorAttributeName: foodOnRouteColor.lightGrey])  //TODO Get right color (Hex: #979797)
        
    
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
        mapView.tintColor = foodOnRouteColor.darkBlue
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
    
    // MARK: mapView Delegates
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        /* Tells the app that the user is being followed. */
        if mode.hashValue == 1 {
            following = true
            followButton.setImage(UIImage(named: "LocationTrackerFollow"), forState: UIControlState.Normal)
        }
        
        /* Stop following whenever the user moves their screen. */
        else {
            following = false
            followButton.setImage(UIImage(named: "LocationTrackerStopFollow"), forState: UIControlState.Normal)
        }
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("\(__FUNCTION__)")
        
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        print("\(__FUNCTION__)")
    }
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
//        print("\(__FUNCTION__)")
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        print("\(__FUNCTION__)")
        
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
    
    
    // MARK: searchBar Delegates
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if activeFilter && searchText.characters.count == 0 {
            print("refreshed!")
            placeAnnotations(true, forStands: nil)
        }
        
        let query = self.realm.objects(Stand).filter("name CONTAINS[c] %@", searchText)
        print(query)
        searchResults = query
        tableView.reloadData()

        if query.count >= 1 && searchText.characters.count >= 1 {
            activeFilter = true
            placeAnnotations(true, forStands: query)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("\(__FUNCTION__)")
        // Wanneer je op 'Zoek' drukt
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("\(__FUNCTION__)")
        // Wanneer je op de form tapt
        addTableView()
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("\(__FUNCTION__)")
        // Wanneer je buiten het veld tapt
        tableView.removeFromSuperview()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("hoi")
    }
    
    
    // MARK: Other Methods
    
    
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
    
    func placeAnnotations(removeOldPins: Bool, forStands: Results<(Stand)>?) {
        var stands : Results<(Stand)>
        
        /* Remove the old pins before updating. */
        if (removeOldPins) {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        /* If this method recieved specific stands to be annotated, use them. 
           Else use all available stands. */
        if forStands?.count >= 1 {
            stands = forStands!
        } else {
            stands = self.realm.objects(Stand)
        }
        
        /* Place all annotations */
        for value in stands {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = value.latitude as CLLocationDegrees
            annotation.coordinate.longitude = value.longitude as CLLocationDegrees
            annotation.title = value.name
            annotation.subtitle = "Appels, Peren, Bananen, Duiven" //TODO: get ingredients from JSON
            self.mapView.addAnnotation(annotation)
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
                self.placeAnnotations(true, forStands: nil)
            })
            }) { (error) -> () in
                print(error)
                // Show the user that new stands could not be loaded
        }
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
//    
//    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
//    notification
//    
//    
//    func keyboardWillShow(aNotification: NSNotification)    {
//        
//        let duration = aNotification.userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as NSNumber
//        let curve = aNotification.userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as NSNumber
//    }
}
