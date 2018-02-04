//
//  HKOTCViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 07/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "AFNetworking.h"
#import "HKOTCViewController.h"
#import "HKTestimonialView.h"
#import "HKGlobal.h"
#import "HKTestimonialModel.h"
#import "HKAIViewController.h"
#import "HKWriteReviewController.h"
#import "HKConstants.h"
#import "HKLocationViewController.h"
#import "HKCartMenuModel.h"
#import "HKGlobal.h"
#import "CustomBadge.h"
#import "HKSelectAddressController.h"
#import "ECSlidingViewController.h"



@interface HKOTCViewController ()
{
    UIView *cartButtonView;
    HKTestimonialView *testimonialView;
    HKGlobal *sharedGlobalObj;
    
    NSInteger medicineCount;
    HKGlobal *sharedHKGlobal;
    NSInteger originalQuantity;
    NSInteger counter;
}

@property (nonatomic, strong) HKAIViewController *activityIndicator;

@property (weak, nonatomic) IBOutlet UIScrollView *otcScrollView;

@property (weak, nonatomic) IBOutlet UILabel *otcTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *otcBrandLabel;

@property (weak, nonatomic) IBOutlet UIImageView *otcImageView;

@property (weak, nonatomic) IBOutlet UIButton *leftScrollImageviewButton;

@property (weak, nonatomic) IBOutlet UIButton *rightScrollImageviewButton;

@property (weak, nonatomic) IBOutlet UIButton *otcBuyButton;

@property (weak, nonatomic) IBOutlet UILabel *otcFlavourLabel;

@property (weak, nonatomic) IBOutlet UILabel *otcSizeLabel;

@property (weak, nonatomic) IBOutlet UIView *otcReviewBottomView;

@property (weak, nonatomic) IBOutlet UIButton *otcReviewButton;

@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *offerPercentageLabel;

@property (weak, nonatomic) IBOutlet UILabel *otcDescription;

@property (weak, nonatomic) IBOutlet UILabel *otcPackForm;

@property (weak, nonatomic) IBOutlet UILabel *otcQuantity;

@property (weak, nonatomic) IBOutlet UILabel *otcTotalQuantity;

@property (weak, nonatomic) IBOutlet UILabel *strikeLabel;

@property (nonatomic, strong) HKOTCDrugInfo *otcDrugDetail;

@property (nonatomic, strong) NSMutableArray *modelObj;

@property (nonatomic, assign) NSInteger quantity ;

@property (nonatomic, weak) NSString *packForm;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic,  assign)NSInteger userRating;

@property (nonatomic, assign)float finalRating;

@property (nonatomic, assign) NSInteger scrollviewHeight;

@property (nonatomic, assign) NSInteger noOfReviews;

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (strong, nonatomic) IBOutlet UIButton *cartButton;

-(void) getOTCDrugDetails;

-(IBAction) otcQuantityIncrease;
-(IBAction) otcQuantityDecrease;

@end

@implementation HKOTCViewController

@synthesize itemImageView = _itemImageView;
@synthesize cartButton = _cartButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    sharedHKGlobal = [HKGlobal sharedHKGlobal];
    
    self.quantity = 1;

    self.count=0;
    
    self.userRating=0;

    self.scrollviewHeight = 0;
    
    [self getOTCDrugDetails]; // back ground
    
    if(self.navigationController.navigationBarHidden == YES)
    {
        self.navigationController.navigationBarHidden = NO;
    }
    
    // Configuring review buttom
    self.otcBuyButton.layer.cornerRadius = 4.0f;
    
    // Setting the values from model.
    self.otcTitleLabel.text = self.drugModel.drugName;
    self.unitPriceLabel.text = [NSString stringWithFormat:@"Rs. %.2f",self.drugModel.mrp];
    self.otcBrandLabel.text = self.drugModel.manufacturer;
    self.otcDescription.text = self.otcDrugDetail.description;

    self.offerPriceLabel.text = [NSString stringWithFormat:@"Rs. %.2f",self.drugModel.oPrice];
    
    if(self.drugModel.oPrice < self.drugModel.mrp){
        
        self.strikeLabel.hidden = NO;
    }else{
        self.strikeLabel.hidden = YES;
    }
    
    // Method to add a default view

}

