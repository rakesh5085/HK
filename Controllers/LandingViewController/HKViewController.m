//
//  HKViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKViewController.h"
#import "HKSearchMedicineController.h"
#import <QuartzCore/QuartzCore.h>
#import "HKNavigationQuickOrderController.h"
#import "HKQuickOrderController.h"
#import "HKAIViewController.h"
#import "HKSignUpViewController.h"
#import "HKNavigationAccountsController.h"
#import "HKConstants.h"
#import "AFNetworking.h"

#import "HKNavigationReorderController.h"
#import "HKReorderViewController.h"

#import "HKAppDelegate.h"

#define kTAG_QUICK_ORDER_BUTTON_VIEW 101
#define kTAG_REORDER_BUTTON_VIEW 102
#define kTAG_LOGIN_BUTTON_VIEW 103

#define OFFSET_X 30.0f

@interface HKViewController ()
{
    HKSearchMedicineController *searchMedicineController;
}

@property (nonatomic, strong) HKAIViewController *activityIndicator;

@end

@implementation HKViewController

@synthesize landingSearchBar= _landingSearchBar;
@synthesize topView = _topView;
@synthesize bottomView = _bottomView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // If user is login then we will show 2nt button view otherwise not.
    // For now it is not signed in
    [self.secondButtonView setFrame:CGRectMake(self.thirdButtonView.frame.origin.x - OFFSET_X, self.secondButtonView.frame.origin.y, self.secondButtonView.frame.size.width, self.secondButtonView.frame.size.height)];
    [self.secondButtonView setHidden:YES];
    [self.firstButtonView setFrame:CGRectMake(self.firstButtonView.frame.origin.x-20 + OFFSET_X, self.firstButtonView.frame.origin.y, self.firstButtonView.frame.size.width, self.firstButtonView.frame.size.height)];
    [self.thirdButtonView setFrame:CGRectMake(self.thirdButtonView.frame.origin.x - OFFSET_X, self.thirdButtonView.frame.origin.y, self.thirdButtonView.frame.size.width, self.thirdButtonView.frame.size.height)];
    
    //Customising view on basis of enum defined
    switch (self.fromScene)
    {
        case COMINGFROM_LEFT_PANE:
        {
            
        }
            break;
        case COMINGFROM_MIDDLE_CHECKOUT_CONFIRMATION_CHECKOUT:
        {
            searchMedicineController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchMedicine"];
            [self.navigationController pushViewController:searchMedicineController animated:NO];
        }
        default:
            break;
    }

    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat heightOfScreen = screenSize.height;
    if(heightOfScreen == SCREEN_HEIGHT_480)
    {
        [_topView setFrame:CGRectMake(_topView.frame.origin.x, _topView.frame.origin.y, _topView.frame.size.width,_topView.frame.size.height + 90)];
        [_bottomView setFrame:CGRectMake(_bottomView.frame.origin.x, _bottomView.frame.origin.y-50, _bottomView.frame.size.width, _bottomView.frame.size.height)];
    }
    
    //setting background color of topview and botoom view
    _topView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.0];
    _topView.layer.cornerRadius = 8.0f;
    [_topView.layer setBorderWidth:1.0f];
    _topView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _bottomView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.0];
    _bottomView.layer.cornerRadius = 5.0f;
    [_bottomView.layer setBorderWidth:1.0f];
    _bottomView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strUserID = [[userDefaults objectForKey:@"userInfo"]  objectForKey:@"userid"];
    if(strUserID) // user earlier has logged in
    {
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"launched"])
        {
            // Auto login user again ....
            [self signInUser];
            
            // and then set the wasAppKilledInBG to NO
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"launched"];
        }
        else
         {
            NSLog(@"App was not killed in bg & USER HAS LOGGED IN EARLIER ....");
            // ******* hide login button view
            [self.view viewWithTag:kTAG_LOGIN_BUTTON_VIEW].hidden = YES;
            [self.view viewWithTag:kTAG_REORDER_BUTTON_VIEW].hidden = NO;
        }

    }
    else // First time app launch
    {
        // show login button and hide reorder button
        [self.view viewWithTag:kTAG_LOGIN_BUTTON_VIEW].hidden = NO;
        [self.view viewWithTag:kTAG_REORDER_BUTTON_VIEW].hidden = YES;
    }

    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    _topView.frame = CGRectMake(5, _topView.frame.origin.y + 172, _topView.frame.size.width, _topView.frame.size.height);
    _topView.alpha = 1.0f;
    //self.navigationController.navigationBarHidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"Search Screen";
    self.screenName = @"Search Screen";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.navigationController.navigationBarHidden == NO)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    [[UIApplication sharedApplication] delegate];
}

