//
//  HKAddressCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 25/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKAddressCell.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 6
#define CHARACTER_LIMIT_CONTACT 10

@implementation HKAddressCell
@synthesize attributeLabel,attributeTextfield;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma  mark - text field delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    if([self.attributeLabel.text isEqualToString:@"City"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    if([self.attributeLabel.text isEqualToString:@"State"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.addressCellDelegate && [self.addressCellDelegate conformsToProtocol:@protocol(HKAddressCellDelegate)])
    {
        if ( [self.addressCellDelegate respondsToSelector:@selector(valueOfCurrentTextfieldAfterEditingWithSelectedCell:)])
        {
            [self.addressCellDelegate valueOfCurrentTextfieldAfterEditingWithSelectedCell:self];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField  // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    if([self.attributeLabel.text isEqualToString:@"Pincode"])
    {
        if ([self.addressCellDelegate respondsToSelector:@selector(getCityAndStateFromEnteredPincode:)]) {
            [self.addressCellDelegate getCityAndStateFromEnteredPincode:textField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self.attributeLabel.text isEqualToString:@"Pincode"])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
    }
    if([self.attributeLabel.text isEqualToString:@"Contact no."])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT_CONTACT));
    }
    return YES;
}
@end
