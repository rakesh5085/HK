//
//  HKSelectPrescriptionCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 28/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKAddedPrescriptionModel.h"

@interface HKSelectPrescriptionCell : UITableViewCell <PrescriptionModelProtocol>


@property (weak, nonatomic) IBOutlet UIImageView *prescriptionImageView;

@property (weak, nonatomic) IBOutlet UILabel *prescriptionNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderedDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectionImageview;

@property (nonatomic, strong) HKAddedPrescriptionModel *prescriptionModel;

// Cusotmize cell
-(void)customizeCell;

@end
