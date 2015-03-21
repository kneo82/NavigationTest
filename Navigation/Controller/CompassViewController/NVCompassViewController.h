//
//  NVCompassViewController.h
//  Compass
//
//  Created by Vitaliy Voronok on 5/2/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "NVRotationGestureRecognizer.h"

@interface NVCompassViewController : UIViewController <CLLocationManagerDelegate,
                                                        NVRotationGestureRecognizerDelegate>

@end

