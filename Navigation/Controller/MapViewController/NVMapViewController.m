//
//  NVMapViewController.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVMapViewController.h"
#import "NVMapView.h"
#import "NVMapAnnotation.h"
#import "NVPinView.h"

#import "UIViewController+IDPExtensions.h"
#import "MKMapView+NVExtensions.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

static NSString * const kTitle = @"Map";
static const CLLocationDegrees kNorth   = 0.0;
static const CLLocationDegrees kSouth   = 180.0;
static const CLLocationDegrees kWest    = -90.0;
static const CLLocationDegrees kEast    = 90.0;

#define kDistanceArray [NSArray arrayWithObjects:@100, @500, @1000, @2000, nil]

@interface NVMapViewController () <CLLocationManagerDelegate>
@property (nonatomic, readonly) NVMapView *mapView;
@property (nonatomic, strong)   CLLocationManager *locationManager;

@end

@implementation NVMapViewController

@dynamic mapView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = kTitle;
    }
    
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        //        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    
    MKMapView *map = self.mapView.map;
    CLLocationCoordinate2D coordinate = map.userLocation.location.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span = span;
    
    [map setRegion:region animated:YES];
}

- (CLLocationCoordinate2D)coordinateForDistance:(CLLocationDistance)distance
                                 fromCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKMapPoint point = MKMapPointForCoordinate(coordinate);
    CLLocationDistance pointsPerMeter = MKMapPointsPerMeterAtLatitude(coordinate.latitude);

    double latPoints = distance * pointsPerMeter;
    point.x -= latPoints;
    return MKCoordinateForMapPoint(point);
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVMapView, mapView)

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)        mapView:(MKMapView *)mapView
  didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D userCoordinate = userLocation.coordinate;

    [mapView setCenterCoordinate:userCoordinate animated:YES];
    [mapView removeAnnotations:mapView.annotations];
    
    NSArray *distances = kDistanceArray;
    
    for (NSNumber *distance  in distances) {
        NVMapAnnotation *placemark = nil;
        placemark = [[[NVMapAnnotation alloc] initWithDistance:distance.doubleValue
                                                       degrees:kWest
                                                fromCoordinate:userCoordinate]autorelease];

        [mapView addAnnotation:placemark];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *reusable = nil;
    reusable = [mapView dequeuePin:[NVPinView class]];
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)reusable;
    
    if (!pinView) {
        return [[[NVPinView alloc] initWithAnnotation:annotation] autorelease];
    }
    
    pinView.annotation = annotation;
    
    return pinView;
}

@end
