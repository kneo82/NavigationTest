//
//  NVRotationGestureRecognizer.h
//  Navigation
//
//  Created by Vitaliy Voronok on 4/28/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@protocol NVRotationGestureRecognizerDelegate <NSObject>

@optional

- (void)rotation:(CGFloat)angle;
- (void)finalAngle:(CGFloat)angle;
- (void)gestureRecognizerStateFailed:(CGFloat)angle;

@end

@interface NVRotationGestureRecognizer : UIGestureRecognizer

- (id)initWithPointOfCentre:(CGPoint)pointOfCentre
                innerRadius:(CGFloat)innerRadius
                outerRadius:(CGFloat)outerRadius
                     target:(id)target;

- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
