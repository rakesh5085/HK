//
//  HKSelectAddressController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 25/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKSelectAddressController.h"
#import "HKSelectAddressCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "HKSignInViewController.h"
#import "HKProfileMenuViewController.h"
#import "HKAIViewController.h"

#import "HKAddressViewController.h"

#import "HKGlobal.h"

#import "HKConstants.h"

@interface HKSelectAddressController ()

@property (weak, nonatomic) IBOutlet UITableView *selectAddressTable;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) HKAIViewController *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noDataAvailableLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;

@property (nonatomic, strong) UIBarButtonItem *rightBarItem;


@end

@implementation HKSelectAddressController

@synthesize cancelButton = _cancelButton;

@synthesize fromScene;


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
    
//    _cancelButton.layer.cornerRadius = 3.0f;
//    _cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    _cancelButton.layer.borderWidth = 1.0f;
    [_cancelButton setHidden:YES];
    
    // initialize array of addresses
    self.addressArray = [[NSMutableArray alloc] init];
    self.selectAddressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
    [self.selectAddressTable setBackgroundColor:[UIColor clearColor]];
    
    // Call api to add an address
    // *******************************************
    self.selectAddressTable.hidden = YES;
    self.noDataAvailableLabel.hidden = YES;
    

}

-(void) viewWillAppear:(BOOL)animated
{
    [self.selectAddressTable reloadData];
    
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"emailAddress"];
    if(username && username.length > 0)
    {
        if(self.fromScene == COMINGFROM_LEFTPANE_MY_ADDRESSES)
        {
            [self fetchAddressFromLeftPane];
            
            self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(didTapEditButton:)];
            self.navigationItem.rightBarButtonItem = self.rightBarItem;
        }
        else
            [self fetchAllAddresses];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login to HealthKartPlus to continue" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign-In", nil];
        alert.tag = 10;
        [alert show];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.  SelectAddressCell
}

-(void)didTapEditButton:(id)sender
{
    if (self.selectAddressTable.editing)
    {
        self.selectAddressTable.editing = NO;
        self.rightBarItem.title = @"Edit";
    }
    else
    {
        self.selectAddressTable.editing = YES;
        self.rightBarItem.title = @"Done";
    }
}

#pragma mark - Search Button tapped
- (IBAction)searchBarButtonTapped:(id)sender
{
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
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
    if (self.activityIndicator != nil) {
        [self.activityIndicator stopAnimatingSpinner];
    }
    self.activityIndicator = nil;
}

-(void)fetchAddressFromLeftPane
{
    NSString *URL = [NSString stringWithFormat:@"http://staging.healthkartplus.com/webservices/address/listing"];
    
    __block HKSelectAddressController *blockSelfObject = self;
    [self showSpinnerWithMessage:@"Loading..."];// start the loader..
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         [self stopSpinner];
         self.selectAddressTable.hidden = NO;
         
         if([responseObject objectForKey:@"result"] && [[responseObject objectForKey:@"result"] isKindOfClass:[NSArray class]])
         {
             if(((NSArray *)[responseObject objectForKey:@"result"]).count>0)
             {
                 NSArray *arrayRecords = [responseObject objectForKey:@"result"];
                 
                 [blockSelfObject createAddressModels:arrayRecords];
                 
                 self.noDataAvailableLabel.hidden = YES;
                 [self.selectAddressTable reloadData]; // relaod the table now
             }
             else if(((NSArray *)[responseObject objectForKey:@"result"]).count == 0)
             {
                 // show the "No data availabel" label and hide table
                 self.noDataAvailableLabel.hidden = NO;
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error fetching addresses, try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             self.selectAddressTable.hidden = NO;
             self.noDataAvailableLabel.hidden = YES;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO:: handle error appropriately
         
         [self stopSpinner];
         self.selectAddressTable.hidden = NO;
         self.noDataAvailableLabel.hidden = YES;
     }];
}


