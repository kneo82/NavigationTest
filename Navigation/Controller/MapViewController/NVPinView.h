//
//  NVPinView.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/22/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <MapKit/MapKit.h>

@class NVMapAnnotation;

@interface NVPinView : MKPinAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation;

@end
