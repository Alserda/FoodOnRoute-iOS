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
    let font = UIFont.systemFontOfSize(18)  // the font we'll use
    
    /// Update size and layout of callout view
    
    func updateCallout() {
        if annotation == nil {
            return
        }
        
        var size = CGSizeZero
        if let string = annotation?.title where string != nil {
            let attributes = [NSFontAttributeName : font]
            size = string!.sizeWithAttributes(attributes)
            titleLabel.text = (annotation?.title)!
        }
        if size.width < 30 {
            size.width = 30
        }
        bubbleView.setContentViewSize(size)
        frame = bubbleView.bounds
        centerOffset = CGPoint(x: 0, y: -40)
    }
    
    /// Perform the initial configuration of the subviews
    
    func configure() {
        backgroundColor = UIColor.clearColor()
        
        addSubview(bubbleView)
        
        titleLabel.frame = CGRectInset(bubbleView.contentView.bounds, -1, -1)
        titleLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        titleLabel.textAlignment = .Center
        titleLabel.font = font
        titleLabel.textColor = foodOnRouteColor.darkBlue
        
        bubbleView.contentView.addSubview(titleLabel)
        
        updateCallout()
    }
}


