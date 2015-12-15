//
//  Helper.swift
//  locationsaver
//
//  Created by Peter Alserda on 01/10/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import CoreLocation

extension Array {
    func containsObject<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

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

/* Gives more clear errors when breaking constraints */
extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}


/* Allows centering views */
extension UIView {
    func centerWithTopMargin(viewController: UIViewController, placeUnderViews: [UIView]?, topMargin: CGFloat) {
        var addedViewHeight : CGFloat = 0
        
        if let extraViews = placeUnderViews {
            for view in extraViews {
                addedViewHeight += view.bounds.size.height
            }
        }

        let horizontalConstraint = self.topAnchor.constraintEqualToAnchor(viewController.topLayoutGuide.bottomAnchor, constant: addedViewHeight + topMargin)
        let verticalConstraint = self.centerXAnchor.constraintEqualToAnchor(viewController.view.centerXAnchor)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint])
    }
    
    func constrainToSize (size : CGSize) {
        let widthConstraint = self.widthAnchor.constraintEqualToAnchor(nil, constant: size.width)
        let heightConstraint = self.heightAnchor.constraintEqualToAnchor(nil, constant: size.height)
        NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint])
    }
    
    /* Add borders to objects */
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, 0, self.frame.size.width, width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, 0, width, self.frame.size.height)
        self.layer.addSublayer(border)
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
