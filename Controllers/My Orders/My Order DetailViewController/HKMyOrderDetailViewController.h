//
//  HKMyOrderDetailViewController.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 16/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "HKOrderModel.h"

@interface HKMyOrderDetailViewController : UIViewController

@property (nonatomic) id orderItems;

@property (nonatomic) HKOrderModel *orderModel;

@property (nonatomic, strong) NSString *status;

@end
