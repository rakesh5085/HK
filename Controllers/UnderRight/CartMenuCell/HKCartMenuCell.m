//
//  HKCartMenuCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 23/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKCartMenuCell.h"

@implementation HKCartMenuCell

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


- (IBAction)updateMedicineCount:(id)sender
{
    [self updateValuesFromDifferentSenders:sender];
}

#pragma mnark - text field delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.cartMenuDelegate && [self.cartMenuDelegate conformsToProtocol:@protocol(HKCartMenuDelegate)])
    {
        if ([self.cartMenuDelegate respondsToSelector:@selector(scrollTableViewRowUpWithSelectedCell)])
        {
            [self.cartMenuDelegate scrollTableViewRowUpWithSelectedCell];
        }
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.cartMenuDelegate && [self.cartMenuDelegate conformsToProtocol:@protocol(HKCartMenuDelegate)])
    {
        if ([self.cartMenuDelegate respondsToSelector:@selector(scrollTableViewRowDownWithSelectedCell)])
        {
            [self.cartMenuDelegate scrollTableViewRowDownWithSelectedCell];
        }
    }
    return YES;
}

- (IBAction)updateTextFieldCount:(id)sender
{
    
    [self updateValuesFromDifferentSenders:sender];
    //[self.cartmenuMedicineCountTextField resignFirstResponder];
}

-(void)updateValuesFromDifferentSenders:(id)sender
{
    self.medicineCount = [self.cartmenuMedicineCountTextField.text integerValue];
    
    if([(UIButton *)sender isEqual:self.cartMenuUpButton])
    {
        self.medicineCount ++;
        self.cartmenuMedicineCountTextField.text = [NSString stringWithFormat:@"%d", (int)self.medicineCount];
    }
    else if([(UIButton *)sender isEqual:self.cartMenuDownButton])
    {
        if(self.medicineCount > 1)
        {
            self.medicineCount --;
            self.cartmenuMedicineCountTextField.text = [NSString stringWithFormat:@"%d", (int)self.medicineCount];
        }
    }
    else
    {
        self.medicineCount = [self.cartmenuMedicineCountTextField.text integerValue];
    }
    
    if (self.cartMenuDelegate && [self.cartMenuDelegate conformsToProtocol:@protocol(HKCartMenuDelegate)])
    {
        if ([self.cartMenuDelegate respondsToSelector:@selector(medicineCountUpdated:withSelectedCell:)])
        {
            [self.cartMenuDelegate medicineCountUpdated:self.medicineCount withSelectedCell:self];
        }
    }
}

@end
