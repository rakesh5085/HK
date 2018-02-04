//
//  HKConfirmationViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 25/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKConfirmationViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "HKViewController.h"
#import "HKNavigationLandingController.h"
#import "HKConstants.h"
#import "ECSlidingViewController.h"

@interface HKConfirmationViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *confirmationScrollView;

@property (weak, nonatomic) IBOutlet UIView *confirmationBottomView;


@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

@end

@implementation HKConfirmationViewController

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
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.navigationController.navigationItem.hidesBackButton = YES;
    CGFloat heightOfScreen = screenSize.height;
    if(heightOfScreen == SCREEN_HEIGHT_480)
    {
        [self.confirmationScrollView setFrame:CGRectMake(self.confirmationScrollView.frame.origin.x, self.confirmationScrollView.frame.origin.y + 64, self.confirmationScrollView.frame.size.width, self.confirmationScrollView.frame.size.height - 62)];
        [self.confirmationBottomView setFrame:CGRectMake(self.confirmationBottomView.frame.origin.x, self.confirmationBottomView.frame.origin.y - 88, self.confirmationBottomView.frame.size.width, self.confirmationBottomView.frame.size.height)];
    }
    // Customising the buttons
    self.facebookButton.layer.cornerRadius = 5.0f;
    self.facebookButton.layer.borderWidth = 2.0f;
    self.facebookButton.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];
    self.twitterButton.layer.cornerRadius = 5.0f;
    self.twitterButton.layer.borderWidth = 2.0f;
    self.twitterButton.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];

    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

- (IBAction)shareOnFacebookClicked:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:@"Posting from my own app! :)"];
//        if (self.imageString)
//        {
//            [tweetSheet addImage:[UIImage imageNamed:self.imageString]];
//        }
        
//        if (self.urlString)
//        {
//            [tweetSheet addURL:[NSURL URLWithString:self.urlString]];
//        }
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"No post, yet"
                                  message:@"To send a post, make sure you are connected to the internet and you have at least one Facebook account set up"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (IBAction)shareOnTwitterClicked:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Tweeting from my own app! :)"];
//        if (self.imageString)
//        {
//            [tweetSheet addImage:[UIImage imageNamed:self.imageString]];
//        }
//        
//        if (self.urlString)
//        {
//            [tweetSheet addURL:[NSURL URLWithString:self.urlString]];
//        }
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"No tweet, yet"
                                  message:@"To send a tweet, make sure you are connected to the internet and you have at least one twitter account set up"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)orderAnotherButtonClicked:(id)sender
{
    // ACTUALLY WE HAVE TO GO TO STARTING FROM WHERE A USER CAN SEARCH MEDICINES
    
    //NavigationLandingView
    HKNavigationLandingController *newTopViewController = (HKNavigationLandingController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
//    HKViewController *viewController = (HKViewController *)[newTopViewController.viewControllers objectAtIndex:0];
    
//    viewController.fromScene = COMINGFROM_MIDDLE_CHECKOUT_CONFIRMATION_CHECKOUT;
    
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

@end
