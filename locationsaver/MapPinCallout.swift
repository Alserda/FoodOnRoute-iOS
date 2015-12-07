//
//  MapPinCallout.swift
//  locationsaver
//
//  Created by Stefan Brouwer on 07-12-15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import MapKit

class MapPinCallout: UIView {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let viewPoint = superview?.convertPoint(point, toView: self) ?? point
        
        _ = pointInside(viewPoint, withEvent: event)
        
        let view = super.hitTest(viewPoint, withEvent: event)
        
        return view
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return CGRectContainsPoint(bounds, point)
    }
}
