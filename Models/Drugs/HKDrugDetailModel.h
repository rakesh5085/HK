//
//  HKDrugDetailModel.h
//  HealthKart+
//
//  Created by Udit Kakkad on 01/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_DRUG_ID @"id"
#define KEY_DRUG_CODE @"hkpDrugCode"
#define KEY_DRUG_MFID @"mfId"
#define KEY_DRUG_NAME @"name"
#define KEY_DRUG_TYPE @"type"
#define KEY_DRUG_P_SIZE @"pSize"
#define KEY_DRUG_MF @"mf"
#define KEY_DRUG_UPRICE @"uPrice"
#define KEY_DRUG_OPRICE @"oPrice"
#define KEY_DRUG_MRP @"mrp"
#define KEY_DRUG_SU @"su"
#define KEY_DRUG_FORM @"form"
#define KEY_DRUG_IMAGE_URL @"imgUrl"
#define KEY_DRUG_PFORM @"pForm"
#define KEY_DRUG_AVAILABLE @"available"
#define KEY_DRUG_MC @"mc"
#define KEY_DRUG_SC @"sc"
#define KEY_DRUG_META_INFO @"metaInfo"
#define KEY_DRUG_UIP @"uip"
#define KEY_DRUG_DISCOUNT_PERC @"discountPerc"
#define KEY_DRUG_FAVORITE @"favorite"
#define KEY_DRUG_SALT_INFO @"saltInfo"

@interface HKDrugDetailModel : NSObject

@property (nonatomic, assign) NSInteger drugId;
@property (nonatomic, strong) NSString *drugCode;
@property (nonatomic) float mfId;
@property (nonatomic, strong) NSString *drugName;
@property (nonatomic, strong) NSString *drugType;
@property (nonatomic, strong) NSString *packSize;
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic) float uPrice;
@property (nonatomic) float oPrice;
@property (nonatomic) float mrp;
@property (nonatomic, assign) NSInteger su;
@property (nonatomic, strong) NSString *form;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *pForm;
@property (nonatomic, assign) BOOL available;
@property (nonatomic, strong) NSString *mc;
@property (nonatomic, strong) NSString *sc;
@property (nonatomic, strong) NSString *metaInfo;
@property (nonatomic, assign) NSUInteger uip;
@property (nonatomic) float discountPercentage;
@property (nonatomic, assign) BOOL favorite;
@property (nonatomic, strong) NSArray *saltInfoArray;

-(id) initWithDrugDetailDictionary:(NSDictionary*)drugInfo;

@end
