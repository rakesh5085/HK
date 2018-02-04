//
//  HKPrescriptionCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 24/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKPrescriptionCell.h"

@implementation HKPrescriptionCell

@synthesize patientNameTextField,doctorNameTextField;

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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
@end
