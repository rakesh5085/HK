//
//  HKMedicineDetailInfoCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 01/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKMedicineDetailInfoCell.h"

#import "HKGlobal.h"

@implementation HKMedicineDetailInfoCell
{
    CGRect frameTemp;
}

@synthesize heightOfLabelsArray;

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


-(void)customiseLabels:(HKDrugSaltInfoModel *)saltInfoModel WithHeights:(NSArray *)heightsArray
{
    
//    NSLog(@"heights array : %@", heightsArray);
    
    UIColor *_black=[UIColor blackColor];
    UIColor *_lightGray = [UIColor lightGrayColor];
    //Helvetica Neue
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    
    float h1 = [[heightsArray objectAtIndex:0] floatValue];
    
    frameTemp = self.saltNameLabel.frame;
    frameTemp.origin.y = 10;
    frameTemp.size.height = h1+5;
    self.saltNameLabel.frame = frameTemp;
    self.saltNameLabel.text = [NSString stringWithFormat:@"%@ %@",saltInfoModel.saltName,saltInfoModel.strength];
    [self.saltNameLabel setBackgroundColor:[UIColor clearColor]];
    
    
    frameTemp.origin.y += h1+10;
    
    float h2 = [[heightsArray objectAtIndex:1] floatValue];
    frameTemp.size.height = h2;
    self.secondDescriptiveLabel.frame = frameTemp;
    self.secondDescriptiveLabel.text = [NSString stringWithFormat:@"Pregnancy:%@ Lactation:%@ Lab:%@ Food:%@",saltInfoModel.ci_pg,saltInfoModel.ci_lc,saltInfoModel.ci_lb,saltInfoModel.ci_fd];
    [self.secondDescriptiveLabel setBackgroundColor:[UIColor clearColor]];
    
    frameTemp.origin.y += h2+10;
    
    float h3 = [[heightsArray objectAtIndex:2] floatValue];
    frameTemp.size.height = h3;
    self.usageLabel.frame = frameTemp;
    
    // Usage Label
    NSString *str = [NSString stringWithFormat:@"Typical Usage: %@",saltInfoModel.lc];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSInteger _stringLength=[str length];
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 14)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(15, _stringLength-15)];
    self.usageLabel.attributedText = attrStr;
    
    frameTemp.origin.y += h3+10;
    
    float h4 = [[heightsArray objectAtIndex:3] floatValue];
    frameTemp.size.height = h4;
    self.sideEffectsLabel.frame = frameTemp;
    
    // Side Effects label
    NSString *sideEffectsString = [NSString stringWithFormat:@"Side Effects: %@",saltInfoModel.se];
    NSMutableAttributedString* attrSideEffectsStr = [[NSMutableAttributedString alloc] initWithString:sideEffectsString];
    NSInteger _strLenSideEffects = [sideEffectsString length];
    [attrSideEffectsStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _strLenSideEffects)];
    [attrSideEffectsStr addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 14)];
    [attrSideEffectsStr addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(14, _strLenSideEffects-14)];
    self.sideEffectsLabel.attributedText = attrSideEffectsStr;
    
    
    frameTemp.origin.y += h4+10;
    
    float h5 = [[heightsArray objectAtIndex:4] floatValue];
    frameTemp.size.height = h5;
    self.drugInteractionLabel.frame = frameTemp;
    
    // Drug Interaction Label
    NSString *drugInteractionString = [NSString stringWithFormat:@"Drug Interaction: %@",saltInfoModel.di];
    NSMutableAttributedString* attrdrugInteractionStr = [[NSMutableAttributedString alloc] initWithString:drugInteractionString];
    NSInteger _strLenDrugInteraction = [drugInteractionString length];
    [attrdrugInteractionStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _strLenDrugInteraction)];
    [attrdrugInteractionStr addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 18)];
    [attrdrugInteractionStr addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(18, _strLenDrugInteraction-18)];
    self.drugInteractionLabel.attributedText = attrdrugInteractionStr;
    
    frameTemp.origin.y += h5+10;
    
    float h6 = [[heightsArray objectAtIndex:5] floatValue];
    frameTemp.size.height = h6;
    self.moaLabel.frame = frameTemp;
    
    // MechanismOfAction Label
    NSString *moaString = [NSString stringWithFormat:@"Mechanism Of Action: %@",saltInfoModel.moa];
    NSMutableAttributedString* attrMoaStr = [[NSMutableAttributedString alloc] initWithString:moaString];
    NSInteger _strLenMoa=[moaString length];
    [attrMoaStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _strLenMoa)];
    [attrMoaStr addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 21)];
    [attrMoaStr addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(21, _strLenMoa-21)];
    self.moaLabel.attributedText = attrMoaStr;
    
//    NSLog(@"height of cell : %f", frameTemp.origin.y + self.moaLabel.frame.size.height);
    
}
@end
