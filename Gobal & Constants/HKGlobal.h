//
//  HKGlobal.h
//  HealthKart+
//
//  Created by Letsgomo Labs on 23/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <HKAIViewController.h>

@protocol GlobalClassProtocol <NSObject>

-(void)signInResponseReceived;

@end

@interface HKGlobal : NSObject

@property (nonatomic, assign) id <GlobalClassProtocol>  globalDelegate;

// Global Array which contains HKCartMenuModel objects
@property (nonatomic , strong) NSMutableArray *cartItemsGlobalArray;


// Global activity indicator view .. can be used on any view
@property (nonatomic, strong) HKAIViewController *activityIndicator;

// shared singleton object will be returned
+(HKGlobal *)sharedHKGlobal;

// image scaling method
+(UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth: (float) i_width;

/***************************************************************************
 DESCRIPTION: For  Dynamic height of the label
 ***************************************************************************/
+(UILabel *)adjustHeightOfLabel:(UILabel *)lbl;

/***************************************************************************
 DESCRIPTION: For  Dynamic frame for a given text or string
 ***************************************************************************/
+(float) heightOfGivenText: (NSString *)string ofWidth: (float)width andFont:(UIFont *)font;


/***************************************************************************
 DESCRIPTION: Auto sign in user 
 ***************************************************************************/
-(void) autoSignIn;



@end
