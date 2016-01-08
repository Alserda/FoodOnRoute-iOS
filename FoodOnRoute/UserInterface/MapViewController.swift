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
    var searchBarTextfield : UITextField = UITextField()
    var activeFilter = false
    var searchResults : Results<(Product)>?
    let tableView = UITableView()
    var selectedStand: Stand? = Stand()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ResultsTableViewCell.self, forCellReuseIdentifier: "ResultCell")

        retrieveAndCacheStands(clearDatabase: false)
        addMapView()
        addSearchField()
        addFollowButton()
        placeAnnotations(false, forStands: nil)

        self.registerShowAndHideKeyboard()

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
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.layer.cornerRadius = 5
        mapView.addSubview(tableView)

        tableView.centerWithTopMargin(self, placeUnderViews: [self.searchBar], topMargin: 17)
        tableView.constrainToSize(CGSize(width: 250, height: 126))
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numOfSections = 0
        if searchResults?.count >= 1 {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            numOfSections = 1
            tableView.backgroundView = nil
        } else {
            let noDataLabel : UILabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text = "Niks gevonden!"
            noDataLabel.textColor = foodOnRouteColor.darkBlack
            noDataLabel.textAlignment = NSTextAlignment.Center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        }
        return numOfSections
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 63
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount = 0

        if searchResults?.count >= 1 {
            cellCount = (searchResults?.count)!
        }

        return cellCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ResultsTableViewCell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultsTableViewCell

        if searchResults?.count >= 1 {
            cell.productTitle.text = searchResults?[indexPath.row].name
        }
        return cell
    }



    // MARK: Views

    func addSearchField() {
        mapView.addSubview(searchBar)

        searchBarTextfield = searchBar.valueForKey("searchField") as! UITextField

        searchBarTextfield.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 10)
        searchBarTextfield.constrainToSize(CGSize(width: 250, height: 44))

        searchBar.centerWithTopMargin(self, placeUnderViews: nil, topMargin: 10)
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
            selectedStand = annotation.identifier
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

            //
        }
        if annotation is CustomAnnotation {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(customAnnotationViewIdentifier)
            if pin == nil {
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewIdentifier)
                pin!.canShowCallout = false
                pin!.image = UIImage(named:"AnnotationsView")
//                print("Normal")
            } else {
                pin!.annotation = annotation
            }
            return pin
        } else if annotation is CalloutAnnotation {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(calloutAnnotationViewIdentifier)
            if pin == nil {
                pin = CalloutAnnotationView(annotation: annotation, reuseIdentifier: calloutAnnotationViewIdentifier)
                pin!.canShowCallout = false
                print("Callout")
            } else {
                let p = pin as! CalloutAnnotationView
                pin!.annotation = annotation

                p.configure()

            }
            return pin
        }

        return nil
    }


    // MARK: searchBar Delegates


    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)

        if searchText.characters.count >= 2 {
            addTableView()

            searchResults = self.realm.objects(Product).filter("name CONTAINS[c] %@", searchText)

            var standsWithProducts: [Stand] = [Stand]()
            if let products = searchResults {
                for elements in products {
                    for stands in elements.stands {
                        if !standsWithProducts.containsObject(stands) {
                            standsWithProducts.append(stands)
                        }
                    }
                }
            }

            tableView.reloadData()

            let searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
            if searchResults?.count == 0 {
                searchTextField!.textColor = UIColor.redColor()
            } else {
                placeAnnotations(true, forStands: standsWithProducts)
                searchTextField!.textColor = foodOnRouteColor.lightGrey
            }

        }
        else  {
            placeAnnotations(true, forStands: nil)
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

    func placeAnnotations(removeOldPins: Bool, forStands: [Stand]?) {
        var allowedToPlaceAnnotations : Bool = true

        func removeUserLocationAnnotationCount(count: [MKAnnotation]) -> Int {
            var counter = mapView.annotations.count

            for elements in mapView.annotations {
                if elements is MKUserLocation {
                    counter -= 1
                }
            }
            return counter
        }

        func placeAnnotation(data: Stand) {
            let newAnnotation = CustomAnnotation()
            newAnnotation.identifier = data as Stand
            newAnnotation.coordinate.latitude = data.latitude as CLLocationDegrees
            newAnnotation.coordinate.longitude = data.longitude as CLLocationDegrees
            newAnnotation.title = data.name
            newAnnotation
            var products: [String] = [String]()
            for product in data.products {
                products.append(product.name)
//                print("\(data.id) \(product.name)")
            }


            if products.count == 0 {
                newAnnotation.subtitle = "Deze stand heeft nog geen producten toegevoegd!"
            } else if products.count <= 3 {
                newAnnotation.subtitle = products.joinWithSeparator(", ")
            } else {
                newAnnotation.subtitle = products[0..<3].joinWithSeparator(", ") + " en nog \(products.count - 3) producten"
            }
            self.mapView.addAnnotation(newAnnotation)
        }

        /* Remove the old pins before updating. */
        if (removeOldPins) {
            if let stands = forStands {
                let placedAnnotations = removeUserLocationAnnotationCount(mapView.annotations)
                if stands.count == placedAnnotations {
                    // doe niks wanneer het aantal gevonden stands gelijk is aan het aantal geplaatste annotations
                    allowedToPlaceAnnotations = false
                    print("stands.count \(stands.count) IS equal to the placed annotations: \(placedAnnotations)!!")
                } else {
                    print("stands.count \(stands.count) is NOT equal to the placed annotations: \(placedAnnotations)")
                    mapView.removeAnnotations(mapView.annotations)
                }
            } else {
                print("show all stands")
                mapView.removeAnnotations(mapView.annotations)
                tableView.removeFromSuperview()
            }
        }

        /* If this method recieved specific stands to be annotated, use them.
           Else use all available stands. */
        if allowedToPlaceAnnotations {
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
    }

    func retrieveAndCacheStands(clearDatabase clearDatabase: Bool?) {
        backend.retrievePath(endpoint.foodOnRouteStandsIndex, completion: { (response) -> () in
            for (_, value) in response {
                var addThisStand: Bool = true
                
                let stand = Stand()
                stand.id = value["id"].intValue

                if let standName = value["name"].string {
                    stand.name = standName
                } else {
                    addThisStand = false
                }
                
                if let standLatitude = value["latitude"].double {
                    stand.latitude = standLatitude
                } else {
                    addThisStand = false
                }
                
                if let standLongitude = value["longitude"].double {
                    stand.longitude = standLongitude
                } else {
                    addThisStand = false
                }

                if let standInformation = value["information"].string {
                    stand.information = standInformation
                } else {
                    stand.information = "De eigenaar van deze stand heeft nog geen informatie gedeeld."
                }
                
                for (_, products) in value["products"] {
                    let product = Product()
                    product.id = products["id"].intValue

                    if let productName = products["name"].string {
                        product.name = productName
                    } else {
                        addThisStand = false
                    }
                    stand.products.append(product)
                }

                try! self.realm.write({ () -> Void in
                    if addThisStand {
                        self.realm.create(Stand.self, value: stand, update: true)
                    }
                })
            }

            print(Realm.Configuration.defaultConfiguration.path!)
            self.placeAnnotations(true, forStands: nil)

            }) { (error) -> () in
                print(error)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "FoodOnRouteLogo")

        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        for touch in touches {
            print(touch.view)
            if (touch.view is BubbleView) {
                let standViewController = StandViewController()
                standViewController.stand = selectedStand!
                self.navigationController?.pushViewController(standViewController, animated: true)
            }
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}
