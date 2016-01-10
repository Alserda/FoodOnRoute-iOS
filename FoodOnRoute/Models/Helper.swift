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

    func centerWithTopMarginInView(view: UIView, placeUnderViews: [UIView]?, topMargin: CGFloat) {
        var addedViewHeight : CGFloat = 0

        if let extraViews = placeUnderViews {
            for view in extraViews {
                for constraint in view.constraints {
                    if constraint.identifier == "height" {
                        addedViewHeight += constraint.constant
                    }
                }
            }
        }

        let horizontalConstraint = self.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: addedViewHeight + topMargin)
        let verticalConstraint = self.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint])
    }

    func constrainToSize (size : CGSize) {
        let widthConstraint = self.widthAnchor.constraintEqualToAnchor(nil, constant: size.width)
        widthConstraint.identifier = "width"
        let heightConstraint = self.heightAnchor.constraintEqualToAnchor(nil, constant: size.height)
        heightConstraint.identifier = "height"
        NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint])
    }
}

extension MapViewController {
    func registerShowAndHideKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        let duration = aNotification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let keyboardSize = (aNotification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().height
        
        UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseIn], animations: { () -> Void in
            self.refreshFollowButtonConstraints(keyboardSize!)
        }) { (finished) -> Void in
            //noppes
        }
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        let duration = aNotification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
            self.refreshFollowButtonConstraints(nil)
        }) { (finished) -> Void in
            //noppes
        }
    }
}