//
//  HKNavigationQuickOrderController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 22/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKNavigationQuickOrderController.h"

@interface HKNavigationQuickOrderController ()

@end

@implementation HKNavigationQuickOrderController

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
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.interactivePopGestureRecognizer.enabled = NO;
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[HKProfileMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileMenuView"];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[HKCartMenuViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CartMenuView"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

@end
