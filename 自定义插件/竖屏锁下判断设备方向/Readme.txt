MotionOrientation
An observer to notify the orientation of iOS device changed, using CoreMotion for taking the orientation in 'Orientation Lock'.

Requirements
This codes are under ARC.
These frameworks are needed.
CoreMotion.framework
CoreGraphics.framework

Usage
Run below.
[MotionOrientation initialize];
Then you can receive notifications below.
MotionOrientationChangedNotification, when the device orientation changed. MotionOrientationInterfaceOrientationChangedNotification, just when the interface orientation changed.
And then you can retrieve orientation informations.
UIInterfaceOrientation interfaceOrientation = [MotionOrientation sharedInstance].interfaceOrientation;
UIDeviceOrientation deviceOrientation = [MotionOrientation sharedInstance].deviceOrientation;