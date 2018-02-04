//
//  HKTestimonialModel.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 20/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_OTC_ID @"id"
#define KEY_OTC_PRODUCT_USER_ID @"userId"
#define KEY_OTC_PRODUCT_ID @"otcProductId"
#define KEY_OTC_PRODUCT_DATE @"date"
#define KEY_OTC_PRODUCT_REVIEW @"review"
#define KEY_OTC_PRODUCT_USER_NAME @"userName"
#define KEY_OTC_PRODUCT_RATING @"userRating"
#define KEY_OTC_PRODUCT_USER_RATING_PERCENT @"userRatingPercent"

@interface HKTestimonialModel : NSObject

@property (nonatomic , assign) NSInteger drugId;
@property (nonatomic , assign) NSInteger userId;
@property (nonatomic , assign) NSInteger productId;
@property (nonatomic , assign) long date;
@property (nonatomic , strong) NSString *review;
@property (nonatomic , strong) NSString *userName;
@property (nonatomic , assign) NSInteger userRating;
@property (nonatomic) float userRatingPercent;

-(id) initWithDictionary:(NSDictionary*)otcdrugReview;

@end