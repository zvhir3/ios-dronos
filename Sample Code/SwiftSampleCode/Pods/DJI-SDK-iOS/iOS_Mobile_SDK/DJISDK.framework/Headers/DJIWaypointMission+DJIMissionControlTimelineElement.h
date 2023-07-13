//
//  DJIWaypointMission+DJIMissionControlTimelineElement.h
//  DJISDK
//
//  Copyright © 2017, DJI. All rights reserved.
//

#import <DJISDK/DJISDK.h>

/**
 *  This category adds trigger support for ``DJIWaypointMission`` inside the Mission
 *  Control timeline.
 */
@interface DJIWaypointMission (DJIMissionControlTimelineElement) <DJIMissionControlTimelineElement>


/**
 *  Mission Control loads and activates the triggers for the duration that the
 *  waypoint mission is executing.
 */
@property (nonatomic, strong) NSArray<DJIMissionTrigger *> *triggers;


/**
 *  The time to delay the start of the mission
 */
@property (nonatomic, assign) NSUInteger delayTime;

@end
