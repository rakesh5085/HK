//
//  HKOrderModel.h
//  HealthKart+
//
//  Created by Udit Kakkad on 04/12/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_ORDERS_ORDERID @"orderId"
#define KEY_ORDERS_USERID @"userId"
#define KEY_ORDERS_DOCTOR_NAME @"doctorName"
#define KEY_ORDERS_ORDER_ITEMS @"orderItems"
#define KEY_ORDERS_STATUS @"status"
#define KEY_ORDERS_ORDER_AMOUNT @"orderAmount"
#define KEY_ORDERS_DISCOUNT @"discount"
#define KEY_ORDERS_ADDRESS @"address"
#define KEY_ORDERS_PHONE_NUMBER @"phoneNumber"
#define KEY_ORDERS_PRESCRIPTION_OPTION @"prescription_option"
#define KEY_ORDERS_SHIPPING_AMOUNT @"shippingAmt"
#define KEY_ORDERS_TOTAL_AMOUNT @"totalAmt"
#define KEY_ORDERS_SAVING @"saving"
#define KEY_ORDERS_ACTUAL_AMOUNT @"actualAmnt"
#define KEY_ORDERS_PATIENT_NAME @"patientName"
#define KEY_ORDERS_ORDER_DATE @"orderDate"
#define KEY_ORDERS_PRESCRIPTION_REQUIRED @"prescriptionReq"
#define KEY_ORDERS_REQUESTED_ITEM @"requestedItem"
#define KEY_ORDERS_PARTIAL_CART @"partialCart"

@interface HKOrderModel : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *doctorName;
@property (nonatomic) id orderitems;
@property (nonatomic, strong) NSString *status;
@property (nonatomic) float orderAmount;
@property (nonatomic) float discount;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *prescription_option;
@property (nonatomic) float shippingAmt;
@property (nonatomic) float totalAmt;
@property (nonatomic) float saving;
@property (nonatomic) float actualAmnt;
@property (nonatomic, strong) NSString *patientName;
@property (nonatomic) NSTimeInterval orderTimeInterval;
@property (nonatomic) BOOL prescriptionReq;
@property (nonatomic) NSString *requestedItem;
@property (nonatomic) BOOL partialCart;

@property (nonatomic, strong) NSArray *myOrderItemsArray;

-(id) initWithDictionary:(NSDictionary*)orders;

@end