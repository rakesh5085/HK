//
//  HKMyOrderDetailCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 16/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKMyOrderDetailCell.h"

@implementation HKMyOrderDetailCell

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

-(void)loadMedicineImageWithURL : (NSString *)packForm
{
    UIImage *tempImage;
    
    if([packForm isEqualToString:@"Bottle"]) // if feedimage string is not nil
    {
            tempImage = [UIImage imageNamed:@"Syrup"];
        
    }else if([packForm isEqualToString:@"Capsule"])
    {
            tempImage = [UIImage imageNamed:@"Capsule-1"];
        
    }else if([packForm isEqualToString:@"Tube"])
    {

            tempImage = [UIImage imageNamed:@"Tube1.png"];
        
    }else if([packForm isEqualToString:@"Tablet"])
    {

            tempImage = [UIImage imageNamed:@"Tablet"];
        
    }else if([packForm isEqualToString:@"Strip"])
    {

            tempImage = [UIImage imageNamed:@"Tablet"];
        
    }else if([packForm isEqualToString:@"Box"])
    {
            tempImage = [UIImage imageNamed:@"Box"];
        
    }else if([packForm isEqualToString:@"Syrup"])
    {

            tempImage = [UIImage imageNamed:@"Syrup"];
        
    }else if([packForm isEqualToString:@"Aerosol"])
    {

            tempImage = [UIImage imageNamed:@"Aerosol"];
        
    }else if([packForm isEqualToString:@"Device"])
    {

            tempImage = [UIImage imageNamed:@"Device"];
        
    }else if([packForm isEqualToString:@"Drops"])
    {
            tempImage = [UIImage imageNamed:@"Drops"];
        
    }else if([packForm isEqualToString:@"EA"])
    {

            tempImage = [UIImage imageNamed:@"EA"];
        
    }else if([packForm isEqualToString:@"Injection"])
    {
            tempImage = [UIImage imageNamed:@"Injection"];
        
    }

    self.myOrderMedicineImageView.image = tempImage;
    
}


@end
