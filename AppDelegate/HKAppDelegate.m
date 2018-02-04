//
//  HKAppDelegate.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKAppDelegate.h"
#import "HKFirstLaunchNavigationController.h"

#import "HKSignInViewController.h"

#import "GAI.h"

static  NSString *trackerID = @"UA-21820217-15";

// Tracker id is : UA-46303880-1
// rakesh@letsgomo.com
// account name is : HKTracking
// Property (to be tracked) name is : HK+


@implementation HKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
// ***************** GAI tracker ***********************************************************
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 100;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:trackerID];
// *****************************************************************************************
    
    // IF this method gets called that means app was not killed in background
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"launched"];
    
    // on launch of application keep 'isLoggedOutLastTime' bool to no
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launchedz
        
        // Check if login is required, if yes let user log in
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"fileNameCounter"];
        
        self.window.rootViewController =
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
         instantiateViewControllerWithIdentifier:@"FirstLaunchNavigationView"];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
