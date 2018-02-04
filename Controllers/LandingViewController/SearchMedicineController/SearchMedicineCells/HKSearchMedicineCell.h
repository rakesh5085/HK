//
//  HKSearchMedicineCell.h
//  HealthKart+
//
//  Created by Letsgomo Labs on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKDrugModel.h"

@interface HKSearchMedicineCell : UITableViewCell

@property (nonatomic, strong) HKDrugModel *drugModel;

-(void) updateDrugDetails;
-(void)modifyCellSubviews;


@end
