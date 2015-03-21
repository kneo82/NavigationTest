//
//  NVCompassView.m
//  Compass
//
//  Created by Vitaliy Voronok on 5/2/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompassView.h"
#import "NVCompassControl.h"

@implementation NVCompassView

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
	self.compass = nil;
	
	[super dealloc];
}

@end
