//
//  HKSelectAddressCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 25/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKSelectAddressCell.h"

@implementation HKSelectAddressCell

@synthesize addressModel  = _addressModel;

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

-(void)customiseCellView
{
//    self.contentView.layer.cornerRadius = 7.0f;
//    self.contentView.layer.borderColor = [[UIColor grayColor] CGColor];
//    self.contentView.layer.borderWidth = 2.0f;
}

-(void)configureAddressCell
{
    _addressName.text = _addressModel.name;
    _street1.text = _addressModel.street1;
    _cityLabel.text = _addressModel.city;
    _stateLabel.text = _addressModel.state;
    _pincodeLabel.text = _addressModel.pincode;
}

@end
