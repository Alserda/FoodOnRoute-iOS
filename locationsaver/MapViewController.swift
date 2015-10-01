//
//  MapViewController.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

class MapViewController : UIViewController {
    let locationManager = LocationController()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.greenColor()
        
        locationManager.start()
    }
}
