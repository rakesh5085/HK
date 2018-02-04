//
//  HKReorderViewController.m
//  HealthKart+
//  Rakesh
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKReorderViewController.h"
#import "HKSelectPrescriptionCell.h"
#import "AFNetworking.h"
#import "HKGlobal.h"
#import "HKCheckoutViewController.h"
#import "HKAddPrescriptionController.h"
#import "HKSignInViewController.h"
#import "HKProfileMenuViewController.h"

#import "HKConstants.h"

@interface HKReorderViewController ()
{
    HKGlobal *sharedGlobalObj;
    
    AFHTTPRequestOperation *operation;
    
    NSString *myPrescriptionURL;
}

@property (weak, nonatomic) IBOutlet UITableView *reorderTableview;
@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;
@property (weak, nonatomic) IBOutlet UIButton *reorderButton;
@property (weak, nonatomic) IBOutlet UIView *noPrescriptionsView;


@property (strong, nonatomic)    NSMutableArray *prescriptionsArray;

@property (nonatomic, strong) HKAIViewController *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *noDataAvailableLabel;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@end

@implementation HKReorderViewController

@synthesize reorderTableview = _reorderTableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - view cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    sharedGlobalObj = [HKGlobal sharedHKGlobal];
    
//    // Calling method to load uploaded prescription.
//    [self listPrescriptions];
    
    self.reorderButton.layer.cornerRadius = 3.0f;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat heightOfScreen = screenSize.height;
    if(heightOfScreen == SCREEN_HEIGHT_480)
    {
        [self.reorderButton setFrame:CGRectMake(self.reorderButton.frame.origin.x, self.reorderButton.frame.origin.y - 88, self.reorderButton.frame.size.width, self.reorderButton.frame.size.height)];
    }
    self.selectedIndexPaths = [[NSMutableArray alloc] init];
    
    // Hide the NoPrescriptionView if self.selectedIndexPaths array is nil
    if([self.selectedIndexPaths count]== 0)
        [self.noPrescriptionsView setHidden:YES];
    
    //Customising view on basis of enum defined 
    switch (self.fromScene)
    {
        case COMINGFROM_LEFTPANE_MYPRESCRIPTION:
        {
            [self.reorderTableview setFrame:CGRectMake(self.reorderTableview.frame.origin.x, self.reorderTableview.frame.origin.y, 320, self.reorderTableview.frame.size.height+53)];
            [self.reorderButton setHidden:YES];
            self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(didTapEditButton:)];
            self.navigationItem.rightBarButtonItem = self.rightBarItem;
            self.navigationItem.title = @"Prescriptions";
            
            //  http://staging.healthkartplus.com/webservices/prescription/all
            myPrescriptionURL = @"http://staging.healthkartplus.com/webservices/prescription/all";
        }
            break;
        case COMINGFROM_LEFTPANE_REORDER:
        {
            [self.reorderButton setHidden:NO];
            [self.reorderButton setTitle:@"Re-Order" forState:UIControlStateNormal];
            self.navigationItem.title = @"Re-Order";
        }
            break;
        case COMINGFROM_CHECKOUT:
        {
            [self.reorderButton setHidden:YES];
            self.navigationItem.title = @"Prescriptions";
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
            [self.navigationItem setLeftBarButtonItem:cancelItem];
            [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        }
            break;
        case COMINGFROM_MYORDERS:
        {
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
            [self.navigationItem setLeftBarButtonItem:cancelItem];
            [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
            
            self.title = @"Re-Order";
        }
            break;
        default:
            break;
    }
    
    // remove separators
    self.reorderTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Initialize array of presc
    self.prescriptionsArray = [[NSMutableArray alloc] init];
    
    // hide no data label intially
    self.noDataAvailableLabel.hidden = YES;
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

-(void)didTapEditButton:(id)sender
{
    if (self.reorderTableview.editing) {
        self.reorderTableview.editing = NO;
        self.rightBarItem.title = @"Edit";
    }
    else
    {
        self.reorderTableview.editing = YES;
        self.rightBarItem.title = @"Done";
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"Re order";
    
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"emailAddress"];
    if(username && username.length > 0)
    {
        if (self.fromScene == COMINGFROM_LEFTPANE_MYPRESCRIPTION)
            [self listPrescriptionForMyPrescriptionLeftPane];
        else
            [self listPrescriptions];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - search bar button item tapped
- (IBAction)searchBarButtonTapped:(id)sender {
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

-(void)listPrescriptionForMyPrescriptionLeftPane
{
    NSString *prescURL = [NSString stringWithFormat:@"http://staging.healthkartplus.com/webservices/prescription/all"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    [manager GET:prescURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         NSArray *result = [responseObject objectForKey:@"result"];
         
         if((result  != (id)[NSNull null]) && result.count > 0)
         {
             self.reorderTableview.hidden = NO;
             self.noDataAvailableLabel.hidden = YES;
             self.reorderButton.enabled = YES; // enable reorder button if there some records
             
             // initialize data models for added prescriptions
             [self createPrescriptionModelsForMyPrescriptions:result];
             
             [self.reorderTableview reloadData]; // relaod the table now
         }
         else
         {
             self.reorderButton.enabled = NO;
             if(result.count == 0) // show no prescriptions view
             {
                 self.reorderTableview.hidden = YES;
                 self.noPrescriptionsView.hidden = NO;
             }
             else
             if ([[responseObject objectForKey:@"status"] integerValue] == 1)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseObject objectForKey:@"op"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
                 
                 self.reorderTableview.hidden = YES;
                 self.noPrescriptionsView.hidden = YES;
             }
         }
         
         [self stopSpinner];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failure123 (Reorder view controller) = %@",[error description]);
         [self stopSpinner];
         
         if(error.code == 3840 )
         {
             // auto sign in
             [self showSpinnerWithMessage:@"Signing in..."];
             [HKGlobal sharedHKGlobal].globalDelegate = self;
             [[HKGlobal sharedHKGlobal] autoSignIn];
         }
         self.reorderTableview.hidden = YES;
         self.noPrescriptionsView.hidden = YES;
         self.reorderButton.enabled = NO;
     }];
}


#pragma mark - list all prescriptions
//http://staging.healthkartplus.com/webservices/order/attachments

-(void)listPrescriptions
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString;
    
    if(self.fromScene == COMINGFROM_LEFTPANE_MYPRESCRIPTION)
        URLString = myPrescriptionURL;
    else
        URLString = @"http://staging.healthkartplus.com/webservices/order/attachments";
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:nil];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://staging.healthkartplus.com/authenticate"]];
    NSDictionary *cookiesDictionary = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    if (cookiesDictionary) {
        [request setAllHTTPHeaderFields:cookiesDictionary];
    }
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    if(operation)
    {
        [operation cancel];
        operation.completionBlock = nil;
    }
    
    operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"response : %@", responseObject);
        if([[responseObject objectForKey:@"Result"] isEqualToString:@"OK"])
        {
            if([responseObject objectForKey:@"Records"] != (id)[NSNull null] && ((NSArray *)[responseObject objectForKey:@"Records"]).count>0)
            {
                NSArray *array_prescriptions = [responseObject objectForKey:@"Records"];
                NSLog(@"(ReOrderVC) list presc - Response : %@", responseObject);
                self.reorderTableview.hidden = NO;
                self.noDataAvailableLabel.hidden = YES;
                self.reorderButton.enabled = YES; // enable reorder button if there some records
                
                // initialize data models for added prescriptions
                [self createPrescriptionModels:array_prescriptions];
                
                [self.reorderTableview reloadData]; // relaod the table now
            }
            else if (((NSArray *)[responseObject objectForKey:@"Records"]).count == 0)
            {
                // show the "No data availabel" label and hide table
                self.reorderTableview.hidden = YES;
                self.noDataAvailableLabel.hidden = NO;
                self.reorderButton.enabled = NO;
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseObject objectForKey:@"op"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            self.reorderTableview.hidden = YES;
            self.noPrescriptionsView.hidden = YES;
            self.reorderButton.enabled = NO;
        }
        [self stopSpinner];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"failure123 (Reorder view controller) = %@",[error description]);
        
        [self stopSpinner]; 
        
        if(error.code == 3840 )
        {
            // auto sign in
            [self showSpinnerWithMessage:@"Signing in..."];
            [HKGlobal sharedHKGlobal].globalDelegate = self;
            [[HKGlobal sharedHKGlobal] autoSignIn];
        }

        self.reorderTableview.hidden = YES;
        self.noPrescriptionsView.hidden = YES;
        self.reorderButton.enabled = NO;
    }];
    
    [manager.operationQueue addOperation:operation];
}



