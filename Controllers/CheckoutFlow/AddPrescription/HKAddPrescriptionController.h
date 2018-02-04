//
//  HKAddPrescriptionController.h
//  HealthKart+
//
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

// Usage:
// List prescriptions that user will add (from gallary or from prev list).
// Here the image passed from checkout view controller will be used in a prescription for the first time only

#import <UIKit/UIKit.h>
#import "HKAddedPrescriptionModel.h"
#import "HKSignInViewController.h"

@interface HKAddPrescriptionController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SignInProtocol>


@property (nonatomic, strong) HKAddedPrescriptionModel *selectedPreviousPrescriptionModel;

// This will hold the image passed from checkout view controller
@property (nonatomic , strong) UIImage *passedSelectedPrescriptionImage;

@property (nonatomic, assign) BOOL addressAvailable;

@end
