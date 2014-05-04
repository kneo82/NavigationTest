//
//  NVMapAnnotation.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/19/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NVMapAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign)   CLLocationCoordinate2D  coordinate;
@property (nonatomic, copy)     NSString                *title;
@property (nonatomic, copy)     NSString                *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithDistance:(CLLocationDistance)distance
			   degrees:(CLLocationDegrees)degrees
		fromCoordinate:(CLLocationCoordinate2D)coordinate;

@end