#pragma mark - select a prescription
-(void)selectPrescription: (HKAddedPrescriptionModel *)prescModel
{
    /*
     Call api to select an address
     // *******************************************
     Parameters : listed below
     Descriptions : select an addresses
     URL sample: http://staging.healthkartplus.com/webservices/prescription/{prescriptionId}
     
     // *******************************************
     */
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    NSString *selectPrescriptionUrl = [NSString stringWithFormat:@"%@/prescription/%@", BaseURLString, prescModel.prescription_id];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Cookie added inernally in the method , manually
    
    [manager GET:selectPrescriptionUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         
         [self stopSpinner];
         
         if([responseObject objectForKey:@"errors"]  == (id)[NSNull null])
         {
             if (self.reorderDelegate && [self.reorderDelegate respondsToSelector:@selector(didSelectPreviousAddedPrescription:)]) {
                 [self.reorderDelegate didSelectPreviousAddedPrescription:prescModel];
             }
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error adding address, Please check all the fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error = %@",[error description]);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error selecting an address , try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         [self stopSpinner];
     }];
}

#pragma mark -
-(void)createPrescriptionModels : (NSArray *)arrayPresc
{
    for (NSDictionary *dict in arrayPresc)
    {
        HKAddedPrescriptionModel *aPrescriptionModel = [[HKAddedPrescriptionModel alloc] initWithDictionary:dict];
        [self.prescriptionsArray addObject:aPrescriptionModel];
    }
}

