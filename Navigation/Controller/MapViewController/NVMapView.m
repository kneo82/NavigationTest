//
//  NVMapView.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVMapView.h"

@implementation NVMapView

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.map = nil;
    
    [super dealloc];
}

@end
