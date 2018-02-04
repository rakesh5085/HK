//
//  HKSelectPrescriptionCell.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 28/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//
// TODO: proper use of todo

#import "HKSelectPrescriptionCell.h"

@implementation HKSelectPrescriptionCell

@synthesize prescriptionImageView,prescriptionNumberLabel,doctorNameLabel,patientNameLabel,orderedDateLabel,selectionImageview;


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
    //self.selectionImageview.image = [UIImage imageNamed:@"check"];
}

-(void)prepareForReuse
{
    self.prescriptionModel = nil;
    self.prescriptionModel.prescriptionDelegate = nil;
}

-(void)customizeCell
{
    // TODO:  image of prescription and order label value pending..
    self.patientNameLabel.text = self.prescriptionModel.patientName;
    self.doctorNameLabel.text = self.prescriptionModel.doctorsName;
    self.prescriptionNumberLabel.text = self.prescriptionModel.prescriptionName;
    self.prescriptionImageView.image = self.prescriptionModel.prescriptionImage;
}

-(void)didDownloadPrescriptionImage:(UIImage *)image
{
    self.prescriptionImageView.image = image;
}

@end
