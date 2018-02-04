//
//  HKAddedPrescriptionCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 05/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKAddedPrescriptionDelegate <NSObject>

-(void)removeButtonTapped:(UITableViewCell *)addedPrescription;

@end

@interface HKAddedPrescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *prescriptionName;

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;


@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

@property (assign, nonatomic) id <HKAddedPrescriptionDelegate> addedPrescriptionDelegate;

-(void)configureRemoveButtonOnCell;


- (IBAction)removeButtonClicked:(id)sender;



@end
