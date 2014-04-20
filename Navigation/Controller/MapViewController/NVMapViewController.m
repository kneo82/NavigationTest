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

#import "UIViewController+IDPExtensions.h"
#import "MKMapView+NVExtensions.h"

static NSString * const kTitle = @"Map";


#define kDistanceArray [NSArray arrayWithObjects:@2, @500, @1000, @2000, nil]

@interface NVMapViewController ()
@property (nonatomic, readonly) NVMapView *mapView;


@end

@implementation NVMapViewController

@dynamic mapView;

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.mapView.map.delegate = self;
        self.title = kTitle;
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

IDPViewControllerViewOfClassGetterSynthesize(NVMapView, mapView)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocationCoordinate2D coord = self.mapView.map.userLocation.location.coordinate;
    coord.latitude = 55.755786000000001;
    coord.longitude = 37.617632999999998;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    MKCoordinateRegion region;
    region.center = coord;
    region.span = span;
    
    [self.mapView.map setRegion:region animated:YES];
//    [self.mapView.map setCenterCoordinate:coord animated:YES];
    
//    NVMapAnnotation *placemark = [[NVMapAnnotation alloc] initWithCoordinate:coord];
//    placemark.title = @"Кремль";
//    placemark.subtitle = @"Россия, Москва";
//    [self.mapView.map addAnnotation:placemark];
//    [placemark release];
////    MKCoordinateRegion reg =  MKCoordinateRegionMakeWithDistance(coord, 500, 0);
////    CLLocation *west = [[CLLocation alloc] init
//    // [self.mapView.map convertPoint:point toCoordinateFromView:nil];
//    
//    CLLocationCoordinate2D coord2 = [self coordinateForDistance:2 fromCoordinate:coord];
//    
//    NVMapAnnotation *placemark2 = [[NVMapAnnotation alloc] initWithCoordinate:coord2];
//    placemark2.title = @"2 m";
//    placemark2.subtitle = @"Россия, Москва";
//    [self.mapView.map addAnnotation:placemark2];
//    [placemark2 release];
//    
//    CLLocationCoordinate2D coord4 = [self coordinateForDistance:2 fromCoordinate:coord];
//    NSLog(@"Coord %f -- %f", coord4.latitude, coord4.longitude);
//    NVMapAnnotation *placemark4 = [[NVMapAnnotation alloc] initWithCoordinate:coord4];
//    placemark4.title = @"1000 m";
//    placemark4.subtitle = @"Россия, Москва";
//    [self.mapView.map addAnnotation:placemark4];
//    [placemark4 release];
//    
//    CLLocationCoordinate2D coord5 = [self coordinateForDistance:2000 fromCoordinate:coord];
//    
//    NVMapAnnotation *placemark5 = [[NVMapAnnotation alloc] initWithCoordinate:coord5];
//    placemark5.title = @"2000 m";
//    placemark5.subtitle = @"Россия, Москва";
//    [self.mapView.map addAnnotation:placemark5];
//    [placemark5 release];

    // Do any additional setup after loading the view from its nib.
}
///////////////////////
- (CLLocationCoordinate2D)coordinateForDistance:(CLLocationDistance)distance
                                 fromCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKMapPoint point = MKMapPointForCoordinate(coordinate);
    CLLocationDistance metersPerPoint = MKMapPointsPerMeterAtLatitude(coordinate.latitude);
    NSLog(@"P : %f --", metersPerPoint);
    double latPoints = distance * metersPerPoint;
    point.x -= latPoints;
    return MKCoordinateForMapPoint(point);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        CLLocationCoordinate2D coordinate = [self coordinateForDistance:distance.intValue fromCoordinate:userCoordinate];
        NVMapAnnotation *placemark = [[NVMapAnnotation alloc] initWithCoordinate:coordinate];
        placemark.title = [NSString stringWithFormat:@"Distance %@ m", distance];
        [self.mapView.map addAnnotation:placemark];
        [placemark release];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *MyIdentifier = @"CustomAnnotation";
    
    MKAnnotationView *reusable = nil;
    reusable = [mapView  dequeueReusableAnnotationViewWithIdentifier:MyIdentifier];
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)reusable;
    
    if (!pinView)
    {
        MKPinAnnotationView *customPinView
        = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                           reuseIdentifier:MyIdentifier] autorelease];
        
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.draggable = NO;

        customPinView.pinColor = MKPinAnnotationColorGreen;
        return customPinView;
    } else     {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

@end
