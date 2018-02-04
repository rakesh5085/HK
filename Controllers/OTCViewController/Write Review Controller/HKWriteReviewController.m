//
//  HKWriteReviewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 18/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKWriteReviewController.h"
#import "HKGlobal.h"
#import "HKTestimonialModel.h"
#import "AFNetworking.h"

@interface HKWriteReviewController ()
{
    HKGlobal *sharedGlobalObj;
}

@property (nonatomic, strong) HKAIViewController *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *otcMedicineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *otcMedicineBrandLabel;

@property (weak, nonatomic) IBOutlet UITextField *reviewTitle;

@property (weak, nonatomic) IBOutlet UIButton *otcStarButton1;
@property (weak, nonatomic) IBOutlet UIButton *otcStarButton2;
@property (weak, nonatomic) IBOutlet UIButton *otcStarButton3;
@property (weak, nonatomic) IBOutlet UIButton *otcStarButton4;
@property (weak, nonatomic) IBOutlet UIButton *otcStarButton5;

@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;

@end

@implementation HKWriteReviewController

@synthesize otcMedicineName;
@synthesize otcBrandName;
@synthesize productId;

NSInteger rating;

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
    sharedGlobalObj = [HKGlobal sharedHKGlobal];
    
    self.otcMedicineNameLabel.text = otcMedicineName;
    self.otcMedicineBrandLabel.text = otcBrandName;
    
    self.reviewTextView.layer.cornerRadius = 3.0f;
    self.reviewTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.reviewTextView.layer.borderWidth = 1.0f;
    [self.reviewTitle becomeFirstResponder];
    
    // This is done to resignn the keyboard down.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)starButtonsClicked:(id)sender
{
    for (UIView* view in [self.view subviews])
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)view;
            if(btn.tag > [sender tag])
                [btn setImage:[UIImage imageNamed:@"star-grey"] forState:UIControlStateNormal];
            else
                [btn setImage:[UIImage imageNamed:@"star-selected"] forState:UIControlStateNormal];
            rating = [sender tag];
            
        }
    }

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
    if (self.activityIndicator != nil)
    {
        [self.activityIndicator stopAnimatingSpinner];
    }
    
    self.activityIndicator = nil;
}

- (IBAction)sendButtonClicked:(id)sender
{
    // TODO: Network request to send review to server and after successfull pop the view to writeview controller
    
    [self showSpinnerWithMessage:@"Sending Review.."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = @"http://staging.healthkartplus.com/otc/product/addReview";
    NSDictionary *parameterDict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInteger:productId],@"prId",[NSNumber numberWithInteger:rating],@"rating",self.reviewTextView.text,@"review", nil];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameterDict];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://staging.healthkartplus.com/authenticate"]];
    NSDictionary *cookiesDictionary = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    if (cookiesDictionary) {
        [request setAllHTTPHeaderFields:cookiesDictionary];
    }
    
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self stopSpinner];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Review sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 0;
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self stopSpinner];
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error Sending Review. Try Again...??" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert1.tag = 1;
        [alert1 show];
    }];
    
    [manager.operationQueue addOperation:operation];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        default:
            break;
    }
}

# pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSLog(@"textViewDidBeginEditing");
    // never called...
}


@end