-(void)createPrescriptionModelsForMyPrescriptions : (NSArray *)arrayPresc
{
    for (NSDictionary *dict in arrayPresc)
    {
        HKAddedPrescriptionModel *aPrescriptionModel = [[HKAddedPrescriptionModel alloc] initWithDictionaryForMyPrescriptions:dict];
        [self.prescriptionsArray addObject:aPrescriptionModel];
    }
}


#pragma mark - global delegate
-(void)signInResponseReceived
{
    NSLog(@"auto sign in complete");
    [self stopSpinner];
}


# pragma mark - UITableView Datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.prescriptionsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SelectPrescriptionCell";
    HKSelectPrescriptionCell *selectPrescriptionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(selectPrescriptionCell == nil)
    {
        selectPrescriptionCell = (HKSelectPrescriptionCell *)[[[NSBundle mainBundle] loadNibNamed:@"SelectPrescriptionCell" owner:self options:nil] objectAtIndex:0];
    }
    selectPrescriptionCell.prescriptionModel = [self.prescriptionsArray objectAtIndex:indexPath.row];
    selectPrescriptionCell.prescriptionModel.prescriptionDelegate = selectPrescriptionCell;
    if ([self.selectedIndexPaths containsObject:indexPath])
        selectPrescriptionCell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        selectPrescriptionCell.accessoryType = UITableViewCellAccessoryNone;
    
    // Configure cell
    [selectPrescriptionCell customizeCell];
    
    return selectPrescriptionCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.fromScene == COMINGFROM_CHECKOUT)
    {
        //call API to select a perscription
        // http://staging.healthkartplus.com/webservices/prescription/{prescriptionId}
        
        [self selectPrescription:(HKAddedPrescriptionModel *)[self.prescriptionsArray objectAtIndex:indexPath.row]];
    }
    else if((self.fromScene == COMINGFROM_LEFTPANE_REORDER) || (self.fromScene == COMINGFROM_MYORDERS))
    {
        // Select a row first
        if ([self.selectedIndexPaths containsObject:indexPath])
            [self.selectedIndexPaths removeObject:indexPath];
        else
            [self.selectedIndexPaths addObject:indexPath];
        [self.reorderTableview reloadData];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //http://staging.healthkartplus.com/admin/webservices/document/delete?id={prescriptionId}
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    HKAddedPrescriptionModel *prescription = [self.prescriptionsArray objectAtIndex:indexPath.row];
    NSString *selectPrescriptionUrl = [NSString stringWithFormat:@"http://staging.healthkartplus.com/admin/webservices/document/delete"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:prescription.prescription_id, @"id", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    __block HKReorderViewController *blockSelf = self;
    [manager POST:selectPrescriptionUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"prescription deleted successfully");
        [blockSelf stopSpinner];
        [blockSelf.prescriptionsArray removeObject:prescription];
        [blockSelf.reorderTableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [blockSelf stopSpinner];
        
    }];
}

#pragma mark - reorder/Continue button tapped

