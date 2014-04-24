//
//  NVCompass.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/24/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompass.h"

@implementation NVCompass

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)awakeFromNib {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.compassView.angle = 10.0;
//        [self.compassView setNeedsDisplay];
//        sleep(5);
//        self.compassView.angle = 50.0;
//        [self.compassView setNeedsDisplay];
//        sleep(5);
//        self.compassView.angle = 180.0;
//        [self.compassView setNeedsDisplay];
//    });
    
//    CGRect rect = self.compassView.bounds;
//    float degrees = 45.0;
//    float radians = (degrees/180.0) * M_PI;
//    [self.compassView setNeedsDisplay];
//    [UIView animateWithDuration:1.25
//                     animations:^{
//                         self.compassView.bounds = rect;
//                         self.compassView.transform = CGAffineTransformMakeRotation(radians);
//                     }
//                     completion:^(BOOL finished){
//                         
//                         [UIView animateWithDuration:1.25
//                                          animations:^{
//                                              self.compassView.bounds = rect;
//                                              self.compassView.transform = CGAffineTransformIdentity;
//                                          }];
//                         
//                     }];
}

@end
