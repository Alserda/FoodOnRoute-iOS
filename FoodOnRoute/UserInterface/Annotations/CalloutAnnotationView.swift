//
//  CalloutAnnotationView.swift
//  FoodOnRoute
//
//  Created by Stefan Brouwer on 08-12-15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit
import MapKit

class CalloutAnnotationView : MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let bubbleView = BubbleView()           // the view that actually represents the callout bubble
    let titleLabel = UILabel()                   // the label we'll add as subview to the bubble's contentView
    let titleFont = UIFont(name: "Montserrat-Bold", size: 18)!  // the font we'll use for the title
    let buttonFont = UIFont(name: "Montserrat", size: 14)!  // the font we'll use for the buttons
    let showStandButton   = UIButton(type: UIButtonType.System) as UIButton

    /// Update size and layout of callout view
    
    func updateCallout() {
        if annotation == nil {
            return
        }
        
        var size = CGSizeZero
        if let string = annotation?.title where string != nil {
            let attributes = [NSFontAttributeName : titleFont]
            size = string!.sizeWithAttributes(attributes)
            titleLabel.text = (annotation?.title)!
        }
        if size.width < 30 {
            size.width = 30
        }
        bubbleView.setContentViewSize(size)
        print("SIZEEEEEE", size)
        frame = (bubbleView.bounds)
        centerOffset = CGPoint(x: 0, y: -40)
    }
    
    /// Perform the initial configuration of the subviews
    
    func configure() {
        backgroundColor = UIColor.clearColor()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        showStandButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bubbleView)
        
        // Create title label stats
        titleLabel.frame = CGRectInset(bubbleView.contentView.bounds, -1, -1)
        titleLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        titleLabel.textAlignment = .Center
        titleLabel.font = titleFont
        titleLabel.textColor = foodOnRouteColor.darkBlue
        
        

        
//        // Create show stand button stats
//        showStandButton.frame = CGRectInset(bubbleView.contentView.bounds, -1, -1)
//            //showStandButton.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        showStandButton.backgroundColor = foodOnRouteColor.lightGreen
//        showStandButton.layer.shadowColor = foodOnRouteColor.darkGreen.CGColor
//        showStandButton.layer.shadowOffset = CGSizeMake(0, 3)
//        showStandButton.layer.shadowRadius = 5
//        showStandButton.layer.cornerRadius = 5
//        showStandButton.setTitle("Winkel bekijken", forState: UIControlState.Normal)
//        showStandButton.titleLabel?.font = buttonFont
//        showStandButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        showStandButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add the subviews
        bubbleView.contentView.addSubview(titleLabel)
//        bubbleView.contentView.addSubview(showStandButton)
        
        titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 0).active = true
//        showStandButton.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: 5).active = true
        
        updateCallout()
    }
}


