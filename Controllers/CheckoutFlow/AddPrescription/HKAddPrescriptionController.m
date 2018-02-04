//
//  HKAddPrescriptionController.m
//  HealthKart+
//
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

// Usage:
// List prescriptions that user will add (from gallary or from prev list).
// Here the image passed from checkout view controller will be used in a prescription for the first time only

#import "HKAddPrescriptionController.h"
#import "HKPrescriptionCell.h"
#import "HKAddedPrescriptionCell.h"
#import "HKAddedPrescriptionModel.h"
#import "HKAddressViewController.h"
#import "HKReorderViewController.h"
#import "AFNetworking.h"
#import "HKProfileMenuViewController.h"
#import "HKSelectAddressController.h"

#import "HKNavigationReorderController.h"

@interface HKAddPrescriptionController () <HKAddedPrescriptionDelegate, HKReorderViewDelegate>
{
    HKPrescriptionCell *prescriptionCell;
    
    BOOL hasImageUploaded;
    int counter ;
}

@property (nonatomic, strong) HKAIViewController *activityIndicator;

@property(nonatomic , strong) NSMutableArray *addedPrescriptionDetailArray;
@property (weak, nonatomic) IBOutlet UITableView *prescriptionsTable;
@property (weak, nonatomic) IBOutlet UIView *prescriptionBottomView;


@end

@implementation HKAddPrescriptionController


@synthesize prescriptionBottomView = _prescriptionBottomView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - view cycle 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [prescriptionCell.patientNameTextField becomeFirstResponder];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat heightOfScreen = screenSize.height;
    if(heightOfScreen == SCREEN_HEIGHT_480)
    {
        [_prescriptionBottomView setFrame:CGRectMake(_prescriptionBottomView.frame.origin.x, _prescriptionBottomView.frame.origin.y - 88, _prescriptionBottomView.frame.size.width, _prescriptionBottomView.frame.size.height)];
    }

    // Allocating the array
    self.addedPrescriptionDetailArray = [[NSMutableArray alloc] init];
    
    // a unique increamenter for names of presc
     counter  = [[NSUserDefaults standardUserDefaults] integerForKey:@"fileNameCounter"];
    
    // This is to resign the keyboard
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    // if any previous prescription is selcted from prev page then display an alert like below
    // this prescr has already been uploaded so no need to upload it again
    if(self.selectedPreviousPrescriptionModel)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Prescription Sent" message:@"You sent your prescription successfully. You can either add another prescription or continue to checkout" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        // image has been select but not shown in table view .. this variable will decide if to show empty cell or not
        //.. in this case we do not need to show emtpy cell which asks for patient and doc name
        hasImageUploaded = YES;
        
        // add this model to array
        [self.addedPrescriptionDetailArray addObject:self.selectedPreviousPrescriptionModel];
        
        self.selectedPreviousPrescriptionModel = nil; // now destroy the model which was selected from checkout
        
        self.passedSelectedPrescriptionImage = nil;

    }
    else
    {
        // for the first time entering to this view set this variable to NO , and after that just set it to NO on each time we choose an image for
        // prescription from album or camera or from prev prescription list (all action sheet options)
        hasImageUploaded = NO;
    }
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void) viewWillAppear:(BOOL)animated
{

}


