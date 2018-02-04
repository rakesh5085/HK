//
//  HKProfileMenuCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 22/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKProfileMenuCell.h"

@implementation HKProfileMenuCell
@synthesize profileMenuImage,profileMenuLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
