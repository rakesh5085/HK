//
//  HKMyOrderViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 16/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKMyOrderViewController.h"
#import "HKMyOrderCell.h"
#import "AFNetworking.h"
#import "HKAIViewController.h"
#import "HKOrderModel.h"
#import "HKMyOrderDetailViewController.h"
#import "HKSignInViewController.h"
#import "HKProfileMenuViewController.h"

#import "HKGlobal.h"

@interface HKMyOrderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myOrderTableview;
@property (nonatomic, strong) NSArray *myOrdersArray;
@property (nonatomic, strong) HKAIViewController *activityIndicator;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) HKOrderModel *modelObj;
@property (nonatomic) id orderItemsArray;

@end

@implementation HKMyOrderViewController

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
    
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"emailAddress"];
    if(username && username.length > 0)
    {
            [self showSpinnerWithMessage:@"Loading..."];
            [self getMyOrders];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login to HealthKartPlus to continue" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign-In", nil];
        alert.tag = 10;
        [alert show];
    }
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    // Call api to add an address
    // *******************************************
    
}

#pragma mark - search bar button tapped
- (IBAction)searchBarButtonTapped:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}


#pragma mark - get my orders
-(void)getMyOrders
{
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"emailAddress"];
    if(username && username.length>0 )
    {
        [self showSpinnerWithMessage:@"Loading"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *URLString = @"http://staging.healthkartplus.com/webservices/order/orders";
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:nil];
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://staging.healthkartplus.com/authenticate"]];
        NSDictionary *cookiesDictionary = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        if (cookiesDictionary) {
            [request setAllHTTPHeaderFields:cookiesDictionary];
        }
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self stopSpinner];
            
            __block HKMyOrderViewController *blockSelf = self;
            id result = [responseObject valueForKey:@"result"];
            if(result && [result isKindOfClass:[NSDictionary class]])
            {
                id orders = [result valueForKey:@"orders"];
                if (orders && [orders isKindOfClass:[NSArray class]] && ((NSArray *)orders).count>0) {
                    [blockSelf createOrderModels:(NSArray*)orders];
                    [self.myOrderTableview reloadData];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No orders found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseObject objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self stopSpinner];
            if(error.code == 3840 )
            {
                // auto sign in
                [self showSpinnerWithMessage:@"Signing in..."];
                [HKGlobal sharedHKGlobal].globalDelegate = self;
                [[HKGlobal sharedHKGlobal] autoSignIn];
            }
        }];
        
        [manager.operationQueue addOperation:operation];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login to HealthKart+" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - global class delegate
-(void)signInResponseReceived
{
    NSLog(@"auto sign in complete");
    [self stopSpinner];
}

-(void)createOrderModels:(NSArray*)orders
{
    NSMutableArray *tempOrders = [[NSMutableArray alloc] init];
    
    for (id ordersModel in orders) {
        if ([ordersModel isKindOfClass:[NSDictionary class]]) {
            HKOrderModel *order = [[HKOrderModel alloc] initWithDictionary:ordersModel];
            [tempOrders addObject:order];
        }
    }
    
    self.myOrdersArray = (NSArray*)tempOrders;
}

#pragma mark - HKMyOrderDelegate
-(void)viewButtonTappedWithSelectedCell:(HKMyOrderCell *)myOrderSelectedCell
{
    // move to details of an order ----
    self.modelObj = myOrderSelectedCell.orderModel;
    self.orderItemsArray = myOrderSelectedCell.orderModel.orderitems;
    
    // TODO : get the index from myOrderSelectedCell and send the modal to next screen
    [self performSegueWithIdentifier:@"myOrderDetail" sender:myOrderSelectedCell];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"myOrderDetail"])
    {
        
        HKMyOrderDetailViewController *destViewController = segue.destinationViewController;

        destViewController.orderModel = self.modelObj;
        destViewController.orderItems = self.orderItemsArray;
        
    }
}


#pragma mark - UITableview Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.myOrdersArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MyOrderCell";
    HKMyOrderCell *myOrderCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(myOrderCell == nil)
    {
        myOrderCell = (HKMyOrderCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyOrderCell" owner:self options:nil] objectAtIndex:0];
        myOrderCell.myOrderDeleagte = self;
    }

    myOrderCell.orderModel = [self.myOrdersArray objectAtIndex:indexPath.row];
    myOrderCell.tag = indexPath.row;
    [myOrderCell customiseViewButton];
    
    [myOrderCell updateOrderDetails];

    return myOrderCell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    
}


#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        switch (buttonIndex) {
            case 0:
            {
                
                UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
                
                [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
                    CGRect frame = self.slidingViewController.topViewController.view.frame;
                    self.slidingViewController.topViewController = newTopViewController;
                    self.slidingViewController.topViewController.view.frame = frame;
                    [self.slidingViewController resetTopView];
                }];
                
            }
                break;
            case 1:
            {
                //user wants to Sign-In.
                
                HKSignInViewController *signInView = (HKSignInViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
                signInView.signInDelegate = self;
                [self presentViewController:signInView animated:YES completion:nil];
                
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - sign in view controller delegate
-(void)userHasSignedInSuccessfully
{
    HKProfileMenuViewController *profileMenuController = (HKProfileMenuViewController *)self.slidingViewController.underLeftViewController;
    [profileMenuController updateLoginHeader];
    
}


@end
