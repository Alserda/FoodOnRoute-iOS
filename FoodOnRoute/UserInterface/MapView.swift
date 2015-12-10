//
//  MapView.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 09/12/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import MapKit

class MapView : MKMapView {
    override init(frame: CGRect) {
        super.init(frame : frame)

        self.mapType = .Standard
        self.showsUserLocation = true
        self.userTrackingMode = .FollowWithHeading
        self.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.tintColor = foodOnRouteColor.darkBlue
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
