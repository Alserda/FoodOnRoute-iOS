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
    convenience init(hexString: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexString.hasPrefix("#") {
            let index   = hexString.startIndex.advancedBy(1)
            let hexColor     = hexString.substringFromIndex(index)
            let scanner = NSScanner(string: hexColor)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if hexColor.characters.count == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if hexColor.characters.count == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9")
                }
            } else {
                print("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

/* Allows centering views */
extension UIView {
    func centerInView (view : UIView) {
        let horizontalConstraint = self.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let verticalConstraint = self.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, ])
        
    }
    
    func constrainToSize (size : CGSize) {
        let widthConstraint = self.widthAnchor.constraintEqualToAnchor(nil, constant: size.width)
        let heightConstraint = self.heightAnchor.constraintEqualToAnchor(nil, constant: size.height)
        NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint])
        
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

/* Stores frequently used colors */
struct foodOnRouteColor {
    static let darkBlue   : UIColor = UIColor(hexString: "#1D717D")
    static let lightGreen : UIColor = UIColor(hexString: "#38A97A")
    static let darkGrey : UIColor = UIColor(hexString: "#666666")
    static let lightGrey  : UIColor = UIColor(hexString: "#979797")
}