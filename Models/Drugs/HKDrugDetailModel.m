//
//  HKDrugDetailModel.m
//  HealthKart+
//
//  Created by Udit Kakkad on 01/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKDrugDetailModel.h"
#import "HKDrugSaltInfoModel.h"

@implementation HKDrugDetailModel

-(id) initWithDrugDetailDictionary:(NSDictionary*)drugInfo
{
    if (self = [super init]) {
        if([drugInfo valueForKey:KEY_DRUG_ID] != (id)[NSNull null] )
            self.drugId = [[drugInfo valueForKey:KEY_DRUG_ID] integerValue];
        
        self.drugCode = [drugInfo valueForKey:KEY_DRUG_CODE];
        
        if([drugInfo valueForKey:KEY_DRUG_MFID] != (id)[NSNull null] )
            self.mfId = [[drugInfo valueForKey:KEY_DRUG_MFID] floatValue];
        
        self.drugName = [drugInfo valueForKey:KEY_DRUG_NAME];
        
        self.drugType = [drugInfo valueForKey:KEY_DRUG_TYPE];
        
        self.packSize = [drugInfo valueForKey:KEY_DRUG_P_SIZE];
        
        self.manufacturer = [drugInfo valueForKey:KEY_DRUG_MF];
        
        if([drugInfo valueForKey:KEY_DRUG_UPRICE] != (id)[NSNull null] )
            self.uPrice = [[drugInfo valueForKey:KEY_DRUG_UPRICE] floatValue];
        
        if([drugInfo valueForKey:KEY_DRUG_OPRICE] != (id)[NSNull null] )
            self.oPrice = [[drugInfo valueForKey:KEY_DRUG_OPRICE] floatValue];
        
        if([drugInfo valueForKey:KEY_DRUG_SU] != (id)[NSNull null] )
            self.su = [[drugInfo valueForKey:KEY_DRUG_SU] integerValue];
        
        if([drugInfo valueForKey:KEY_DRUG_MRP] != (id)[NSNull null] )
            self.mrp = [[drugInfo valueForKey:KEY_DRUG_MRP] floatValue];
        
        self.form = [drugInfo valueForKey:KEY_DRUG_FORM];
        
        self.imageUrl = [drugInfo valueForKey:KEY_DRUG_IMAGE_URL];
        
        self.pForm = [drugInfo valueForKey:KEY_DRUG_PFORM];
        
        if([drugInfo valueForKey:KEY_DRUG_AVAILABLE] != (id)[NSNull null] )
            self.available = [[drugInfo valueForKey:KEY_DRUG_AVAILABLE] boolValue];
        
        self.mc = [drugInfo valueForKey:KEY_DRUG_MC];
        
        self.sc = [drugInfo valueForKey:KEY_DRUG_SC];
        
        self.metaInfo = [drugInfo valueForKey:KEY_DRUG_META_INFO];
        
        if([drugInfo valueForKey:KEY_DRUG_UIP] != (id)[NSNull null] )
            self.uip = [[drugInfo valueForKey:KEY_DRUG_UIP] integerValue];
        
        if([drugInfo valueForKey:KEY_DRUG_DISCOUNT_PERC] != (id)[NSNull null] )
            self.discountPercentage = [[drugInfo valueForKey:KEY_DRUG_DISCOUNT_PERC] floatValue];
        
        if([drugInfo valueForKey:KEY_DRUG_FAVORITE] != (id)[NSNull null] )
            self.favorite = [[drugInfo valueForKey:KEY_DRUG_FAVORITE] boolValue];
        
        if([drugInfo valueForKey:KEY_DRUG_SALT_INFO]!= (id)[NSNull null])
        {
            NSArray *tempArray = [drugInfo valueForKey:KEY_DRUG_SALT_INFO];
            
            NSMutableArray *tempMutableArray = [NSMutableArray array];
            for (id tempDict in tempArray)
            {
                if ([tempDict isKindOfClass:[NSDictionary class]]) {
                    HKDrugSaltInfoModel *saltInfoModel = [[HKDrugSaltInfoModel alloc] initWithDrugDetailDictionary:(NSDictionary*)tempDict];
                    // Adding the saltInfoModel object in temporary array
                    [tempMutableArray addObject:saltInfoModel];
                }
            }
            // Assigning to self array
            self.saltInfoArray = tempMutableArray;
        }
    }
    
    return self;
}

@end
