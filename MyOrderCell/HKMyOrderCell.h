//
//  HKMyOrderCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 16/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKOrderModel.h"

@class HKMyOrderCell;

@protocol HKMyOrderViewDelegate <NSObject>

-(void)viewButtonTappedWithSelectedCell:(HKMyOrderCell *)myOrderSelectedCell;

@end


@interface HKMyOrderCell : UITableViewCell

@property (nonatomic, strong) HKOrderModel *orderModel;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *medicine1Label;

@property (weak, nonatomic) IBOutlet UILabel *medicine2Label;

@property (weak, nonatomic) IBOutlet UILabel *medicine3Label;

@property (weak, nonatomic) IBOutlet UIButton *viewButton;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;



@property (assign , nonatomic) id <HKMyOrderViewDelegate> myOrderDeleagte;

-(void)customiseViewButton;

-(void) updateOrderDetails;

- (IBAction)viewButtonClicked:(id)sender;




@end
