//
//  ViewController.swift
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
        fancyControl.trackColor = UIColor.white
        fancyControl.handle.color = UIColor(red: 255/255.0, green: 111/255.0, blue: 0, alpha: 1)
        //fancyControl.handlePadding = 0.0 //Add no extra padding around the handle
        //fancyControl.animationType = .linear
        
        fancyControl.addTarget(self, action: #selector(newSizeSelected), for: .touchDragFinished)
        fancyControl.addTarget(self, action: #selector(sizeSliderTapped), for: .touchUpInside)
        self.view.addSubview(fancyControl)
        
        /* Test for moving frame and changing padding */
        //fancyControl.frame = CGRect(x: 50, y: 130, width: 200, height: 50)
        //fancyControl.handlePadding = 0.0
        
        
        /* A button to test for click-through on the fancyControl as well as appear when tapped */
        debugBtn = UIButton(frame: CGRect(x: 165, y: 75, width: 100, height: 22))
        debugBtn.setTitle("Tapped", for: UIControlState())
        debugBtn.alpha = 0
        debugBtn.addTarget(self, action: #selector(test), for: .touchUpInside) //For testing purposes
        self.view.insertSubview(debugBtn, belowSubview: fancyControl)
    }
    
    func newSizeSelected(_ sender: SizeSlideButton){
        //Do something once a size is selected and the control let go
        let multipler = sender.handle.height
        
        print("Value: \(sender.value)")
        print("Multiplier: \(multipler)")
    }
    
    func sizeSliderTapped(_ sender: SizeSlideButton){
        //Do something when the button is tapped
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.debugBtn.alpha = 1
            }, completion: { (done) in
                UIView.animate(withDuration: 0.3, delay: 0.65, options: .curveEaseIn, animations: {
                    self.debugBtn.alpha = 0
                    }, completion: nil)
        }) 
    }
    
    func test(){
        print("Clickarooo!")
    }
}

