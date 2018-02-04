//
//  HKMyOrderViewController.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 16/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyOrderCell.h"
#import "HKSignInViewController.h"

#import "HKGlobal.h"

@interface HKMyOrderViewController : UIViewController <HKMyOrderViewDelegate , SignInProtocol, GlobalClassProtocol>

@end