-(void)viewWillAppear:(BOOL)animated
{
    self.screenName = @"sign in Screen";

    if(sharedHKGlobal.cartItemsGlobalArray.count > 0)
    {
        CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", sharedHKGlobal.cartItemsGlobalArray.count]
                                                       withStringColor:[UIColor whiteColor]
                                                        withInsetColor:[UIColor greenColor]
                                                        withBadgeFrame:YES
                                                   withBadgeFrameColor:[UIColor greenColor]
                                                             withScale:1.0
                                                           withShining:YES];
        
        [customBadge1 setFrame:CGRectMake(0,20, 15, 15)];
        [_cartButton addSubview:customBadge1]; //Add NKNumberBadgeView as a subview on UIButton
    }
}

- (IBAction)cartButtonClicked:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}


-(void)addOTCAverageRatingView
{
    UIView *otcAverageRatingView = [[UIView alloc] initWithFrame:CGRectMake(0, 510, 320, 80)];
    [otcAverageRatingView setBackgroundColor:[UIColor clearColor]];
    // Adding uilabel
    UILabel *avgRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 120, 21)];
    avgRatingLabel.text = @"Average Ratings";
    [avgRatingLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [avgRatingLabel setBackgroundColor:[UIColor clearColor]];
    [otcAverageRatingView addSubview:avgRatingLabel];
    
    
    // Star UIImageView 1
    UIImageView *starImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 38,30, 30)];
    starImageView1.image = [UIImage imageNamed:@"star-selected"];
    [starImageView1 setTag:1];
    [otcAverageRatingView addSubview:starImageView1];
    
    // Star UIImageView 2
    UIImageView *starImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 38,30, 30)];
    starImageView2.image = [UIImage imageNamed:@"star-selected"];
    [starImageView2 setTag:2];
    [otcAverageRatingView addSubview:starImageView2];
    
    // Star UIImageView 3
    UIImageView *starImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 38,30, 30)];
    starImageView3.image = [UIImage imageNamed:@"star-selected"];
    [starImageView3 setTag:3];
    [otcAverageRatingView addSubview:starImageView3];
    
    // Star UIImageView 4
    UIImageView *starImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 38,30, 30)];
    starImageView4.image = [UIImage imageNamed:@"star-selected"];
    [starImageView4 setTag:4];
    [otcAverageRatingView addSubview:starImageView4];
    
    // Star UIImageView 5
    UIImageView *starImageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(155, 38,30, 30)];
    starImageView5.image = [UIImage imageNamed:@"star-grey"];
    [starImageView5 setTag:5];
    [otcAverageRatingView addSubview:starImageView5];
    
    // Write review button
    UIButton *writeReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeReviewButton setFrame:CGRectMake(200, 36, 110, 36)];
    [writeReviewButton setTitle:@"Write a review" forState:UIControlStateNormal];
    [writeReviewButton setTitleColor:[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] forState:UIControlStateNormal];
    [writeReviewButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    writeReviewButton.layer.cornerRadius = 3.0f;
    writeReviewButton.layer.borderWidth = 1.0f;
    writeReviewButton.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];
    [writeReviewButton addTarget:self action:@selector(writeReviewButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [otcAverageRatingView addSubview:writeReviewButton];
    

    for (HKTestimonialModel *testimonialModel in self.modelObj)
    {
        
        HKTestimonialView *view = (HKTestimonialView*)[[[NSBundle mainBundle] loadNibNamed:@"HKTestimonialView" owner:self options:nil] objectAtIndex:0];
        [view setFrame:CGRectMake(0, 600+(self.noOfReviews*90), 320, 170)];
        
        int rating = testimonialModel.userRating;
        
        self.userRating = self.userRating+rating;
        
        for (UIView* sview in [view subviews])
        {
            if([sview isKindOfClass:[UIImageView class]])
            {
                UIImageView *imgView = (UIImageView*)sview;
                if(imgView.tag > rating)
                    [imgView setImage:[UIImage imageNamed:@"star-grey"]];
                else
                    [imgView setImage:[UIImage imageNamed:@"star-selected"]];
            }
        }

        view.testimonialLabel.text = testimonialModel.review;
        
        [view.testimonialLabel setNumberOfLines:0];
        
        view.testimonialLabel =  [HKGlobal adjustHeightOfLabel:view.testimonialLabel];
        
        self.scrollviewHeight = self.scrollviewHeight + view.frame.size.height;
        
        self.noOfReviews = self.noOfReviews+1;
        
        [self.otcScrollView addSubview:view];
    }
    
    if(self.noOfReviews == 0)
    {
        for (UIView* fview in [otcAverageRatingView subviews])
        {
            if([fview isKindOfClass:[UIImageView class]])
            {
                UIImageView *imgView = (UIImageView*)fview;
                if(imgView.tag > 0)
                    [imgView setImage:[UIImage imageNamed:@"star-grey"]];
            }
            
        }
    }
    else
    {
        self.finalRating = self.userRating/self.noOfReviews;
    
        for (UIView* fview in [otcAverageRatingView subviews])
        {
            if([fview isKindOfClass:[UIImageView class]])
            {
            UIImageView *imgView = (UIImageView*)fview;
            if(imgView.tag > self.finalRating)
                [imgView setImage:[UIImage imageNamed:@"star-grey"]];
            else
                [imgView setImage:[UIImage imageNamed:@"star-selected"]];
            }
        }
    }
    
    self.scrollviewHeight = 504 + otcAverageRatingView.frame.size.height + self.scrollviewHeight;
    
    // "Based on # reviews" label
    UILabel *basedLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 10, 150, 21)];
    basedLabel.text = [NSString stringWithFormat:@"Based on %i reviews", self.noOfReviews];
    [basedLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [basedLabel setTextColor:[UIColor grayColor]];
    [basedLabel setBackgroundColor:[UIColor clearColor]];
    [otcAverageRatingView addSubview:basedLabel];
    
    [self.otcScrollView addSubview:otcAverageRatingView];
    
    [self.otcScrollView setContentSize:CGSizeMake(320, self.scrollviewHeight)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)writeReviewButtonClicked
{
    [self performSegueWithIdentifier:@"writeReview" sender:self];
}

#pragma mark - Private Methods.

- (IBAction)reviewButtonClicked:(id)sender
{
     if ([self.otcReviewButton.currentImage isEqual:[UIImage imageNamed:@"down_arrow_blue"]])
     {
         [self.otcReviewButton setImage:[UIImage imageNamed:@"up_arrow_blue"] forState:UIControlStateNormal];
         self.otcScrollView.contentSize = CGSizeMake(320, 968);
         // scrolling up
         [self.otcScrollView setContentOffset:CGPointMake(0, 468) animated:YES];
     }
    else
    {
        [self.otcReviewButton setImage:[UIImage imageNamed:@"down_arrow_blue"] forState:UIControlStateNormal];
        self.otcScrollView.contentSize = CGSizeMake(320, 504);
        [self.otcScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"writeReview"]){
        
        HKWriteReviewController *destViewController = segue.destinationViewController;
        
        destViewController.productId = self.drugModel.drugId;
        destViewController.otcMedicineName = self.drugModel.drugName;
        destViewController.otcBrandName = self.drugModel.manufacturer;
    }else if([segue.identifier isEqualToString:@"OTCCheckout"]){
        
        HKSelectAddressController *addressController = segue.destinationViewController;
        
        addressController.fromScene = COMINGFROM_CHECKOUT_FLOW;
        
    }
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


-(void) getOTCDrugDetails
{
    [self showSpinnerWithMessage:@"Loading"];
    
    NSString *drugname = self.drugModel.drugName;
    drugname = [drugname stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *drugDetailURL = [NSString stringWithFormat:@"%@/otc/product/%@/%@", BaseURLString, drugname, self.drugModel.slug];
    
    //drugDetailURL = [drugDetailURL stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    NSLog(@"medicine detail URL : %@", drugDetailURL);
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block HKOTCViewController *blockSelf = self;
    [manager GET:drugDetailURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id otcdrugDetail = [responseObject objectForKey:@"result"];
         
         if(otcdrugDetail && [otcdrugDetail isKindOfClass:[NSDictionary class]])
         {
             //populate drug detail model here and update the view
             [blockSelf createOTCDrugDetailModelFromDrugDictionary:(NSDictionary*)otcdrugDetail];
             
             // modify view
             
         }
         else
         {
             // TODO:: handle else condition appropriately
         }
         [self stopSpinner];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self stopSpinner];
         //TODO:: handle error appropriately
     }];
    
}

-(void)createOTCDrugDetailModelFromDrugDictionary:(NSDictionary*)drugDetailInfo
{
    HKOTCDrugInfo *otcDrugInfo = [[HKOTCDrugInfo alloc] initWithDictionary:drugDetailInfo];
    self.otcDrugDetail = otcDrugInfo;
    
    self.packForm = otcDrugInfo.packForm;
    
    self.otcDescription.text = otcDrugInfo.description;
    
    self.otcPackForm.text = otcDrugInfo.packForm;
    
    self.offerPercentageLabel.text = [NSString stringWithFormat:@"%0.0f%% Off on MRP ", otcDrugInfo.discount];
    
    self.otcQuantity.text = [NSString stringWithFormat:@"%d", self.quantity];
    
    self.otcTotalQuantity.text = [NSString stringWithFormat:@"%d %@(s)", self.quantity, otcDrugInfo.packForm];
    
    NSString *url = self.otcDrugDetail.imageUrl;
    
    if([url isEqualToString:@""]){
        
        [self.noImageLabel setHidden:NO];
        
    }else{
    
        [self.noImageLabel setHidden:YES];
        NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.otcDrugDetail.imageUrl]];
        
        if (image == nil) {
            [self.noImageLabel setHidden:NO];
        }else{
            UIImage *drugImage = [[UIImage alloc] initWithData:image];

            [self.otcImageView setImage:drugImage];
            self.otcImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    
    [self getReviews];
    
}

-(IBAction)otcQuantityIncrease{
    
    if (self.quantity < 10) {
        
        self.quantity = self.quantity+1;
        
        self.otcQuantity.text = [NSString stringWithFormat:@"%d", self.quantity];
        self.otcTotalQuantity.text = [NSString stringWithFormat:@"%d %@(s)", self.quantity, self.packForm];
        float totalPrice = self.drugModel.oPrice * self.quantity;
        self.offerPriceLabel.text = [NSString stringWithFormat:@"Rs. %.2f",totalPrice];
    }
    
}

-(IBAction)otcQuantityDecrease{
    
    if(self.quantity > 1){
        
       self.quantity = self.quantity-1;
        
        self.otcQuantity.text = [NSString stringWithFormat:@"%d", self.quantity];
        self.otcTotalQuantity.text = [NSString stringWithFormat:@"%d %@(s)", self.quantity, self.packForm];
        float totalPrice = self.drugModel.oPrice * self.quantity;
        self.offerPriceLabel.text = [NSString stringWithFormat:@"Rs. %.2f",totalPrice];
    }else{
        
        
    }
    
}

#pragma mark - get reviews of product
-(void)getReviews{
    
    NSString *drugReviewURL = [NSString stringWithFormat:@"http://staging.healthkartplus.com/otc/product/reviews/%@", self.drugModel.slug];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block HKOTCViewController *blockSelf = self;
    [manager GET:drugReviewURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id otcdrugReview = [responseObject objectForKey:@"result"];
         
         if(otcdrugReview && [otcdrugReview isKindOfClass:[NSArray class]])
         {
             //populate drug detail model here and update the view
             [blockSelf createOTCDrugReviewModelFromDrugDictionary:(NSArray*)otcdrugReview];
             
             // modify view
             
         }
         else
         {
             // TODO:: handle else condition appropriately
         }
         [self stopSpinner];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self stopSpinner];
         //TODO:: handle error appropriately
     }];
}

