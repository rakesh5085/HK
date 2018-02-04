//
//  HKQuickOrderController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 22/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKQuickOrderController.h"
#import <QuartzCore/QuartzCore.h>
#import "HKQuickOrderPrescriptionCell.h"
#import "HKQuickOrderPrescriptionModel.h"
#import "HKGlobal.h"

#import "AFNetworking.h"

#import  "ECSlidingViewController.h"
#import "HKCustomAlertView.h"

#define QUICKORDERTABLEVIEW_OFFSET 40.0f                  // Used when we have to show quickorderBottomView
#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 10


@interface HKQuickOrderController ()
{
//    HKQuickOrderUserDetailCell *userDetailCell;
    HKQuickOrderPrescriptionModel *prescriptionModelObj;
    NSInteger counter;                                   // It is used to ensure one time view adjustment
    NSMutableArray *prescriptionsArray;
    HKGlobal *sharedGlobal;
}
@property (weak, nonatomic) IBOutlet UIView *bottomOptionsView;
@property (weak, nonatomic) IBOutlet UIButton *bottomViewCancelButton;          // Actually cancel button is Add prescription

@property (weak, nonatomic) IBOutlet UITableView *quickOrderTableview;
// Bottom View
@property (weak, nonatomic) IBOutlet UIView *quickOrderBottomView;
@property (weak, nonatomic) IBOutlet UIButton *bottomViewAddButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomViewShareButton;

@property (nonatomic,strong) UIImage *selectedImage;
@property (nonatomic, strong) HKAIViewController *activityIndicator;

// Top view for Email and contact numbers
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation HKQuickOrderController

@synthesize bottomOptionsView = _bottomOptionsView;
@synthesize bottomViewCancelButton = _bottomViewCancelButton;

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
    self.emailTextField.delegate = self;
    self.contactNumberTextField.delegate = self;
    [self.emailTextField becomeFirstResponder];
    
    self.emailTextField.tag = 1;
    self.contactNumberTextField.tag = 2;
    
    // Setting counter to 0
    counter = 0;
    self.navigationItem.title = @"Quick Order";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat heightOfScreen = screenSize.height;
    if(heightOfScreen == SCREEN_HEIGHT_480)
    {
        [self.bottomOptionsView setFrame:CGRectMake(self.bottomOptionsView.frame.origin.x, self.bottomOptionsView.frame.origin.y - 88, self.bottomOptionsView.frame.size.width, self.bottomOptionsView.frame.size.height)];
        [self.quickOrderBottomView setFrame:CGRectMake(self.quickOrderBottomView.frame.origin.x, self.quickOrderBottomView.frame.origin.y - 88, self.quickOrderBottomView.frame.size.width, self.quickOrderBottomView.frame.size.height)];
    }
    sharedGlobal = [HKGlobal sharedHKGlobal];
    //Allocating prescriptions array
    prescriptionsArray = [[NSMutableArray alloc] init];

    // Initially hiding the bottom view
    if([prescriptionsArray count]<1)
    {
        [self.quickOrderBottomView setHidden:YES];
    }
    if(self.navigationController.navigationBarHidden == YES)
    {
        self.navigationController.navigationBarHidden = NO;
    }
    
    
    [self.bottomViewCancelButton setBackgroundColor:[UIColor whiteColor]];
    [self.bottomViewCancelButton setEnabled:NO];
    
    //method to make roundercorners , border width and border color to uibuttons.
    [self customizeButtons];
    
    // remove separators from tableview
    [self.quickOrderTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    // This is done to resignn the keyboard down.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}


-(void)customizeButtons
{
    //making a border in bottoms of bottomview. and this cancel button is add prescription please dont confuse!!!!!!!!
    _bottomViewCancelButton.layer.cornerRadius = 5.0f;
    _bottomViewCancelButton.layer.borderWidth = 1.0f;
    _bottomViewCancelButton.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];
    
    //Add buttton
    self.bottomViewAddButton.layer.cornerRadius = 5.0f;
    self.bottomViewAddButton.layer.borderWidth = 1.0f;
    self.bottomViewAddButton.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //share button
    self.bottomViewShareButton.layer.cornerRadius = 5.0f;
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
}

