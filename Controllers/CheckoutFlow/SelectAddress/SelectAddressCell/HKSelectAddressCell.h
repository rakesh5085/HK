//
//  HKSelectAddressCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 25/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKAddressModel.h"

@interface HKSelectAddressCell : UITableViewCell


@property (nonatomic, strong) HKAddressModel *addressModel;

@property (weak, nonatomic) IBOutlet UILabel *addressName;
@property (weak, nonatomic) IBOutlet UILabel *street1;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pincodeLabel;

-(void)customiseCellView;


-(void)configureAddressCell;

@end
