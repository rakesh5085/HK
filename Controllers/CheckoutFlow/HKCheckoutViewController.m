    //
//  HKCheckoutViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 24/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

// Usage:
// Just fetches images from camera or album and pass this image to add prescription controller

#import "HKCheckoutViewController.h"
#import "HKAddPrescriptionController.h"
#import "HKConstants.h"
#import "HKAddPrescriptionController.h"
#import "HKSelectAddressController.h"

#import "AFNetworking.h"

#import "HKAddressModel.h"

#import "HKAddressViewController.h"

#import "HKReorderViewController.h"
#import <HKAddedPrescriptionModel.h>

#import "HKNavigationReorderController.h"

@interface HKCheckoutViewController () <HKReorderViewDelegate>

@property (nonatomic, strong) HKAIViewController *activityIndicator;

@property (weak, nonatomic) IBOutlet UIView *prescriptionTopView;

@property (weak, nonatomic) IBOutlet UIView *selfBottomView;

@property (weak, nonatomic) IBOutlet UIButton *addPrescriptionButton;

@property (nonatomic , strong) UIImage *selectedImage;

@property (nonatomic, strong) NSMutableArray *addressesArray;

@property (nonatomic, strong) HKAddedPrescriptionModel *selectedPrescriptionModel;


@end

@implementation HKCheckoutViewController



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
    CGFloat heightOfScreen = screenSize.height;
    if(heightOfScreen == SCREEN_HEIGHT_480)
    {
        [self.selfBottomView setFrame:CGRectMake(self.selfBottomView.frame.origin.x, self.selfBottomView.frame.origin.y - 88, self.selfBottomView.frame.size.width, self.selfBottomView.frame.size.height)];
    }
    [_prescriptionTopView setBackgroundColor:[UIColor colorWithRed:0.969f green:0.969f blue:0.969f alpha:1.0f]];
    
    // change appearance of add prescription button
//    self.addPrescriptionButton.layer.borderWidth = 1.0f;
//    self.addPrescriptionButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.addPrescriptionButton.layer.cornerRadius = 5.0f;
    self.addPrescriptionButton.backgroundColor = [UIColor whiteColor];
    
    // initialize address array for the current login user
    self.addressesArray  = [[NSMutableArray alloc] init];
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    // fetch all the addresses first
    [self fetchAllAddresses];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger i = buttonIndex;
    switch(i)
    {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:^{}];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"HealthKart Plus" message:@"Camera not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 2: // use prev prescriptions
        {
            // Directly move to prescriptions list  (Use Reorder controller for this)
            //[self performSegueWithIdentifier:@"previousPrescriptionSegue" sender:self]; // for using prev prescriptions
            
            HKNavigationReorderController *newTopViewController = (HKNavigationReorderController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationReorder"];
            HKReorderViewController *reorderController = (HKReorderViewController *)[newTopViewController.viewControllers objectAtIndex:0];
            reorderController.fromScene = COMINGFROM_CHECKOUT;
            reorderController.reorderDelegate = self;
            [self presentViewController:newTopViewController animated:YES completion:nil];
        }
            break;
        case 3:
        {
         
            // IF address are 0 then add new address
            if(self.addressesArray.count > 0)
                [self performSegueWithIdentifier:@"listAddressSegue" sender:self]; // List all addresses
            else
                [self performSegueWithIdentifier:@"newAddress" sender:self]; // add new address
        }
            break;
        default:
            // Do Nothing.........
            break;
    }
}


#pragma mark - fetch addresses
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

/*
 Fetch addresses for currenly logged in user so that on tap of "No prescription Required" , we can determine which address screen to display 
 A new address screen or list of address screen (HKSelectAddressController)
 */
