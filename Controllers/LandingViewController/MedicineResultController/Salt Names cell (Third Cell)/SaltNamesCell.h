//
//  HKSearchMedicineCell.h
//  HealthKart+
//
//  Created by Letsgomo Labs on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKDrugDetailModel.h"

#import "HKDrugSaltInfoModel.h"

@interface SaltNamesCell : UITableViewCell

@property (nonatomic,strong) HKDrugDetailModel *drugDetailModel;

-(void)customiseSaltNamesLabelWithString:(NSString *)saltsNames;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeightForSaltNamesLabel:(float)h;

@end
