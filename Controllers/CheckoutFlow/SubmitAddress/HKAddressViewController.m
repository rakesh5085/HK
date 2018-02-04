//
//  HKAddressViewController.m
//  HealthKart+
//
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKAddressViewController.h"
#import "HKAddressCell.h"
#import "AFNetworking.h"
#import "HKConstants.h"

#import "HKAIViewController.h"

#import "HKGlobal.h"

#define kTag_Address_button 101

@interface HKAddressViewController ()
{
    NSArray *addressLabelArray;
    HKAddressCell *addressCell;
    
    NSString *myCity, *myState;
}

@property (nonatomic , strong) NSMutableArray *addressTextfieldValuesArray;
@property (weak, nonatomic) IBOutlet UITableView *addressTableview;
@property (weak, nonatomic) IBOutlet UIView *addressBottomView;
@property (weak, nonatomic) IBOutlet UIButton *shipAddressButton;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) HKAIViewController *activityIndicator;


// address dictionary to be passed to the post request of submitting an address
@property (nonatomic, strong) NSMutableDictionary *addressDict;

@end

@implementation HKAddressViewController


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
    self.index = 0;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat heightOfScreen = screenSize.height;
    
    [addressCell.attributeTextfield becomeFirstResponder];
    
    if(heightOfScreen == SCREEN_HEIGHT_480)
    {
        [self.addressTableview setFrame:CGRectMake(self.addressTableview.frame.origin.x, self.addressTableview.frame.origin.y , self.addressTableview.frame.size.width, self.addressTableview.frame.size.height)];
        [self.addressBottomView setFrame:CGRectMake(self.addressBottomView.frame.origin.x, self.addressBottomView.frame.origin.y - 87 , self.addressBottomView.frame.size.width, self.addressBottomView.frame.size.height)];
    }
    
    addressLabelArray = [NSArray arrayWithObjects:@"Patient",@"Address Line #1",@"Address Line #2",@"Landmark",@"Contact no.",@"Pincode",@"City",@"State", nil];
    self.addressTextfieldValuesArray = [[NSMutableArray alloc] init];
    
    // Filling self.addressTextfieldValuesArray with blank data.. so that later on these blank values can be replaced with actual values
    for (int i = 0; i<[addressLabelArray count]; i++)
    {
        [self.addressTextfieldValuesArray addObject:@""];
    }
    
    // initialize the address dict to be passed along with the post request
    self.addressDict = [[NSMutableDictionary alloc] init];
    
    //Customising view on basis of enum defined
    if(self.fromScene == COMINGFROM_LEFTPANE_MY_ADDRESSES)
    {
        // Change the text of "Ship to this address" button
        [self.shipAddressButton setTitle:@"Add this Address" forState:UIControlStateNormal];
    }
    else
    {
        // If not enterning from left pane
        [self.shipAddressButton setTitle:@"Ship to this Address" forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

-(void)handleTap: (id)sender
{
    // resign keyboard or end editing of complete view
    [self.addressTableview endEditing:YES];
}


#pragma mark - table view delegates/ datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"HKAddressCell";
    addressCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(addressCell == nil)
    {
        addressCell = (HKAddressCell *)[[[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil] objectAtIndex:0];
        addressCell.addressCellDelegate = self;

        if(!(indexPath.row == 2 || indexPath.row == 3))
        {
            [addressCell.attributeTextfield setPlaceholder:@"Required" ];
        }
        
        if(indexPath.row == 4 || indexPath.row == 5)
        {
            addressCell.attributeTextfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            addressCell.attributeTextfield.keyboardType = UIKeyboardTypeDefault;
        }
    }

    addressCell.attributeLabel.text = [addressLabelArray objectAtIndex:indexPath.row];
//    if(indexPath.row != 6 && indexPath.row != 7)
        addressCell.attributeTextfield.text = [self.addressTextfieldValuesArray objectAtIndex:indexPath.row];
    
//    if(myCity && indexPath.row == 6)
//    {
//        addressCell.attributeTextfield.text = myCity;
////        addressCell.attributeLabel.text = @"City";
//    }
//    if(myCity && indexPath.row == 7)
//    {
//        if(myState)
//            addressCell.attributeTextfield.text = myState;
//        else
//            addressCell.attributeTextfield.text = myCity;
////        addressCell.attributeLabel.text = @"State";
//    }
    
    addressCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return addressCell;
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

#pragma mark - add Address button tapped
- (void)addAnAddress
{
    /*
     Call api to add an address
     // *******************************************
     Parameters : @name, @pageSize
     @name : keyword to search medicin for
     @pageSize : Number of results
     URL sample: @"http://staging.healthkartplus.com/webservices/order/address/order/update"
     Parameters
     "altContactNo = null
     city = DELHI
     ContactNo = “”
     country = INDIA
     name = Test One
     pincode = 110021
     state = DELHI
     street1 = Test Street one
     street2 = Near Test Street Two
     userId = “”"
     // *******************************************
     */
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    NSLog(@"array = %@",self.addressTextfieldValuesArray);
//    NSLog(@"address dictionary: %@", self.addressDict);

    NSString *addAddressUrl = [NSString stringWithFormat:@"%@/order/address/order/update", BaseURLString];
    
    //__block HKAddressViewController *blockSelf = self;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"userInfo in user defaults : %@", [NSString stringWithFormat:@"%@", [[defaults objectForKey:@"userInfo"] valueForKey:@"userid"]]);
    
    NSDictionary *addressAttributesDict = @{@"altContactNo": @"", @"city":[self.addressTextfieldValuesArray objectAtIndex:6],@"contactNo":[self.addressTextfieldValuesArray objectAtIndex:4],@"country":@"india",@"name":[self.addressTextfieldValuesArray objectAtIndex:0],@"pincode": [self.addressTextfieldValuesArray objectAtIndex:5], @"state": [self.addressTextfieldValuesArray objectAtIndex:7], @"street1": [self.addressTextfieldValuesArray objectAtIndex:1], @"street2": [self.addressTextfieldValuesArray objectAtIndex:2], @"userId": [[defaults objectForKey:@"userInfo"] valueForKey:@"userid"]};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // Cookie added inernally in the method , manually
    [manager POST:addAddressUrl parameters:addressAttributesDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         
         [self stopSpinner];
         
         if([[responseObject objectForKey:@"Result"] isEqualToString:@"OK"])
         {
             if (self.fromScene == COMINGFROM_LEFTPANE_MY_ADDRESSES)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Address added!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
             }
             else
             {
                 //address successfully added. call upload API
                 if([responseObject objectForKey:@"errors"] == (id)[NSNull null])
                 {
                     // Remove all cart items ..
                     [[HKGlobal sharedHKGlobal].cartItemsGlobalArray removeAllObjects];
                 }
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error adding address, Please check all the fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error = %@",[error description]);
     }];
    
}

// Place order in case user is coming from check out flow
#pragma mark - place order
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
         NSArray *arrResult = [responseObject objectForKey:@"result"];
         [self stopSpinner];
         
         if((responseObject  != (id)[NSNull null]) && (arrResult  != (id)[NSNull null]) )
         {
             // Remove all cart items ..
             [[HKGlobal sharedHKGlobal].cartItemsGlobalArray removeAllObjects];
             
             // take it back to confirmation page
             [self performSegueWithIdentifier:@"ConfirmOrder" sender:self];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ship / Add address button tapped

- (IBAction)shipButtonClicked:(id)sender
{
    //Customising view on basis of enum defined
    if(self.fromScene == COMINGFROM_LEFTPANE_MY_ADDRESSES)
    {
        if([[self.addressTextfieldValuesArray objectAtIndex:self.index] isEqualToString:@"" ])
        {
            UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [missingInfo show];
            
        }else if([[self.addressTextfieldValuesArray objectAtIndex:self.index+1] isEqualToString:@"" ]){
            
            UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [missingInfo show];
            
        }else if([[self.addressTextfieldValuesArray objectAtIndex:self.index+4] isEqualToString:@"" ]){
            
            UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [missingInfo show];
            
        }else if([[self.addressTextfieldValuesArray objectAtIndex:self.index+5] isEqualToString:@"" ]){
            
            UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [missingInfo show];
            
        }else{
            
            // add an address if user is coming from left pane and wants to add an address
            [self addAnAddress];
        }
    }
    else if(self.fromScene == COMINGFROM_CHECKOUT_FLOW)
    {
            if([[self.addressTextfieldValuesArray objectAtIndex:self.index] isEqualToString:@"" ]){
                
                UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [missingInfo show];
                
            }else if([[self.addressTextfieldValuesArray objectAtIndex:self.index+1] isEqualToString:@"" ]){
                
                UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [missingInfo show];
                
            }else if([[self.addressTextfieldValuesArray objectAtIndex:self.index+4] isEqualToString:@"" ]){
                
                UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [missingInfo show];
                
            }else if([[self.addressTextfieldValuesArray objectAtIndex:self.index+5] isEqualToString:@"" ]){
                
                UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [missingInfo show];
                
            }else if([[self.addressTextfieldValuesArray objectAtIndex:self.index+6] isEqualToString:@"" ]){
                
                UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Details Missing" message:@"Please fill in the necessary fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [missingInfo show];
                
            }else{
                [self selectThisAddressForOrderPlacement];
    
            }
    }
}

#pragma mark - select address
-(void)selectThisAddressForOrderPlacement
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
    
    NSLog(@"array = %@",self.addressTextfieldValuesArray);
    //    NSLog(@"address dictionary: %@", self.addressDict);
    
    NSString *addAddressUrl = [NSString stringWithFormat:@"%@/order/address/order/update", BaseURLString];
    
    //__block HKAddressViewController *blockSelf = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"user id in user defaults : %@", [NSString stringWithFormat:@"%@", [[defaults objectForKey:@"userInfo"] valueForKey:@"userid"]]);
    
    NSDictionary *addressAttributesDict = @{@"altContactNo": @"7838234557", @"city":[self.addressTextfieldValuesArray objectAtIndex:5],@"contactNo":@"7838234557",@"country":@"india",@"name":[self.addressTextfieldValuesArray objectAtIndex:0],@"pincode": [self.addressTextfieldValuesArray objectAtIndex:4], @"state": [self.addressTextfieldValuesArray objectAtIndex:6], @"street1": [self.addressTextfieldValuesArray objectAtIndex:1], @"street2": [self.addressTextfieldValuesArray objectAtIndex:2], @"userId": [[defaults objectForKey:@"userInfo"] valueForKey:@"userid"]};
    
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
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         NSLog(@"error = %@",[error description]);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Error selecting an address , try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HKAddressCellDelegate
-(void)valueOfCurrentTextfieldAfterEditingWithSelectedCell:(HKAddressCell *)selectedAddressCell
{
    NSIndexPath *selectedIndexPath = [self.addressTableview indexPathForCell:selectedAddressCell];
    
    [self.addressTextfieldValuesArray replaceObjectAtIndex:selectedIndexPath.row withObject:selectedAddressCell.attributeTextfield.text];
    
}

-(void)getCityAndStateFromEnteredPincode:(NSString*)pincode
{
    if(pincode.length == 6)
    {
    
        [self showSpinnerWithMessage:@"Loading..."];
        
        NSString *pincodeURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", pincode];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        // Cookie added inernally in the method , manually
        [manager GET:pincodeURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [self stopSpinner];
             if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
             {
                 id result = [responseObject valueForKey:@"results"];
                 if (result && [result isKindOfClass:[NSArray class]] && [result count]>0)
                 {
                     // search now for 'India' in "formatted_address" key array 'results' of dictionaries
                     BOOL isCityFound = NO;
                     NSString *city;
                     NSString *state;
                     
                     for (id obj in result)
                     {
                         if (obj && [obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"formatted_address"])
                         {
                             NSString *stringAddress = [obj objectForKey:@"formatted_address"];
                             if([stringAddress rangeOfString:@"India"].location != NSNotFound)
                             {
                                 NSLog(@"location found");
                                 id addressComponents = [obj objectForKey:@"address_components"];
                                 for (id component in addressComponents)
                                 {
                                     id types = [component valueForKey:@"types"];
                                     if (types && [types isKindOfClass:[NSArray class]])
                                     {
                                         for (id type in types)
                                         {
                                             if ([type isEqualToString:@"locality"])
                                             {
                                                 city = [component valueForKey:@"long_name"];
                                                 NSLog(@"city: %@", city);
                                                 
                                                 isCityFound = YES;
                                             }
                                             else if ([type isEqualToString:@"administrative_area_level_2"])
                                             {
                                                 state = [component valueForKey:@"long_name"];
                                                 NSLog(@"state: %@", state);
                                                 myState = [[NSString alloc] initWithString:state];
                                             }
                                         }
                                         
                                         // break if city and state both found
                                         if(isCityFound )
                                         {
                                             break;
                                         }
                                     }
                                 }
                                 
                                 // break if city and state both found
                                 if(isCityFound)
                                 {
                                     break;
                                 }
                             }
                         }
                     }
                     
                     // break if city and state both found
                     // New Delhi || Noida || Gurgaon
                     if(isCityFound && ([city isEqualToString:@"New Delhi"] || [city isEqualToString:@"Noida"] || [city isEqualToString:@"Gurgaon"]))
                     {
                         if (!state) // if state not found
                         {
                             [self.addressTextfieldValuesArray replaceObjectAtIndex:6 withObject:city];
                             [self.addressTextfieldValuesArray replaceObjectAtIndex:7 withObject:city];
                         }
                         else
                         {
                             [self.addressTextfieldValuesArray replaceObjectAtIndex:6 withObject:city];
                             [self.addressTextfieldValuesArray replaceObjectAtIndex:7 withObject:state];
                         }

                         [self.addressTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:6 inSection:0], [NSIndexPath indexPathForRow:7 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                     }
                     else
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"please enter pincode for Delhi, NCR only" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"please enter pincode for Delhi, NCR only" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"please enter pincode for Delhi, NCR only" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
             
             [self stopSpinner];
             NSLog(@"error = %@",[error description]);
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"please enter correct pincode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
