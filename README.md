# SizeSlideButton
![Supported Version](https://img.shields.io/badge/Swift-3-yellow.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgray.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![CocoaPods](https://img.shields.io/badge/CocoaPods-1.5-green.svg)

A fun Swift UIControl for picking a size.
![Demo Animation](../assets/demo.gif?raw=true)

## Installation
### Cocoapods
Add `pod 'SizeSlideButton'` to your Podfile.
### Manually
Add the `SizeSlideButton.swift` class to your project.

## Examples
```Swift
let condensedFrame = CGRect(x: 280, y: 70, width: 32, height: 32) //Width and Height should be equal
let fancyControl = SizeSlideButton(condensedFrame: condensedFrame)

fancyControl.trackColor = UIColor(red: 38/255, green: 50/255, blue: 56/255, alpha: 1)
fancyControl.handle.color = UIColor.white
fancyControl.addTarget(self, action: #selector(newSizeSelected), for: .touchDragFinished)
fancyControl.addTarget(self, action: #selector(sizeSliderTapped), for: .touchUpInside)
self.view.addSubview(fancyControl)


func newSizeSelected(_ sender: SizeSlideButton){
    //Do something once a size is selected and the control let go
    // You can now use the senders .value for a value between 0 and 1
    // Or use the handle's height (handle.height) as a multiplier for size
    print("Value: \(sender.value)")
    print("Size multiplier: \(sender.handle.height)")

    // Ex: self.paintbrush.brushSize = kDefaultBrushSize * sender.handle.height
}

func sizeSliderTapped(_ sender: SizeSlideButton){
    //Do something when the button is tapped
    print("Tip Tap")
 }
```
Output:

<img src="../assets/darkScreenshot.png?raw=true" width="350">

## Documentation
+ `init(condensedFrame: CGRect)` will set the frame of where the condensed frame should lie (width and height should be equal)
+ `init(frame: CGRect)` will set the frame of where the frame should lie when fully expanded
+ `currentSize` to obtain the size the person has selected
+ `handlePadding` sets the padding around the handle (default is the left side's radius). Works best as <= leftSideRadius
+ `handle.color` is the slider's handle color
+ `handle.height`/`handle.width` gets the sizes of the handle and can be best used as a multiplier against a constant default size
+ `trackColor` is the color of the track
+ `value` is a value between 0 and 1.0 of where the handle was positioned relative on the track
+ `leftSideRadius` and `rightSideRadius` return the radii of the left and right sides of the frame when expanded
+ `currentState` returns if the control is condensed or expanded
+ `animationType` specifies the animation type used when letting go of the control

## Supported UIControlEvents
+ `touchUpInside` is called when a tap on the control is released
+ `valueChanged` is called when the slider is moved
+ `touchDown` is called both when a long press is detected or a regular touch is detected
+ `touchDragFinished` (A custom UIControlEvent) is called when the slider has selected a new value and been released


## License
SizeSlideButton is available under the MIT license. See the LICENSE file for more info.
