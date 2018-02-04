//
//  HKAIViewController.h
//  HealthKart+
//
//  Created by Udit Kakkad on 05/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKAIViewController : UIViewController

/**
 * The opacity of the activity background. Defaults to 0.7 (70% opacity).
 */
@property (nonatomic, assign) float backgroundOpacity;
@property (nonatomic, retain) UIActivityIndicatorView *spinnerView;
@property (nonatomic, retain) UILabel *spinnerLabel;

-(id)initToShowOnView:(UIView *)containerView WithSpinnerLabelText:(NSString *)labelText;

-(void)startAnimatingSpinner;

-(void)startAnimatingSpinnerWithMessage:(NSString *)message;

-(void)setTextForAnimatingSpinner:(NSString*)message;

-(void)stopAnimatingSpinner;

-(BOOL)isAnimating;
@end
