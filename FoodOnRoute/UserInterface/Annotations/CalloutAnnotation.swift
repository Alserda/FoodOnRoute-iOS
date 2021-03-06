//
//  CalloutAnnotation.swift
//  FoodOnRoute
//
//  Created by Stefan Brouwer on 09-12-15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import MapKit

class CalloutAnnotation : MKPointAnnotation {
    let underlyingAnnotation: MKPointAnnotation      // this is the annotation for which this object is acting as callout
    
    init(annotation: MKPointAnnotation) {
        self.underlyingAnnotation = annotation
        super.init()
    }
    
    // Override `coordinate` so that it returns the same coordinate of the annotation for which this serves as callout
    
    override var coordinate: CLLocationCoordinate2D {
        get { return underlyingAnnotation.coordinate }
        set { underlyingAnnotation.coordinate = newValue }
    }
    
    // Override `title` so that it simply the title of the annotation for which this serves as callout
    
    override var title: String? {
        get {
            return underlyingAnnotation.title! }
        set { underlyingAnnotation.title = newValue! }
    }
    
    override var subtitle: String? {
        get { 
            return underlyingAnnotation.subtitle! }
        set { underlyingAnnotation.subtitle = newValue! }
    }
}


