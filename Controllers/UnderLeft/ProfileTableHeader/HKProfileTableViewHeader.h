//
//  HKProfileTableViewHeader.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSignInViewController.h"

@interface HKProfileTableViewHeader : UIView 

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *tableEmailField;

-(void)setProfileHeader;

@end
