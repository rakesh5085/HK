//
//  HKDrugModel.m
//  HealthKart+
//
//  Created by Letsgomo Labs on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKDrugModel.h"

@implementation HKDrugModel

-(id) initWithDictionary:(NSDictionary*)drugInfo
{
    if (self = [super init]) {
        if([drugInfo valueForKey:KEY_DRUG_ID] != (id)[NSNull null] )
            self.drugId = [[drugInfo valueForKey:KEY_DRUG_ID] integerValue];
        if([drugInfo valueForKey:KEY_DRUG_CODE] != (id)[NSNull null] )
            self.drugCode = [drugInfo valueForKey:KEY_DRUG_CODE];
        if([drugInfo valueForKey:KEY_DRUG_MFID] != (id)[NSNull null] )
            self.mfId = [[drugInfo valueForKey:KEY_DRUG_MFID] floatValue];
        if([drugInfo valueForKey:KEY_DRUG_LABEL] != (id)[NSNull null] )
            self.drugLabel = [drugInfo valueForKey:KEY_DRUG_LABEL];
        if([drugInfo valueForKey:KEY_DRUG_NAME] != (id)[NSNull null] )
            self.drugName = [drugInfo valueForKey:KEY_DRUG_NAME];
        if([drugInfo valueForKey:KEY_DRUG_TYPE] != (id)[NSNull null] )
            self.drugType = [drugInfo valueForKey:KEY_DRUG_TYPE];
        if([drugInfo valueForKey:KEY_DRUG_PACK_SIZE] != (id)[NSNull null] )
            self.packSize = [drugInfo valueForKey:KEY_DRUG_PACK_SIZE];
        if([drugInfo valueForKey:KEY_DRUG_MANUFACTURER] != (id)[NSNull null] )
            self.manufacturer = [drugInfo valueForKey:KEY_DRUG_MANUFACTURER];
        if([drugInfo valueForKey:KEY_DRUG_UPRICE] != (id)[NSNull null] )
            self.uPrice = [[drugInfo valueForKey:KEY_DRUG_UPRICE] floatValue];
        if([drugInfo valueForKey:KEY_DRUG_OPRICE] != (id)[NSNull null] )
            self.oPrice = [[drugInfo valueForKey:KEY_DRUG_OPRICE] floatValue];
        if([drugInfo valueForKey:KEY_DRUG_SU] != (id)[NSNull null] )
            self.su = [[drugInfo valueForKey:KEY_DRUG_SU] integerValue];
        if([drugInfo valueForKey:KEY_DRUG_MRP] != (id)[NSNull null] )
            self.mrp = [[drugInfo valueForKey:KEY_DRUG_MRP] floatValue];
        if([drugInfo valueForKey:KEY_DRUG_SLUG] != (id)[NSNull null] )
            self.slug = [drugInfo valueForKey:KEY_DRUG_SLUG];
        if([drugInfo valueForKey:KEY_DRUG_PACK_FORM] != (id)[NSNull null] )
            self.packForm = [drugInfo valueForKey:KEY_DRUG_PACK_FORM];
        if([drugInfo valueForKey:KEY_DRUG_FORM] != (id)[NSNull null] )
            self.form = [drugInfo valueForKey:KEY_DRUG_FORM];
        if([drugInfo valueForKey:KEY_DRUG_IMAGE_URL] != (id)[NSNull null] )
            self.imageUrl = [drugInfo valueForKey:KEY_DRUG_IMAGE_URL];
        if([drugInfo valueForKey:KEY_DRUG_PFORM] != (id)[NSNull null] )
            self.pForm = [drugInfo valueForKey:KEY_DRUG_PFORM];
        if([drugInfo valueForKey:KEY_DRUG_AVAILABLE] != (id)[NSNull null] )
            self.available = [[drugInfo valueForKey:KEY_DRUG_AVAILABLE] boolValue];
    }
    
    return self;
}

-(id) initWithSubstituteDictionary:(NSDictionary*)drugInfo
{
    if (self = [super init]) {
        if([drugInfo valueForKey:KEY_DRUG_ID] != (id)[NSNull null] )
            self.drugId = [[drugInfo valueForKey:KEY_DRUG_ID] integerValue];
        if([drugInfo valueForKey:KEY_DRUG_MFID] != (id)[NSNull null] )
            self.mfId = [[drugInfo valueForKey:KEY_DRUG_MFID] floatValue];
        if([drugInfo valueForKey:KEY_DRUG_LABEL] != (id)[NSNull null] )
            self.drugLabel = [drugInfo valueForKey:KEY_DRUG_LABEL];
        if([drugInfo valueForKey:KEY_DRUG_NAME] != (id)[NSNull null] )
            self.drugName = [drugInfo valueForKey:KEY_DRUG_NAME];
        if([drugInfo valueForKey:@"pSize"] != (id)[NSNull null] )
            self.packSize = [drugInfo valueForKey:@"pSize"];
        if([drugInfo valueForKey:@"mf"] != (id)[NSNull null] )
            self.manufacturer = [drugInfo valueForKey:@"mf"];
        if([drugInfo valueForKey:KEY_DRUG_UPRICE] != (id)[NSNull null] )
            self.uPrice = [[drugInfo valueForKey:KEY_DRUG_UPRICE] floatValue];
        if([drugInfo valueForKey:KEY_DRUG_OPRICE] != (id)[NSNull null] )
            self.oPrice = [[drugInfo valueForKey:KEY_DRUG_OPRICE] floatValue];
        if([drugInfo valueForKey:KEY_DRUG_MRP] != (id)[NSNull null] )
            self.mrp = [[drugInfo valueForKey:KEY_DRUG_MRP] floatValue];
        if([drugInfo valueForKey:KEY_DRUG_FORM] != (id)[NSNull null] )
            self.form = [drugInfo valueForKey:KEY_DRUG_FORM];
        if([drugInfo valueForKey:KEY_DRUG_PFORM] != (id)[NSNull null] )
            self.pForm = [drugInfo valueForKey:KEY_DRUG_PFORM];
        if([drugInfo valueForKey:KEY_DRUG_AVAILABLE] != (id)[NSNull null] )
            self.available = [[drugInfo valueForKey:KEY_DRUG_AVAILABLE] boolValue];
    }
    
    return self;
}

/*
 mc: "M",
 sc: "M",
 save: -180,
 favorite: false
 }
 */


@end