#pragma mark - fetch address
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
    
    [self showSpinnerWithMessage:@"Loading…"];
    
    NSString *Url = [NSString stringWithFormat:@"%@/address/currentorder", BaseURLString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // Cookie added inernally in the method , manually
    
    __block HKCheckoutViewController *blockSelfObject = self;
    [manager POST:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self stopSpinner];
         
         if([[responseObject objectForKey:@"Result"] isEqualToString:@"OK"])
         {
             if([responseObject objectForKey:@"Records"] != (id)[NSNull null] && ((NSArray *)[responseObject objectForKey:@"Records"]).count>0)
             {
                 NSArray *arrayRecords = [responseObject objectForKey:@"Records"];
                 
                 [blockSelfObject createAddressModels:arrayRecords];
             }
             else if(((NSArray *)[responseObject objectForKey:@"Records"]).count == 0) // handle cases for 0 result
             {
                 NSLog(@"NO addresses are there");
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[responseObject objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error = %@",[error description]);
         [self stopSpinner];
         
//         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login Session Expired." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//         [alert show];
//         
         if(error.code == 3840 )
         {
             // auto sign in
             [self showSpinnerWithMessage:@"Signing in..."];
             [HKGlobal sharedHKGlobal].globalDelegate = self;
             [[HKGlobal sharedHKGlobal] autoSignIn];
         }
     }];
}

#pragma mark - global class delegate
-(void)signInResponseReceived
{
    NSLog(@"auto sign in complete");
    [self stopSpinner];
}

// create address model and initialize them
-(void)createAddressModels :(NSArray *)addressesArray
{
    [self.addressesArray removeAllObjects];
    
    for (id addressModel in addressesArray) {
        if ([addressModel isKindOfClass:[NSDictionary class]])
        {
            HKAddressModel *address = [[HKAddressModel alloc] initWithDictionary:addressModel];
            [self.addressesArray addObject:address];
        }
    }
}



#pragma mark -
#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (!self.selectedImage)
    {
        return;
    }
    
    // Adjusting Image Orientation
    NSData *data = UIImagePNGRepresentation(self.selectedImage);
    UIImage *tmp = [UIImage imageWithData:data];
    UIImage *fixed = [UIImage imageWithCGImage:tmp.CGImage
                                         scale:self.selectedImage.scale
                                   orientation:self.selectedImage.imageOrientation];
    self.selectedImage = fixed;
    
    
    // Performing the segue with an image which is selected
    [self performSegueWithIdentifier:@"UsePrescriptionImage" sender:self];
    
}
- (IBAction)addPrescriptionButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Upload From Album",@"Use Existing Prescription",@"No Prescription Required", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - text field delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"previousPrescriptionSegue"])
    {
        HKReorderViewController *myPrescriptionsController = (HKReorderViewController *)[segue destinationViewController];
        myPrescriptionsController.reorderDelegate = self;
        myPrescriptionsController.fromScene = COMINGFROM_CHECKOUT;
    }
    else if([segue.identifier isEqualToString:@"listAddressSegue"]) // go to HK select address controller
    {
        // to list addresses or to add new addresses
        HKSelectAddressController *selectAddressController = [segue destinationViewController];
        selectAddressController.fromScene = COMINGFROM_CHECKOUT_FLOW; // we are entring from checkout flow
    }
    else if([segue.identifier isEqualToString:@"newAddress"])
    {
        HKAddressViewController *destinationController = [segue destinationViewController];
        destinationController.fromScene = COMINGFROM_CHECKOUT_FLOW;
    }
    else if ([segue.identifier isEqualToString:@"UsePrescriptionImage"])
    {
        HKAddPrescriptionController *destintionController = [segue destinationViewController];
        if (self.selectedImage)
            destintionController.passedSelectedPrescriptionImage = self.selectedImage;
        
        if (self.selectedPrescriptionModel)
            destintionController.selectedPreviousPrescriptionModel = self.selectedPrescriptionModel;
        
        if ([self.addressesArray count]>0)
            destintionController.addressAvailable = YES;
        else
            destintionController.addressAvailable = NO;
    }
}

#pragma mark - delegate when image is selected form a list of prescriptions  (HKReorderController)

-(void)didSelectPreviousAddedPrescription:(HKAddedPrescriptionModel*)prevPrescription
{
    NSLog(@"prescription uploaded and now controll is back to CheckoutViewController");
    self.selectedPrescriptionModel = prevPrescription; // save the selected prescription model
    [self performSegueWithIdentifier:@"UsePrescriptionImage" sender:self];
}

@end
