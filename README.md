# ColorSizeSlider
A fun Swift UIControl for picking a size


 
## Customize :pencil:
+ `currentSize` to obtain the size the person has selected
+ `handlePadding` sets the padding around the handle (default is the left side's radius). Works best as <= leftSideRadius
+ `handle.color` is the slider's handle color
+ `trackColor` is the color of the track
+ `value` is a value between 0 and 1.0 of where the handle was positioned relative on the track


## Supported UIControlEvents
+ `TouchUpInside` is called when a tap on the control is released
+ `ValueChanged` is called when the slider is moved
+ `TouchDown` is called both when a long press is detected or a regular touch is detected
+ `TouchDragFinished` (A custom UIControlEvent) is called when the slider has selected a new value and been released
 

##Examples
```Swift

```
