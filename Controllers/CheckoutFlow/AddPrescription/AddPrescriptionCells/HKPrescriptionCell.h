//
//  HKPrescriptionCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 24/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKPrescriptionCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *patientNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *doctorNameTextField;




@end
