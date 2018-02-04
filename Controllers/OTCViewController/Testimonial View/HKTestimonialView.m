//
//  HKTestimonialView.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 20/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKTestimonialView.h"
#import "HKTestimonialModel.h"
#import "HKGlobal.h"

@implementation HKTestimonialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)customiseViewWithModel:(HKTestimonialModel *)objTestimonialModel
{
    // Actual Frame
    // CGRect actualFrame;
    // Adding component
    // Star rating..
    for (UIView* view in [self subviews])
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            UIImageView *imgView = (UIImageView*)view;
            if(imgView.tag > objTestimonialModel.userRating)
                [imgView setImage:[UIImage imageNamed:@"star-grey"]];
            else
                [imgView setImage:[UIImage imageNamed:@"star-selected"]];
        }
    }
    
    // Testimonial title label
//    float height = [HKGlobal heightOfGivenText:objTestimonialModel.testimonialTitleString ofWidth:310.0f andFont:[UIFont systemFontOfSize:12.0f]];
//    NSLog(@"font = %f",height);
//    [self.testimonialTitleLabel setFrame:CGRectMake(self.testimonialTitleLabel.frame.origin.x, self.testimonialTitleLabel.frame.origin.x, 310, height)];
    
    
//    NSString *str = [NSString stringWithFormat:@"Sourabh Shekhar | %@",];
//    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:str];
//    NSInteger _stringLength=[str length];
//    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
//    [attrStr addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 14)];
//    [attrStr addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(18, _stringLength - 18)];
//    [self.usageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    self.usageLabel.attributedText = attrStr;
//    self.usageLabel.frame = frameTemp;
//    self.usageLabel = [HKGlobal adjustHeightOfLabel:self.usageLabel];
}

@end
