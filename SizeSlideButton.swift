//
//  SizeSlideButton.swift
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
open class SizeSlideHandle: CAShapeLayer {
    open var color: UIColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1){
        didSet{ self.fillColor = color.cgColor }
    }
    
    override open var frame: CGRect {
        didSet{
            self.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)).cgPath
        }
    }
    
    open var height: CGFloat {
        return frame.size.height
    }
    
    open var width: CGFloat {
        return frame.size.width
    }
    
    override init() {
        super.init()
        self.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)).cgPath
        self.fillColor = color.cgColor
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
    static public let touchDragFinished = UIControlEvents(rawValue: 0x01000000)
}

open class SizeSlideButton: UIControl {
    public enum AnimationType {
        case spring
        case linear
    }
    
    open let shapeMask = CAShapeLayer()
    open var handle = SizeSlideHandle()
    open var animationType: AnimationType = .spring
    open fileprivate(set) var currentState: SizeSlideButtonState = .condensed //default state
    
    override open var frame: CGRect {
        didSet{
            if currentState == .condensed {
                shapeMask.path = condensedLayerMaskPath
            } else{
                shapeMask.path = expandedLayerMaskPath
            }
            handle.frame.size = CGSize(width: frame.height, height: frame.height)
            handle.position = CGPoint(x: frame.width-rightSideRadius, y: frame.height/2)
        }
    }
    
    open var handlePadding: CGFloat = 0.0{ //padding on sides of the handle
        didSet{
            //Adjust size position for delta value
            handle.frame.size = CGSize(width: handle.frame.width + (oldValue-handlePadding), height: handle.frame.height + (oldValue-handlePadding))
            handle.position = CGPoint(x: handle.position.x + (handlePadding-oldValue)/2, y: frame.height/2)
        }
    }
    