- (IBAction)reorderButtonClicked:(id)sender
{
    //Customising view on basis of enum defined
    switch (self.fromScene)
    {
        case COMINGFROM_LEFTPANE_MYPRESCRIPTION:
        {

        }
            break;
        case COMINGFROM_LEFTPANE_REORDER:
        {
           // reoder Items
            if(self.selectedIndexPaths.count>0)
                [self reOrderItems];
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Pleaase select a prescription" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
        case COMINGFROM_CHECKOUT: // Continue button will be shown  in this case
        {
            // on tap of continue button take user to Add another prescription
            [self performSegueWithIdentifier:@"addAnotherPresc" sender:self]; // go to add another prescription
        }
            break;
        case COMINGFROM_MYORDERS:
        {
            // reoder Items
            [self reOrderItems];
        }
            break;
        default:
            break;
    }
}

-(void)reOrderItems
{
    /* Description:  Reorder by selecting prescriptions
     
     URL : http://staging.healthkartplus.com/webservices/order/prescription/alreadyPresent
     
     Parameters:
     "file=”multipart file”,(can be ommitted)
     documantId=”documentId”,
     Street1 = “”,
     Street2 =””
     City=””,
     Pincode=””,
     country=””
     name=””
     contactNo=””
     altContactNo=””
     notes=””
     UserId=””"	POST
     */
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    //  ************ selected prescriptions IDs *********
    NSMutableString *stringIDs = [[NSMutableString alloc] init];
    for (NSIndexPath *indexPath in self.selectedIndexPaths)
    {
        HKAddedPrescriptionModel *prescModel = ((HKAddedPrescriptionModel *)[self.prescriptionsArray objectAtIndex:indexPath.row]);
        [stringIDs appendString:[NSString stringWithFormat:@"%@,",prescModel.prescription_id]];
    }
    if ( [stringIDs length] > 0)
        stringIDs = (NSMutableString *)[stringIDs substringToIndex:[stringIDs length] - 1];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *params = @{@"documantId": stringIDs, @"userId": [[defaults objectForKey:@"userInfo"] valueForKey:@"userid"], @"contactNo":@"7838234557"};
    
    NSString *selectPrescriptionUrl = [NSString stringWithFormat:@"%@/order/prescription/alreadyPresent", BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Cookie added inernally in the method , manually
    [manager POST:selectPrescriptionUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         
         [self stopSpinner];
         
         if([responseObject objectForKey:@"errors"] == (id)[NSNull null])
         {
             [self displayCustomAlert];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[responseObject objectForKey:@"op"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error = %@",[error description]);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error selecting an address , try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
     }];
}


#pragma mark - show custom alert view
-(void)displayCustomAlert
{
    // Here we need to pass a full frame
    HKCustomAlertView *alertView = [[HKCustomAlertView alloc] init];
    alertView.delegate = self;
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createViewForAlert]];
    
    // Modify the parameters
    [alertView setButtonTitles:nil];//[NSMutableArray arrayWithObjects:@"Close1", @"Close2", @"Close3", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(HKCustomAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (void)customDialogButtonTouchUpInside: (HKCustomAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %ld.", buttonIndex, (long)[alertView tag]);
    [alertView close];
    
    // order alert has been closed , now go back to previous page
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)createViewForAlert
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    
    // Adding Imageview
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 30, 30, 30)];
    [imageView setImage:[UIImage imageNamed:@"check"]];
    [demoView addSubview:imageView];
    
    //Adding UIlabel as title.
    UILabel *alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 150, 21)];
    alertTitleLabel.text = @"Order Placed!";
    alertTitleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    alertTitleLabel.textColor = [UIColor blueColor];
    [demoView addSubview:alertTitleLabel];
    
    //Adding UIlabel as description.
    UILabel *alertdescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 270, 65)];
    alertdescriptionLabel.numberOfLines = 3;
    alertdescriptionLabel.font = [UIFont systemFontOfSize:14.0f];
    alertdescriptionLabel.text = @"Our agent will call you soon to confirm your order.Thanks for shopping with HealthKartPlus:)";
    alertdescriptionLabel.textColor = [UIColor blueColor];
    [demoView addSubview:alertdescriptionLabel];
    
    // Setting Demoview
    demoView.layer.cornerRadius = 5.0f;
    demoView.layer.borderColor = [[UIColor greenColor] CGColor];
    demoView.layer.borderWidth = 2.0f;
    
    return demoView;
}

#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        switch (buttonIndex)
        {
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
