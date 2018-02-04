//
//  HKLocationViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 29/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKLocationViewController.h"
#import "AFNetworking.h"
#import "HKAIViewController.h"
#import "HKViewController.h"
#import "ECSlidingViewController.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 6

@interface HKLocationViewController ()

@property (nonatomic, strong) HKAIViewController *activityIndicator;

@end

@implementation HKLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self showLocationAlert];
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Location";
}

-(void)showLocationAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter your location" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"pincode"])
    {
        [[alertView textFieldAtIndex:0] setText:@""];
    }else{
        
        [[alertView textFieldAtIndex:0] setText:[[[NSUserDefaults standardUserDefaults] valueForKey:@"pincode"] stringValue]];
        
    }
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView show];
}

-(void)showSpinnerWithMessage:(NSString*)spinnerMessage
{
    if (!self.activityIndicator) {
        self.activityIndicator = [[HKAIViewController alloc] initToShowOnView:self.view WithSpinnerLabelText:nil];
        [self.activityIndicator setBackgroundOpacity:0.7f];
    }
    
    [self.activityIndicator startAnimatingSpinnerWithMessage:spinnerMessage];
}

-(void)stopSpinner
{
    if (self.activityIndicator != nil) {
        [self.activityIndicator stopAnimatingSpinner];
    }
    
    self.activityIndicator = nil;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10)
    {
        [self moveToLocationView];
    }
    else
    {
        
        NSString *titleString = [alertView buttonTitleAtIndex:buttonIndex];
        if([titleString isEqualToString:@"Confirm"])
        {
            /*
             Call api to search on each key press
             // *******************************************
             Parameters : @name, @pageSize
             @name : keyword to search medicine for
             @pageSize : Number of results
             URL sample: @"http://staging.healthkartplus.com/webservices/search/session/pincode?pincode={pinCode}"
             // *******************************************
             */
            
            [self showSpinnerWithMessage:@"Loading..."];
            
            NSString *urlString = [NSString stringWithFormat@"%@/search/session/pincode", ba];
            NSDictionary *parameterDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text] ,@"pincode", nil];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:urlString parameters:parameterDict success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 // TODO:: parse the response
                 NSLog(@"responseobject = %@",responseObject);
                 
                 [self stopSpinner];
                 NSInteger status = [[responseObject valueForKey:@"status"] integerValue];

                 if(status == 1){
                     
                     NSString *result = [responseObject valueForKey:@"result"];
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 else{
                     
                     [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"result"] forKey:@"pincode"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     if (self.isComingFromProductDetailScreen) {
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }
                     else
                     {
                         NSString *message = [responseObject valueForKey:@"message"];
                         
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                         [alert show];
                         
                         [self moveToSearchView];
                         
                         [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
                     }
                     
                 }
                 
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 
                 [self stopSpinner];
                 //TODO:: handle error appropriately
             }];
        }
        else
        {
            if (self.isComingFromProductDetailScreen)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else
            {
                UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
            
                [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
                    CGRect frame = self.slidingViewController.topViewController.view.frame;
                    self.slidingViewController.topViewController = newTopViewController;
                    self.slidingViewController.topViewController.view.frame = frame;
                    [self.slidingViewController resetTopView];
                }];
            }
            
        }
    }
}


// Method to Navigate To SearchMedicineViewController
-(void)moveToSearchView
{
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}


// Method to Navigate To LocationViewController
-(void)moveToLocationView
{
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLocation"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Delegate Method toEnable Confirm Button in Location AlertView only when user enters 6 digits for Pincode.
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    textField.delegate = self;
    
    if ([textField.text length] < 6){
        return NO;
    }
    return YES;
}

// Delegate Method for Setting the No. Of Digits Limit for Pincode Text Field in Location AlertView
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