#pragma  mark - show/stop spinner
-(void)showSpinnerWithMessage:(NSString*)spinnerMessage
{
    if (!self.activityIndicator)
    {
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

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [prescriptionCell.patientNameTextField resignFirstResponder];
    [prescriptionCell.doctorNameTextField resignFirstResponder]; 
}

//add model to array to display detail in row of table
#pragma mark - Create model and add to Arrray
-(void)insertModalValuesWithImage : (UIImage *)prescImage andPrescriptionID:(NSString* )prescID
{
    NSLog(@"image uplaoded , now creating model");
    ++counter;
    
    HKAddedPrescriptionModel *addedPrescription = [[HKAddedPrescriptionModel alloc] init];
    addedPrescription.patientName = prescriptionCell.patientNameTextField.text;
    addedPrescription.doctorsName = prescriptionCell.doctorNameTextField.text;
    addedPrescription.prescription_id = prescID;
    addedPrescription.prescriptionName = [NSString stringWithFormat:@"Prescription%d",counter];
    addedPrescription.prescriptionImage = prescImage;
    
    // adding this object in array holding prescriptions.
    [self.addedPrescriptionDetailArray addObject:addedPrescription];
}

#pragma mark - upload prescription method

-(void)uploadPrescriptionImage :(UIImage *)imagePresc fromContinue:(BOOL)isFromContinue
{
    // upload image here on the prescription
    /*
     Uploading a prescription
     URL: http://staging.healthkartplus.com/webservices/prescription/upload
     Params: docName=doctor's name,patientName =patient name,multipart-form data for file,orderId=order id.
     Method: POST
     */
    
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"emailAddress"];
    if(username && username.length > 0)
    {

        NSString *fileName = [NSString stringWithFormat:@"Prescription%d.jpg", counter];
        
        [self showSpinnerWithMessage:@"Uploading Prescription..."];
        
        NSData *imageData = UIImageJPEGRepresentation(imagePresc, 0.6);
        
        NSString *orderID = [[NSUserDefaults standardUserDefaults] valueForKey:@"orderId"]; // orderId
        
        NSDictionary *parameters = @{@"docName":prescriptionCell.doctorNameTextField.text,@"patientName":prescriptionCell.patientNameTextField.text,@"orderId" : orderID};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://staging.healthkartplus.com/webservices/prescription/upload" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
        }success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"response is :  %@",responseObject);
             
             [self stopSpinner];
             
             if([responseObject objectForKey:@"errors"] == (id)[NSNull null] &&
                [responseObject objectForKey:@"result"] != (id)[NSNull null])
             {
                 // image has been uploaded
                 hasImageUploaded = YES;
                 // save counter in user defaults
                 [[NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"fileNameCounter"];
                 
                 id result = [responseObject objectForKey:@"result"];
                 
                 if([result isKindOfClass:[NSDictionary class]])
                     // first create a model so that this presc can be shown in table
                     [self insertModalValuesWithImage:imagePresc andPrescriptionID:[result objectForKey:@"documentId"]];
                 
                 if(isFromContinue)
                 {
                     //add first prescription here and proceed to new address screen.
                     [self showAddressScreen];
                 }
                else
                {
                     //  table has been updated now show action sheet again
                     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                              delegate:self
                                                                    cancelButtonTitle:@"Cancel"
                                                                destructiveButtonTitle:nil
                                                                     otherButtonTitles:@"Take Photo", @"Upload From Album",@"Use Previous Prescriptions", nil];
                     actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                     [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
                }
             }
             else
             {
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"HealthKart Plus" message:@"Issues with prescription upload, try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
             }
             
             // reload table to hide the parameter input cell (HKPrescriptionCell) and show the added presc cell (HKAddedPrescriptionCell)
             [self.prescriptionsTable reloadData];
             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
             NSLog(@"Error: %@ *****", [error description]);
             [self stopSpinner];
             
             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"HealthKart Plus" message:error.debugDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please login to HealthKartPlus to continue" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign-In", nil];
        alert.tag = 10;
        [alert show];
    }
}

