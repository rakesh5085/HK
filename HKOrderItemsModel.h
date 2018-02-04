//
//  HKOrderItemsModel.h
//  HealthKart+
//
//  Created by vivek on 04/12/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_ORDER_ITEM_PRODUCTID @"productId"
#define KEY_ORDER_ITEM_ORDERID @"orderId"
#define KEY_ORDER_ITEM_ORDER_LINEID @"orderLineId"
#define KEY_ORDER_ITEM_PRODUCT_QUANTITY @"productQuantity"
#define KEY_ORDER_ITEM_OFFERED_PRICE @"offeredPrice"
#define KEY_ORDER_ITEM_ACTUAL_PRICE @"actualPrice"
#define KEY_ORDER_ITEM_ITEM_NOTE @"itemNote"
#define KEY_ORDER_ITEM_PRODUCT_NAME @"productName"
#define KEY_ORDER_ITEM_PACK_FORM @"packForm"
#define KEY_ORDER_ITEM_SELLING_UNIT @"sellingUnit"
#define KEY_ORDER_ITEM_UNIT_PRICE @"unitPrice"
#define KEY_ORDER_ITEM_MANUFACTURER_NAME @"manuName"
#define KEY_ORDER_ITEM_VENDOR_PRICE @"vendorPrice"
#define KEY_ORDER_ITEM_VENDOR_STOCK @"vendorStock"
#define KEY_ORDER_ITEM_PSIZE @"pSize"
#define KEY_ORDER_ITEM_PRTYPE @"prtype"
#define KEY_ORDER_ITEM_URL @"url"
#define KEY_ORDER_ITEM_DISCOUNT_PERCENTAGE @"discountPerc"
#define KEY_ORDER_ITEM_STATUS @"status"
#define KEY_ORDER_ITEM_FORM @"form"
#define KEY_ORDER_ITEM_TRIMMED @"trimmed"

@interface HKOrderItemsModel : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderLineId;
@property (nonatomic, strong) NSString *productQuantity;
@property (nonatomic, strong) NSString *offeredPrice;
@property (nonatomic, strong) NSString *actualPrice;
@property (nonatomic, strong) NSString *itemNote;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *packForm;
@property (nonatomic) NSInteger sellingUnit;
@property (nonatomic, strong) NSString *unitPrice;
@property (nonatomic, strong) NSString *manuName;
@property (nonatomic, strong) NSString *vendorPrice;
@property (nonatomic, strong) NSString *vendorStock;
@property (nonatomic, strong) NSString *pSize;
@property (nonatomic, strong) NSString *prtype;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) float discountPerc;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *form;
@property (nonatomic) BOOL trimmed;

-(id) initWithDictionary:(NSDictionary*)orderItems;

@end
