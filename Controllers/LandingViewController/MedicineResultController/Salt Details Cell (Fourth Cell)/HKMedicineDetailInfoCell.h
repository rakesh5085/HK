//
//  HKMedicineDetailInfoCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 01/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKDrugSaltInfoModel.h"

@interface HKMedicineDetailInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *saltNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondDescriptiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *usageLabel;

@property (weak, nonatomic) IBOutlet UILabel *sideEffectsLabel;

@property (weak, nonatomic) IBOutlet UILabel *drugInteractionLabel;

@property (weak, nonatomic) IBOutlet UILabel *moaLabel;

@property (nonatomic, strong) NSArray *heightOfLabelsArray;

-(void)customiseLabels:(HKDrugSaltInfoModel *)saltInfoModel  WithHeights:(NSArray *)heightsArray;


@end