-(void)fetchAllAddresses
{
    /*
     Call api to list addresses
     // *******************************************
     Parameters : nil
     Descriptions : list all addresses
     URL sample: @"http://staging.healthkartplus.com/webservices/address/currentorder"
     // *******************************************
     */
    
    [self showSpinnerWithMessage:@"Loading..."];// start the loader..
    
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"emailAddress"];
    if(username && username.length>0 )
    {
        NSString *Url = [NSString stringWithFormat:@"%@/address/currentorder", BaseURLString];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        // Cookie added inernally in the method , manually
        
        __block HKSelectAddressController *blockSelfObject = self;
        [manager POST:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"responseobject = %@",responseObject);
             [self stopSpinner];
             
             if([[responseObject objectForKey:@"Result"] isEqualToString:@"OK"])
             {
                 if([responseObject objectForKey:@"Records"] != (id)[NSNull null] && ((NSArray *)[responseObject objectForKey:@"Records"]).count>0)
                 {
                     NSArray *arrayRecords = [responseObject objectForKey:@"Records"];
                     
                     [blockSelfObject createAddressModels:arrayRecords];
                     
                     self.selectAddressTable.hidden = NO;
                     self.noDataAvailableLabel.hidden = YES;
                     [self.selectAddressTable reloadData]; // relaod the table now
                 }
                 else if(((NSArray *)[responseObject objectForKey:@"Records"]).count == 0)
                 {
                      // show the "No data availabel" label and hide table
                     self.selectAddressTable.hidden = YES;
                     self.noDataAvailableLabel.hidden = NO;
                     
                     if(self.fromScene == COMINGFROM_CHECKOUT_FLOW)
                     {
                         // take user directly to add to new screen
                         [self performSegueWithIdentifier:@"addAddressIdentifier" sender:self];
                     }
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseObject objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
                 self.selectAddressTable.hidden = NO;
                 self.noDataAvailableLabel.hidden = YES;
             }

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"error = %@",[error description]);
             [self stopSpinner];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"NSDebugDescription"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             self.selectAddressTable.hidden = NO;
             self.noDataAvailableLabel.hidden = YES;
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login to HealthKartPlus to continue" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - select address
-(void)selectAnAddress : (HKAddressModel *)addressModel
{
    /*
     Call api to select an address
     // *******************************************
     Parameters : listed below
     Descriptions : select an addresses
     URL sample: @"http://staging.healthkartplus.com/webservices/address/currentorder"
     
     // *******************************************
     */
    
    /* params:
     altContactNonull
     cityGurgaon
     contactNo“”
     countryINDIA
     deletednull
     Id2024 (in case of selecting a address)
     namekjkj
     notesnull
     pincode122001
     selectedtrue
     stateHaryana
     street1kjnjk
     street2
     UserId“”
     verifyAddresstrue
     */
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    NSLog(@"array = %@",self.addressArray);
    //    NSLog(@"address dictionary: %@", self.addressDict);
    
    NSString *addAddressUrl = [NSString stringWithFormat:@"%@/order/address/order/update", BaseURLString];
    
    //__block HKAddressViewController *blockSelf = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"user id in user defaults : %@", [NSString stringWithFormat:@"%@", [[defaults objectForKey:@"userInfo"] valueForKey:@"userid"]]);
    
    NSDictionary *addressAttributesDict = @{@"altContactNo": @"", @"city":addressModel.city,@"contactNo":addressModel.contactNo,@"country":@"india",@"name":addressModel.name, @"pincode": addressModel.pincode, @"state": addressModel.state, @"street1": addressModel.street1, @"street2": addressModel.street2, @"userId": [[defaults objectForKey:@"userInfo"] valueForKey:@"userid"], @"id": addressModel.address_id, @"notes": @"null", };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Cookie added inernally in the method , manually
    
    [manager POST:addAddressUrl parameters:addressAttributesDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         
         [self stopSpinner];
         
         if([[responseObject objectForKey:@"Result"] isEqualToString:@"OK"])
         {
             // place the order
             // http://staging.healthkartplus.com/webservices/order/confirm
             
             [self placeOder];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error Selecting address, try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self stopSpinner];
         NSLog(@"error = %@",[error description]);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error selecting an address , try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
     }];
}

#pragma mark - place an order

