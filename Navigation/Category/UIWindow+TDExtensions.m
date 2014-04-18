//
//  UIWindow+TDExtensions.m
//  TableData
//
//  Created by Vitaliy Voronok on 4/2/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "UIWindow+TDExtensions.h"

@implementation UIWindow (TDExtensions)

+ (id)window {
    return [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
}

@end
