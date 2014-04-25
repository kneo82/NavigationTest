//
//  NVCompassViewController.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NVCompassViewController.h"
#import "NVCompassView.h"

#import "NSObject+IDPExtensions.h"
#import "UIViewController+IDPExtensions.h"

static NSString * const kTitle = @"Compass";

@interface NVCompassViewController ()
@property (nonatomic, retain)   CLLocationManager   *locationManager;
@property (nonatomic, readonly) NVCompassView       *compassView;
@end

@implementation NVCompassViewController

@dynamic compassView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = kTitle;
        
        self.locationManager = [CLLocationManager object];
        CLLocationManager *locationManager = self.locationManager;
        
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        [locationManager startUpdatingHeading];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger count = arc4random_uniform(20) + 25;
        for (int index = 0; index < count; index++) {
            CGFloat angle = arc4random_uniform(40);
            angle = (arc4random_uniform(2)%2) ? angle * (-1) : angle;
            self.compassView.angle += angle;
            sleep(2);
        }
    });
}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVCompassView, compassView)

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    CGFloat mHeading = newHeading.magneticHeading;
    self.compassView.angle = mHeading;    
}

@end
