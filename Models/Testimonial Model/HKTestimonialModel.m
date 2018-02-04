//
//  HKTestimonialModel.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 20/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKTestimonialModel.h"

@implementation HKTestimonialModel

-(id) initWithDictionary:(NSDictionary*)otcdrugReview
{
    if (self = [super init]) {
        
        
        if([otcdrugReview valueForKey:KEY_OTC_ID] != (id)[NSNull null] )
            self.drugId = [[otcdrugReview valueForKey:KEY_OTC_ID] integerValue];
        
        if([otcdrugReview valueForKey:KEY_OTC_PRODUCT_USER_ID] != (id)[NSNull null] )
            self.userId = [[otcdrugReview valueForKey:KEY_OTC_PRODUCT_USER_ID] integerValue];
        
        if([otcdrugReview valueForKey:KEY_OTC_PRODUCT_ID] != (id)[NSNull null] )
            self.productId = [[otcdrugReview valueForKey:KEY_OTC_PRODUCT_ID] integerValue];
        
        if([otcdrugReview valueForKey:KEY_OTC_PRODUCT_DATE] != (id)[NSNull null] )
            self.date = [[otcdrugReview valueForKey:KEY_OTC_PRODUCT_DATE]  longValue];
        
        self.review = [otcdrugReview valueForKey:KEY_OTC_PRODUCT_REVIEW];
        
        self.userName = [otcdrugReview valueForKey:KEY_OTC_PRODUCT_USER_NAME];
        
        self.userRating = [[otcdrugReview valueForKey:KEY_OTC_PRODUCT_RATING] integerValue];
        
        self.userRatingPercent = [[otcdrugReview valueForKey:KEY_OTC_PRODUCT_USER_RATING_PERCENT] floatValue];
        
    }
        return self;
        
}

@end
