//
//  HKMedicineDetailViewCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKMedicineDetailViewCell.h"


@interface HKMedicineDetailViewCell ()

@property (nonatomic) NSInteger quantityOfDrug;

@end

@implementation HKMedicineDetailViewCell

@synthesize medicineBasePriceLabel,medicineBrandLabel,medicineFinalPriceLabel,medicineImageView,medicineNameLabel;
@synthesize numberOfMedicineInSheetLabel,numberOfMedicineTextField;
@synthesize downArrowButton,upArrowButton,totalMedicineLabel,sheetsLabel;
@synthesize buyButton,stockAvailabilityLabel;

@synthesize quantityOfDrug;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //quantityOfDrug = 1;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}
-(void)modifyCellSubviews
{
    self.stockAvailabilityLabel.layer.cornerRadius = 3.0f;
    self.stockAvailabilityLabel.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];
    self.stockAvailabilityLabel.layer.borderWidth = 1.0f;
    
    //Making rounded corners of buyButton
    self.buyButton.layer.cornerRadius = 3.0f;
}

-(void)updateCellData
{
    if (self.stockAvailability)
    {
        self.stockAvailabilityLabel.font = [UIFont systemFontOfSize:12.0];
        self.stockAvailabilityLabel.text = @"IN STOCK";
        self.stockAvailabilityLabel.textColor = [UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0];
        [self modifyCellSubviews ];
        self.stockAvailabilityLabel.frame = CGRectMake(251.0, 62.0, 64.0, 21.0);
        self.buyButton.hidden = NO;
    }
    else
    {
        self.stockAvailabilityLabel.font = [UIFont systemFontOfSize:11.0];
        self.stockAvailabilityLabel.text = @"Not Available";
        self.stockAvailabilityLabel.textColor = [UIColor grayColor];
        self.stockAvailabilityLabel.layer.borderColor = [[UIColor grayColor] CGColor];
        self.stockAvailabilityLabel.frame = CGRectMake(240, 62.0, 75.0, 21.0);
        self.buyButton.hidden = YES;
    }
    
//    if(self.cellMedicineCount > 0)
//        self.downArrowButton.hidden = NO;
//    else
//       self.downArrowButton.hidden = YES;
    
    [self loadMedicineImage];
}

-(void)loadMedicineImage
{
    if([self.medPForm isEqualToString:@"Bottle"]) // if feedimage string is not nil
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Syrup_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Syrup_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Capsule"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Capsule_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Capsule_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Tube"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Tube_blue1.png"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Tube_grey1.png"];
        
    }else if([self.medPForm isEqualToString:@"Tablet"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Tablet_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Tablet_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Strip"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Tablet_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Tablet_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Box"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Box_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Box_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Syrup"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Syrup_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Syrup_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Aerosol"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Aerosol_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Aerosol_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Device"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Device_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Device_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Drops"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Drops_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Drops_grey1"];
        
    }else if([self.medPForm isEqualToString:@"EA"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"EA_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"EA_grey1"];
        
    }else if([self.medPForm isEqualToString:@"Injection"])
    {
        if(self.stockAvailability)
            self.medicineImageView.image = [UIImage imageNamed:@"Injection_blue1"];
        else
            self.medicineImageView.image = [UIImage imageNamed:@"Injection_grey1"];
        
    }
    
    
   // self.medicineImageView.image = [UIImage imageNamed:@""];
}

- (IBAction)didTapBuyButton:(id)sender
{
    if (self.medicineDetailDelegate && [self.medicineDetailDelegate conformsToProtocol:@protocol(HKMedicineDetailDelegate)]) {
        if ([self.medicineDetailDelegate respondsToSelector:@selector(buyButtonTappedWithMedicineCount:)]) {
            [self.medicineDetailDelegate buyButtonTappedWithMedicineCount:quantityOfDrug];
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"comes here");
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    id sender = (UITextField *)self.numberOfMedicineTextField;
    self.numberOfMedicineTextField.text = string;
    [self updateCountFromDifferentSendersInDetailViewCell:sender];
    

    
    return YES;
}
#pragma mark - increase/decrease quantity

-(IBAction)increaseOrDecreaseNumberOfSheets:(id)sender
{
    [self updateCountFromDifferentSendersInDetailViewCell:sender];

}

-(void)updateCountFromDifferentSendersInDetailViewCell:(id)sender
{
    self.cellMedicineCount = [self.numberOfMedicineTextField.text integerValue];
    
    
    if([(UIButton *)sender isEqual:upArrowButton])
    {
        self.cellMedicineCount ++;
        numberOfMedicineTextField.text = [NSString stringWithFormat:@"%d", (int)self.cellMedicineCount];
    }
    else if([(UIButton *)sender isEqual:downArrowButton])
    {
        if(self.cellMedicineCount > 1)
        {
            self.cellMedicineCount--;
            numberOfMedicineTextField.text = [NSString stringWithFormat:@"%d", (int)self.cellMedicineCount];
        }
    }
    else
    {
        self.cellMedicineCount = [self.numberOfMedicineTextField.text integerValue];
        
    }
    if (self.medicineDetailDelegate && [self.medicineDetailDelegate conformsToProtocol:@protocol(HKMedicineDetailDelegate)])
    {
        if ([self.medicineDetailDelegate respondsToSelector:@selector(drugCountUpdated:)])
        {
            [self.medicineDetailDelegate drugCountUpdated:self.cellMedicineCount];
        }
    }
    
    if(self.cellMedicineCount >= 2)
        self.downArrowButton.hidden = NO;
    else
        self.downArrowButton.hidden = YES;
}



@end
