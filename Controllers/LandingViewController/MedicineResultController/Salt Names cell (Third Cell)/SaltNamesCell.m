//
//  HKSearchMedicineCell.m
//  HealthKart+
//
//  Created by Letsgomo Labs on 31/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "SaltNamesCell.h"

#import "HKGlobal.h"
#import "AFNetworking.h"

@interface SaltNamesCell ()


@property (strong, nonatomic)  UILabel *titleLabel;

@property (strong, nonatomic)  UILabel *saltNamesLabel;

@end

#define kHeightOfTitleLabel 15.0

@implementation SaltNamesCell

@synthesize drugDetailModel = _drugDetailModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withHeightForSaltNamesLabel:(float)h
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // initiallize
        [self addTitleLabel];
        [self addSaltNamesLabelWithHeight:h];
        
        CGRect frame = self.frame;
        
        frame.size.height = 10 + kHeightOfTitleLabel + h;
        
        self.frame = frame;
    }
    return self;
}

-(void)customiseSaltNamesLabelWithString:(NSString *)saltsNames
{
    self.titleLabel.text= @"Salts";
    if(saltsNames.length > 0)
        self.saltNamesLabel.text = saltsNames;
    else
        self.saltNamesLabel.text = @"";
}

-(void) addTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 280.0, kHeightOfTitleLabel)];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
}

-(void) addSaltNamesLabelWithHeight:(float)h
{
    self.saltNamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, 300.0, h)];
    self.saltNamesLabel.numberOfLines = 0;
    self.saltNamesLabel.font = [UIFont systemFontOfSize:13.0];
    self.saltNamesLabel.textColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    [self addSubview:self.saltNamesLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
