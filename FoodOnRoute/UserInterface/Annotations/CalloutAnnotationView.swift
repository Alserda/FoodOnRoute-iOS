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
    let subtitleLabel = UILabel()                   // the label we'll add as subview to the bubble's contentView
    let subtitleFont = UIFont(name: "PT Sans", size: 14)!  // the font we'll use for the title
    let showStandButton = UIButton(type: UIButtonType.System) as UIButton

    /// Update size and layout of callout view    
    func updateCallout() {
        if annotation == nil {
            print(annotation, "is nil")
            return
        }
        
        var size = CGSizeZero
        if let string = annotation?.title where string != nil {
            let attributes = [NSFontAttributeName : titleFont]
            size = string!.sizeWithAttributes(attributes)
            titleLabel.text = (annotation?.title)!
            subtitleLabel.text = (annotation?.subtitle)!
            subtitleLabel.numberOfLines = 2
        }
        bubbleView.setContentViewSize(size)
        print("SIZEEEEEE", size)
        frame = (bubbleView.bounds)
        centerOffset = CGPoint(x: 0, y: -115)
    }
    
    /// Perform the initial configuration of the subviews
    
    func configure() {
        addBubbleData()
        updateCallout()
        setBubbleConstraints()
    }
    
    func addBubbleData() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        showStandButton.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bubbleView)
        
        // Create title label stats
        titleLabel.frame = CGRectInset(bubbleView.bounds, -1, -1)
        titleLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        titleLabel.textAlignment = .Left
        titleLabel.font = titleFont
        titleLabel.textColor = foodOnRouteColor.darkBlue
        
        // Create subtitle label stats
        subtitleLabel.frame = CGRectInset(bubbleView.bounds, -1, -1)
        subtitleLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        subtitleLabel.textAlignment = .Left
        subtitleLabel.font = subtitleFont
        subtitleLabel.textColor = foodOnRouteColor.darkGrey
//
//        // Create show stand button stats
        showStandButton.backgroundColor = foodOnRouteColor.lightGreen
        showStandButton.layer.borderWidth = 3
        showStandButton.layer.borderColor = foodOnRouteColor.darkGreen.CGColor
        showStandButton.layer.cornerRadius = 5
//
        showStandButton.setImage(UIImage(named: "NavToStandButton")?.imageWithRenderingMode(.AlwaysOriginal), forState: UIControlState.Normal)
        showStandButton.addTarget(self, action: "showStandView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // Add the subviews
        bubbleView.contentView.addSubview(titleLabel)
        bubbleView.contentView.addSubview(subtitleLabel)
        bubbleView.contentView.addSubview(showStandButton)
    }
    
    func showStandView(sender: UIButton!) {
        print("button pressed")
    }
    
    func setBubbleConstraints() {
        titleLabel.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 20).active = true
        titleLabel.topAnchor.constraintEqualToAnchor(bubbleView.topAnchor, constant: 20).active = true
        subtitleLabel.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 20).active = true
        titleLabel.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor, constant: 20).active = true
        subtitleLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: 5).active = true
        
        showStandButton.bottomAnchor.constraintEqualToAnchor(bubbleView.bottomAnchor, constant: -28).active = true
        showStandButton.centerXAnchor.constraintEqualToAnchor(bubbleView.centerXAnchor).active = true
        print(bubbleView.bounds)
        
        let showStandWidthConstraint = showStandButton.widthAnchor.constraintEqualToAnchor(nil, constant: bubbleView.bounds.width - 40)
        let showStandHeightConstraint = showStandButton.heightAnchor.constraintEqualToAnchor(nil, constant: 42)
        NSLayoutConstraint.activateConstraints([showStandWidthConstraint, showStandHeightConstraint])
    }
}


