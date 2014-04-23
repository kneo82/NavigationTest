//
//  NVCompassView.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompassView.h"

#import "NSString+NVExtensions.h"

@implementation NVCompassView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
    CGContextFillRect(context, rect);
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    double width = rect.size.width - 50;
    CGContextSetLineWidth(context, 6.0);
    
    double x = (rect.size.width / 2) - width / 2;
    double y = (rect.size.height / 2) - width / 2;
    CGRect circleRect = CGRectMake(x, y, width, width);
    CGContextStrokeEllipseInRect(context, circleRect);
    CGRect point = CGRectMake ((rect.size.width / 2), (rect.size.height / 2) ,3,3);
    CGContextStrokeEllipseInRect(context, point);
    
    for (int i = 0; i < 360 / 6; i++) {
        double lenght = 0;
        double radians = 0;
        if (i%5) {
            radians = [self radiansFromDegrees:(6.0 * i)-90];
            lenght = 15;
        } else {
            radians = [self radiansFromDegrees:(30.0 * i)-90];
            lenght = 30;
        }
        double x1 = rect.size.width/2 + (width/2) * cos(radians);
        double y1 = rect.size.height/2  + (width/2) * sin(radians);
        double x2 = rect.size.width/2 + ((width/2) - lenght) * cos(radians);
        double y2 = rect.size.height/2  + ((width/2)- lenght) * sin(radians);
        
        CGPoint point1 = {x1, y1};
        CGPoint point2 = {x2, y2};
        
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        if (i == 0) CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
        CGContextSetLineWidth(context, 3.0);
        CGPoint p[] = {point1,point2};
        CGContextStrokeLineSegments(context, p, 2);
        
        if (!(i%15)) {
            double x3 = rect.size.width/2 + ((width/2) - lenght-16) * cos(radians);
            double y3 = rect.size.height/2  + ((width/2)- lenght-16) * sin(radians);
            CGPoint point3 = {x3, y3};
            CGContextSaveGState(context);
            CGContextSetRGBFillColor(context, 255, 0, 0, 1);
            CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
            NSString *str = nil;
            switch (i) {
                case 0:
                    str = @"N";
                    break;
                case 15:
                    str = @"E";
                    break;
                case 30:
                    str = @"S";
                    break;
                case 45:
                    str = @"W";
                    break;
            }
            [str drawWithBasePoint:point3 andAngle:radians+2/M_PI andFont:[UIFont boldSystemFontOfSize:16.0]];
        }
        
    }
    
}

- (double)radiansFromDegrees:(double)degrees {
    return degrees * (M_PI/180.0);
}

@end
