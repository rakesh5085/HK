//
//  HKOrderModel.m
//  HealthKart+
//
//  Created by Udit Kakkad on 04/12/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKOrderModel.h"
#import "HKOrderItemsModel.h"

@implementation HKOrderModel

-(id) initWithDictionary:(NSDictionary*)orders
{
    if (self = [super init]) {
        
        if([orders valueForKey:KEY_ORDERS_ORDERID] != (id)[NSNull null] )
            self.orderId = [orders valueForKey:KEY_ORDERS_ORDERID];
        
        if([orders valueForKey:KEY_ORDERS_USERID] != (id)[NSNull null] )
            self.userId = [orders valueForKey:KEY_ORDERS_USERID];
        
        if([orders valueForKey:KEY_ORDERS_DOCTOR_NAME] != (id)[NSNull null] )
            self.doctorName = [orders valueForKey:KEY_ORDERS_DOCTOR_NAME];
        
        if([orders valueForKey:KEY_ORDERS_ORDER_ITEMS] != (id)[NSNull null] )
            self.orderitems = [orders valueForKey:KEY_ORDERS_ORDER_ITEMS];
        
        if (self.orderitems && [self.orderitems isKindOfClass:[NSArray class]])
            [self createOrderItemsModels:(NSArray*)self.orderitems];
        
        if([orders valueForKey:KEY_ORDERS_STATUS] != (id)[NSNull null] )
            self.status = [orders valueForKey:KEY_ORDERS_STATUS];
        
        if([orders valueForKey:KEY_ORDERS_ORDER_AMOUNT] != (id)[NSNull null] )
            self.orderAmount = [[orders valueForKey:KEY_ORDERS_ORDER_AMOUNT] floatValue];
        
        if([orders valueForKey:KEY_ORDERS_DISCOUNT] != (id)[NSNull null] )
            self.discount = [[orders valueForKey:KEY_ORDERS_DISCOUNT] floatValue];
        
        if([orders valueForKey:KEY_ORDERS_ADDRESS] != (id)[NSNull null] )
            self.address = [orders valueForKey:KEY_ORDERS_ADDRESS];
        
        if([orders valueForKey:KEY_ORDERS_PHONE_NUMBER] != (id)[NSNull null] )
            self.phoneNumber = [orders valueForKey:KEY_ORDERS_PHONE_NUMBER];
        
        if([orders valueForKey:KEY_ORDERS_PRESCRIPTION_OPTION] != (id)[NSNull null] )
            self.prescription_option = [orders valueForKey:KEY_ORDERS_PRESCRIPTION_OPTION];
        
        if([orders valueForKey:KEY_ORDERS_SHIPPING_AMOUNT] != (id)[NSNull null] )
            self.shippingAmt = [[orders valueForKey:KEY_ORDERS_SHIPPING_AMOUNT] floatValue];
        
        if([orders valueForKey:KEY_ORDERS_TOTAL_AMOUNT] != (id)[NSNull null] )
            self.totalAmt = [[orders valueForKey:KEY_ORDERS_TOTAL_AMOUNT] floatValue];
        
        if([orders valueForKey:KEY_ORDERS_SAVING] != (id)[NSNull null] )
            self.saving = [[orders valueForKey:KEY_ORDERS_SAVING] floatValue];
        
        if([orders valueForKey:KEY_ORDERS_ACTUAL_AMOUNT] != (id)[NSNull null] )
            self.actualAmnt = [[orders valueForKey:KEY_ORDERS_ACTUAL_AMOUNT] floatValue];
        
        if([orders valueForKey:KEY_ORDERS_PATIENT_NAME] != (id)[NSNull null] )
            self.patientName = [orders valueForKey:KEY_ORDERS_PATIENT_NAME];
        
        if([orders valueForKey:KEY_ORDERS_ORDER_DATE] != (id)[NSNull null] )
            self.orderTimeInterval = [[orders valueForKey:KEY_ORDERS_ORDER_DATE] doubleValue];
        
        if([orders valueForKey:KEY_ORDERS_PRESCRIPTION_REQUIRED] != (id)[NSNull null] )
            self.prescriptionReq = [[orders valueForKey:KEY_ORDERS_PRESCRIPTION_REQUIRED] boolValue];
        
        if([orders valueForKey:KEY_ORDERS_REQUESTED_ITEM] != (id)[NSNull null] )
            self.requestedItem = [orders valueForKey:KEY_ORDERS_REQUESTED_ITEM];
        
        if([orders valueForKey:KEY_ORDERS_PARTIAL_CART] != (id)[NSNull null] )
            self.partialCart = [[orders valueForKey:KEY_ORDERS_PARTIAL_CART] boolValue];
        
    }
    
    return self;
}

-(void)createOrderItemsModels:(NSArray*)orderItems
{
    
    NSMutableArray *tempOrderItems = [[NSMutableArray alloc] init];
    
    for (id orderItemsModel in orderItems) {
        if ([orderItemsModel isKindOfClass:[NSDictionary class]]) {
            HKOrderItemsModel *order = [[HKOrderItemsModel alloc] initWithDictionary:orderItemsModel];
            [tempOrderItems addObject:order];
        }
    }
    
    self.myOrderItemsArray = (NSArray*)tempOrderItems;
    
}


@end