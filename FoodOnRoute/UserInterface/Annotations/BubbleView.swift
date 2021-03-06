//
//  BubbleView.swift
//  FoodOnRoute
//
//  Created by Stefan Brouwer on 08-12-15.
//  Copyright © 2015 Peter Alserda. All rights reserved.
//

import UIKit

/// A reusuable `UIView` subclass that draws a callout bubble.
///
/// This renders a simple callout or popover looking view where there is an arrow pointing down
/// (i.e. the callout is above the object in question). The `arrowHeight` and `arrowAngle` control
/// the shape of the arrow. The `cornerRadius` controls how rounded the main "box" of the callout
/// is.
///
/// This defines a `conventView`, a `UIView` subclass in which you can put your content. The intent
/// here is to isolate the code that uses this class from all of the ugly details about drawing the
/// path around the callout, the indentation within the callout, etc. If you want to resize it based
/// upon the size of the content of the bubble, call `setContentViewSize`.
///
/// Note, this was designed as `@IBDesignable` and generally you'd put this in a separate module.
/// But to keep this example simple, I'm just going to keep here, in this main target's module.

class BubbleView: UIView {
    var cornerRadius      : CGFloat = 5
    var arrowHeight       : CGFloat = 5
    var arrowAngle        : CGFloat = CGFloat(M_PI_4)
    var bubbleFillColor   : UIColor = UIColor.whiteColor()
    var bubbleStrokeColor : UIColor = UIColor.clearColor()
    var bubbleLineWidth   : CGFloat = 1
    
    let contentView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        addSubview(contentView)
    }
    
    override func layoutSubviews() {
        let contentViewFrame = CGRect(x: cornerRadius, y: cornerRadius, width: frame.size.width - cornerRadius * 2.0, height: frame.size.height - cornerRadius * 2.0 - arrowHeight)
        
        contentView.frame = contentViewFrame
    }
    
    func setContentViewSize(size: CGSize) {
        var bubbleFrame = self.frame
        bubbleFrame.size = CGSize(width: 250 + cornerRadius * 2.0, height: 167 + cornerRadius * 2.0 + arrowHeight)
        frame = bubbleFrame
        print("\(frame.height) ContentViewSize")
        setNeedsDisplay()
    }
    
    // draw the callout/popover/bubble with rounded corners and an arrow pointing down (presumably to the item below this)
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        let start = CGPointMake(frame.size.width / 2.0, frame.size.height)
        
        path.moveToPoint(start)
        
        // right side of arrow
        
        var point = CGPointMake(start.x + CGFloat(arrowHeight * tan(arrowAngle)), start.y - arrowHeight - bubbleLineWidth)
        path.addLineToPoint(point)
        
        // lower right
        
        point.x = frame.size.width - cornerRadius - bubbleLineWidth / 2.0
        path.addLineToPoint(point)
        
        // lower right corner
        
        point.x += cornerRadius
        var controlPoint = point
        point.y -= cornerRadius
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        
        // right
        
        point.y -= frame.size.height - arrowHeight - cornerRadius * CGFloat(2.0) - bubbleLineWidth * CGFloat(1.5)
        path.addLineToPoint(point)
        
        // upper right corner
        
        point.y -= cornerRadius
        controlPoint = point
        point.x -= cornerRadius
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        
        // top
        
        point.x -= (frame.size.width - cornerRadius * 2.0 - bubbleLineWidth)
        path.addLineToPoint(point)
        
        var lowerLeftPoint = point
        lowerLeftPoint.y += cornerRadius
        
        // top left corner
        
        point.x -= cornerRadius
        controlPoint = point
        point.y += cornerRadius
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        
        // left
        
        point.y += frame.size.height - arrowHeight - cornerRadius * CGFloat(2.0) - bubbleLineWidth * CGFloat(1.5)
        path.addLineToPoint(point)
        
        // lower left corner
        
        point.y += cornerRadius
        controlPoint = point
        point.x += cornerRadius
        path.addQuadCurveToPoint(point, controlPoint: controlPoint)
        
        // lower left
        
        point = CGPointMake(start.x - CGFloat(arrowHeight * tan(arrowAngle)), start.y - arrowHeight - bubbleLineWidth)
        path.addLineToPoint(point)
        
        // left side of arrow
        
        path.closePath()
        
        // draw the callout bubble
        
        bubbleFillColor.setFill()
        bubbleStrokeColor.setStroke()
        path.lineWidth = bubbleLineWidth
        
        path.fill()
        path.stroke()
    }
    
}
