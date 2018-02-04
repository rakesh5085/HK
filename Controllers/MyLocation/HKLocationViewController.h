//
//  HKLocationViewController.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 29/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAITrackedViewController.h"

@interface HKLocationViewController : GAITrackedViewController <UIAlertViewDelegate,UITextFieldDelegate>

@property (assign, nonatomic) BOOL isComingFromProductDetailScreen;

@end
