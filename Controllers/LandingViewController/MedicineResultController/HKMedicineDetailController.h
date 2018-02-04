//
//  HKMedicineDetailController.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 24/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKDrugModel.h"

#import "CustomBadge.h"

#import "GAITrackedViewController.h"

typedef enum
{
    CHECKOUT_FLOW_ALERTVIEW = 0,
    ERROR_ALERT_VIEW
} AlertViewTags;

@interface HKMedicineDetailController : GAITrackedViewController <UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic, strong) HKDrugModel *drugModel;

@end
