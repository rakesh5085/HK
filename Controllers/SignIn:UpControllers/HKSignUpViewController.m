//
//  HKSignUpViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 22/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKSignUpViewController.h"
#import "HKTermsAndAgreeViewController.h"
#import "HKSignInViewController.h"

#import "HKProfileMenuViewController.h"
#import "HKProfileTableViewHeader.h"

#import "HKNavigationLandingController.h"

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 10

@interface HKSignUpViewController ()
{
    UIPickerView *professionPickerView;
}

@property (nonatomic , strong) NSString *profileType;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *retypePasswordTextField;

@property (nonatomic) IBOutlet UIView *professionView;

@property (nonatomic) IBOutlet UILabel *selectedProfessionLabel;

@property (weak, nonatomic) IBOutlet UIButton *professionButton;

@property (nonatomic , strong) NSMutableArray *professionPickerArray;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;


@end

@implementation HKSignUpViewController


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
    
        self.navigationItem.title = @"Sign Up";
    self.professionPickerArray = (NSMutableArray *)@[@"Healthcare professionals",
                                                     @"Consumers"];
    
    self.profileType = @"Healthcare professionals";
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(professionButton:)];
    
    [self.professionView addGestureRecognizer:singleTap];
    
    // Setting the first object in texfield.
    self.selectedProfessionLabel.text = [self.professionPickerArray objectAtIndex:0];
    
    // Customising Buttons of view
    // Continue Button
    self.continueButton.backgroundColor = [UIColor colorWithRed:.333f green:.816f blue:.412f alpha:1.0];
    self.continueButton.layer.cornerRadius = 5.0f;
    self.continueButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.continueButton.layer.borderWidth = 1.0f;
    // SignIn Button
    self.signInButton.layer.cornerRadius = 5.0f;
    self.signInButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.signInButton.layer.borderWidth = 1.0f;
    
    // This is done to resignn the keyboard down.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHere:)];
    [self.view addGestureRecognizer:tap];
    
    
    // Show keyboard on the basis of hasEnteredFromSearchView bool
//    if(!_hasEnteredFromSearchView)
//    {
//        [self.emailTextField becomeFirstResponder];
//    }
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

#pragma mark - Search bar button tapped

- (IBAction)serachBarButtonTapped:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

#pragma mark - tap gesture
- (void)handleTapHere:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    if(professionPickerView)
    {
        [professionPickerView removeFromSuperview];
        professionPickerView = nil;
    }
    
    [self.view endEditing:YES];
}

#pragma mark- Private methods

- (IBAction)professionButton:(id)sender
{
    [self.view endEditing:YES];
    if(!professionPickerView)
    {
        professionPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 332 , 320, 280)];
        professionPickerView.backgroundColor = [UIColor whiteColor];
        professionPickerView.delegate = self;
        professionPickerView.showsSelectionIndicator = YES;
        [self.view addSubview:professionPickerView];
    }    
}
- (IBAction)signMeInClicked:(id)sender
{
    HKSignInViewController *signInView = (HKSignInViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
    signInView.signInDelegate = self;
    [self presentViewController:signInView animated:YES completion:nil];
}

#pragma mark - sign in view controller delegate
-(void)userHasSignedInSuccessfully
{
    HKProfileMenuViewController *profileMenuController = (HKProfileMenuViewController *)self.slidingViewController.underLeftViewController;
    [profileMenuController updateLoginHeader];
    
    HKNavigationLandingController *newTopViewController = (HKNavigationLandingController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

#pragma mark - continue tapped
- (IBAction)continueButtonClicked:(id)sender
{
    if(([self.emailTextField.text length] && [self.passwordTextField.text length] && [self.retypePasswordTextField.text length]) >0 )
    {
        if(![self validateEmailWithString:self.passwordTextField.text]){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"You must enter a valid email id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
            
        }else {
        
            if([self.retypePasswordTextField.text length] < 6){
            
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"Make your password at least 6 characters long." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alertView show];
            
            }else{
        
                [self performSegueWithIdentifier:@"signMeUp" sender:sender];
            }
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Details missing" message:@"Please fill in the necessary field" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.emailTextField.text = @"";
    self.passwordTextField.text = @"";
    self.retypePasswordTextField.text = @"";
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([(UIButton *)sender isEqual:self.continueButton])
    {
        // Preparing the dictionary
        NSDictionary *objectsDictionary = @{@"name":self.emailTextField.text,@"username":self.passwordTextField.text,@"password":self.retypePasswordTextField.text,@"profileType":self.profileType};
        HKTermsAndAgreeViewController *termsAndAgreementObj = [segue destinationViewController];
        termsAndAgreementObj.parameterDictionary = objectsDictionary;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 1)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
    }
    return YES;
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.professionPickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.profileType = self.professionPickerArray[row];
    return self.professionPickerArray[row];
}

#pragma mark -
#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.selectedProfessionLabel.text = [self.professionPickerArray objectAtIndex:row];
}

#pragma mark- UITextField Delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
