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
    let mapView = MapView()
    var followButton = UIButton()
    var following : Bool = false
    let realm = try! Realm()
    let searchBar : ResultsSearchBar = ResultsSearchBar()
    var activeFilter = false
    var searchResults : Results<(Product)>?
    let tableView = ResultsTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarAppearance()

        mapView.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        searchResults = self.realm.objects(Product).filter("name CONTAINS[c] %@", "a")
        
        
//        let arrayWithStands = [["id": Int, "name": String, "latitude": Double, "longitude": Double]]()

        
        let standsWithProducts: List<(Stand)> = List<(Stand)>()
        if let products = searchResults {
            for elements in products {
                for stands in elements.stands {
                    print(stands.id)
                    standsWithProducts.append(stands)
                }
            }
        }
        
        var arrayWithStands: [Stand] = [Stand]()
        for elements in standsWithProducts {
            if !arrayWithStands.containsObject(elements) {
                print(false)
                arrayWithStands.append(elements)
            } else {
                print(true)
            }
        }
        
        print(arrayWithStands)
        
//        retrieveAndCacheStands(clearDatabase: false)
//        addMapView()
//        addSearchField()
//        addFollowButton()
//        placeAnnotations(false, forStands: nil)
//
//        self.registerShowAndHideKeyboard()

    }


    func refreshFollowButtonConstraints(extraHeightToHeightConstraint: CGFloat?) {
        var extraHeight : CGFloat = 0
        if ((extraHeightToHeightConstraint) != nil) {
            extraHeight = extraHeightToHeightConstraint!
        }

        self.followButton.removeConstraints(self.followButton.constraints)
        self.followButton.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.bottomAnchor, constant: -20).active = true
        self.followButton.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: -20).active = true
        followButton.constrainToSize(CGSize(width: 54, height: extraHeight + 47))
        self.followButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: extraHeight, right: 0)


    }


    func addFollowButton() {
        followButton.setImage(UIImage(named: "LocationTrackerFollow"), forState: UIControlState.Normal)
        followButton.addTarget(self, action: "followUser:", forControlEvents: .TouchUpInside)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(followButton)

        followButton.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.bottomAnchor, constant: -20).active = true
        followButton.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: -20).active = true

        followButton.constrainToSize(CGSize(width: 54, height: 47))
    }


    func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(tableView)

        tableView.centerWithTopMargin(self, placeUnderViews: [self.searchBar], topMargin: 0)
        tableView.constrainToSize(CGSize(width: 250, height: 100))
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
        mapView.addSubview(searchBar)
        print(self)

        searchBar.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 0)
        searchBar.constrainToSize(CGSize(width: 250, height: 44))

    }

    /* Adds the MapView to the view. */
    func addMapView() {
        mapView.frame = self.view.frame
        view.addSubview(mapView)
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

    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("\(__FUNCTION__)")
        if let annotation = view.annotation as? CalloutAnnotation {
            mapView.removeAnnotation(annotation)
            print("Removed: ", annotation)
        }
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("\(__FUNCTION__)")
        if let annotation = view.annotation as? CustomAnnotation {
            let calloutAnnotation = CalloutAnnotation(annotation: annotation)
            mapView.addAnnotation(calloutAnnotation)
            mapView.selectAnnotation(calloutAnnotation, animated: false)

        }
    }

    // Define annotation view identifiers

    let calloutAnnotationViewIdentifier = "CalloutAnnotation"
    let customAnnotationViewIdentifier = "MyAnnotation"

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        print("\(__FUNCTION__)")

        if annotation is MKUserLocation {
            // Return nil to reset User location icon to default
            return nil
        }
        if annotation is CustomAnnotation {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("customAnnotationViewIdentifier")
            if pin == nil {
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotationViewIdentifier")
                pin!.canShowCallout = false
                pin!.image = UIImage(named:"AnnotationsView")
                //print("Normal")
            } else {
                pin!.annotation = annotation
            }
            return pin
        }
        else if annotation is CalloutAnnotation {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier("calloutAnnotationViewIdentifier")
            if pin == nil {
                pin = CalloutAnnotationView(annotation: annotation, reuseIdentifier: "calloutAnnotationViewIdentifier")
                pin!.canShowCallout = false
                print("Callout")
            } else {
                pin!.annotation = annotation
            }
            return pin
        }

        return nil
    }


    // MARK: searchBar Delegates
    

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if activeFilter && searchText.characters.count == 0 {
            placeAnnotations(true, forStands: nil)
            activeFilter = false
        }

        searchResults = self.realm.objects(Product).filter("name CONTAINS[c] %@", searchText)
        
        let standsWithProducts: List<(Stand)> = List<(Stand)>()
        if let products = searchResults {
            for elements in products {
                for stands in elements.stands {
                    standsWithProducts.append(stands)
                }
            }
        }
        
        for elements in standsWithProducts {
            print(elements.name)
        }
        

        

            
       

        tableView.reloadData()

        if searchText.characters.count >= 1 {
            let searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
            activeFilter = true
            if searchResults?.count == 0 {
                searchTextField!.textColor = UIColor.redColor()
            } else {
                placeAnnotations(true, forStands: standsWithProducts)
                searchTextField!.textColor = foodOnRouteColor.lightGrey
            }

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

    func placeAnnotations(removeOldPins: Bool, forStands: List<(Stand)>?) {

        /* Remove the old pins before updating. */
        if (removeOldPins) {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        func placeAnnotation(data: Stand) {
            let newAnnotation = CustomAnnotation()
            newAnnotation.coordinate.latitude = data.latitude as CLLocationDegrees
            newAnnotation.coordinate.longitude = data.longitude as CLLocationDegrees
            newAnnotation.title = data.name
            newAnnotation.subtitle = "Appels, Peren, Bananen, Druiven" //TODO: get ingredients from JSON
            self.mapView.addAnnotation(newAnnotation)
        }

        /* If this method recieved specific stands to be annotated, use them.
           Else use all available stands. */
        if forStands?.count >= 1 {
            /* Place all annotations */
            for value in forStands! {
                placeAnnotation(value)
            }
        } else {
            /* Place all annotations */
            for value in self.realm.objects(Stand) {
                placeAnnotation(value)
            }
        }
    }

    func retrieveAndCacheStands(clearDatabase clearDatabase: Bool?) {
        backend.retrievePath(endpoint.foodOnRouteStandsIndex, completion: { (response) -> () in
            for (_, value) in response {
                let stand = Stand()
                stand.id = value["id"].intValue
                stand.name = value["name"].string!
                stand.latitude = value["latitude"].double!
                stand.longitude = value["longitude"].double!
                for (_, products) in value["products"] {
                    let product = Product()
                    product.id = products["id"].intValue
                    product.name = products["name"].string!
                    stand.products.append(product)
                }
                
                try! self.realm.write({ () -> Void in
                    self.realm.create(Stand.self, value: stand, update: true)
                })
            }
            
            print(Realm.Configuration.defaultConfiguration.path!)
            self.placeAnnotations(true, forStands: nil)

            }) { (error) -> () in
                print(error)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}