#pragma mark - location related methods


#pragma mark- uisearchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _landingSearchBar.text=@"";
    
    CGRect newFrame = CGRectMake(5,-132, _topView.frame.size.width, _topView.frame.size.height);
    [UIView animateWithDuration:0.4
                        delay: 0.3
                        options: UIViewAnimationOptionCurveEaseIn
                        animations:^{
                            _topView.frame = newFrame;    // move
                        }
                        completion:^(BOOL finished){
                            //_topView.alpha = 0.0f;
                            [_landingSearchBar resignFirstResponder];
                            _landingSearchBar.text = @"";
                            // This is done to hide the animation when we perform the segue with animation.
                            //[self performSegueWithIdentifier:@"goSearchMedicine" sender:self];
                            searchMedicineController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchMedicine"];
                            [self.navigationController pushViewController:searchMedicineController animated:NO];
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_landingSearchBar resignFirstResponder];
    
    [self performSegueWithIdentifier:@"goSearchMedicine" sender:self];
}

#pragma mark - Quick order button tapped
- (IBAction)firstViewButtonClicked:(id)sender
{
    //NavigationQuickOrder , Which has the Quick order view controller as its root view controller
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationQuickOrder"];
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

#pragma mark - Re order button tapped
- (IBAction)secondViewButtonClicked:(id)sender
{
    //Navigation ReOrder , Which has the Re order view controller as its root view controller, Display it on tap of "ReOrder" button
    HKNavigationReorderController *newTopViewController = (HKNavigationReorderController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationReorder"];
    HKReorderViewController *reorderViewController = (HKReorderViewController *)[newTopViewController.viewControllers objectAtIndex:0];
    reorderViewController.fromScene = COMINGFROM_LEFTPANE_REORDER;
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

#pragma mark - Login button tapped
- (IBAction)thirdViewButtonClicked:(id)sender
{
    //NavigationAccount Controller , Which has the Sign up view controller as its root view controller
    HKNavigationAccountsController *newTopViewController = (HKNavigationAccountsController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationAccount"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}



#pragma mark - show / stop indicator
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

- (IBAction)enterLocation:(id)sender
{
    // enter location
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLocation"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}



#pragma mark - sign in action
- (void)signInUser
{
        /*
         Sign in API
         // *******************************************
         TYPE : POST
         Parameters :emailId & password
         URL sample: @" http://www.healthkartplus.com/authenticate?username={emailID}&password={password}"
         // *******************************************
         */
        
        [self showSpinnerWithMessage:@"Singing in..."];
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userEmail =  [[defaults objectForKey:@"userInfo"]  objectForKey:@"emailAddress"];
        NSString *pwd =  [[defaults objectForKey:@"userInfo"]  objectForKey:@"password"];
        
        NSString *signInURLString = ProductionBaseURLString;
        // Creating dictionary to give parameter
        NSDictionary *parameterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:userEmail,@"username",pwd,@"password",@"rest",@"protocol",nil];
        
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
                                  @"password":pwd,@"profession":[[responseObject objectForKey:@"result"] objectForKey:@"profession"]};
                 }
                 else
                 {
                     userInfo = @{@"emailAddress":[[responseObject objectForKey:@"result"] objectForKey:@"emailAddress"],@"userid":[[responseObject objectForKey:@"result"] objectForKey:@"uid"],@"username":[[responseObject objectForKey:@"result"] objectForKey:@"username"], @"password":pwd};
                 }
                 // Save user prefrences ..
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:userInfo forKey:@"userInfo"];
                 
                 // ******* hide login button view
                 [self.view viewWithTag:kTAG_LOGIN_BUTTON_VIEW].hidden = YES;
                 [self.view viewWithTag:kTAG_REORDER_BUTTON_VIEW].hidden = NO;
             }
             else
             {
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error singing in , Plz try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil    , nil];
                 [alert show];
                 
                 // show login button and hide reorder button
                 [self.view viewWithTag:kTAG_LOGIN_BUTTON_VIEW].hidden = NO;
                 [self.view viewWithTag:kTAG_REORDER_BUTTON_VIEW].hidden = YES;
             }
             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             //FAILURE STEPS
             NSLog(@"failure response object = %@",[error description]);
             [self stopSpinner];
             
             // show login button and hide reorder button

             [self.view viewWithTag:kTAG_LOGIN_BUTTON_VIEW].hidden = NO;
             [self.view viewWithTag:kTAG_REORDER_BUTTON_VIEW].hidden = YES;
             
         }];

}



@end
