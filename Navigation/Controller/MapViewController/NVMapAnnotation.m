//
//  NVMapAnnotation.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/19/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVMapAnnotation.h"

@interface NVMapAnnotation ()


@end

@implementation NVMapAnnotation

#pragma mark -
#pragma mark Initializations and Deallocations

//-(void) dealloc {
//    self.title = nil;
//    self.subtitle = nil;
//	[super dealloc];
//}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	self = [super init];
	self.coordinate=coordinate;
	return self;
}

@end
