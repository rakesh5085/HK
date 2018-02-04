//
//  HKSignInViewController.h
//  HealthKart+
//
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

#import "GAITrackedViewController.h"

@protocol SignInProtocol <NSObject>

@required
-(void)userHasSignedInSuccessfully;

@end

@interface HKSignInViewController : GAITrackedViewController <UIAlertViewDelegate>

@property (nonatomic, assign) id <SignInProtocol> signInDelegate;

@end
