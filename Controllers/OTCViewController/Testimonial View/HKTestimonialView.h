//
//  HKTestimonialView.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 20/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKTestimonialModel;

@interface HKTestimonialView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *firstImageview;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageview;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageview;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageview;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImageview;

@property (weak, nonatomic) IBOutlet UILabel *testimonialLabel;

-(void)customiseViewWithModel:(HKTestimonialModel *)objTestimonialModel;

@end