-(void)placeOder
{
    // http://staging.healthkartplus.com/webservices/order/confirm
    // device=”device type (android/iphone)” , "iphone in our case"
    
    NSString *orderUrl = [NSString stringWithFormat:@"%@/order/confirm", BaseURLString];
    
    NSDictionary *parameterDictionary = @{@"device": @"iphone"};
    
    [self showSpinnerWithMessage:@"Placing Order..."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:orderUrl parameters:parameterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         id arrResult = [responseObject objectForKey:@"result"];
         [self stopSpinner];
         
         if((responseObject  != (id)[NSNull null]) && (arrResult  != (id)[NSNull null]) )
         {
             // Remove all cart items ..
             // TODO: sdfsdf
             [[HKGlobal sharedHKGlobal].cartItemsGlobalArray removeAllObjects];
             
             // take it back to confirmation page
             [self performSegueWithIdentifier:@"selectAndConfirm" sender:self];
         }
         else
         {
             id errors = [responseObject valueForKey:@"errors"];
             id errs = [errors valueForKey:@"errs"];
             
             if (errs && [errs isKindOfClass:[NSArray class]])
             {
                 id error = [errs objectAtIndex:0];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self stopSpinner];
         //TODO:: handle error appropriately
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.debugDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
     }];
}

#pragma mark - create address models
// create address model and initialize them
-(void)createAddressModels :(NSArray *)addressesArray
{
    [self.addressArray removeAllObjects];
    
    for (id addressModel in addressesArray) {
        if ([addressModel isKindOfClass:[NSDictionary class]]) {
            HKAddressModel *address = [[HKAddressModel alloc] initWithDictionary:addressModel];
            [self.addressArray addObject:address];
        }
    }
}

#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"addAddressIdentifier"])
    {
    HKAddressViewController *destinationController = [segue destinationViewController];
    if(self.fromScene == COMINGFROM_LEFTPANE_MY_ADDRESSES)
    {
        destinationController.fromScene = COMINGFROM_LEFTPANE_MY_ADDRESSES;
//        destinationController.newAddressDelegate = self;
    }
    else
        destinationController.fromScene = COMINGFROM_CHECKOUT_FLOW;
    }
}

-(void)moveToNewAddressScreen
{
    [self performSegueWithIdentifier:@"addAddressIdentifier" sender:self];
}

#pragma mark - delegate of new address screen
-(void)newAddressAdded
{
    [self.selectAddressTable reloadData];
}

#pragma mark - table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.addressArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SelectAddressCell";
    HKSelectAddressCell *selectAddressCell = (HKSelectAddressCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(selectAddressCell == nil)
    {
        selectAddressCell = (HKSelectAddressCell *)[[[NSBundle mainBundle] loadNibNamed:@"SelectAddressCell" owner:self options:nil] objectAtIndex:0];
    }
    
    selectAddressCell.addressModel = [self.addressArray objectAtIndex:indexPath.row];
    [selectAddressCell configureAddressCell];
    
    return selectAddressCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    headerView.backgroundColor = [UIColor clearColor];
    
    if(!self.fromScene == COMINGFROM_LEFTPANE_MY_ADDRESSES)
    {
        UIView * uppperView =[ [UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        uppperView.backgroundColor = [UIColor whiteColor];
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 7.5, 250, 25)];
        label.text = @"Choose an address";
        label.backgroundColor = [UIColor clearColor];
    
        [uppperView addSubview:label];
        [headerView addSubview:uppperView];
    }
    else
    {
        UIView * uppperView =[ [UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        uppperView.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 7.5, 300, 25)];
        [btn addTarget:self action:@selector(moveToNewAddressScreen) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"Add a new address" forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = [UIColor blackColor];
        btn.backgroundColor = [UIColor clearColor];
        
        [uppperView addSubview:btn];
        [headerView addSubview:uppperView];
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"goConfirmation" sender:self];
    if(self.fromScene  == COMINGFROM_CHECKOUT_FLOW)
    {
        [self selectAnAddress:[self.addressArray objectAtIndex:indexPath.row]];
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //http://staging.healthkartplus.com/webservices/address/delete?id={addressId}
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    HKAddressModel *addressModel = [self.addressArray objectAtIndex:indexPath.row];
    NSString *selectPrescriptionUrl = [NSString stringWithFormat:@"%@/address/delete", BaseURLString];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:addressModel.address_id, @"id", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    __block HKSelectAddressController *blockSelf = self;
    [manager POST:selectPrescriptionUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Address deleted successfully");
        [blockSelf stopSpinner];
        [blockSelf.addressArray removeObject:addressModel];
        [blockSelf.selectAddressTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [blockSelf stopSpinner];
        
    }];
}

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


//http://staging.healthkartplus.com/webservices/address/currentorder

@end
