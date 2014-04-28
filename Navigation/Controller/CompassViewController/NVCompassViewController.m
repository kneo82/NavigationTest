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

#import "CGGeometry+IDPExtensions.h"
#import "NSObject+IDPExtensions.h"
#import "UIViewController+IDPExtensions.h"

static NSString * const kTitle = @"Compass";

@interface NVCompassViewController ()
@property (nonatomic, retain)   CLLocationManager   *locationManager;
@property (nonatomic, readonly) NVCompassView       *compassView;

@property (nonatomic, retain)   NVRotationGestureRecognizer *gestureRecognizer;

- (void)setupLocationManager;
- (void)setupGestureRecognizer;

@end

@implementation NVCompassViewController

@dynamic compassView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.locationManager = nil;
    self.gestureRecognizer =nil;
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = kTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocationManager];
    [self setupGestureRecognizer];
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVCompassView, compassView)

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    CGFloat mHeading = newHeading.magneticHeading;
    self.compassView.angle = mHeading;    
}

#pragma mark -
#pragma mark NVRotationGestureRecognizerDelegate

- (void) rotation: (CGFloat) angle {
    self.compassView.angle = angle ;
}

- (void)finalAngle:(CGFloat)angle {
    [self.compassView rotateViewWithDuration:1 byAngleInDegrees:-angle];
}

- (void)gestureRecognizerStateFailed:(CGFloat)angle {
    [self finalAngle:angle];
}
#pragma mark -
#pragma mark Private

- (void)setupLocationManager {
    self.locationManager = [CLLocationManager object];
    CLLocationManager *locationManager = self.locationManager;
    
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager startUpdatingHeading];
}

- (void)setupGestureRecognizer {
    CGRect rect = self.compassView.frame;
    CGPoint pointOfCentre = CGRectGetCenter(rect);
    CGFloat outRadius = rect.size.width / 2;
    
    self.gestureRecognizer = [[NVRotationGestureRecognizer alloc] initWithPointOfCentre:pointOfCentre
                                                                            innerRadius:outRadius/3
                                                                            outerRadius:outRadius
                                                                                 target:self];
    [self.gestureRecognizer autorelease];
                              
    [self.compassView addGestureRecognizer: self.gestureRecognizer];
}

@end
