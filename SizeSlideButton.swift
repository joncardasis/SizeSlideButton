//
//  SizeSlideButton.swift
//  ColorSizeSlider
//
//  Created by Jonathan Cardasis on 6/30/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit

//MARK: - SizeSlideButton Subcomponents
public class SizeSlideHandle: CAShapeLayer {
    public var color: UIColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1){
        didSet{ self.fillColor = color.CGColor }
    }
    
    override public var frame: CGRect{
        didSet{
            self.path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)).CGPath
        }
    }
    
    override init() {
        super.init()
        self.path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)).CGPath
        self.fillColor = color.CGColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SizeSlideButton
public enum SizeSlideButtonState {
    case condensed
    case expanded
}

public extension UIControlEvents{ //Add extra control event
    /* Note that Apple only reserves 4 values: 0x01000000, 0x02000000, 0x04000000 and 0x08000000 for use by UIControlEventApplicationReserved */
    static public let TouchDragFinished = UIControlEvents(rawValue: 0x01000000) //uppercase to match UIControlEvents (sorry Swift3)
}

public class SizeSlideButton: UIControl {
    override public var frame: CGRect {
        didSet{
            if currentState == .condensed {
                mask.path = condensedLayerMaskPath
            }else{
                mask.path = expandedLayerMaskPath
            }
            handle.frame.size = CGSize(width: frame.height, height: frame.height)
            handle.position = CGPoint(x: frame.width-rightSideRadius, y: frame.height/2)
        }
    }
    let mask = CAShapeLayer()
    public var handle = SizeSlideHandle()
    
    public var handlePadding: CGFloat = 0.0{ //padding on sides of the handle
        didSet{
            //Adjust size position for delta value
            handle.frame.size = CGSize(width: handle.frame.width + (oldValue-handlePadding), height: handle.frame.height + (oldValue-handlePadding))
            handle.position = CGPoint(x: handle.position.x + (handlePadding-oldValue)/2, y: frame.height/2)
        }
    }
    public var value: Float { //value which displays between 0 and 1.0 for position on control
        get{
            /* Return a value between 0 and 1.0 */
            let input = (((handle.frame.height+handlePadding)/2)/leftSideRadius)
            let result = (1/3)*(input - 1) // 1/3 is m(x)
            //let result = map((handle.frame.height+handlePadding)/2, leftMin: leftSideRadius, leftMax: rightSideRadius, rightMin: 0, rightMax: frame.width) / frame.width
            return Float(result)
        }
        set{
            let boundValue = max(0, min(CGFloat(newValue), 1)) //clip value between 0 and 1
            
            var multiplier: CGFloat
            if newValue <= 0.5 {
                multiplier = map(boundValue, leftMin: 0, leftMax: 0.5, rightMin: (1/4), rightMax: (5/8))
            }else{
                multiplier = map(boundValue, leftMin: 0.5, leftMax: 1, rightMin: (5/8), rightMax: 1)
            }
            
            let height = frame.height * multiplier
            
            let newSize = CGSize(width: height - handlePadding, height: height - handlePadding)
            handle.frame = CGRect(x: frame.width - rightSideRadius - newSize.width/2, y: self.frame.height/2 - newSize.height/2, width: newSize.width, height: newSize.height)
        }
    }
    public private (set) var currentState: SizeSlideButtonState = .condensed //default state
    public var currentSize: CGFloat { //return the height of the displayed handle indicator
        get { return handle.frame.size.height }
    }
    
    public var trackColor: UIColor = UIColor.whiteColor(){
        didSet{ backgroundColor = trackColor }
    }
    
