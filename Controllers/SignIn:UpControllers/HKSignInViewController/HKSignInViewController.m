//
//  HKSignInViewController.m
//  HealthKart+
//
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKSignInViewController.h"
#import "AFNetworking.h"
#import "HKGlobal.h"

#import "HKAIViewController.h"


#define kID_PWD_CONTAINER_VIEW_TAG  101

@interface HKSignInViewController ()
{
    HKGlobal *sharedGlobalObj;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (nonatomic, strong) HKAIViewController *activityIndicator;

@end

@implementation HKSignInViewController

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
    [self.emailTextField becomeFirstResponder];
    
    sharedGlobalObj = [HKGlobal sharedHKGlobal];
	// Do any additional setup after loading the view.
    // Customising buttons on view
    //SignInButton
    self.signInButton.backgroundColor = [UIColor colorWithRed:.333f green:.816f blue:.412f alpha:1.0];
    self.signInButton.layer.cornerRadius = 5.0f;
    self.signInButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.signInButton.layer.borderWidth = 1.0f;
    
    self.emailTextField.tag = 1;
    self.passwordTextField.tag = 2;
    
    //SignUpButton
    self.signUpButton.layer.cornerRadius = 5.0f;
    self.signUpButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.signUpButton.layer.borderWidth = 1.0f;
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"sign in Screen";
}

#pragma mark - sign in action
- (IBAction)signInButton:(id)sender
{
    if(([self.emailTextField.text length] && [self.passwordTextField.text length])> 0)
    {
        
        if(![self validateEmailWithString:self.emailTextField.text])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"You must enter a valid email id." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
            
        }else{
        
            /*
             Sign in API
             // *******************************************
             TYPE : POST
             Parameters :emailId & password
             URL sample: @" http://www.healthkartplus.com/authenticate?username={emailID}&password={password}"
             // *******************************************
             */
        
            [self showSpinnerWithMessage:@"Singing in..."];
        
            NSString *username = self.emailTextField.text;
            NSString *password = self.passwordTextField.text;
        
            NSString *signInURLString = ProductionBaseURLString;
            // Creating dictionary to give parameter
            NSDictionary *parameterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",@"rest",@"protocol",nil];
        
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
            [manager POST:signInURLString parameters:parameterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [self stopSpinner];
            
                 if([[responseObject objectForKey:@"result"] objectForKey:@"uid"])
                 {
                
                     NSDictionary *headers = [operation.response allHeaderFields];
                     NSString *str = [headers valueForKey:@"Set-Cookie"];
                
                     NSArray *arr = [str componentsSeparatedByString:@"."];
                     NSArray *arrr2 = [[arr objectAtIndex:0] componentsSeparatedByString:@"="];
                     NSString *cookieValue = [arrr2 objectAtIndex:1];
                     NSDictionary *properties1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                             @"staging.healthkartplus.com", NSHTTPCookieDomain,
                                             @"/", NSHTTPCookiePath,
                                             @"JSESSIONID", NSHTTPCookieName,
                                             cookieValue, NSHTTPCookieValue,
                                             nil];
                     NSHTTPCookie *httpCookie = [NSHTTPCookie cookieWithProperties:properties1];
                     NSArray *cookieArray = [NSArray arrayWithObjects:httpCookie, nil];
                     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookieArray forURL:operation.response.URL mainDocumentURL:operation.response.URL];
                
                     NSDictionary *userInfo;
                     if([[responseObject objectForKey:@"result"] objectForKey:@"profession"] != (id) [NSNull null])
                     {
                         userInfo = @{@"emailAddress":[[responseObject objectForKey:@"result"] objectForKey:@"emailAddress"],@"userid":[[responseObject objectForKey:@"result"] objectForKey:@"uid"],@"username":[[responseObject objectForKey:@"result"] objectForKey:@"username"],
                                  @"password":password,@"profession":[[responseObject objectForKey:@"result"] objectForKey:@"profession"]};
                     }
                     else
                     {
                         userInfo = @{@"emailAddress":[[responseObject objectForKey:@"result"] objectForKey:@"emailAddress"],@"userid":[[responseObject objectForKey:@"result"] objectForKey:@"uid"],@"username":[[responseObject objectForKey:@"result"] objectForKey:@"username"], @"password":password};
                     }
                     // Save user prefrences ..
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:userInfo forKey:@"userInfo"];
                
                     NSLog(@"userInfo at the time of signing in : %@", [defaults objectForKey:@"userInfo"]);

                     if([[responseObject objectForKey:@"status"] integerValue] == 0) // Sign in success ful
                     {
                         UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"You are logged in. Welcome to HealthKartPlus." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         alertView1.tag = 1;
                         [alertView1 show];
                     }
                 }
            
             }failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                    //FAILURE STEPS
                 NSLog(@"failure - response object = %@",[error description]);
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"Some error occurred. Please try again later." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                 [alertView show];
                 [self stopSpinner];
             }];
            }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Details missing" message:@"Please fill in the necessary field." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
    }
    // Remove the keyboard
    [self.view endEditing:YES];
}



#pragma mark - show / stop indicator
-(void)showSpinnerWithMessage:(NSString*)spinnerMessage
{
    if (!self.activityIndicator) {
        self.activityIndicator = [[HKAIViewController alloc] initToShowOnView:self.view WithSpinnerLabelText:nil];
        [self.activityIndicator setBackgroundOpacity:0.7f];
    }
    
    [self.activityIndicator startAnimatingSpinnerWithMessage:spinnerMessage];
    
    // Also disable container view interaction which contains id and pwd fields
    ((UIView *)[self.view viewWithTag:kID_PWD_CONTAINER_VIEW_TAG]).userInteractionEnabled = NO;

}

-(void)stopSpinner
{
    if (self.activityIndicator != nil)
    {
        [self.activityIndicator stopAnimatingSpinner];
    }
    
    self.activityIndicator = nil;
    
    // Also enable container view interaction which contains id and pwd fields
    ((UIView *)[self.view viewWithTag:kID_PWD_CONTAINER_VIEW_TAG]).userInteractionEnabled = YES;
}

#pragma mark - done button tapped
- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)signUpButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UITextField Delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == self.emailTextField)
    {
        [textField resignFirstResponder];
        
    }
    
    if(textField == self.passwordTextField){
        
        [textField resignFirstResponder];
        
        [self signInButton:nil];
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    
    }else if (textField.tag == 2){
     
        textField.keyboardType = UIKeyboardTypeDefault;
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        // Move to search screen
//        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.signInDelegate && [self.signInDelegate respondsToSelector:@selector(userHasSignedInSuccessfully)])
        {
            [self.signInDelegate userHasSignedInSuccessfully];
        }
    }
}


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end