-(void)createOTCDrugReviewModelFromDrugDictionary:(NSArray*)drugReview
{
    self.count = drugReview.count;
    
    self.modelObj = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for(int i =0; i<drugReview.count; i++){
        
        HKTestimonialModel *review = [[HKTestimonialModel alloc] initWithDictionary:[drugReview objectAtIndex:i]];
        
        [self.modelObj addObject:review];
        
        
    }
    
    [self addOTCAverageRatingView];

}

-(IBAction)buyButtonClicked
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"pincode"])
    {
        //pin code not entered. ask the user to enter pin code.
        
        UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLocation"];
        HKLocationViewController *locationController = [newTopViewController.viewControllers objectAtIndex:0];
        locationController.isComingFromProductDetailScreen = YES;
        [self presentViewController:newTopViewController animated:YES completion:nil];
    }
    else
    {
        [self buyProductItem];
    }
}

-(void)buyProductItem
{
    NSString *buyItemUrl = [NSString stringWithFormat:@"%@/cart/add/%d?qty=%d", BaseURLString, self.drugModel.drugId, self.quantity];
    
    //    __block HKMedicineDetailController *blockSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:buyItemUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         NSDictionary *resultDict = [responseObject objectForKey:@"result"];
         
         if((resultDict  != (id)[NSNull null]) && (resultDict  != (id)[NSNull null]))
         {
             [[NSUserDefaults standardUserDefaults] setValue:[[responseObject valueForKey:@"result"] valueForKey:@"orderId"] forKey:@"orderId"];
             
             NSString *medMessage = [NSString stringWithFormat:@"You just added %@ to your Cart", self.drugModel.drugName];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:medMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Checkout",@"Continue Shopping", nil];
             alertView.tag = 1;
             [alertView show];
             //update the cart
             [self updateCartItemsArray];
         }
         else
         {
             //TODO: handle else condition appropriately
             if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
                 
                 id errors = [responseObject valueForKey:@"errors"];
                 id errs = [errors valueForKey:@"errs"];
                 
                 if (errs && [errs isKindOfClass:[NSArray class]]) {
                     id error = [errs objectAtIndex:0];
                     
                     if ([[error valueForKey:@"msg"] isEqualToString:@"Please specify delivery pincode."])
                     {
                         //show pin entry screen.
                         UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLocation"];
                         HKLocationViewController *locationController = [newTopViewController.viewControllers objectAtIndex:0];
                         locationController.isComingFromProductDetailScreen = YES;
                         [self presentViewController:newTopViewController animated:YES completion:nil];
                     }
                     else
                     {
                         UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error valueForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         errorAlert.tag = 2;
                         [errorAlert show];
                     }
                 }
             }
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO:: handle error appropriately
     }];
}