#pragma mark - table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if(hasImageUploaded) // if image has been uploaded then hide the prescription cell and show the added prescr cell
        return [self.addedPrescriptionDetailArray count];
    return [self.addedPrescriptionDetailArray count]+1; // to also show prec cell (which takes input parameter from user doc name and patient name)
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"HKPrescriptionCell";
    NSString *cellIdentifier1= @"AddedPrescriptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!hasImageUploaded)
    {
        if(indexPath.row == 0)
        {
            prescriptionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!prescriptionCell)
            {
                prescriptionCell = (HKPrescriptionCell *)[[[NSBundle mainBundle] loadNibNamed:@"HKPrescriptionCell" owner:self options:nil] objectAtIndex:0];
            }
            return prescriptionCell;
        }
        else //(indexPath.row != [self.addedPrescriptionDetailArray count])
        {
            HKAddedPrescriptionCell *addedPrescriptionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if(!addedPrescriptionCell)
            {
                addedPrescriptionCell = (HKAddedPrescriptionCell *)[[[NSBundle mainBundle] loadNibNamed:@"AddedPrescriptionCell" owner:self options:nil] objectAtIndex:0];
                addedPrescriptionCell.addedPrescriptionDelegate = self;
                [addedPrescriptionCell configureRemoveButtonOnCell];
            }
            HKAddedPrescriptionModel *addedPrescriptionModel = (HKAddedPrescriptionModel*)[self.addedPrescriptionDetailArray objectAtIndex:indexPath.row-1];
            addedPrescriptionCell.patientNameLabel.text = addedPrescriptionModel.patientName;
            addedPrescriptionCell.doctorNameLabel.text = addedPrescriptionModel.doctorsName;
            addedPrescriptionCell.prescriptionName.text = addedPrescriptionModel.prescriptionName;
            return addedPrescriptionCell;
        }

    }
    else
    {
        HKAddedPrescriptionCell *addedPrescriptionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if(!addedPrescriptionCell)
        {
            addedPrescriptionCell = (HKAddedPrescriptionCell *)[[[NSBundle mainBundle] loadNibNamed:@"AddedPrescriptionCell" owner:self options:nil] objectAtIndex:0];
            addedPrescriptionCell.addedPrescriptionDelegate = self;
            [addedPrescriptionCell configureRemoveButtonOnCell];
        }
        HKAddedPrescriptionModel *addedPrescriptionModel = (HKAddedPrescriptionModel*)[self.addedPrescriptionDetailArray objectAtIndex:indexPath.row];
        addedPrescriptionCell.patientNameLabel.text = addedPrescriptionModel.patientName;
        addedPrescriptionCell.doctorNameLabel.text = addedPrescriptionModel.doctorsName;
        addedPrescriptionCell.prescriptionName.text = addedPrescriptionModel.prescriptionName;
        return addedPrescriptionCell;
    }
    return cell;
}

#pragma mark - Continue tapped

