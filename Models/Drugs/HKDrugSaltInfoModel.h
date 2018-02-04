//
//  HKDrugSaltInfoModel.h
//  HealthKart+
//
//  Created by Udit Kakkad on 06/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_SALT_ID @"id"
#define KEY_SALT_NAME @"name"
#define KEY_SALT_TC @"tc"
#define KEY_SALT_LC @"lc"
#define KEY_SALT_LB @"lb"
#define KEY_SALT_FD @"fd"
#define KEY_SALT_CI @"ci"
#define KEY_SALT_SE @"se"
#define KEY_SALT_DI @"di"
#define KEY_SALT_MOA @"moa"
#define KEY_SALT_PG @"pg"
#define KEY_SALT_CI_LB @"ci_lb"
#define KEY_SALT_CI_LC @"ci_lc"
#define KEY_SALT_CI_PG @"ci_pg"
#define KEY_SALT_CI_FD @"ci_fd"
#define KEY_SALT_STRENGTH @"strength"
#define KEY_SALT_INDICATIONS @"indications"

@interface HKDrugSaltInfoModel : NSObject

@property (nonatomic, strong) NSString *saltName;
@property (nonatomic, assign) NSInteger saltId;
@property (nonatomic, strong) NSString *tc;
@property (nonatomic, strong) NSString *lc;
@property (nonatomic, strong) NSString *lb;
@property (nonatomic, strong) NSString *fd;
@property (nonatomic, strong) NSString *ci;
@property (nonatomic, strong) NSString *se;
@property (nonatomic, strong) NSString *di;
@property (nonatomic, strong) NSString *moa;
@property (nonatomic, strong) NSString *pg;
@property (nonatomic, strong) NSString *ci_lb;
@property (nonatomic, strong) NSString *ci_lc;
@property (nonatomic, strong) NSString *ci_pg;
@property (nonatomic, strong) NSString *ci_fd;
@property (nonatomic, strong) NSString *strength;
@property (nonatomic, strong) NSString *indications;


-(id) initWithDrugDetailDictionary:(NSDictionary*)drugSaltInfo;


@end
