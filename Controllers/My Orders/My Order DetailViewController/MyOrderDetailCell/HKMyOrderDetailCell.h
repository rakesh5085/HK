//
//  HKMyOrderDetailCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 16/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKMyOrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myOrderMedicineImageView;
@property (weak, nonatomic) IBOutlet UILabel *medicineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSheetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

-(void)loadMedicineImageWithURL : (NSString *)packForm;

@end
