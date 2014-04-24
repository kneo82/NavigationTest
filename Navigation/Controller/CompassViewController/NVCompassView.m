//
//  NVCompassView.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVCompassView.h"

#import "NSString+NVExtensions.h"

static const double margin = 50.0;
static const double thicksMainLine = 6.0;
static const double fontSize = 16.0;
static const double angleSegments = 6.0;
static const double angleBigSegments = 30.0;
static const double shadowSize = 10.0;

@interface NVCompassView ()

- (double)radiansFromDegrees:(double)degrees;

- (void)drawShadowEllipseInContext:(CGContextRef)context
                             rect:(CGRect)rect
                  withShadowOfset:(CGSize)shadowOfset
                    andShadowSize:(CGFloat)shadowSize;

- (void)drawdivisionCompassInContext:(CGContextRef)context
                     centerCoordinat:(CGPoint)centerCoordinat
                              radius:(CGFloat)radius;

@end

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
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, rect);
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    double width = rect.size.width - margin;
    CGContextSetLineWidth(context, thicksMainLine);
    
   
    
    CGPoint centerCoordinat = {rect.size.width / 2, rect.size.height / 2};
    
    
    CGAffineTransform   t   =   CGAffineTransformMakeTranslation(+centerCoordinat.x , +centerCoordinat.y);
    CGAffineTransform   r   =   CGAffineTransformMakeRotation([self radiansFromDegrees:self.angle]);//////////
    CGAffineTransform   t2   =   CGAffineTransformMakeTranslation(-centerCoordinat.x , -centerCoordinat.y);
    CGContextConcatCTM(context, t);
    CGContextConcatCTM(context, r);
    CGContextConcatCTM(context, t2);
    
    
    double radius = width / 2;
    
    CGPoint startPoint = {centerCoordinat.x - width / 2, centerCoordinat.y - width / 2};
    CGRect circleRect = CGRectMake(startPoint.x, startPoint.y, width, width);
    
    CGSize shadowOffset = CGSizeMake (15,  10);
    [self drawShadowEllipseInContext:context
                               rect:circleRect
                    withShadowOfset:shadowOffset
                      andShadowSize:shadowSize];
    
    CGRect ellipseRect = CGRectMake (centerCoordinat.x, centerCoordinat.y, 3, 3);
    CGContextStrokeEllipseInRect(context, ellipseRect);
  
    CGContextSetLineWidth(context, thicksMainLine / 2.0);
    [self drawdivisionCompassInContext:context centerCoordinat:centerCoordinat radius:radius];
    
//    CGContextConcatCTM(context, CGAffineTransformInvert(r));
//    CGContextConcatCTM(context, CGAffineTransformInvert(t));
}

#pragma mark -
#pragma mark Private

- (double)radiansFromDegrees:(double)degrees {
    return degrees * (M_PI/180.0);
}

- (void)drawdivisionCompassInContext:(CGContextRef)context
                      centerCoordinat:(CGPoint)centerCoordinat
                               radius:(CGFloat)radius
{
    
    CGContextSaveGState(context);
    for (int i = 0; i < 360 / angleSegments; i++) {
        double lenght = i%5 ? 15 : 30;
        double radians = [self radiansFromDegrees:(6.0 * i)-90];
        
        double x1 = centerCoordinat.x + radius * cos(radians);
        double y1 = centerCoordinat.y + radius * sin(radians);
        double x2 = centerCoordinat.x + (radius - lenght) * cos(radians);
        double y2 = centerCoordinat.y + (radius - lenght) * sin(radians);
        
        CGPoint point1 = {x1, y1};
        CGPoint point2 = {x2, y2};
        
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        if (i == 0) CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
        
        CGPoint p[] = {point1,point2};
        CGContextStrokeLineSegments(context, p, 2);
        
        if (!(i%15)) {
            double radiusFontPosition = radius - lenght - fontSize;
            double x3 = centerCoordinat.x + radiusFontPosition * cos(radians);
            double y3 = centerCoordinat.y + radiusFontPosition * sin(radians);
            CGPoint coordinateDrawText = {x3, y3};

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
                           andAngle:(radians+M_PI/2)
                            andFont:[UIFont boldSystemFontOfSize:fontSize]];
        }
    }
    CGContextRestoreGState(context);
}

- (void)drawShadowEllipseInContext:(CGContextRef)context
                             rect:(CGRect)rect
                  withShadowOfset:(CGSize)shadowOfset
                    andShadowSize:(CGFloat)shadowSize
{
    CGContextSaveGState(context);
    CGContextSetShadow (context, shadowOfset, shadowSize);
    CGContextFillEllipseInRect(context, rect);
    CGContextRestoreGState(context);
    CGContextStrokeEllipseInRect(context, rect);
}

@end
