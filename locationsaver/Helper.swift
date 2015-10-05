//
//  Helper.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import CoreLocation

/* Makes the use of hex colors possible. */
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

/* Makes it possible to compare coordinates. */
extension CLLocationCoordinate2D {
    func equals (c: CLLocationCoordinate2D) -> Bool {
        return c.latitude == self.latitude && c.longitude == self.longitude
    }
}

/* Formats Double */
extension Double {
    func format() -> String {
        return NSString(format: "%0.4f", self) as String
    }
}

/* Collects debug messages and displays this in DebugViewController. */
struct Debugger {
    static var messages : [String] = [String]()
}

/* Handles location-related variables. */
struct Locations {
    static var lastLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    static var pinnedLocations : [CLLocationCoordinate2D] = []
}