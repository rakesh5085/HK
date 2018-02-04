//
//  HKSelectAddressController.h
//  HealthKart+
//
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

// Usage : to show list of all addresses

#import <UIKit/UIKit.h>
#import "HKSignInViewController.h"

//#import "HKAddressViewController.h"

typedef enum
{
    COMINGFROM_LEFTPANE_MY_ADDRESSES = 0,
    COMINGFROM_CHECKOUT_FLOW = 1,
}ComingFromSceneAddressEnum;

@class  HKAddressViewController;

@interface HKSelectAddressController : UIViewController<UITableViewDataSource, UITableViewDelegate , SignInProtocol>

@property (nonatomic, strong) NSMutableArray *addressArray;

@property (assign, nonatomic) ComingFromSceneAddressEnum fromScene;

@end
