//
//  HKHelpViewController.m
//  HealthKart+
//
//  Created by vivek on 28/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKHelpViewController.h"
#import "HKViewController.h"
#import "ECSlidingViewController.h"
#import "HKInitialSlidingViewController.h"
#import "HKAppDelegate.h"

@interface HKHelpViewController ()

@end

@implementation HKHelpViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize btnClose;   

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
    
    CGFloat xoffset=self.view.frame.size.width/2;
    
    CGFloat yoffset = self.view.frame.size.height;
    
    CGPoint Point = CGPointMake(xoffset, yoffset-35);
    
    self.pageControl.center = Point;
    
    
    scrollOffset = 0;
    
    pageControlBeingUsed = NO;
    
    NSArray *screens = [NSArray arrayWithObjects:[UIImage imageNamed:@"HelpScreen1"], [UIImage imageNamed:@"HelpScreen2"], [UIImage imageNamed:@"HelpScreen3"], nil];
    
    for (int i = 0; i < screens.count; i++)
    {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        subview.image = [screens objectAtIndex:i];
        [self.scrollView addSubview:subview];
        
        NSMutableAttributedString *btnTitleString = [[NSMutableAttributedString alloc] initWithString:@"Close"];
        [btnTitleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [btnTitleString length])];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(closeBttonClicked)
         forControlEvents:UIControlEventTouchDown];
        
        [button setTintColor:[UIColor whiteColor]];
        [button setAttributedTitle:btnTitleString forState:UIControlStateNormal];
        button.frame = CGRectMake((220)+i*320, 0, 160.0, 40.0);
        [self.scrollView addSubview:button];
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * screens.count, self.scrollView.frame.size.height);
	
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = screens.count;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, 1);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    scrollOffset = scrollOffset+320;
    pageControlBeingUsed = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    scrollOffset = scrollOffset+320;
}

-(void)closeBttonClicked
{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    UIViewController *topViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
//    
    
    [self.timer invalidate];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        HKAppDelegate *app = (HKAppDelegate *)[[UIApplication sharedApplication] delegate];
        HKInitialSlidingViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
        
        [app.window setRootViewController:newTopViewController];
//        [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
//            CGRect frame = self.slidingViewController.topViewController.view.frame;
//            self.slidingViewController.topViewController = newTopViewController;
//            self.slidingViewController.topViewController.view.frame = frame;
//            [self.slidingViewController resetTopView];
//        }];
        
    }else{

        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];

    }
    
   // newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
}

- (void) scrollTimer
{
    
//    int i=0;
    
    // Updates the variable h, adding 100 (put your own value here!)
    
    if(scrollOffset<=640)
    {
    [scrollView setContentOffset:CGPointMake(scrollOffset, 0) animated:YES];
    
            scrollOffset = scrollOffset+320;
    }else{
        
        if([self.timer isValid]){
            [self.timer invalidate];
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
        {
            HKAppDelegate *app = (HKAppDelegate *)[[UIApplication sharedApplication] delegate];
            HKInitialSlidingViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InitialView"];
            
            [app.window setRootViewController:newTopViewController];
            //        [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
            //            CGRect frame = self.slidingViewController.topViewController.view.frame;
            //            self.slidingViewController.topViewController = newTopViewController;
            //            self.slidingViewController.topViewController.view.frame = frame;
            //            [self.slidingViewController resetTopView];
            //        }];
            
        }else{
            
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


@end
