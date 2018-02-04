//
//  HKAddressViewController.h
//  HealthKart+
//
//  Created by Rakesh Jogi on 25/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKAddressCell.h"
#import "HKReorderViewController.h"
#import "HKSelectAddressController.h"

@protocol NewAddressProtocol <NSObject>

-(void)newAddressAdded;

@end

@class HKSelectAddressController;

@interface HKAddressViewController : UIViewController <HKAddressCellDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) ComingFromSceneAddressEnum fromScene;

//@property (assign, nonatomic) id <NewAddressProtocol> newAddressDelegate;


@end