    open var value: Float { //value which displays between 0 and 1.0 for position on control
        get{
            /* Return a value between 0 and 1.0 */
            let input = (((handle.frame.height+handlePadding)/2)/leftSideRadius)
            let result = (1/3)*(input - 1) // 1/3 is m(x)
            //let result = map((handle.frame.height+handlePadding)/2, leftMin: leftSideRadius, leftMax: rightSideRadius, rightMin: 0, rightMax: frame.width) / frame.width
            return Float(result)
        }
        set{
            /* Adjust view to fit the new value */
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
   
    open var currentSize: CGFloat { //return the height of the displayed handle indicator
        get { return handle.frame.size.height }
    }
    open var leftSideRadius: CGFloat{
        get{ return frame.size.height/8 }
    }
    open var rightSideRadius: CGFloat{
        get{ return frame.size.height/2 }
    }
    open var trackColor: UIColor = UIColor.white{
        didSet{ backgroundColor = trackColor }
    }
    
    /* Layer Masks - must share same points for animations */
    var expandedLayerMaskPath: CGPath{
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x:  leftSideRadius, y: frame.height/2), radius: leftSideRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(1.5*M_PI), clockwise: true)
        path.addArc(withCenter: CGPoint(x: frame.width - rightSideRadius, y: rightSideRadius), radius: rightSideRadius, startAngle: CGFloat(1.5*M_PI), endAngle: 0, clockwise: true)
        path.addArc(withCenter: CGPoint(x: frame.width - rightSideRadius, y: frame.height - rightSideRadius), radius: rightSideRadius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addArc(withCenter: CGPoint(x: leftSideRadius, y: frame.height/2), radius: leftSideRadius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        path.close()
        return path.cgPath
    }
    
    var condensedLayerMaskPath: CGPath{
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x:  frame.width - rightSideRadius, y: rightSideRadius), radius: rightSideRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(1.5*M_PI), clockwise: true)
        path.addArc(withCenter: CGPoint(x: frame.width - rightSideRadius, y: rightSideRadius), radius: rightSideRadius, startAngle: CGFloat(1.5*M_PI), endAngle: 0, clockwise: true)
        path.addArc(withCenter: CGPoint(x: frame.width - rightSideRadius, y: frame.height - rightSideRadius), radius: rightSideRadius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addArc(withCenter: CGPoint(x: frame.width - rightSideRadius, y: frame.height - rightSideRadius), radius: rightSideRadius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        path.close()
        return path.cgPath
    }
    
    /* Convenience variables */
    var condensedFrame: CGRect{ //Frame representing the condensed view
        var properBounds = condensedLayerMaskPath.boundingBox
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
        let dimensionSize = min(condensedFrame.width, condensedFrame.height)
        let defaultTrackSize = CGSize(width: dimensionSize * 8, height: dimensionSize) //give  a default size if its not specified
        super.init(frame: CGRect(x: condensedFrame.origin.x - defaultTrackSize.width + dimensionSize, y: condensedFrame.origin.y, width: defaultTrackSize.width, height: dimensionSize))
        commonInit()
    }
    
    fileprivate func commonInit(){
        trackColor = UIColor.white //default track color

        /* Setup mask layer */
        shapeMask.path = condensedLayerMaskPath
        shapeMask.rasterizationScale = UIScreen.main.scale
        shapeMask.shouldRasterize = true
        self.layer.mask = shapeMask
        
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
    func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer){
        
        if currentState == .condensed{
            self.sendActions(for: .touchDown)
            
            /* Animate mask to full glory and change state when completed */
            currentState = .expanded //promise the state will be expanded
            self.animateTrack(to: .expanded, velocity: 20, damping: 40)
        }
        
        if gesture.state == .changed{
            let touchLocation = gesture.location(in: self)
            self.moveHandle(to: touchLocation)

            /* Trigger event actions */
            self.sendActions(for: .valueChanged)
        }
        
        if gesture.state == .ended{
            let damping: CGFloat = 20
            
            /* Animate handle to right side position */
            let spring = CASpringAnimation(keyPath: "position.x")
            spring.initialVelocity = CGFloat(((1-value) * 2) + 13) //tweaked speed algorithm (faster velocity further to 0)
            spring.damping = damping
            spring.fromValue = handle.position.x
            spring.toValue = frame.width-rightSideRadius
            spring.duration = spring.settlingDuration
            handle.position = CGPoint(x: frame.width-rightSideRadius, y: handle.position.y) //set final state
            if animationType == .linear {
                //Simulate a linear movement with a modified mass
                spring.mass = 0.2
            }
            handle.add(spring, forKey: nil)
        
            /* Animate mask back and change enum state */
            currentState = .condensed //promise the state will become condensed
            self.animateTrack(to: .condensed, velocity: spring.initialVelocity, damping: spring.damping)
            
            /* Trigger event actions */
            self.sendActions(for: .touchDragFinished)
        }
    }
    
    
    func springAnimateHandle(to position: CGPoint, with damping: CGFloat = 20) { }
    
    func handleTapGesture(_ gesture: UITapGestureRecognizer){
        if gesture.state == .began{
            self.sendActions(for: .touchDown)
        }
        else if gesture.state == .ended{
            self.sendActions(for: .touchUpInside)
        }
    }
    
    //Override to allow touches through the frame when the extended state is not active
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        //Set so only hit-box area is the condensed frame
        let condensedHitBox = CGRect(origin: CGPoint(x: condensedFrame.origin.x - frame.origin.x, y:0), size: condensedFrame.size) //recalculate proper hitbox for condensedframe
        return condensedHitBox.contains(point)
    }
    
    // Moves the handle's center to the point in the frame
    fileprivate func moveHandle(to touchPoint: CGPoint){
       
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
    
    func animateTrack(to state: SizeSlideButtonState, velocity: CGFloat, damping: CGFloat , completion: ((_ done: Bool) -> ())? = nil) {
        guard let layerMask = self.layer.mask else{//protect
            completion?(false)
            return
        }
        
        let newMaskPath: CGPath
        if state == .condensed{
            newMaskPath = condensedLayerMaskPath
        }else{
            newMaskPath = expandedLayerMaskPath
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({ completion?(true) })
        
        let revealAnimation = CASpringAnimation(keyPath: "path")
        revealAnimation.initialVelocity = velocity
        revealAnimation.damping = damping
        revealAnimation.fromValue = shapeMask.path
        revealAnimation.toValue = newMaskPath
        revealAnimation.duration = revealAnimation.settlingDuration
        revealAnimation.isRemovedOnCompletion = false
        revealAnimation.fillMode = kCAFillModeForwards
        
        shapeMask.path = newMaskPath //set final state
        
        //CATrasaction will not account for self.mask having an animation added even though self.layer.mask points to this variable. We must animate directly on the layer mask.
        layerMask.add(revealAnimation, forKey: nil)
        
        CATransaction.commit()
    }
    
    //MARK: Helper Functions
    fileprivate func map(_ value: CGFloat, leftMin:CGFloat, leftMax:CGFloat, rightMin:CGFloat, rightMax: CGFloat) -> CGFloat{
        let leftSpan = leftMax - leftMin
        let rightSpan = rightMax - rightMin
        let valueScaled = (value - leftMin) / (leftSpan)

        return (valueScaled * rightSpan) + rightMin
    }
}