- (IBAction)continueButtonClicked:(id)sender
{
    if (self.passedSelectedPrescriptionImage) // if user has selected an image
    {
        if ([prescriptionCell.patientNameTextField.text length]>0 && [prescriptionCell.doctorNameTextField.text length]>0)
        {
            
            // upload prescriptions first .....
            [self uploadPrescriptionImage:self.passedSelectedPrescriptionImage fromContinue:YES];
            
            // make it nil so that next time same image shd not get uploaded
            self.passedSelectedPrescriptionImage = nil;
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"Please don’t leave the field empty" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else //else let user go directly to address page
    {
        [self showAddressScreen];
    }
}

-(void)showAddressScreen
{
    if (self.addressAvailable)
    {
        [self performSegueWithIdentifier:@"listAllAddresses" sender:self]; // List all addresses
    }
    else
    {
        HKAddressViewController *address = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
        [self.navigationController pushViewController:address animated:YES];
    }
}

#pragma mark - add another prescription tapped

- (IBAction)addAnotherPrescriptionClicked:(id)sender
{
    if (self.passedSelectedPrescriptionImage) // if user has selected an image
    {
        if ([prescriptionCell.patientNameTextField.text length]>0 && [prescriptionCell.doctorNameTextField.text length]>0)
        {
            
            // upload prescriptions first .....
            [self uploadPrescriptionImage:self.passedSelectedPrescriptionImage fromContinue:NO];
            
            // make it nil so that next time same image shd not get uploaded
            self.passedSelectedPrescriptionImage = nil;
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"Please don’t leave the field empty" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else //else let user go directly to address page
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take Photo", @"Upload From Album",@"Use Previous Prescriptions", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
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
        case 2:
        {
//            [self performSegueWithIdentifier:@"previousPrescription" sender:self]; // for using prev prescriptions
            // instantiate reorder controller
            HKNavigationReorderController *newTopViewController = (HKNavigationReorderController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationReorder"];
            HKReorderViewController *reorderController = (HKReorderViewController *)[newTopViewController.viewControllers objectAtIndex:0];
            reorderController.fromScene = COMINGFROM_CHECKOUT;
            reorderController.reorderDelegate = self;
            [self presentViewController:newTopViewController animated:YES completion:nil];
        }
            break;
        case 3:
        {
        }
        default:
            // Do Nothing.........
            break;
    }
}


#pragma mark -
#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Pick the image for a prescription and relaod the table
    //.. after that start the process of uploading a prescrition
    
    // Picking Image from Camera/ Library
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *tempImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (!tempImage)
    {
        return;
    }
    
    // Adjusting Image Orientation
    NSData *data = UIImagePNGRepresentation(tempImage);
    UIImage *imageToFix= [UIImage imageWithData:data];
    UIImage *fixed = [UIImage imageWithCGImage:imageToFix.CGImage
                                         scale:tempImage.scale
                                   orientation:tempImage.imageOrientation];
    
    // use this in uploading prescription image ....
    self.passedSelectedPrescriptionImage = fixed;
    hasImageUploaded = NO; // image is just selected not being uploded (in this case still not shown in table)
    
    [self.prescriptionsTable reloadData]; // now reload the table to add this image to table row
    
}

#pragma mark - delegate received from HKAddedPrescriptionDelegate
-(void)removeButtonTapped:(UITableViewCell *)addedPrescription;
{
    NSIndexPath *indexPath = [self.prescriptionsTable indexPathForCell:addedPrescription];
    NSLog(@"indexpath.row  = %d",indexPath.row);
    
    HKAddedPrescriptionModel *modelToRemove = [self.addedPrescriptionDetailArray objectAtIndex:indexPath.row];
    
    // call remove api
    [self removeSelectedPrescription:modelToRemove];

}

#pragma mark - remove prescription api
-(void)removeSelectedPrescription :(HKAddedPrescriptionModel *)modelToRemove
{
    /* 
     API URL : http://staging.healthkartplus.com/webservices/prescription/{prescriptionId}?remove=true
     PARAMETERS: NA
     METHOD: GET
     */
    
    [self showSpinnerWithMessage:@"Loading..."];
    
    NSString *urlString = [NSString stringWithFormat:@"http://staging.healthkartplus.com/webservices/prescription/%@?remove=true", modelToRemove.prescription_id];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // TODO:: parse the response
         NSLog(@"responseobject = %@",responseObject);
         
         [self stopSpinner];
         NSInteger status = [[responseObject valueForKey:@"status"] integerValue];
         
         if(status == 1)
         {
             NSString *result = [responseObject valueForKey:@"result"];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             alert.tag = 10;
             
             [alert show];
         }
         else
         {
             // Removing the model object from array and reloading the tableview
             [self.addedPrescriptionDetailArray removeObject:modelToRemove];
             
             [self.prescriptionsTable reloadData];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Prescription removed successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             
             [alert show];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self stopSpinner];
         //TODO:: handle error appropriately
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"previousPrescription"])
    {
        HKReorderViewController *myPrescriptionsController = (HKReorderViewController *)[segue destinationViewController];
        myPrescriptionsController.reorderDelegate = self;
        myPrescriptionsController.fromScene = COMINGFROM_CHECKOUT;
    }
    else if ([segue.identifier isEqualToString:@"listAllAddresses"])
    {
        HKSelectAddressController *selectAddressController = (HKSelectAddressController *)[segue destinationViewController];
        selectAddressController.fromScene = COMINGFROM_CHECKOUT_FLOW;
    }
}

#pragma mark - delegate when prescription is choosen

-(void)didSelectPreviousAddedPrescription:(HKAddedPrescriptionModel*)prevPrescription
{
    NSLog(@"prescription uploaded and now controll is back to AddPrescriptionController");
    self.selectedPreviousPrescriptionModel = prevPrescription;
    
    // adding model object in array holding prescriptions model
    [self.addedPrescriptionDetailArray addObject:prevPrescription];
    
    // make it nil so that next time same image shd not get uploaded
    self.passedSelectedPrescriptionImage = nil;
    
    hasImageUploaded = YES; // image has been selected (considered uploaded)
    [self.prescriptionsTable reloadData]; // reload data now with prev presc model // using above variable wether empty cell will display or not
}

#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        switch (buttonIndex)
        {
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
