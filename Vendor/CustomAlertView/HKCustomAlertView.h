//
//  HKCustomAlertView.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 07/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKCustomAlertViewDelegate<NSObject>

@optional
- (void)customDialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface HKCustomAlertView : UIView <HKCustomAlertViewDelegate>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog

@property (nonatomic, assign) id<HKCustomAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;

@property (copy) void (^onButtonTouchUpInside)(HKCustomAlertView *alertView, int buttonIndex) ;

- (id)initWithParentView: (UIView *)_parentView;
- (id)init;

- (void)show;
- (void)close;

- (IBAction)customDialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(HKCustomAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;


@end
