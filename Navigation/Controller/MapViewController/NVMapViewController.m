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

static NSString * const kTitle = @"Map";


#define kDistanceArray [NSArray arrayWithObjects:@100, @500, @1000, @2000, nil]

@interface NVMapViewController ()
@property (nonatomic, readonly) NVMapView *mapView;

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
    
    NSArray *array = kDistanceArray;
    
    for (NSNumber *distance  in array) {
        CLLocationCoordinate2D coordinate = [self coordinateForDistance:distance.intValue
                                                         fromCoordinate:userCoordinate];
        
        NVMapAnnotation *placemark = nil;
        placemark = [[[NVMapAnnotation alloc] initWithCoordinate:coordinate] autorelease];
        placemark.title = [NSString stringWithFormat:@"Distance %@ m", distance];
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
