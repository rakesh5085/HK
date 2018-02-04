//
//  HKOTCDrugInfo.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 26/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKOTCDrugInfo.h"

@implementation HKOTCDrugInfo

-(id) initWithDictionary:(NSDictionary*)otcdrugInfo
{
    if (self = [super init]) {
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_ID] != (id)[NSNull null] )
            self.drugId = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_ID] integerValue];
        
        self.familyId = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_FAMILY_ID] integerValue];
        
        self.discount = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_DISCOUNT] floatValue];
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_MRP] != (id)[NSNull null] )
            self.mrp = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_MRP] floatValue];
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_OPRICE] != (id)[NSNull null] )
            self.oPrice = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_OPRICE] floatValue];
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_IMAGE_URL] != (id)[NSNull null] )
            self.imageUrl = [otcdrugInfo valueForKey:KEY_OTC_DRUG_IMAGE_URL];
        
        self.manufacturer = [otcdrugInfo valueForKey:KEY_OTC_DRUG_MF];
        
        self.slug = [otcdrugInfo valueForKey:KEY_OTC_DRUG_SLUG];
        
        self.description = [otcdrugInfo valueForKey:KEY_OTC_DRUG_DESCRIPTION];
        
        self.packSize = [otcdrugInfo valueForKey:KEY_OTC_DRUG_PACK_SIZE];
        
        self.packForm = [otcdrugInfo valueForKey:KEY_OTC_DRUG_PACK_FORM];
        
        self.name = [otcdrugInfo valueForKey:KEY_OTC_DRUG_NAME];
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_SELLING_UNIT] != (id)[NSNull null] )
            self.sellingUnit = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_SELLING_UNIT] integerValue];
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_UNITS_IN_PACK] != (id)[NSNull null] )
            self.uInPack = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_UNITS_IN_PACK] integerValue];
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_UPRICE] != (id)[NSNull null] )
            self.uPrice = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_UPRICE] floatValue];
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_VMRP] != (id) [NSNull null])
            self.vendorMRP = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_VMRP] floatValue];
        
        if([otcdrugInfo valueForKey:KEY_OTC_DRUG_VOPRICE] != (id) [NSNull null])
            self.vendorOfferedPrice = [[otcdrugInfo valueForKey:KEY_OTC_DRUG_VOPRICE] floatValue];

    }
    
    return self;
}

@end
