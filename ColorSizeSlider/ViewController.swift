//
//  ViewController.swift
//  ColorSizeSlider
//
//  Created by Cardasis, Jonathan (J.) on 6/30/16.
//  Copyright © 2016 Cardasis, Jonathan (J.). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //let testFrame = CGRect(x: 280, y: 30, width: 32, height: 32)
        //let fancyControl = SizeSlideButton(condensedFrame: testFrame)
        
        let fancyControl = SizeSlideButton(frame: CGRect(x: 10, y: 30, width: 352, height: 32))
        
        
        /* Additional Setup */
        fancyControl.trackColor = UIColor.whiteColor()
        fancyControl.handle.color = UIColor(red: 255/255.0, green: 111/255.0, blue: 0, alpha: 1)
        //fancyControl.handlePadding = 0.0 //Add no extra padding around the handle
            //handlePadding works best as <= leftSideRadius
        self.view.addSubview(fancyControl)
        
        
        //fancyControl.frame = CGRect(x: 50, y: 130, width: 200, height: 50)
        //fancyControl.handlePadding = fancyControl.leftSideRadius
        
//        let debugView = UIView(frame: testFrame)
//        debugView.backgroundColor = UIColor.blueColor()
//        self.view.insertSubview(debugView, belowSubview: fancyControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
/*
 
 Document:
 
 .TouchUp is called when a TAP has finished
 .ValueChanged is called when the slider was let go
 .TouchDown is called both when a long press is detected or a regular touch is detected
 
 
 
 
 */