    public var leftSideRadius: CGFloat{
        get{ return frame.size.height/8 }
    }
    public var rightSideRadius: CGFloat{
        get{ return frame.size.height/2 }
    }
    
    
    /* Layer Masks - must share same points for animations */
    var expandedLayerMaskPath: CGPath{
        let path = UIBezierPath()
        path.addArcWithCenter(CGPoint(x:  leftSideRadius, y: frame.height/2), radius: leftSideRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(1.5*M_PI), clockwise: true)
        path.addArcWithCenter(CGPoint(x: frame.width - rightSideRadius, y: rightSideRadius), radius: rightSideRadius, startAngle: CGFloat(1.5*M_PI), endAngle: 0, clockwise: true)
        path.addArcWithCenter(CGPoint(x: frame.width - rightSideRadius, y: frame.height - rightSideRadius), radius: rightSideRadius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addArcWithCenter(CGPoint(x: leftSideRadius, y: frame.height/2), radius: leftSideRadius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        path.closePath()
        return path.CGPath
    }
    var condensedLayerMaskPath: CGPath{
        let path = UIBezierPath()
        path.addArcWithCenter(CGPoint(x:  frame.width - rightSideRadius, y: rightSideRadius), radius: rightSideRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(1.5*M_PI), clockwise: true)
        path.addArcWithCenter(CGPoint(x: frame.width - rightSideRadius, y: rightSideRadius), radius: rightSideRadius, startAngle: CGFloat(1.5*M_PI), endAngle: 0, clockwise: true)
        path.addArcWithCenter(CGPoint(x: frame.width - rightSideRadius, y: frame.height - rightSideRadius), radius: rightSideRadius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addArcWithCenter(CGPoint(x: frame.width - rightSideRadius, y: frame.height - rightSideRadius), radius: rightSideRadius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        path.closePath()
        return path.CGPath
    }
    
    /* Convenience variables */
    var condensedFrame: CGRect{ //Frame representing the condensed view
        var properBounds = CGPathGetBoundingBox(condensedLayerMaskPath)
        properBounds.origin.x += frame.origin.x //remap inner frame coords to world coords
        properBounds.origin.y += frame.origin.y
        return properBounds
    }
    
    
    //MARK: Implementation
    override public init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    public init(condensedFrame: CGRect){
        let defaultTrackSize = CGSizeMake(condensedFrame.width * 8, condensedFrame.height) //give  a default size if its not specified
        super.init(frame: CGRect(x: condensedFrame.origin.x - defaultTrackSize.width + condensedFrame.width, y: condensedFrame.origin.y, width: defaultTrackSize.width, height: condensedFrame.height))
        commonInit()
    }
    
    private func commonInit(){
        trackColor = UIColor.whiteColor() //default track color

        /* Setup mask layer */
        mask.path = condensedLayerMaskPath
        mask.rasterizationScale = UIScreen.mainScreen().scale
        mask.shouldRasterize = true
        self.layer.mask = mask
        
        /* Set a default handle padding */
        handlePadding = leftSideRadius
        
        /* Setup Handle */
        handle.frame = CGRect(x: 0, y: 0, width: frame.height - handlePadding, height: frame.height - handlePadding)
        handle.position = CGPoint(x: frame.width-rightSideRadius, y: frame.height/2)
        handle.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()] //disable implicit animations
        self.layer.addSublayer(handle)
        
        /* Setup Gesture Recognizers */
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        holdGesture.minimumPressDuration = 0.3
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        
        self.addGestureRecognizer(holdGesture)
        self.addGestureRecognizer(tapGesture)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    //MARK: Gesture/Touch Controls
    func handleLongPressGesture(gesture: UILongPressGestureRecognizer){
        
        if currentState == .condensed{
            self.sendActionsForControlEvents(.TouchDown)
            
            /* Animate mask to full glory and change state when completed */
            currentState = .expanded //promise the state will be expanded
            self.animateTrack(to: .expanded, velocity: 20, damping: 40)
        }
        
        if gesture.state == .Changed{
            let touchLocation = gesture.locationInView(self)
            self.moveHandle(to: touchLocation)

            /* Trigger event actions */
            self.sendActionsForControlEvents(.ValueChanged)
        }
        
        if gesture.state == .Ended{
            /* Animate handle to right side position */
            let spring = CASpringAnimation(keyPath: "position.x")
            spring.initialVelocity = CGFloat(((1-value) * 2) + 13) //tweaked speed algorithm (faster velocity further to 0)
            spring.damping = 20
            spring.fromValue = handle.position.x
            spring.toValue = frame.width-rightSideRadius
            spring.duration = spring.settlingDuration
            handle.position = CGPoint(x: frame.width-rightSideRadius, y: handle.position.y) //set final state
            handle.addAnimation(spring, forKey: nil)

            /* Animate mask back and change enum state */
            currentState = .condensed //promise the state will become condensed
            self.animateTrack(to: .condensed, velocity: spring.initialVelocity, damping: spring.damping)
            
            /* Trigger event actions */
            self.sendActionsForControlEvents(.TouchDragFinished)
        }
    }
    
    func handleTapGesture(gesture: UITapGestureRecognizer){
        if gesture.state == .Began{
            self.sendActionsForControlEvents(.TouchDown)
        }
        else if gesture.state == .Ended{
            self.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    //Override to allow touches through the frame when the extended state is not active
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        //Set so only hit-box area is the condensed frame
        let condensedHitBox = CGRect(origin: CGPoint(x: condensedFrame.origin.x - frame.origin.x, y:0), size: condensedFrame.size) //recalculate proper hitbox for condensedframe
        return CGRectContainsPoint(condensedHitBox, point)
    }
    
    
    // Moves the handle's center to the point in the frame
    private func moveHandle(to touchPoint: CGPoint){
        /* Recalculate for outside points */
        var point = touchPoint
        if point.x < leftSideRadius {
            point.x = leftSideRadius
        }
        else if point.x > self.frame.width-rightSideRadius {
            point.x = self.frame.width-rightSideRadius
        }
        
        /* Get a proper multipler for the height */
        //   We use 1/8 + 4/8 (5/8) as the median multiplier because the caps are different sizes
        //   We start at 1/4 for the smallest multiper so it is equal to leftsideradius on the left
        var multiplier: CGFloat = 0
        if point.x <= frame.width/2 {
           multiplier = map(point.x, leftMin: leftSideRadius, leftMax: frame.width/2, rightMin: (1/4), rightMax: (5/8))
        }
        else if point.x > frame.width/2 {
            multiplier = map(point.x, leftMin: frame.width/2, leftMax: frame.width-rightSideRadius, rightMin: (5/8), rightMax: 1)
        }
        
        
        let newHandleSize = CGSize(width: frame.height * CGFloat(multiplier) - handlePadding, height: frame.height * CGFloat(multiplier) - handlePadding)
        
        /* Apply for new size and location */
        handle.frame = CGRect(x: point.x - newHandleSize.width/2, y: self.frame.height/2 - newHandleSize.height/2, width: newHandleSize.width, height: newHandleSize.height)
    }
    
    func animateTrack(to state: SizeSlideButtonState, velocity: CGFloat, damping: CGFloat , completion: ((done: Bool) -> ())? = nil) {
        guard let layerMask = self.layer.mask else{//protect
            completion?(done: false)
            return
        }
        
        let newMaskPath: CGPath
        if state == .condensed{
            newMaskPath = condensedLayerMaskPath
        }else{
            newMaskPath = expandedLayerMaskPath
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({ completion?(done: true) })
        
        let revealAnimation = CASpringAnimation(keyPath: "path")
        revealAnimation.initialVelocity = velocity
        revealAnimation.damping = damping
        revealAnimation.fromValue = mask.path
        revealAnimation.toValue = newMaskPath
        revealAnimation.duration = revealAnimation.settlingDuration
        revealAnimation.removedOnCompletion = false
        revealAnimation.fillMode = kCAFillModeForwards
        
        mask.path = newMaskPath //set final state
        
        //CATrasaction will not account for self.mask having an animation added even though self.layer.mask points to this variable. We must animate directly on the layer mask.
        layerMask.addAnimation(revealAnimation, forKey: nil)
        
        CATransaction.commit()
    }
    
    //MARK: Helper Functions
    private func map(value: CGFloat, leftMin:CGFloat, leftMax:CGFloat, rightMin:CGFloat, rightMax: CGFloat) -> CGFloat{
        let leftSpan = leftMax - leftMin
        let rightSpan = rightMax - rightMin
        
        let valueScaled = (value - leftMin) / (leftSpan)
        
        return (valueScaled * rightSpan) + rightMin
    }
}
