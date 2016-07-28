//
//  ViewController.swift
//  ColorSizeSlider
//
//  Created by Jonathan Cardasis on 6/30/16.
//  Copyright © 2016 Jonathan Cardasis. All rights reserved.
//

import UIKit

/* A test viewcontroller */
class ViewController: UIViewController {
    
    var debugBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let condensedFrame = CGRect(x: 280, y: 70, width: 32, height: 32) //Width and Height should be equal
        let fancyControl = SizeSlideButton(condensedFrame: condensedFrame)
        
        //let fancyControl = SizeSlideButton(frame: CGRect(x: 10, y: 30, width: 352, height: 32))
        
        
        /* Additional Setup */
        fancyControl.trackColor = UIColor.whiteColor()
        fancyControl.handle.color = UIColor(red: 255/255.0, green: 111/255.0, blue: 0, alpha: 1)
        //fancyControl.handlePadding = 0.0 //Add no extra padding around the handle
        
        
        fancyControl.addTarget(self, action: #selector(newSizeSelected), forControlEvents: .TouchDragFinished)
        fancyControl.addTarget(self, action: #selector(sizeSliderTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(fancyControl)
        
        /* Test for moving frame and changing padding */
        //fancyControl.frame = CGRect(x: 50, y: 130, width: 200, height: 50)
        //fancyControl.handlePadding = 0.0
        
        
        //A button to test for click-through on the fancyControl
        debugBtn = UIButton(frame: CGRect(x: 165, y: 75, width: 100, height: 22))
        //debugBtn.backgroundColor = UIColor.purpleColor();
        debugBtn.setTitle("Tapped", forState: .Normal)
        debugBtn.alpha = 0
        debugBtn.addTarget(self, action: #selector(test), forControlEvents: .TouchUpInside)
        self.view.insertSubview(debugBtn, belowSubview: fancyControl)
    }
    
    func newSizeSelected(sender: SizeSlideButton){
        //Do something once a size is selected and the control let go
        print("Value: \(sender.value)")
    }
    
    func sizeSliderTapped(sender: SizeSlideButton){
        //Do something when the button is tapped
        
        UIView.animateWithDuration(0.3, animations: { 
            self.debugBtn.alpha = 1
            }) { (done) in
                UIView.animateWithDuration(0.3, delay: 0.65, options: .CurveEaseIn, animations: {
                    self.debugBtn.alpha = 0
                    }, completion: nil)
        }
        
    }
    
    
    func test(){
        print("Clickarooo!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
/*
 
 Document:
 
 .TouchUpInside is called when a TAP has finished
 .ValueChanged is called when the slider is moved
 .TouchDown is called both when a long press is detected or a regular touch is detected
 A custom UIControlEvent called `TouchDragFinished` is implemented for when the slider has selected a new value and been released
 
 
 
 + Use `currentSize` to obtain the size the person has selected
 + Use `handlePadding` to adjust the padding around the handle (default is set is the left side radius). Works best as <= leftSideRadius
 + Set the handle color by using `fancyControl.handle.color = UIColor.someColor()` to change its color
 + `trackColor` sets the color of the track
 + Use `value` to obtain a value between 0 and 1.0 of the slider
 
 */