-(void)updateCartItemsArray
{
    BOOL found = FALSE;
    // First Check whether the object you are adding is allready added in cartItemsGlobalArray or not
    // If added then just increase the count of medicine or
    // Just add the whole model in array.
    for (HKCartMenuModel *cartMenuModel in sharedHKGlobal.cartItemsGlobalArray)
    {
        if(cartMenuModel.cartMenuMedicineId == self.drugModel.drugId)
        {
            found = TRUE;
            // Adding the count to model
            cartMenuModel.cartMenuMedicineCount += self.quantity;
            break;
        }
    }
    if(!found)
    {
        // Initialising HKCartMenuModel
        HKCartMenuModel *cartMenuModelObj = [[HKCartMenuModel alloc] init];
        cartMenuModelObj.cartMenuMedicineId = self.drugModel.drugId;
        cartMenuModelObj.cartMenuDrugImageType = self.drugModel.pForm;
        cartMenuModelObj.cartMenuMedicineName = self.drugModel.drugName;
        cartMenuModelObj.cartMenuMedicinePrice = self.drugModel.oPrice ;
        cartMenuModelObj.cartMenuMedicineTotalPrice = self.drugModel.oPrice * self.quantity;
        cartMenuModelObj.cartMenuMedicineCount = self.quantity;
        cartMenuModelObj.cartMenuSheetType = self.drugModel.packForm;
        cartMenuModelObj.medPForm = self.drugModel.pForm;
        // Adding in cartItemsGlobalArray array
        [sharedHKGlobal.cartItemsGlobalArray addObject:cartMenuModelObj];
        
        if(sharedHKGlobal.cartItemsGlobalArray.count > 0)
        {
            
            CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", sharedHKGlobal.cartItemsGlobalArray.count]
                                                           withStringColor:[UIColor whiteColor]
                                                            withInsetColor:[UIColor greenColor]
                                                            withBadgeFrame:YES
                                                       withBadgeFrameColor:[UIColor greenColor]
                                                                 withScale:1.0
                                                               withShining:YES];
            
            [customBadge1 setFrame:CGRectMake(0,20, 15, 15)];
            [_cartButton addSubview:customBadge1]; //Add NKNumberBadgeView as a subview on UIButton
        }
        
    }
    
    //    NSString *drugFormString = nil;
    
    //    if (noOfMedicines > 1)
    //        drugFormString = [NSString stringWithFormat:@"%@s", self.drugModel.packForm];
    //    else
    //    {
    //        drugFormString = self.drugModel.packForm;
    //    }
    
}


