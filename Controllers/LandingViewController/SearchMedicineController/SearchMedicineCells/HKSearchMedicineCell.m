//
//  HKSearchMedicineCell.m
//  HealthKart+
//
//  Created by Letsgomo Labs on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKSearchMedicineCell.h"

#import "HKGlobal.h"
#import "AFNetworking.h"

@interface HKSearchMedicineCell ()

@property (nonatomic, strong) UILabel *medicineNameLabel;
@property (nonatomic, strong) UILabel *numberOfTabletsLabel;
@property (nonatomic, strong) UILabel *manufacturerLabel;
@property (nonatomic, strong) UILabel *priceWithoutDiscountLabel;
@property (nonatomic, strong) UILabel *priceAfterDiscountLabel;
@property (nonatomic, strong) UIImageView *drugImageView;
@property (strong, nonatomic)  UILabel *stockAvailabilityLabel;
@property (strong, nonatomic)  UILabel *strikeLabel;

-(void) addMedicineNameLabel;
-(void) addNumberOfTabletsLabel;
-(void) addManufacturerLabel;
-(void) addPriceWithoutDiscountLabel;
-(void) addStrikeThroughLabel;
-(void) addpriceAfterDiscountLabel;

@end

@implementation HKSearchMedicineCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // initiallize
        [self addMedicineNameLabel];
        [self addNumberOfTabletsLabel];
        [self addManufacturerLabel];
        [self addPriceWithoutDiscountLabel];
    
        [self addpriceAfterDiscountLabel];

        [self addDrugImageView];
        [self addInStockLabel];
        
        
    }
    return self;
}

-(void)prepareForReuse
{
    self.drugModel = nil;
}

-(void) addMedicineNameLabel
{
    self.medicineNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 220.0, 20.0)];
    self.medicineNameLabel.backgroundColor = [UIColor clearColor];
    self.medicineNameLabel.font = [UIFont systemFontOfSize:18.0];
    self.medicineNameLabel.textColor = [UIColor blackColor];
    [self addSubview:self.medicineNameLabel];
}

-(void) addNumberOfTabletsLabel
{
    self.numberOfTabletsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 35.0, 220.0, 15.0)];
    self.numberOfTabletsLabel.font = [UIFont systemFontOfSize:14.0];
    self.numberOfTabletsLabel.textColor = [UIColor blackColor];
    [self addSubview:self.numberOfTabletsLabel];
}

-(void) addManufacturerLabel
{
    self.manufacturerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 55.0, 220.0, 15.0)];
    self.manufacturerLabel.font = [UIFont systemFontOfSize:14.0];
    self.manufacturerLabel.textColor = [UIColor blackColor];
    [self addSubview:self.manufacturerLabel];
}

-(void)addPriceWithoutDiscountLabel
{
    self.priceWithoutDiscountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0, 220.0, 12.0)];
    self.priceWithoutDiscountLabel.font = [UIFont systemFontOfSize:12.0];
    self.priceWithoutDiscountLabel.textColor = [UIColor grayColor];
    [self addSubview:self.priceWithoutDiscountLabel];
    
    [self addStrikeThroughLabel];
    
}

-(void)addStrikeThroughLabel
{
    self.strikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220.0, 12.0)];
    self.strikeLabel.font = [UIFont systemFontOfSize:12.0];
    self.strikeLabel.textColor = [UIColor grayColor];
    self.strikeLabel.text = @"--------";
    [self.priceWithoutDiscountLabel addSubview:self.strikeLabel];
}

-(void)addpriceAfterDiscountLabel
{
    self.priceAfterDiscountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 94.0, 220.0, 15.0)];
    self.priceAfterDiscountLabel.font = [UIFont systemFontOfSize:14.0];
    self.priceAfterDiscountLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:1.0];
    [self addSubview:self.priceAfterDiscountLabel];
}

-(void)addDrugImageView
{
    self.drugImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270.0, 15.0, 30, 30)];
    self.drugImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.drugImageView];
}

-(void)addInStockLabel
{
    self.stockAvailabilityLabel = [[UILabel alloc] initWithFrame:CGRectMake(251, 50.0, 64, 21)];
    self.stockAvailabilityLabel.backgroundColor = [UIColor clearColor];
    self.stockAvailabilityLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:1.0];
    self.stockAvailabilityLabel.text = @" IN STOCK";
    self.stockAvailabilityLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:self.stockAvailabilityLabel];
}

