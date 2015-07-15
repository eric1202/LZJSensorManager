//
//  LZJSensorManager.m


#import "LZJSensorManager.h"
#import <UIKit/UIKit.h>



@interface LZJSensorManager () <CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CLLocationManager       *locationMgr;
    CMMotionManager         *motionMgr;
    
    CLLocationDirection     curHeading;
    CMAttitude              *curAttitude;
    CMAcceleration          curAcceleration;
}

@property (nonatomic, strong) CMAttitude              *curAttitude;

@end



@implementation LZJSensorManager

@synthesize curAttitude;


- (id)init
{
    if (self = [super init]) {
        locationMgr = [[CLLocationManager alloc] init];
        locationMgr.delegate = self;
        motionMgr = [[CMMotionManager alloc] init];
        
    }
    
    return self;
}



#pragma mark - CLLocationManager

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    //put some codes here
}

//check if the navigation is not used
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"请在设置中打开对本应用的位置使用授权";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"oh no" message:errorString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
    [alert show];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    //NSLog(@"didUpdateHeading - %@", newHeading);
    curHeading = newHeading.trueHeading;

}

#pragma mark - ui alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"请在设置中打开对本应用的位置使用授权"]) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}



#pragma mark - interface

- (void)startSensor
{
    [self startHeadingSensor];
    
    [self startMotionSensor];
    //[self startAccelerometerSensor];
}


- (void)stopSensor
{
    [self stopHeadingSensor];
    
    [self stopMotionSensor];
    //[self stopAccelerometerSensor];
}



#pragma mark - heading

- (void)startHeadingSensor
{
    [locationMgr startUpdatingLocation];
    [locationMgr startUpdatingHeading];
}

- (void)stopHeadingSensor
{
    [locationMgr stopUpdatingLocation];
    [locationMgr stopUpdatingHeading];
}

- (void)setHeadingOrientation:(UIDeviceOrientation)orientation
{
    locationMgr.headingOrientation = (CLDeviceOrientation)orientation;
}


- (CLLocationDirection)getCurrentHeading
{
    return curHeading;
}



#pragma mark - motion

- (void)startMotionSensor
{
    motionMgr.deviceMotionUpdateInterval = 0.033;
    [motionMgr startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [self updateMotionData:motion];
    }];

}

- (void)stopMotionSensor
{
    [motionMgr stopDeviceMotionUpdates];
}


- (void)updateMotionData:(CMDeviceMotion*)motion
{
    self.curAttitude = motion.attitude;
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:motion.attitude.pitch] forKey:NOTIFY_PITCH_UPDATE];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PITCH_UPDATE object:nil userInfo:dic];
    
    
}

- (CMAttitude*)getCurrentAttitude
{
    return curAttitude;
}


#pragma mark - accelerometer

- (void)startAccelerometerSensor
{
    motionMgr.accelerometerUpdateInterval = 0.033;
    [motionMgr startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self updateAccelerometerData:accelerometerData];
    }];
}


- (void)stopAccelerometerSensor
{
    [motionMgr stopAccelerometerUpdates];
}


- (void)updateAccelerometerData:(CMAccelerometerData*)accelerometer
{
    NSLog(@"Accelerometer - x=%f, y=%f, z=%f", accelerometer.acceleration.x, accelerometer.acceleration.y, accelerometer.acceleration.z);
    curAcceleration = accelerometer.acceleration;
}


- (CMAcceleration)getCurrentAcceleration
{
    return curAcceleration;
}





@end
