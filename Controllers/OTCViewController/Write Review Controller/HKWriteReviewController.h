//
//  HKWriteReviewController.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 18/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKTestimonialModel.h"

@interface HKWriteReviewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic , strong) HKTestimonialModel *testimonialModel;
@property (nonatomic) NSInteger productId;
@property (weak, nonatomic) NSString *otcMedicineName;
@property (weak, nonatomic) NSString *otcBrandName;
@end
