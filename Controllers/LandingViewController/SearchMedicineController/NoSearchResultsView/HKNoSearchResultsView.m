//
//  HKNoSearchResultsView.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 09/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKNoSearchResultsView.h"

@implementation HKNoSearchResultsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.suggestMedicineButton.layer.cornerRadius = 5.0f;
}


@end
