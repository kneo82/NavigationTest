//
//  NVPinView.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/22/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVPinView.h"
#import "IDPPropertyMacros.h"

@implementation NVPinView

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
    return [self initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([self class])];
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.animatesDrop = YES;
        self.canShowCallout = YES;
        self.draggable = NO;
        
        self.pinColor = MKPinAnnotationColorGreen;
    }
    
    return self;
}

@end
