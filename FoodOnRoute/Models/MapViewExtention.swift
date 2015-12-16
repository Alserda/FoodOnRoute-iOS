//
//  KeyboardController.swift
//  FoodOnRoute
//
//  Created by Peter Alserda on 10/12/15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

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