-(NSAttributedString *)stringWithstrikethroughEffect: (NSString *)str
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    // Set font, notice the range is for the whole string
    UIFont *font = [UIFont systemFontOfSize:10.0];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attributedString length])];
    
    // Set strikethrough for partial range
    [attributedString addAttribute:NSStrikethroughStyleAttributeName
                             value:[NSNumber numberWithInt:2]
                             range:NSMakeRange(0, 10)];
    
    return attributedString;
}

#pragma mark - update details of drug
-(void)updateDrugDetails
{
    if(self.drugModel.drugName != nil)
        self.medicineNameLabel.text = self.drugModel.drugName;
    else
        self.medicineNameLabel.text = @"";
    if(self.drugModel.packSize != nil)
    {
        self.numberOfTabletsLabel.text = [NSString stringWithFormat:@"(%@ in a %@)", self.drugModel.packSize, self.drugModel.pForm];
    }
    else
        self.numberOfTabletsLabel.text = @"";
    if(self.drugModel.manufacturer != nil)
        self.manufacturerLabel.text = self.drugModel.manufacturer;
    else
        self.manufacturerLabel.text = @"";
    
    float discountPercentage = ((self.drugModel.mrp - self.drugModel.oPrice)*100)/self.drugModel.mrp;
    
    if(self.drugModel.mrp)
    {
        if (discountPercentage == 0) {
            self.priceWithoutDiscountLabel.text = [NSString stringWithFormat:@"Rs. %.2f",self.drugModel.mrp];
            self.strikeLabel.hidden = YES;
        }
        else{
            self.priceWithoutDiscountLabel.text = [NSString stringWithFormat:@"Rs. %.2f | %g%% off",self.drugModel.mrp , discountPercentage];
            self.strikeLabel.hidden = NO;
        }
    }
    else
        self.priceWithoutDiscountLabel.text = @"";
    if(self.drugModel.oPrice)
        self.priceAfterDiscountLabel.text = [NSString stringWithFormat:@"Rs. %.2f", self.drugModel.oPrice];
    else
        self.priceAfterDiscountLabel.text = @"";
    
    if(self.drugModel.available)
        self.stockAvailabilityLabel.hidden = NO;
    else
        self.stockAvailabilityLabel.hidden = YES;
    
    //Setting imageview to nil to prevent caching of image ; Important
    self.drugImageView.image = [UIImage imageNamed:@"capsule"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImage *tempImage;
        if([self.drugModel.pForm isEqualToString:@"Bottle"]) // if feedimage string is not nil
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Syrup_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Syrup_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Capsule"]) 
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Capsule_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Capsule_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Tube"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Tube_blue1.png"];
            else
                tempImage = [UIImage imageNamed:@"Tube1_grey1.png"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Tablet"])
        {
            if(self.drugModel.available)
                    tempImage = [UIImage imageNamed:@"Tablet_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Tablet_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Strip"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Tablet_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Tablet_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Box"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Box_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Box_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Syrup"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Syrup_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Syrup_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Aerosol"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Aerosol_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Aerosol_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Device"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Device_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Device_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Drops"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Drops_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Drops_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"EA"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"EA_blue1"];
            else
                tempImage = [UIImage imageNamed:@"EA_grey1"];
            
        }else if([self.drugModel.pForm isEqualToString:@"Injection"])
        {
            if(self.drugModel.available)
                tempImage = [UIImage imageNamed:@"Injection_blue1"];
            else
                tempImage = [UIImage imageNamed:@"Injection_grey1"];
            
        }
        // create thumb image of width 300*2 (maintaining aspect ratio)
        UIImage *image_thumb = [HKGlobal imageWithImage:tempImage scaledToWidth:160];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.drugImageView.image = [UIImage imageWithData:UIImageJPEGRepresentation(image_thumb, 1)];
            
            //TODO: in stock image
        });
    });
}

-(void)modifyCellSubviews
{
    // Adding border to stockAvailabilityLabel
    self.stockAvailabilityLabel.layer.cornerRadius = 3.0f;
    self.stockAvailabilityLabel.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];
    self.stockAvailabilityLabel.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
