//
//  NVCompassView.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompassView.h"

#import "IDPPropertyMacros.h"

#import "NSString+NVExtensions.h"
#import "CGGeometry+IDPExtensions.h"

static const double margin = 50.0;
static const double thicksMainLine = 6.0;
static const double fontSize = 16.0;
static const double angleSegments = 6.0;
static const double angleBigSegments = 30.0;
static const double shadowBlur = 10.0;

@interface NVCompassView ()

- (double)radiansFromDegrees:(double)degrees;
- (void)rotateByAngleInDegrees:(CGFloat)angleInDegrees;

- (void)drawShadowEllipseInContext:(CGContextRef)context
                             rect:(CGRect)rect
                  withShadowOfset:(CGSize)shadowOfset
                    andShadowSize:(CGFloat)shadowBlure;

- (void)drawDivisionCompassInContext:(CGContextRef)context
                     centerCoordinat:(CGPoint)centerCoordinat
                              radius:(CGFloat)radius;

- (CGPoint)pointForAngle:(CGFloat)angle
         centerCoordinat:(CGPoint)centerCoordinat
                  radius:(CGFloat)radius;

@end

@implementation NVCompassView

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.angle = 0;
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setAngle:(CGFloat)angle {
    IDPNonatomicAssignPropertySynthesize(_angle, angle);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self rotateByAngleInDegrees:angle];
    });
}
#pragma mark -
#pragma mark View Lifecycle

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, rect);
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    double width = rect.size.width - margin;
    CGContextSetLineWidth(context, thicksMainLine);
    
    CGPoint centerCoordinat = {rect.size.width / 2, rect.size.height / 2};
    double radius = width / 2;
    
    CGPoint startPoint = {centerCoordinat.x - width / 2, centerCoordinat.y - width / 2};
    CGRect circleRect = CGRectMake(startPoint.x, startPoint.y, width, width);
    
    CGSize shadowOffset = CGSizeMake (10,  10);
    [self drawShadowEllipseInContext:context
                                rect:circleRect
                     withShadowOfset:shadowOffset
                       andShadowSize:shadowBlur];
    
    CGRect ellipseRect = CGRectMake (centerCoordinat.x-1.5, centerCoordinat.y-1.5, 3, 3);
    CGContextStrokeEllipseInRect(context, ellipseRect);
    
    CGContextSetLineWidth(context, thicksMainLine / 2.0);
    [self drawDivisionCompassInContext:context centerCoordinat:centerCoordinat radius:radius];
}

#pragma mark -
#pragma mark Public

- (void)rotateViewWithDuration:(CFTimeInterval)duration byAngleInDegrees:(CGFloat)angleInDegrees {
    CGFloat angleInRadians = [self radiansFromDegrees:angleInDegrees];
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:angleInRadians];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = YES;
    
    [CATransaction setCompletionBlock:^{
        self.transform = CGAffineTransformRotate(self.transform, angleInRadians);
    }];
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];
}

#pragma mark -
#pragma mark Private

- (void)rotateByAngleInDegrees:(CGFloat)angleInDegrees {
    CGFloat angleInRadians = [self radiansFromDegrees:angleInDegrees];
    [UIView animateWithDuration:(2/(2*M_PI))*angleInRadians
                     animations:^{
                         self.transform = CGAffineTransformMakeRotation(angleInRadians);
                     }];
}

- (double)radiansFromDegrees:(double)degrees {
    return degrees * (M_PI/180.0);
}

- (CGPoint)pointForAngle:(CGFloat)angle
         centerCoordinat:(CGPoint)centerCoordinat
                  radius:(CGFloat)radius
{
    double x = centerCoordinat.x + radius * cos(angle);
    double y = centerCoordinat.y + radius * sin(angle);
    
    return CGPointMake(x, y);
}

- (void)drawDivisionCompassInContext:(CGContextRef)context
                      centerCoordinat:(CGPoint)centerCoordinat
                               radius:(CGFloat)radius
{
    
    CGContextSaveGState(context);
    for (int i = 0; i < 360 / angleSegments; i++) {
        double lenght = i%5 ? 15 : 30;
        double radians = [self radiansFromDegrees:(6.0 * i)-90];
        
        CGPoint point1 = [self pointForAngle:radians centerCoordinat:centerCoordinat radius:radius];
        
        CGFloat radius2 = radius - lenght;
        CGPoint point2 = [self pointForAngle:radians centerCoordinat:centerCoordinat radius:radius2];
        
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        if (i == 0) CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
        
        CGPoint p[] = {point1,point2};
        CGContextStrokeLineSegments(context, p, 2);
        
        if (!(i%15)) {
            double radiusFontPosition = radius - lenght - fontSize;

            CGPoint coordinateDrawText = [self pointForAngle:radians
                                             centerCoordinat:centerCoordinat
                                                      radius:radiusFontPosition];

            NSString *text = nil;
            switch (i) {
                case 0:
                    text = @"N";
                    break;
                case 15:
                    text = @"E";
                    break;
                case 30:
                    text = @"S";
                    break;
                case 45:
                    text = @"W";
                    break;
            }
            
            [text drawWithBasePoint:coordinateDrawText
                           andAngle:(radians + M_PI/2)
                            andFont:[UIFont boldSystemFontOfSize:fontSize]];
        }
    }
    CGContextRestoreGState(context);
}

- (void)drawShadowEllipseInContext:(CGContextRef)context
                             rect:(CGRect)rect
                  withShadowOfset:(CGSize)shadowOfset
                    andShadowSize:(CGFloat)shadowBlur
{
    CGContextSaveGState(context);
    CGColorRef color = [[UIColor blackColor] CGColor];
    CGContextSetShadowWithColor(context, shadowOfset, shadowBlur, color);
    CGContextFillEllipseInRect(context, rect);
    CGContextRestoreGState(context);
    CGContextStrokeEllipseInRect(context, rect);
}

@end
