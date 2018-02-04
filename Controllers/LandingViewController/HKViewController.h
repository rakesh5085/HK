//
//  HKViewController.h
//  HealthKart+
//
//  Created by Rakesh jogi on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"

#import "GAITrackedViewController.h"

typedef enum
{
    COMINGFROM_LEFT_PANE = 0,
    COMINGFROM_MIDDLE_CHECKOUT_CONFIRMATION_CHECKOUT = 1,
} ComingFromSceneFirstViewEnum;


#import "HKSignUpViewController.h"

@interface HKViewController : GAITrackedViewController <UISearchBarDelegate>

@property (nonatomic, assign) ComingFromSceneFirstViewEnum fromScene;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISearchBar *landingSearchBar;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

// ButtonViews
@property (weak, nonatomic) IBOutlet UIView *firstButtonView;

@property (weak, nonatomic) IBOutlet UIView *secondButtonView;
@property (weak, nonatomic) IBOutlet UIView *thirdButtonView;


@end
