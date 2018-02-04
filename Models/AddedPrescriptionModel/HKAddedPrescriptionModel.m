

//
//  HKAddedPrescriptionModel.m
//  HealthKart+
//
//  Created by Rakesh Jogi on 05/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKAddedPrescriptionModel.h"
#import "AFNetworking.h"

@implementation HKAddedPrescriptionModel

-(id)initWithDictionary: (NSDictionary *)dictPrescriptions
{
    if (self = [super init])
    {
        if([dictPrescriptions objectForKey:@"patientName"] != (id)[NSNull null])
            self.patientName = [dictPrescriptions objectForKey:@"patientName"];
        if([dictPrescriptions objectForKey:@"docName"] != (id)[NSNull null])
            self.doctorsName = [dictPrescriptions objectForKey:@"docName"];
        if([dictPrescriptions objectForKey:@"fileName"] != (id)[NSNull null])
            self.prescriptionName = [dictPrescriptions objectForKey:@"fileName"];
        if([dictPrescriptions objectForKey:@"filepath"] != (id)[NSNull null])
            self.filePath = [dictPrescriptions objectForKey:@"filepath"];
        
        if([dictPrescriptions objectForKey:@"id"] != (id)[NSNull null])
            self.prescription_id = [dictPrescriptions objectForKey:@"id"];
        
//        [self performSelectorInBackground:@selector(getImageForPrescription:) withObject:self.prescription_id];
        [self getImageForPrescription:self.prescription_id];
    }
    return self;
}

-(id)initWithDictionaryForMyPrescriptions: (NSDictionary *)dictPrescriptions
{
    if (self = [super init])
    {
        if([dictPrescriptions objectForKey:@"patientName"] != (id)[NSNull null])
            self.patientName = [dictPrescriptions objectForKey:@"patientName"];
        if([dictPrescriptions objectForKey:@"docName"] != (id)[NSNull null])
            self.doctorsName = [dictPrescriptions objectForKey:@"docName"];
        if([dictPrescriptions objectForKey:@"prescriptionFile"] != (id)[NSNull null])
            self.prescriptionName = [dictPrescriptions objectForKey:@"prescriptionFile"];
        
        if([dictPrescriptions objectForKey:@"cpId"] != (id)[NSNull null])
            self.prescription_id = [dictPrescriptions objectForKey:@"cpId"];
        
        [self getImageForPrescription:self.prescription_id];
    }
    return self;
}


-(void)getImageForPrescription:(NSString*)prescriptionId
{
    NSString *selectPrescriptionUrl = [NSString stringWithFormat:@"http://staging.healthkartplus.com/admin/webservices/prescription/download/%@", prescriptionId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Cookie added inernally in the method , manually
    [manager GET:selectPrescriptionUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         id result = [responseObject valueForKey:@"result"];
         
         if (result && [result isKindOfClass:[NSString class]])
         {
             [self downloadImageForUrlString:(NSString *)result];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         // TODO: handle error case appropriately
     }];
}

-(void)downloadImageForUrlString:(NSString*)urlString
{
//    self.prescriptionImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    
    if (self.prescriptionImageData)//Checking feedImageData availabilty if present then prevent downloading
    {
        self.prescriptionImage = [UIImage imageWithData:self.prescriptionImageData];
    }
    else //Downloading image and setting it to imageView
    {
        //Setting imageview to nil to prevent caching of image ; Important
        self.prescriptionImage = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if(urlString != nil) // if feedimage string is not nil
            {
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                
                self.prescriptionImage=nil;
                self.prescriptionImageData = imageData;
                self.prescriptionImage = [UIImage imageWithData:self.prescriptionImageData];
            }
            // TODO: can create thumb image of width 300*2 (maintaining aspect ratio)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // now notify delegate that image has been downloaded..
                if (!self.prescriptionDelegate && ![self.prescriptionDelegate respondsToSelector:@selector(didDownloadPrescriptionImage:)]) {
                    NSLog(@"prescriptionDelegate Delegate is nil now");
                }
                else
                {
                    [self.prescriptionDelegate didDownloadPrescriptionImage:self.prescriptionImage];
                }
            });
        });
    }
}

@end
