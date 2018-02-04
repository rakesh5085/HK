//
//  HKDrugSaltInfoModel.m
//  HealthKart+
//
//  Created by Udit Kakkad on 06/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKDrugSaltInfoModel.h"

@implementation HKDrugSaltInfoModel


-(id) initWithDrugDetailDictionary:(NSDictionary*)drugSaltInfo
{
    if (self = [super init])
    {
        if([drugSaltInfo valueForKey:KEY_SALT_ID] != (id)[NSNull null] )
            self.saltId = [[drugSaltInfo valueForKey:KEY_SALT_ID] integerValue];
        
        if([drugSaltInfo valueForKey:KEY_SALT_NAME] != (id)[NSNull null] )
            self.saltName = [drugSaltInfo valueForKey:KEY_SALT_NAME] ;
        
        if([drugSaltInfo valueForKey:KEY_SALT_TC] != (id)[NSNull null] )
            self.tc = [drugSaltInfo valueForKey:KEY_SALT_TC];
        
        self.lc = [drugSaltInfo valueForKey:KEY_SALT_LC];
        
        self.lb = [drugSaltInfo valueForKey:KEY_SALT_LB];
        
        self.fd = [drugSaltInfo valueForKey:KEY_SALT_FD];
        
        self.ci = [drugSaltInfo valueForKey:KEY_SALT_CI];
        
        self.se = [drugSaltInfo valueForKey:KEY_SALT_SE];
        
        self.di = [drugSaltInfo valueForKey:KEY_SALT_DI];
        
        self.moa = [drugSaltInfo valueForKey:KEY_SALT_MOA];
        
        self.pg = [drugSaltInfo valueForKey:KEY_SALT_PG];
        
        self.ci_lb = [drugSaltInfo valueForKey:KEY_SALT_CI_LB];
        
        self.ci_lc = [drugSaltInfo valueForKey:KEY_SALT_CI_LC];
        
        self.ci_pg = [drugSaltInfo valueForKey:KEY_SALT_CI_PG];
        
        self.ci_fd = [drugSaltInfo valueForKey:KEY_SALT_CI_FD];
        
        self.strength = [drugSaltInfo valueForKey:KEY_SALT_STRENGTH];
        
        self.indications = [drugSaltInfo valueForKey:KEY_SALT_INDICATIONS];
        
    }
    return self;
}
@end
