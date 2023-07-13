//
//  DJIHotpointMission+DJIMissionControlTimelineElement.h
//  DJISDK
//
//  Copyright © 2017, DJI. All rights reserved.
//

#import <DJISDK/DJISDK.h>

/**
 This category makes the DJIHotpointMission operatable inside the Mission
 Control timeline.
 */
@interface DJIHotpointMission (DJIMissionControlTimelineElement) <DJIMissionControlTimelineElement>


/**
 *  The time to delay the start of the mission
 */
@property (nonatomic, assign) NSUInteger delayTime;

@end