#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 0:
            {
                //proceed with checkout flow
                [self performSegueWithIdentifier:@"OTCCheckout" sender:self];
                
            }
                break;
            case 1:
            {
                //user wants to continue shopping.
            }
                break;
                
            default:
                break;
        }
    }
}

- (CAKeyframeAnimation *) itemViewCurvingIntoCartAnimation
{
    CGRect positionOfItemViewInView = _itemImageView.frame;
    
    float riseAbovePoint = 20.0f;
    
    CGPoint beginningPointOfQuadCurve = positionOfItemViewInView.origin;
    CGPoint endPointOfQuadCurve = CGPointMake(cartButtonView.frame.origin.x + cartButtonView.frame.size.width/2, cartButtonView.frame.origin.y + cartButtonView.frame.size.height/2) ;
    //CGPoint endPointOfQuadCurve = CGPointMake(_btn.frame.origin.x + _btn.frame.size.width/2, _btn.frame.origin.y + _btn.frame.size.height/2 ) ;
    //CGPoint controlPointOfQuadCurve = CGPointMake((beginningPointOfQuadCurve.x + endPointOfQuadCurve.x *2)/2, beginningPointOfQuadCurve.y -riseAbovePoint);
    CGPoint controlPointOfQuadCurve = CGPointMake((beginningPointOfQuadCurve.x - endPointOfQuadCurve.x )/2, beginningPointOfQuadCurve.y + riseAbovePoint );
    
    UIBezierPath * quadBezierPathOfAnimation = [UIBezierPath bezierPath];
    [quadBezierPathOfAnimation moveToPoint:beginningPointOfQuadCurve];
    [quadBezierPathOfAnimation addQuadCurveToPoint:endPointOfQuadCurve controlPoint:controlPointOfQuadCurve];
    
    CAKeyframeAnimation * itemViewCurvingIntoCartAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    itemViewCurvingIntoCartAnimation.path = quadBezierPathOfAnimation.CGPath;
    
    return itemViewCurvingIntoCartAnimation;
}

@end
