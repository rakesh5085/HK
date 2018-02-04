//
//  HKOTCDrugInfo.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 26/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>


#define KEY_OTC_DRUG_ID @"id"
#define KEY_OTC_DRUG_FAMILY_ID @"otcFamilyId"
#define KEY_OTC_DRUG_MRP @"mrp"
#define KEY_OTC_DRUG_OPRICE @"offeredPrice"
#define KEY_OTC_DRUG_IMAGE_URL @"imgUrl"
#define KEY_OTC_DRUG_MF @"mf"
#define KEY_OTC_DRUG_SLUG @"slug"
#define KEY_OTC_DRUG_DESCRIPTION @"desc"
#define KEY_OTC_DRUG_PACK_SIZE @"packSize"
#define KEY_OTC_DRUG_PACK_FORM @"packForm"
#define KEY_OTC_DRUG_NAME @"name"
#define KEY_OTC_DRUG_SELLING_UNIT @"sunit"
#define KEY_OTC_DRUG_UNITS_IN_PACK @"uinpack"
#define KEY_OTC_DRUG_DISCOUNT @"percentSave"
#define KEY_OTC_DRUG_UPRICE @"uPrice"
#define KEY_OTC_DRUG_VOPRICE @"voprice"
#define KEY_OTC_DRUG_VMRP @"vmrp"


@interface HKOTCDrugInfo : NSObject

@property (nonatomic, assign) NSInteger drugId;
@property (nonatomic, assign) NSInteger familyId;
@property (nonatomic) float mrp;
@property (nonatomic) float oPrice;
@property (nonatomic) float discount;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *packSize;
@property (nonatomic, strong) NSString *packForm;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger sellingUnit;
@property (nonatomic, assign) NSInteger uInPack;
@property (nonatomic) float uPrice;
@property (nonatomic) float vendorOfferedPrice;
@property (nonatomic) float vendorMRP;


-(id) initWithDictionary:(NSDictionary*)otcdrugInfo;

@end
