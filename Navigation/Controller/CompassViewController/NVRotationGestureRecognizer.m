//
//  NVRotationGestureRecognizer.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/28/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVRotationGestureRecognizer.h"
#import "CGGeometry+IDPExtensions.h"

@interface NVRotationGestureRecognizer ()
@property (nonatomic, assign)   CGPoint pointOfCentre;
@property (nonatomic, assign)   CGFloat innerRadius;
@property (nonatomic, assign)   CGFloat outerRadius;
@property (nonatomic, assign)   CGFloat cumulatedAngle;

@property (nonatomic, retain)   id<NVRotationGestureRecognizerDelegate> target;

- (void)sendStateFailed;
- (void)sendEndRotation;
- (void)sendRotation;
- (void)sendStartRotation;

CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB, CGPoint endLineB);
@end

@implementation NVRotationGestureRecognizer

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.target = nil;
    
    [super dealloc];
}

- (id)initWithPointOfCentre:(CGPoint)pointOfCentre
                innerRadius:(CGFloat)innerRadius
                outerRadius:(CGFloat)outerRadius
                     target:(id)target
{
    self = [super initWithTarget:target action:nil];
    
    if (self) {
        self.target = target;
        self.innerRadius = innerRadius;
        self.outerRadius = outerRadius;
        self.pointOfCentre = pointOfCentre;
    }
    
    return  self;
}

#pragma mark -
#pragma mark UIGestureRecognizer

- (void)reset {
    [super reset];
    
    self.cumulatedAngle = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (1 != [touches count]) {
        self.state = UIGestureRecognizerStateFailed;
        
        return;
    }
    [self sendStartRotation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    if (UIGestureRecognizerStateFailed == self.state) {
        return;
    }
    
    CGPoint nowPoint  = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    CGPoint pointOfCentre = self.pointOfCentre;
    
    CGFloat distance = CGDistance(self.pointOfCentre, nowPoint);
    if (self.innerRadius <= distance && distance <= self.outerRadius) {
        CGFloat angle = angleBetweenLinesInDegrees(pointOfCentre, prevPoint, pointOfCentre, nowPoint);
        
        if (180 < angle) {
            angle -= 360;
        } else if (-180 > angle) {
            angle += 360;
        }
        
        self.cumulatedAngle += angle;

        [self sendRotation];
        
    } else {
        self.state = UIGestureRecognizerStateFailed;
        [self sendStateFailed];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (UIGestureRecognizerStatePossible == self.state) {
        self.state = UIGestureRecognizerStateRecognized;
        
        [self sendEndRotation];
        
    } else {
        self.state = UIGestureRecognizerStateFailed;
        [self sendStateFailed];
    }
    
    self.cumulatedAngle = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
    self.cumulatedAngle = 0;
}

#pragma mark -
#pragma mark Private

- (void)sendStateFailed {
    id target = self.target;
    if ([target respondsToSelector: @selector(gestureRecognizerStateFailed:)]) {
        [target gestureRecognizerStateFailed:self.cumulatedAngle];
    }
}

- (void)sendRotation {
    id target = self.target;
    if ([target respondsToSelector: @selector(rotation:)]) {
        [target rotation:self.cumulatedAngle];
    }
}

- (void)sendEndRotation {
    id target = self.target;
    if ([target respondsToSelector: @selector(endRotation:)]) {
        [target endRotation:self.cumulatedAngle];
    }
}

- (void)sendStartRotation {
    id target = self.target;
    if ([target respondsToSelector: @selector(startRotation)]) {
        [target startRotation];
    }
}

CGFloat angleBetweenLinesInDegrees(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB)
{
    CGFloat a = endLineA.x - beginLineA.x;
    CGFloat b = endLineA.y - beginLineA.y;
    CGFloat c = endLineB.x - beginLineB.x;
    CGFloat d = endLineB.y - beginLineB.y;
    
    CGFloat atanA = atan2(a, b);
    CGFloat atanB = atan2(c, d);

    return (atanA - atanB) * 180 / M_PI;
}

@end
