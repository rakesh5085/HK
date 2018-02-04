//
//  HKCartMenuCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 23/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCartMenuCell;

@protocol HKCartMenuDelegate <NSObject>

-(void)medicineCountUpdated:(NSInteger )count withSelectedCell:(HKCartMenuCell *)cartMenuCell;
-(void)scrollTableViewRowUpWithSelectedCell;
-(void)scrollTableViewRowDownWithSelectedCell;

@end

@interface HKCartMenuCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cartMenuMedicineImageview;

@property (weak, nonatomic) IBOutlet UILabel *cartMenuMedicineNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *cartmenuMedicineCountTextField;

@property (weak, nonatomic) IBOutlet UILabel *sheetsLabel;

@property (weak, nonatomic) IBOutlet UIButton *cartMenuDownButton;

@property (weak, nonatomic) IBOutlet UIButton *cartMenuUpButton;

@property (weak, nonatomic) IBOutlet UILabel *cartMenuMedicinePriceLabel;

@property (assign , nonatomic) id <HKCartMenuDelegate> cartMenuDelegate;

@property (assign , nonatomic) NSInteger medicineCount;

- (IBAction)updateMedicineCount:(id)sender;

- (IBAction)updateTextFieldCount:(id)sender;


@end
