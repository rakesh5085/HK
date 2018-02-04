//
//  HKInitialSlidingViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKInitialSlidingViewController.h"

@interface HKInitialSlidingViewController ()
 
@end

@implementation HKInitialSlidingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 //
- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    self.shouldAdjustChildViewHeightForStatusBar = YES;
   // self.statusBarBackgroundView.backgroundColor = [UIColor blackColor];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
    
    // Write and register the notifications to handle the key board resign activity on left or right slide
    //ECSlidingViewUnderRightWillAppear  notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderLeftSlide:) name:ECSlidingViewUnderLeftWillAppear object:nil];
    //ECSlidingViewUnderRightWillAppear  notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderRightSlide:) name:ECSlidingViewUnderRightWillAppear object:nil];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - slide left notifications
-(void)sliderLeftSlide : (NSNotification *)notification
{
    if([[notification name] isEqualToString:ECSlidingViewUnderLeftWillAppear])
    {
        [self.view endEditing:YES];
    }
}
-(void)sliderRightSlide : (NSNotification *)notification
{
    if([[notification name] isEqualToString:ECSlidingViewUnderRightWillAppear])
    {
        [self.view endEditing:YES];
    }
}

@end
