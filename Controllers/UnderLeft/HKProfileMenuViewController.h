//
//  HKProfileMenuViewController.h
//  HealthKart+
//  rakesh kumar 
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

#import "HKProfileMenuViewController.h"

@interface HKProfileMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate >

-(void)updateLoginHeader;

@end
