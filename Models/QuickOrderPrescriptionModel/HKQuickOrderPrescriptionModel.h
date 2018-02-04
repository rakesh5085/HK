//
//  HKQuickOrderPrescriptionModel.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKQuickOrderPrescriptionModel : NSObject
{
    UIImage *prescriptionImage;
    NSString *prescriptionName;
}

@property (nonatomic,strong) UIImage *prescriptionImage;
@property (nonatomic,strong) NSString *prescriptionName;

@end
