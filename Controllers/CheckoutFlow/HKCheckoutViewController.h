//
//  HKCheckoutViewController.h
//  HealthKart+
//
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

// Usage:

// fetches images from camera or album and pass this image to add prescription controller

#import <UIKit/UIKit.h>

#import "HKGlobal.h"

@interface HKCheckoutViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, GlobalClassProtocol>

@end
