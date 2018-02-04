//
//  HKMyOrderCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 16/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKMyOrderCell.h"

@implementation HKMyOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)customiseViewButton
{
    self.viewButton.layer.cornerRadius = 3.0f;
    self.viewButton.layer.borderWidth = 1.0f;
    self.viewButton.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];
}

- (IBAction)viewButtonClicked:(id)sender
{
    if (self.myOrderDeleagte && [self.myOrderDeleagte conformsToProtocol:@protocol(HKMyOrderViewDelegate)])
    {
        if ([self.myOrderDeleagte respondsToSelector:@selector(viewButtonTappedWithSelectedCell:)])
        {
            [self.myOrderDeleagte viewButtonTappedWithSelectedCell:self];
        }
    }
}

-(void) updateOrderDetails
{
    if(self.orderModel.orderId != nil)
        self.orderNumberLabel.text = [NSString stringWithFormat:@"Order# %@",self.orderModel.orderId];
    else
        self.orderNumberLabel.text = @"";
    
    if(self.orderModel.status != nil)
        self.statusLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.status];
    else
        self.statusLabel.text = @"";
    
    if(self.orderModel.totalAmt)
        self.totalAmountLabel.text = [NSString stringWithFormat:@"%f",self.orderModel.totalAmt];
    else
        self.totalAmountLabel.text = @"";
    
    if([self.orderModel.orderitems count] == 1){
    
    if([self.orderModel.orderitems objectAtIndex:0] != nil){
        self.medicine1Label.text = [NSString stringWithFormat:@"1. %@",[[self.orderModel.orderitems objectAtIndex:0] valueForKey:@"productName"]];
    }else
        self.medicine1Label.text = @"";
        
    self.medicine2Label.text = @"";
    self.medicine3Label.text = @"";
        
    }else if ([self.orderModel.orderitems count] == 2){
        
        if([self.orderModel.orderitems objectAtIndex:0] != nil){
            self.medicine1Label.text = [NSString stringWithFormat:@"1. %@",[[self.orderModel.orderitems objectAtIndex:0] valueForKey:@"productName"]];
        }else
            self.medicine1Label.text = @"";
        
        if([self.orderModel.orderitems objectAtIndex:1] != nil){
            self.medicine2Label.text = [NSString stringWithFormat:@"2. %@",[[self.orderModel.orderitems objectAtIndex:1] valueForKey:@"productName"]];
        }else
            self.medicine2Label.text = @"";
        
        self.medicine3Label.text = @"";
    }else if ([self.orderModel.orderitems count] > 2){
        
        if([self.orderModel.orderitems objectAtIndex:0] != nil){
            self.medicine1Label.text = [NSString stringWithFormat:@"1. %@",[[self.orderModel.orderitems objectAtIndex:0] valueForKey:@"productName"]];
        }else
            self.medicine1Label.text = @"";
        
        if([self.orderModel.orderitems objectAtIndex:1] != nil){
            self.medicine2Label.text = [NSString stringWithFormat:@"2. %@",[[self.orderModel.orderitems objectAtIndex:1] valueForKey:@"productName"]];
        }else
            self.medicine2Label.text = @"";
        
        if([self.orderModel.orderitems objectAtIndex:2] != nil){
            self.medicine3Label.text = [NSString stringWithFormat:@"3. %@",[[self.orderModel.orderitems objectAtIndex:2] valueForKey:@"productName"]];
        }else
            self.medicine3Label.text = @"";
        
    }else{
        self.medicine1Label.text = @"";
        self.medicine2Label.text = @"";
        self.medicine3Label.text = @"";
        
    }
    NSDate * newNow = [NSDate dateWithTimeIntervalSince1970:self.orderModel.orderTimeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yy"];
    NSString *dateString = [formatter stringFromDate:newNow];
    
    
//    NSString *displayString = [NSDate stringForDisplayFromDate:newNow];
    
    self.orderDateLabel.text = [NSString stringWithFormat:@"Ordered On  %@", dateString];
    
}
@end
