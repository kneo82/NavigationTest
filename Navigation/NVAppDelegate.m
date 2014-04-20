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
    
    NVMapViewController *mapController = nil;
    mapController = [NVMapViewController viewControllerWithDefaultNib];
//    mapController.title = @"Map";
    
    NVLocationViewController *locationController = nil;
    locationController = [NVLocationViewController viewControllerWithDefaultNib];
//    locationController.title = @"Location";
    
    NVCompassViewController *compassController = nil;
    compassController = [NVCompassViewController viewControllerWithDefaultNib];
//    compassController.title = @"Compass";
    
    UITabBarController *tabBar = [UITabBarController object];
    NSArray *controllers = [NSArray arrayWithObjects:mapController,
                                                    locationController,
                                                    compassController,
                                                    nil];
    

    tabBar.viewControllers = controllers;

    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
