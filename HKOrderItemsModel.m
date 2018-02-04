//
//  HKOrderItemsModel.m
//  HealthKart+
//
//  Created by vivek on 04/12/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKOrderItemsModel.h"

@implementation HKOrderItemsModel

-(id) initWithDictionary:(NSDictionary*)orderItems
{
    if (self = [super init]) {
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_PRODUCTID] != (id)[NSNull null] )
            self.productId = [orderItems valueForKey:KEY_ORDER_ITEM_PRODUCTID];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_ORDERID] != (id)[NSNull null] )
            self.orderId = [orderItems valueForKey:KEY_ORDER_ITEM_ORDERID];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_ORDER_LINEID] != (id)[NSNull null] )
            self.orderLineId = [orderItems valueForKey:KEY_ORDER_ITEM_ORDER_LINEID];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_PRODUCT_QUANTITY] != (id)[NSNull null] )
            self.productQuantity = [orderItems valueForKey:KEY_ORDER_ITEM_PRODUCT_QUANTITY];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_OFFERED_PRICE] != (id)[NSNull null] )
            self.offeredPrice = [orderItems valueForKey:KEY_ORDER_ITEM_OFFERED_PRICE];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_ACTUAL_PRICE] != (id)[NSNull null] )
            self.actualPrice = [orderItems valueForKey:KEY_ORDER_ITEM_ACTUAL_PRICE];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_ITEM_NOTE] != (id)[NSNull null] )
            self.itemNote = [orderItems valueForKey:KEY_ORDER_ITEM_ITEM_NOTE];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_PRODUCT_NAME] != (id)[NSNull null] )
            self.productName = [orderItems valueForKey:KEY_ORDER_ITEM_PRODUCT_NAME];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_PACK_FORM] != (id)[NSNull null] )
            self.packForm = [orderItems valueForKey:KEY_ORDER_ITEM_PACK_FORM];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_SELLING_UNIT] != (id)[NSNull null] )
            self.sellingUnit = [[orderItems valueForKey:KEY_ORDER_ITEM_SELLING_UNIT] integerValue];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_UNIT_PRICE] != (id)[NSNull null] )
            self.unitPrice = [orderItems valueForKey:KEY_ORDER_ITEM_UNIT_PRICE];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_MANUFACTURER_NAME] != (id)[NSNull null] )
            self.manuName = [orderItems valueForKey:KEY_ORDER_ITEM_MANUFACTURER_NAME];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_VENDOR_PRICE] != (id)[NSNull null] )
            self.vendorPrice = [orderItems valueForKey:KEY_ORDER_ITEM_VENDOR_PRICE];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_VENDOR_STOCK] != (id)[NSNull null] )
            self.vendorStock = [orderItems valueForKey:KEY_ORDER_ITEM_VENDOR_STOCK];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_PSIZE] != (id)[NSNull null] )
            self.pSize = [orderItems valueForKey:KEY_ORDER_ITEM_PSIZE];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_PRTYPE] != (id)[NSNull null] )
            self.prtype = [orderItems valueForKey:KEY_ORDER_ITEM_PRTYPE];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_URL] != (id)[NSNull null] )
            self.url = [orderItems valueForKey:KEY_ORDER_ITEM_URL];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_DISCOUNT_PERCENTAGE] != (id)[NSNull null] )
            self.discountPerc = [[orderItems valueForKey:KEY_ORDER_ITEM_DISCOUNT_PERCENTAGE] floatValue];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_STATUS] != (id)[NSNull null] )
            self.status = [orderItems valueForKey:KEY_ORDER_ITEM_STATUS];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_FORM] != (id)[NSNull null] )
            self.form = [orderItems valueForKey:KEY_ORDER_ITEM_FORM];
        
        if([orderItems valueForKey:KEY_ORDER_ITEM_TRIMMED] != (id)[NSNull null] )
            self.trimmed = [[orderItems valueForKey:KEY_ORDER_ITEM_TRIMMED] boolValue];
        
    }
    
    return self;
}


@end
