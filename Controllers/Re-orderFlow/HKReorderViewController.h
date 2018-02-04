//
//  HKReorderViewController.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 22/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCustomAlertView.h"
#import "HKAddedPrescriptionModel.h"
#import "HKSignInViewController.h"
#import "HKGlobal.h"

#import "GAITrackedViewController.h"

@protocol HKReorderViewDelegate <NSObject>

-(void)didSelectPreviousAddedPrescription:(HKAddedPrescriptionModel*)prevPrescription;

@end

typedef enum
{
    COMINGFROM_LEFTPANE_MYPRESCRIPTION = 0,
    COMINGFROM_LEFTPANE_REORDER = 1,
    COMINGFROM_CHECKOUT = 2,
    COMINGFROM_MYORDERS = 3,
    COMINGFROM_MY_Addresses = 4
} ComingFromScene;

@interface HKReorderViewController : GAITrackedViewController <UITableViewDataSource,UITableViewDelegate,HKCustomAlertViewDelegate, GlobalClassProtocol , SignInProtocol>
{
    
}

@property (nonatomic, assign) id <HKReorderViewDelegate> reorderDelegate;
@property (nonatomic, assign) ComingFromScene fromScene;

@end
