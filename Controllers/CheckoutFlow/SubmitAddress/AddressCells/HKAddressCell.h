//
//  HKAddressCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 25/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKAddressCell;

@protocol HKAddressCellDelegate <NSObject>

-(void)valueOfCurrentTextfieldAfterEditingWithSelectedCell:(HKAddressCell *)selectedAddressCell;
-(void)getCityAndStateFromEnteredPincode:(NSString*)pincode;

@end

@interface HKAddressCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *attributeLabel;

@property (weak, nonatomic) IBOutlet UITextField *attributeTextfield;

@property(assign, nonatomic) id<HKAddressCellDelegate> addressCellDelegate;

@end
