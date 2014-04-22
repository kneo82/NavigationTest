//
//  NVLocationView.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NVLocationView : UIView
@property (nonatomic, retain)   IBOutlet UILabel    *coordinate;
@property (nonatomic, retain)   IBOutlet UILabel    *address;
@property (nonatomic, retain)   CLPlacemark         *placemark;

@end
