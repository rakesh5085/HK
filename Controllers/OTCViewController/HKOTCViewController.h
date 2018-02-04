//
//  HKOTCViewController.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 07/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKOTCDrugInfo.h"
#import "HKDrugModel.h"

#import "GAITrackedViewController.h"

@interface HKOTCViewController : GAITrackedViewController

@property (nonatomic, strong) HKDrugModel *drugModel;
@property (nonatomic) IBOutlet UILabel *noImageLabel;
-(IBAction)buyButtonClicked;

@end
