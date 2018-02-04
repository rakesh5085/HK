//
//  HKProfileMenuViewController.m
//  HealthKart+
//
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKProfileMenuViewController.h"
#import "HKProfileTableViewHeader.h"
#import "HKProfileMenuCell.h"
#import "HKSectionCell.h"
#import "HKNavigationReorderController.h"
#import "HKReorderViewController.h"
#import "HKSignUpViewController.h"
#import "HKNavigationAccountsController.h"

#import "HKAddressNavigationController.h" // Address navigation controller
#import "HKAddressViewController.h"
#import "HKSelectAddressController.h"

#import "HKHelpNavigationController.h"
#import "HKHelpViewController.h"

@interface HKProfileMenuViewController ()
{
    HKProfileTableViewHeader *tableHeaderView;
}
@property(nonatomic,strong) NSMutableArray *profileMenuArray;
@property (weak, nonatomic) IBOutlet UITableView *profileMenuTable;

@end

@implementation HKProfileMenuViewController

@synthesize profileMenuArray = _profileMenuArray;
@synthesize profileMenuTable = _profileMenuTable;


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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    _profileMenuArray = [NSMutableArray arrayWithObjects:@"",@"Search",@"My Orders",@"My Prescriptions",
                         @"My Addresses",@"My Location",@"Sign Up",@"",@"",@"Quick Order",@"Re-Order",@"Help",@"", nil];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    HKProfileTableViewHeader *headerview = (HKProfileTableViewHeader*)[[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil] objectAtIndex:0];
    
    [headerview setProfileHeader];
    
    _profileMenuTable.tableHeaderView = headerview;
}

#pragma mark - login header change delegate method
-(void)updateLoginHeader
{
    HKProfileTableViewHeader *headerview = (HKProfileTableViewHeader*)[[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil] objectAtIndex:0];
    
    [headerview setProfileHeader];
    
    _profileMenuTable.tableHeaderView = headerview;
    
    
    // Also change sign up to "Sing out"
    [self.profileMenuArray replaceObjectAtIndex:6 withObject:@"Sign Out"];
    
    [self.profileMenuTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:6 inSection:0] , nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//in this we will create an image and a label.
-(UIView *)createTableViewHeader
{
        return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 13;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 7)
    {
        return 20.0f;
    }
    else if(indexPath.row == 8)
    {
        return 35.0f;
    }
    else if (indexPath.row == 13)
    {
        return 35.0f;
    }
    else
    {
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ProfileItemCell";
    NSString *cellIdentifier1 = @"sectioncell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if((indexPath.row == 0)||(indexPath.row == 8))
    {
        HKSectionCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if(!sectionCell)
        {
            sectionCell = (HKSectionCell *)[[[NSBundle mainBundle] loadNibNamed:@"SectionCell" owner:self options:nil] objectAtIndex:0];

        }
        if(indexPath.row == 0)
        {
            sectionCell.sectionCellLabel.text = @"Account";
        }
        else
        {
            sectionCell.sectionCellLabel.text = @"Services";
        }
        return sectionCell;
        
    }
    else if(indexPath.row == 7)
    {
        HKProfileMenuCell *profileCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!profileCell)
        {
            profileCell = (HKProfileMenuCell *)[[[NSBundle mainBundle] loadNibNamed:@"HKProfileMenuCell" owner:self options:nil] objectAtIndex:0];

        }
        // Because requirement of blank cell
        // THIS IS WARNING COMING IN LOG BECAUSE WE ARE PASSING NIL IN IMAGEVIEW OBJECT
        //It is done because it no image is required
        //ERROR:-CUICatalog: Invalid asset name supplied: , or invalid scale factor: 2.000000
        profileCell.profileMenuLabel.text = nil;
        profileCell.profileMenuImage.image = nil;
        return profileCell;
    }
    else
    {
        HKProfileMenuCell *profileCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!profileCell)
        {
            profileCell = (HKProfileMenuCell *)[[[NSBundle mainBundle] loadNibNamed:@"HKProfileMenuCell" owner:self options:nil] objectAtIndex:0];
        }
        profileCell.profileMenuLabel.text = [_profileMenuArray objectAtIndex:indexPath.row];
        if(indexPath.row == 6)
            profileCell.profileMenuImage.image = [UIImage imageNamed:@"Sign Up"];
        else
            profileCell.profileMenuImage.image = [UIImage imageNamed:[_profileMenuArray objectAtIndex:indexPath.row]];
        return profileCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [_profileMenuArray objectAtIndex:indexPath.row]];
    NSLog(@"idebtifier - %@",identifier);
   // NSLog(@"self.topview = %@",self.slidingViewController.topViewController);
    if(indexPath.row == 6)
    {
        NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"emailAddress"];
        if(username && username.length > 0)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
            
            NSHTTPCookieStorage *cookieStorage =  [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie  *cookie in [cookieStorage cookies]) {
                [cookieStorage deleteCookie:cookie];
            }
            
            UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
            
            [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = newTopViewController;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
                
                // change header
                [self updateLoginHeader];
                // Also change sign out to "Sing up"
                [self.profileMenuArray replaceObjectAtIndex:6 withObject:@"Sign Up"];
                
                [self.profileMenuTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:6 inSection:0] , nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"You have logged out!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
            }];
        }
        else
        {
            // Navigation account controller , which has the root view sign up view controller
            HKNavigationAccountsController *newTopViewController = (HKNavigationAccountsController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationAccount"];
    //        HKSignUpViewController *signUpViewController =  (HKSignUpViewController *)[newTopViewController.viewControllers objectAtIndex:0];
            
            [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = newTopViewController;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
            }];
        }
    }
    else if (indexPath.row == 1)
    {
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];

    }
    else if (indexPath.row == 2)
    {
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationMyOrder"];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    else if (indexPath.row == 3)
    {
        HKNavigationReorderController *newTopViewController = (HKNavigationReorderController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationReorder"];
        
        HKReorderViewController *reorderController = (HKReorderViewController *)[newTopViewController.viewControllers objectAtIndex:0];
        
        reorderController.fromScene = COMINGFROM_LEFTPANE_MYPRESCRIPTION;
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
        
    }
    else if (indexPath.row == 4)
    {
        HKAddressNavigationController *newTopViewController = (HKAddressNavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddressNavigation"];
        NSLog(@"newTopViewController.viewControllers -- %@", newTopViewController.viewControllers);
        HKSelectAddressController *addressViewController = (HKSelectAddressController *)[newTopViewController.viewControllers objectAtIndex:0];
        
        addressViewController.fromScene = COMINGFROM_LEFTPANE_MY_ADDRESSES; // entring from left pane "My addresses"
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    else if (indexPath.row == 9)
    {
        //NavigationQuickOrder
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationQuickOrder"];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    else if (indexPath.row == 10)
    {
       // UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationReorder"];
        HKNavigationReorderController *newTopViewController = (HKNavigationReorderController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationReorder"];
        
        HKReorderViewController *reorderController = (HKReorderViewController *)[newTopViewController.viewControllers objectAtIndex:0];
        
        reorderController.fromScene = COMINGFROM_LEFTPANE_REORDER;
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    else if (indexPath.row == 5)
    {
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLocation"];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    else if (indexPath.row == 11)
    {
        HKHelpNavigationController *newTopViewController = (HKHelpNavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpNavigationController"]; // instantiate navigation controller of help view controller
        
//        HKHelpViewController *helpViewController = (HKHelpViewController *)[newTopViewController.viewControllers objectAtIndex:0];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    
}


@end
