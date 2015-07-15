//
//  LZJSensorManager.h
//  iAR
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

#define NOTIFY_HEADING_UPDATE @"notify_heading_update"

#define NOTIFY_PITCH_UPDATE @"notify_pitch_update"



@interface LZJSensorManager : NSObject




- (void)startSensor;
- (void)stopSensor;


- (void)startHeadingSensor;
- (void)stopHeadingSensor;

- (CLLocationDirection)getCurrentHeading;


- (void)startMotionSensor;
- (void)stopMotionSensor;
- (CMAttitude*)getCurrentAttitude;

- (void)startAccelerometerSensor;
- (void)stopAccelerometerSensor;
- (CMAcceleration)getCurrentAcceleration;

@end
