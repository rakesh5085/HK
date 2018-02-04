//
//  HKAddedPrescriptionCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 05/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKAddedPrescriptionCell.h"

@implementation HKAddedPrescriptionCell

@synthesize prescriptionName,patientNameLabel,doctorNameLabel,removeButton;



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

-(void)configureRemoveButtonOnCell
{
    self.removeButton.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];
    self.removeButton.layer.cornerRadius = 4.0f;
    self.removeButton.layer.borderWidth = 2.0f;
}

- (IBAction)removeButtonClicked:(id)sender
{
    if (self.addedPrescriptionDelegate && [self.addedPrescriptionDelegate conformsToProtocol:@protocol(HKAddedPrescriptionDelegate)])
    {
        if([self.addedPrescriptionDelegate respondsToSelector:@selector(removeButtonTapped:)])
        {
            [self.addedPrescriptionDelegate removeButtonTapped:self];
        }
    }
}


@end
