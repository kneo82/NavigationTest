//
//  NVAppDelegate.m
//  Navigation
//
//  Created by Vitaliy Voronok on 4/18/14.
//  Copyright (c) 2014 Vitaliy Voronok. All rights reserved.
//

#import "NVAppDelegate.h"

#import "NVMapViewController.h"
#import "NVLocationViewController.h"
#import "NVCompassViewController.h"

#import "UIWindow+TDExtensions.h"
#import "UIViewController+IDPInitialization.h"
#import "NSObject+IDPExtensions.h"

@interface NVAppDelegate ()

- (UITabBarController *)setupTabBarController;

@end

@implementation NVAppDelegate

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    self.window = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

-           (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [UIWindow window];
    UIWindow *window = self.window;

    window.backgroundColor = [UIColor whiteColor];
    window.rootViewController = [self setupTabBarController];
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark -
#pragma mark Private

- (UITabBarController *)setupTabBarController {
    NVMapViewController *mapController = nil;
    mapController = [NVMapViewController viewControllerWithDefaultNib];
    
    NVLocationViewController *locationController = nil;
    locationController = [NVLocationViewController viewControllerWithDefaultNib];
    
    NVCompassViewController *compassController = nil;
    compassController = [NVCompassViewController viewControllerWithDefaultNib];
    
    UITabBarController *tabBar = [UITabBarController object];
    NSArray *controllers = [NSArray arrayWithObjects:mapController,
                            locationController,
                            compassController,
                            nil];
    
    tabBar.viewControllers = controllers;
    
    return tabBar;
}

@end
