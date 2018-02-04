//
//  HKFirstLaunchViewController.m
//  HealthKart+
//
//  Created by vivek on 02/12/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKFirstLaunchViewController.h"
#import "ECSlidingViewController.h"
#import "HKAppDelegate.h"
#import "HKNavigationLandingController.h"
#import "HKViewController.h"
#import "HKHelpNavigationController.h"
#import "HKHelpViewController.h"

@interface HKFirstLaunchViewController ()

@end

@implementation HKFirstLaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self performSelector:@selector(loadingNextView)
               withObject:nil afterDelay:2.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadingNextView{
 
    HKAppDelegate *appDelegate = (HKAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    HKHelpNavigationController *newTopViewController = (HKHelpNavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpNavigationController"];
    
    HKHelpViewController *viewController = (HKHelpViewController *)[newTopViewController.viewControllers objectAtIndex:0];
    appDelegate.window.rootViewController = viewController;
    
    
//    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
//        CGRect frame = self.slidingViewController.topViewController.view.frame;
//        self.slidingViewController.topViewController = newTopViewController;
//        self.slidingViewController.topViewController.view.frame = frame;
//        [self.slidingViewController resetTopView];
//    }];
    
}

@end
