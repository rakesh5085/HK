//
//  HKMedicineOptionSegmentCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 01/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKMedicineOptionSegmentCell.h"

@implementation HKMedicineOptionSegmentCell

@synthesize medicineOptionSegmentedControl;

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

- (IBAction)optionSegmentedControlTapped:(id)sender
{
    if (self.medicineOptionSegmentDelegate && [self.medicineOptionSegmentDelegate conformsToProtocol:@protocol(HKMedicineOptionSegmentDelegate)]) {
        if ([self.medicineOptionSegmentDelegate respondsToSelector:@selector(optionSegmentedControlTappedWithSegmentIndex:)]) {
            // TODO: remove the hardcoed value and replace with actual value.
            [self.medicineOptionSegmentDelegate optionSegmentedControlTappedWithSegmentIndex:medicineOptionSegmentedControl.selectedSegmentIndex];
        }
    }
}

@end
