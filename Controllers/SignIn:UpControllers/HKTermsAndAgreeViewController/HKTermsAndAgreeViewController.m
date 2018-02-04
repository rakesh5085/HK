//
//  HKTermsAndAgreeViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 11/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKTermsAndAgreeViewController.h"
#import "AFNetworking.h"
#import "HKAIViewController.h"
#import "HKSignInViewController.h"

@interface HKTermsAndAgreeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *termsTextView;
@property (nonatomic, strong) HKAIViewController *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation HKTermsAndAgreeViewController

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
    // Customising buttons in view
    //SignUpButton
    self.signUpButton.backgroundColor = [UIColor colorWithRed:.333f green:.816f blue:.412f alpha:1.0];
    self.signUpButton.layer.cornerRadius = 5.0f;
    self.signUpButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.signUpButton.layer.borderWidth = 1.0f;
    //SignUpButton
    self.cancelButton.layer.cornerRadius = 5.0f;
    self.cancelButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.cancelButton.layer.borderWidth = 1.0f;
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
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

- (IBAction)signUpButtonClicked:(id)sender
{
    // Calling spinner class to show spinner
    [self showSpinnerWithMessage:@"Signing Up..."];
    /*
     Sign up API
     // *******************************************
     TYPE : POST
     Parameters :name, username, password & profile type
     URL sample: @" http://staging.healthkartplus.com/webservices/users/registration/hkp-rest?name={name}&username={email"
     // *******************************************
     */
    __block HKTermsAndAgreeViewController *blockSelf = self;
    
    NSString *signInURLString = [NSString stringWithFormat:@"%@/users/registration/hkp-rest",BaseURLString];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:signInURLString parameters:self.parameterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // SUCCESS STEPS
        
        if([[responseObject objectForKey:@"status"] integerValue] == 0)
        {
            NSLog(@"response object = %@",responseObject);
            // ***********************  *******************  *************************
            // First get the result object and save it in NSUSER DEFAULTS - Emailid, userid, username , profession in a nsdictionary
            NSDictionary *userInfo = @{@"emailAddress":[[responseObject objectForKey:@"result"] objectForKey:@"emailAddress"],@"userid":[[responseObject objectForKey:@"result"] objectForKey:@"uid"],@"username":[[responseObject objectForKey:@"result"] objectForKey:@"username"],@"profession":[[responseObject objectForKey:@"result"] objectForKey:@"profession"]};
            
            NSLog(@"user info : %@", userInfo);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userInfo forKey:@"userInfo"];
            [defaults setInteger:0 forKey:@"fileNameCounter"];
            
            // Stoping spinner
            [blockSelf stopSpinner];
            // alertview
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HelathKart Plus" message:@"You are now signed up with HealthKartPlus" delegate:blockSelf cancelButtonTitle:@"Sign In" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            // Stoping spinner
            [blockSelf stopSpinner];
            NSString *tempMesgStr = [[[[responseObject objectForKey:@"errors"] objectForKey:@"errs"] objectAtIndex:0] objectForKey:@"msg"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HelathKart Plus" message:tempMesgStr delegate:blockSelf cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //FAILURE STEPS
        NSLog(@"failure response object = %@",[error description]);
        
        [blockSelf stopSpinner];
    }];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-  UIAlertView Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *alertTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([alertTitle isEqualToString:@"Sign In"])
    {
        HKSignInViewController *signInView = (HKSignInViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
        [self presentViewController:signInView animated:YES completion:nil];
    }
}

@end
