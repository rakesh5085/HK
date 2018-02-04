//
//  HKAddressModel.h
//  HealthKart+
//
//  Created by Letsgomo Labs on 23/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

/*
 {
 altContactNo = 7838234557;
 city = Gurgaon;
 contactNo = 7838234557;
 country = INDIA;
 deleted = "<null>";
 id = 3359;
 name = ddd;
 notes = "<null>";
 pincode = 122001;
 selected = 1;
 state = Haryana;
 street1 = gsgsgsg;
 street2 = hsshsh;
 userId = "test123@test123.com";
 }

 */

#import <Foundation/Foundation.h>

@interface HKAddressModel : NSObject

@property (nonatomic , strong) NSString *altContactNo;
@property (nonatomic , strong) NSString *city;
@property (nonatomic , strong) NSString *contactNo;
@property (nonatomic , strong) NSString *country;
@property (nonatomic , strong) NSString *deleted;
@property (nonatomic , strong) NSString *address_id;

@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSString *notes;
@property (nonatomic , strong) NSString *pincode;
@property (nonatomic , strong) NSString *selected;
@property (nonatomic , strong) NSString *state;
@property (nonatomic , strong) NSString *street1;
@property (nonatomic , strong) NSString *street2;
@property (nonatomic , strong) NSString *userId;

-(id) initWithDictionary:(NSDictionary*)addressInfo;

@end
