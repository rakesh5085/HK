//
//  HKMedicineDetailViewCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//
// 
// First cell in the details view controller of medicine

#import <UIKit/UIKit.h>

#import "HKDrugDetailModel.h"

@protocol HKMedicineDetailDelegate <NSObject>

-(void)buyButtonTappedWithMedicineCount:(NSUInteger)noOfMedicines;

-(void)drugCountUpdated:(NSInteger)quantity;

@end

@interface HKMedicineDetailViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) BOOL stockAvailability;
@property (nonatomic , strong) NSString *medPForm;
@property (weak, nonatomic) IBOutlet UILabel *medicineNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfMedicineInSheetLabel;

@property (weak, nonatomic) IBOutlet UILabel *medicineBrandLabel;

@property (weak, nonatomic) IBOutlet UITextField *numberOfMedicineTextField;

@property (weak, nonatomic) IBOutlet UIButton *downArrowButton;

@property (weak, nonatomic) IBOutlet UIButton *upArrowButton;

@property (weak, nonatomic) IBOutlet UILabel *sheetsLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMedicineLabel;

@property (weak, nonatomic) IBOutlet UILabel *medicineBasePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *medicineFinalPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *medicineImageView;

@property (weak, nonatomic) IBOutlet UILabel *stockAvailabilityLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UILabel *strikeLabel;

@property (assign, nonatomic) id <HKMedicineDetailDelegate> medicineDetailDelegate;

@property (nonatomic , assign) NSInteger cellMedicineCount;

-(void)modifyCellSubviews;
-(void)updateCellData ;

- (IBAction)didTapBuyButton:(id)sender;

-(IBAction)increaseOrDecreaseNumberOfSheets:(id)sender;







@end
