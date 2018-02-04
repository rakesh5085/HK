//
//  HKAddressModel.m
//  HealthKart+
//
//  Created by Letsgomo Labs on 23/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKAddressModel.h"

@implementation HKAddressModel

@synthesize altContactNo, city, contactNo, country, deleted, address_id, name, notes, pincode,
selected, state, street1, street2, userId;

-(id) initWithDictionary:(NSDictionary*)addressInfo
{
    if (self = [super init])
    {
        if([addressInfo valueForKey:@"altContactNo"] != (id)[NSNull null] )
            self.altContactNo = [addressInfo valueForKey:@"altContactNo"];
        
        self.city = [addressInfo valueForKey:@"city"];
        self.contactNo = [addressInfo valueForKey:@"contactNo"];
        self.country = [addressInfo valueForKey:@"country"];
        
        if([addressInfo valueForKey:@"deleted"] != (id)[NSNull null] )
            self.deleted = [addressInfo valueForKey:@"deleted"];
        
        self.address_id = [addressInfo valueForKey:@"id"];
        self.name = [addressInfo valueForKey:@"name"];
        
        if([addressInfo valueForKey:@"notes"] != (id)[NSNull null] )
            self.notes = [addressInfo valueForKey:@"notes"];
        
        self.pincode = [addressInfo valueForKey:@"pincode"];
        self.selected = [addressInfo valueForKey:@"selected"];
        self.state = [addressInfo valueForKey:@"state"];
        self.street1 = [addressInfo valueForKey:@"street1"];
        self.street2 = [addressInfo valueForKey:@"street2"];
        self.userId = [addressInfo valueForKey:@"userId"];

    }
    
    return self;
}

@end
