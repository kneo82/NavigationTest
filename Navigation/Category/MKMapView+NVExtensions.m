//
//  MKAnnotationView+NVExtensions.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/19/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "MKMapView+NVExtensions.h"

@implementation MKMapView (NVExtensions)

- (id)dequeuePin:(Class)theClass {
    MKAnnotationView *annotation = nil;
    annotation = [self dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(theClass)];
    
    return annotation;
}

@end