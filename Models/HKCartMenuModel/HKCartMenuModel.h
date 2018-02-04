//
//  HKCartMenuModel.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 09/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKCartMenuModel : NSObject
{
    NSString *cartMenuDrugImageType;
    NSString *cartMenuMedicineName;
    float cartMenuMedicinePrice;
    NSInteger cartMenuMedicineCount;
}
@property (nonatomic , assign) NSInteger cartMenuMedicineId;
@property (nonatomic , strong) NSString *cartMenuDrugImageType;
@property (nonatomic , strong) NSString *cartMenuMedicineName;
@property (nonatomic) float cartMenuMedicinePrice;
@property (nonatomic) float cartMenuMedicineTotalPrice;
@property (nonatomic , assign) NSInteger cartMenuMedicineCount;
@property (nonatomic, strong) NSString *cartMenuSheetType;
@property (nonatomic , strong) NSString *medPForm;

@end