-(void)viewDidAppear:(BOOL)animated
{
    if([prescriptionsArray count] < 1)
        [self.emailTextField becomeFirstResponder];
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


- (void)keyboardWasShown:(NSNotification *)notification {

    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint viewOrigin = self.bottomOptionsView.frame.origin;
    
//    CGFloat viewHeight = self.bottomOptionsView.frame.size.height;
    
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, viewOrigin)){
        
        CGFloat xoffset=self.view.frame.size.width/2;
        
        CGFloat yoffset = self.view.frame.size.height/2;
        
        CGPoint Point = CGPointMake(xoffset, yoffset-35);
        
        self.bottomOptionsView.center = Point;
        
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    
    CGFloat xoffset=self.view.frame.size.width/2;
    
    CGFloat yoffset = self.view.frame.size.height;
    
        CGPoint Point = CGPointMake(xoffset, yoffset-35);
        
        self.bottomOptionsView.center = Point;
}

-(IBAction)searchBarButtonTapped:(id)sender
{
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLandingView"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECANCELED animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

#pragma  mark - slide left notifications
-(void)sliderLeftSlide : (NSNotification *)notification
{
    if([[notification name] isEqualToString:ECSlidingViewUnderLeftWillAppear])
    {
        [self.view endEditing:YES];
    }
}
-(void)sliderRightSlide : (NSNotification *)notification
{
    if([[notification name] isEqualToString:ECSlidingViewUnderRightWillAppear])
    {
        [self.view endEditing:YES];
    }
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

#pragma mark - utility methods
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// Prescription would be uplaoded one by one on tap of share prescription / Add another
-(void)uploadPrescriptionForThisQuickOrder:(UIImage *)imageToUpload isViaShare:(BOOL)isShareButtonTapped
{
    NSLog(@"sharing doctors prescription as an IMAGE....");
    if([self.contactNumberTextField.text isEqualToString:@""] && [self.emailTextField.text isEqualToString:@""])
    {
        UIAlertView *missingInfo=[[UIAlertView alloc]initWithTitle:@"Missing Details" message:@"All Fields Are Necessary" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [missingInfo show];
    }
    else
    {
        if(![self validateEmailWithString:self.emailTextField.text])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"You must enter a valid email id." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            /*
             Sharing a prescription
             URL: http://staging.healthkartplus.com/webservices/order/prescription
             Params:
             file=”multipart file”,
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
             UserId=””
             Method: POST
             */
            [self showSpinnerWithMessage:@"Sharing Prescription..."];
            
            NSData *imageData = UIImageJPEGRepresentation(imageToUpload, 0.6);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *params = @{ @"userId": [[defaults objectForKey:@"userInfo"] valueForKey:@"userid"], @"contactNo":@"7838234557"};
            
            NSString *selectPrescriptionUrl = [NSString stringWithFormat:@"%@/order/prescription", BaseURLString];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:selectPrescriptionUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpeg" mimeType:@"image/jpeg"];
                
            }success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSLog(@"response is :  %@",responseObject);
                 [self stopSpinner];
                 
                 if([responseObject objectForKey:@"errors"] == (id)[NSNull null])
                 {
                     // save counter in user defaults
                     [[NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"fileNameCounter"];
                     
                     // If share button tapped then only show user the confirmation alert, else just display action sheet to upload another
                     if(isShareButtonTapped)
                     {
                         [self displayCustomAlert];
                     }
                     else
                     {
                         UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"Cancel"
                                                                    destructiveButtonTitle:nil
                                                                         otherButtonTitles:@"Take Photo", @"Upload From Album", nil];
                         actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                         [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
                     }
                     
                     // image uplaoded and now remove it from memory
                     self.selectedImage = nil;
                 }
                 else
                 {
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"HealthKart Plus" message:@"Issues with prescription upload, try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
             }failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 
                 NSLog(@"Error: %@ *****", [error description]);
                 [self stopSpinner];
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"HealthKart Plus" message:error.debugDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
             }];
        }
    }
}

