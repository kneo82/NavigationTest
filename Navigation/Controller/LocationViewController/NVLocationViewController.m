//
//  NVLocationViewController.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NVLocationViewController.h"
#import "NVLocationView.h"

#import "UIViewController+IDPExtensions.h"
#import "NSObject+IDPExtensions.h"

static NSString * const kTitle = @"Location";

@interface NVLocationViewController ()
@property (nonatomic, readonly) NVLocationView      *locationView;
@property (nonatomic, retain)   CLLocationManager   *locationManager;
@end

@implementation NVLocationViewController

@dynamic locationView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.locationManager = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = kTitle;
        self.locationManager = [CLLocationManager object];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVLocationView, locationView)


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSString *coordinat = [NSString stringWithFormat:@"%f - %f", location.coordinate.latitude, location.coordinate.longitude];
    
    self.locationView.coordinate.text = coordinat;
    
    CLGeocoder *coder = [CLGeocoder object];
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *pl = [placemarks firstObject];
            NSLog(@"%@", pl.addressDictionary);
            self.locationView.address.text = [NSString stringWithFormat:@"%@", pl];
        } else {
            self.locationView.address.text = [NSString stringWithFormat:@"ERROR : %@", error];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    self.locationView.coordinate.text = [NSString stringWithFormat:@"Could not find location: %@", error];
}

@end
