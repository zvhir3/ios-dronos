//
//  DUXCameraConfigShutterWidget.h
//  DJIUXSDK
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import <DJIUXSDK/DJIUXSDK.h>


/**
 *  Display:
 *  Camera's current shutter speed setting.
 *  
 *  Usage:
 *  Preferred Aspect Ratio: (variable, max:221):30.
 */
@interface DUXCameraConfigShutterWidget : DUXCameraConfigWidget


/**
 *  Selects which camera index widget refers to. Default value is 0.
 */
@property (nonatomic) NSUInteger preferredCameraIndex;


/**
 *  Selects which lens index widget refers to. Default value is 0.
 */
@property (nonatomic) NSUInteger preferredLensIndex;


/**
 *  The current shutterSpeed value. Defaults to unknown until transformed.
 */
@property DJICameraShutterSpeed shutterSpeed;

@end