#pragma mark - share button tapped
- (IBAction)sharePrescriptionTapped:(id)sender
{
    if (self.selectedImage) // if user has selected an image
    {
        // WE have created the model's array , which is used in displaying table , now just upload the prescription
        // make it nil so that next time same image shd not get uploaded, do it in the successfull upload of this image
        [self uploadPrescriptionForThisQuickOrder:self.selectedImage isViaShare:YES];

    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"Please choose an image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - add another prescription tapped

- (IBAction)addPrescriptionClicked:(id)sender
{
    if (self.selectedImage) // if user has selected an image
    {
        // upload prescription first then , select the next one..
        [self uploadPrescriptionForThisQuickOrder:self.selectedImage isViaShare:NO];
    }
    else // display action sheet
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take Photo", @"Upload From Album", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark - show custom alert view
-(void)displayCustomAlert
{
    // Here we need to pass a full frame
    HKCustomAlertView *alertView = [[HKCustomAlertView alloc] init];
    
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

#pragma mark - text field delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.contactNumberTextField])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        [self btnEnable];
        return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
    }
    
    return YES;
}


-(void) btnEnable
{
    
    NSInteger length1 = 0,length2 = 0;
        
        length1 = [self.emailTextField.text length];

        length2 = [self.contactNumberTextField.text length];
    
    
    if(length1 > 0 && length2 > 0)
    {
        [self.bottomViewCancelButton setBackgroundColor:[UIColor greenColor]];
        [self.bottomViewCancelButton setEnabled:YES];
    }
    
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger i = buttonIndex;
    switch(i)
    {
        case 0: // from camera
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
        default:
            // Do Nothing.........
            break;
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
    
    // Adding the QuickOrderPrescriptionModel object to an prescriptionarray
    prescriptionModelObj = [[HKQuickOrderPrescriptionModel alloc] init];
    prescriptionModelObj.prescriptionImage = self.selectedImage;
    prescriptionModelObj.prescriptionName = [self getPrescriptionName];
    
    // Adding objectto array
    [prescriptionsArray addObject:prescriptionModelObj];
    
    // If counter = 0 then do adjustment otherwise not.
    if(counter == 0)
    {
        // Hiding and unhiding desired views and resizing tableview.
        [_bottomOptionsView setHidden:YES];
        [self.quickOrderBottomView setHidden:NO];
        [self.quickOrderTableview setFrame:CGRectMake(self.quickOrderTableview.frame.origin.x, self.quickOrderTableview.frame.origin.y, self.quickOrderTableview.frame.size.width, self.quickOrderTableview.frame.size.height- QUICKORDERTABLEVIEW_OFFSET)];
    }
    // increasing the counter to 1;
    counter += 1;
    // Reloading the tableview
    [self.quickOrderTableview reloadData];
}

-(NSString *)getPrescriptionName
{
    NSString *nameString = [NSString stringWithFormat:@"Prescription 0%d.jpg",[prescriptionsArray count]+1];
    return nameString;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.emailTextField resignFirstResponder];
    [self.contactNumberTextField resignFirstResponder];
}

#pragma mark - UITableview Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [prescriptionsArray count]; // this is done because we have to show one static cell everytime.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"HKPrescriptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
            HKQuickOrderPrescriptionCell *prescriptionCell = (HKQuickOrderPrescriptionCell *)[[[NSBundle mainBundle] loadNibNamed:@"QuickOrderPrescriptionCell" owner:self options:nil] objectAtIndex:0];
            HKQuickOrderPrescriptionModel *modelObj = (HKQuickOrderPrescriptionModel *)[prescriptionsArray objectAtIndex:indexPath.row]; // -1 is done because 1st cell is static
            
            prescriptionCell.prescriptionImageView.image = [HKGlobal imageWithImage:modelObj.prescriptionImage scaledToWidth:prescriptionCell.prescriptionImageView.frame.size.width *2];
            prescriptionCell.prescriptionNameLabel.text = modelObj.prescriptionName;
            
            cell = prescriptionCell;
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 80.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
