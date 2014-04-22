//
//  NVLocationView.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVLocationView.h"
#import "IDPPropertyMacros.h"

static NSString * const kAddressKey = @"FormattedAddressLines";

@interface NVLocationView ()

- (void)fillPlacemark;

@end

@implementation NVLocationView

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.coordinate = nil;
    self.address = nil;
    self.placemark = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (void)setPlacemark:(CLPlacemark *)placemark {
    IDPNonatomicRetainPropertySynthesize(_placemark, placemark);
    [self fillPlacemark];
}

#pragma mark -
#pragma mark Private

- (void)fillPlacemark {
    NSArray *addressLine = self.placemark.addressDictionary[kAddressKey];
    NSMutableString *formattedAddress = [NSMutableString string];
    for (NSString *item in addressLine) {
        [formattedAddress appendFormat:@"%@\n", item];
    }
    self.address.text = formattedAddress;
}

@end
