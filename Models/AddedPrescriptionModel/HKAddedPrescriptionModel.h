//
//  HKAddedPrescriptionModel.h
//  HealthKart+
//
//  Created by Rakesh jogi on 05/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PrescriptionModelProtocol <NSObject>

-(void)didDownloadPrescriptionImage:(UIImage*)image;

@end

@interface HKAddedPrescriptionModel : NSObject

@property (nonatomic , strong)  NSString *patientName;
@property (nonatomic , strong) NSString *doctorsName;
@property (nonatomic , strong) NSString *prescriptionName;
@property (nonatomic , strong) UIImage *prescriptionImage;
@property (nonatomic , strong) NSData *prescriptionImageData;

@property (nonatomic , strong) NSString *prescription_id;
@property (nonatomic , strong) NSString *uploadedDate;

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) id <PrescriptionModelProtocol> prescriptionDelegate;

-(id)initWithDictionary: (NSDictionary *)dictPrescriptions;
-(id)initWithDictionaryForMyPrescriptions: (NSDictionary *)dictPrescriptions;

@end
