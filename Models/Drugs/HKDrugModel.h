//
//  HKDrugModel.h
//  HealthKart+
//
//  Created by Letsgomo Labs on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_DRUG_ID @"id"
#define KEY_DRUG_CODE @"hkpDrugCode"
#define KEY_DRUG_MFID @"mfId"
#define KEY_DRUG_LABEL @"label"
#define KEY_DRUG_NAME @"name"
#define KEY_DRUG_TYPE @"type"
#define KEY_DRUG_PACK_SIZE @"packSize"
#define KEY_DRUG_MANUFACTURER @"manufacturer"
#define KEY_DRUG_UPRICE @"uPrice"
#define KEY_DRUG_OPRICE @"oPrice"
#define KEY_DRUG_MRP @"mrp"
#define KEY_DRUG_SU @"su"
#define KEY_DRUG_SLUG @"slug"
#define KEY_DRUG_PACK_FORM @"packForm"
#define KEY_DRUG_FORM @"form"
#define KEY_DRUG_IMAGE_URL @"imgUrl"
#define KEY_DRUG_PFORM @"pForm"
#define KEY_DRUG_AVAILABLE @"available"


@interface HKDrugModel : NSObject

@property (nonatomic, assign) NSInteger drugId;
@property (nonatomic, strong) NSString *drugCode;
@property (nonatomic) float mfId;
@property (nonatomic, strong) NSString *drugLabel;
@property (nonatomic, strong) NSString *drugName;
@property (nonatomic, strong) NSString *drugType;
@property (nonatomic, strong) NSString *packSize;
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic) float uPrice;
@property (nonatomic) float oPrice;
@property (nonatomic) float mrp;
@property (nonatomic, assign) NSInteger su;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *packForm;
@property (nonatomic, strong) NSString *form;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *pForm;
@property (nonatomic, assign) BOOL available;

-(id) initWithDictionary:(NSDictionary*)drugInfo;
-(id) initWithSubstituteDictionary:(NSDictionary*)drugInfo;

@end


