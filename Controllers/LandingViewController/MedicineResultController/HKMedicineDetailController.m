//
//  HKMedicineDetailController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 24/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "AFNetworking.h"
#import "HKMedicineDetailController.h"
#import "HKMedicineDetailViewCell.h"
#import "HKMedicineOptionSegmentCell.h"
#import "HKMedicineDetailInfoCell.h"
#import "HKSearchMedicineCell.h"
#import "HKDrugDetailModel.h"
#import "HKDrugSaltInfoModel.h"
#import "HKCartMenuModel.h"
#import "HKGlobal.h"
#import "HKConstants.h"
#import "HKOTCViewController.h"
#import "HKAIViewController.h"
#import "SaltNamesCell.h"
#import "HKLocationViewController.h"
#import "ECSlidingViewController.h"
#import "HKCartMenuViewController.h"



/*
    Use pForm to show the image where required.
*/

@interface HKMedicineDetailController() <HKMedicineDetailDelegate,HKMedicineOptionSegmentDelegate>
{
    UIView *cartButtonView;
    HKMedicineDetailViewCell *medicineDetailCell;
    // to hold medicine count
    NSInteger medicineCount;
    HKGlobal *sharedHKGlobal;
    NSInteger originalQuantity;
    NSInteger counter;
    
    // for height and string of salt names
    float heightOfSaltsNamesLabel;
    NSString *saltNamesString;
    
    // For height and string of salt details cells
    NSMutableArray *arrayOFLabelsHeights;
    
}
@property (nonatomic, strong) HKAIViewController *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UIButton *cartButton;
@property (weak, nonatomic) IBOutlet UITableView *medicineDetailTableview;
@property (nonatomic, assign) NSInteger optionsSelectedIndex;
@property (nonatomic, strong) NSMutableArray *medicineSubstituteArray;
@property (nonatomic, strong) HKDrugDetailModel *drugDetailModel;

-(void) getDrugDetails;

@end

@implementation HKMedicineDetailController

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

#pragma  mark -  view cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    sharedHKGlobal = [HKGlobal sharedHKGlobal];
    originalQuantity = 0;
    counter = 0;
    // Initialising medicineCount
    medicineCount = 1;
    // Setting 0th index of segmented control on HKMedicineOptionSegmentCell.h as this is default behaviour.
    self.optionsSelectedIndex = 0;
    // Initialising the substitute array
    self.medicineSubstituteArray = [[NSMutableArray alloc] init];
    
    [self getDrugDetails];
    
    if(self.navigationController.navigationBarHidden == YES)
    {
        self.navigationController.navigationBarHidden = NO;
    }
    
    // to collect heights of all labels in all cells
    arrayOFLabelsHeights = [[NSMutableArray alloc] init];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"Medicine Detail Screen";
    self.screenName = @"Medicine Detail Screen";
    
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - private methods

- (IBAction)buyButtonClicked:(id)sender
{
    //call buy item API
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"pincode"]) {
        [self buyProductItem];
    }
    else
    {
        UINavigationController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationLocation"];
        HKLocationViewController *locationController = [newTopViewController.viewControllers objectAtIndex:0];
        locationController.isComingFromProductDetailScreen = YES;
        [self presentViewController:newTopViewController animated:YES completion:nil];
    }
}

-(void)buyProductItem
{
    NSString *buyItemUrl = [NSString stringWithFormat:@"%@/cart/add/%d?qty=%d", BaseURLString, self.drugModel.drugId, medicineCount];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:buyItemUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         NSDictionary *resultDict = [responseObject objectForKey:@"result"];
         
         if((resultDict  != (id)[NSNull null]) && (resultDict  != (id)[NSNull null]))
         {
             [[NSUserDefaults standardUserDefaults] setValue:[[responseObject valueForKey:@"result"] valueForKey:@"orderId"] forKey:@"orderId"];
             
             NSString *medMessage = [NSString stringWithFormat:@" You just added %@ to your Cart", self.drugModel.drugName];
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:medMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"Checkout",@"Continue Shopping", nil];
             [alertView show];
             //update the cart
             [self updateCartItemsArray];
         }
         else
         {
             //TODO: handle else condition appropriately
             if ([[responseObject objectForKey:@"status"] integerValue] == 1)
             {
                 id errors = [responseObject valueForKey:@"errors"];
                 id errs = [errors valueForKey:@"errs"];
                 
                 if (errs && [errs isKindOfClass:[NSArray class]])
                 {
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
                         errorAlert.tag = ERROR_ALERT_VIEW;
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
            cartMenuModel.cartMenuMedicineCount += medicineCount;
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
        cartMenuModelObj.cartMenuMedicineTotalPrice = self.drugModel.oPrice * medicineCount;
        cartMenuModelObj.cartMenuMedicineCount = medicineCount;
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

- (IBAction)cartButtonClicked:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}
- (IBAction)btnClick:(id)sender
{
    static float const curvingIntoCartAnimationDuration = 1.0f;
    
    CALayer * layerToAnimate = _itemImageView.layer;
    
    CAKeyframeAnimation * itemViewCurvingIntoCartAnimation = [self itemViewCurvingIntoCartAnimation];
    CABasicAnimation * itemViewShrinkingAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    itemViewShrinkingAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0.0,0.0, _itemImageView.bounds.size.width/1.5, _itemImageView.bounds.size.height/1.5)];
    CABasicAnimation * itemAlphaFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    itemAlphaFadeAnimation.toValue = [NSNumber numberWithFloat:0.5];
    
    CAAnimationGroup * shrinkFadeAndCurveAnimation = [CAAnimationGroup animation];
    [shrinkFadeAndCurveAnimation setAnimations:[NSArray arrayWithObjects:
                                                itemViewCurvingIntoCartAnimation,
                                                itemViewShrinkingAnimation,
                                                itemAlphaFadeAnimation,
                                                nil]];
    [shrinkFadeAndCurveAnimation setDuration:curvingIntoCartAnimationDuration];
    [shrinkFadeAndCurveAnimation setDelegate:self];
    [shrinkFadeAndCurveAnimation setRemovedOnCompletion:NO];
    [shrinkFadeAndCurveAnimation setValue:@"shrinkAndCurveToAddToOrderAnimation" forKey:@"name"];
    [layerToAnimate addAnimation:shrinkFadeAndCurveAnimation forKey:nil];
}

// **************
// To get height of the string
// **************

-(float)saltNamesStringHeightFromArray: (NSArray *)saltsArray
{
    // to hold all the salts
    NSMutableString *string_salts = [[NSMutableString alloc] init];
    int count = 0;
    for (HKDrugSaltInfoModel *saltInfoModel in saltsArray)
    {
        if(saltInfoModel.saltName != (id)[NSNull null])
        {
            count++;
            if(count != saltsArray.count)
                [string_salts appendString:[NSString stringWithFormat:@"%@ %@; ",saltInfoModel.saltName,saltInfoModel.strength]];
            else
                [string_salts appendString:[NSString stringWithFormat:@"%@ %@",saltInfoModel.saltName,saltInfoModel.strength]];
        }
    }
 
    CGRect textRect = [string_salts boundingRectWithSize:CGSizeMake(300, 10000.0f)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 +0.5f]}
                                           context:nil];
    
    
    
    CGSize newSize = textRect.size;
    
    heightOfSaltsNamesLabel = newSize.height; // set height
    saltNamesString = [[NSString alloc] initWithString:string_salts]; // string of salt names
    
    return newSize.height;
}
-(float)saltDetailsCellHeight : (HKDrugSaltInfoModel *)saltInfoModel
{
    UIColor *_black=[UIColor blackColor];
    UIColor *_lightGray = [UIColor lightGrayColor];
    UIFont *font=[UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    
    // salt Heading
    NSString * saltNameLabelString = [NSString stringWithFormat:@"%@ %@",saltInfoModel.saltName,saltInfoModel.strength];
    float hSaltNameLabelString =  [HKGlobal heightOfGivenText:saltNameLabelString ofWidth:300.0 andFont:font];

    // Salts string
    NSString * saltsString  = [NSString stringWithFormat:@"Pregnancy:%@ Lactation:%@ Lab:%@ Food:%@",saltInfoModel.ci_pg,
                               saltInfoModel.ci_lc,saltInfoModel.ci_lb,saltInfoModel.ci_fd];
    float hSaltsString =  [HKGlobal heightOfGivenText:saltsString ofWidth:300.0 andFont:font];
    
    // Usage Label
    NSString *usageString = [NSString stringWithFormat:@"Typical Usage: %@",saltInfoModel.lc];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:usageString];
    NSInteger _stringLength=[usageString length];
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 14)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(15, _stringLength-15)];
    float hUsageString =  [HKGlobal heightOfGivenText:[attrStr string] ofWidth:300.0 andFont:font];

    // Side Effects label
    NSString *sideEffectsString = [NSString stringWithFormat:@"Side Effects: %@",saltInfoModel.se];
    NSMutableAttributedString* attrStrSideEffects = [[NSMutableAttributedString alloc] initWithString:sideEffectsString];
    NSInteger _stringLengthSE = [sideEffectsString length];
    [attrStrSideEffects addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLengthSE)];
    [attrStrSideEffects addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 14)];
    [attrStrSideEffects addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(15, _stringLengthSE-15)];
    float hSideEffectsString =  [HKGlobal heightOfGivenText:[attrStrSideEffects string] ofWidth:300.0 andFont:font]+10;

    // Drug Interaction Label
    NSString *drugInteractionString = [NSString stringWithFormat:@"Drug Interaction: %@",saltInfoModel.di];
    NSMutableAttributedString* attrdrugInteractionStr = [[NSMutableAttributedString alloc] initWithString:drugInteractionString];
    NSInteger _strLenDrugInteraction = [drugInteractionString length];
    [attrdrugInteractionStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _strLenDrugInteraction)];
    [attrdrugInteractionStr addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 17)];
    [attrdrugInteractionStr addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(18, _strLenDrugInteraction-18)];
    float hAttrdrugInteractionStr =  [HKGlobal heightOfGivenText:[attrdrugInteractionStr string] ofWidth:300.0 andFont:font];
    
    // MechanismOfAction Label
    NSString *moaString = [NSString stringWithFormat:@"Mechanism Of Action: %@",saltInfoModel.moa];
    NSMutableAttributedString* attrMoaStr = [[NSMutableAttributedString alloc] initWithString:moaString];
    NSInteger _strLenMoa=[moaString length];
    [attrMoaStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _strLenMoa)];
    [attrMoaStr addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 20)];
    [attrMoaStr addAttribute:NSForegroundColorAttributeName value:_lightGray range:NSMakeRange(21, _strLenMoa-21)];
    float hAttrMoaStr =  [HKGlobal heightOfGivenText:[attrMoaStr string] ofWidth:300.0 andFont:font] + 10;
    
    NSArray * arrayTemp  = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:hSaltNameLabelString],
                             [NSNumber numberWithFloat:hSaltsString],
                             [NSNumber numberWithFloat:hUsageString],
                             [NSNumber numberWithFloat:hSideEffectsString],
                             [NSNumber numberWithFloat:hAttrdrugInteractionStr],
                             [NSNumber numberWithFloat:hAttrMoaStr],
                             nil];
    
    [arrayOFLabelsHeights addObject:arrayTemp];
    
    float cellHeight = hSaltNameLabelString+10+hSaltsString+10+hUsageString+10+hSideEffectsString+10+hAttrdrugInteractionStr+10+hAttrMoaStr+10;
    
    return cellHeight;
    
}

#pragma mark - tableview delegate and datasource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if(self.optionsSelectedIndex == 0)
        return self.drugDetailModel.saltInfoArray.count + 3;
    else
        return [self.medicineSubstituteArray count] + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)      // For the first row.
    {
        return 170.0f;
    }
    else if(indexPath.row == 1)                     // For segment cell
    {
        return 50.0f;
    }
    else if(indexPath.row == 2)                     // For salt names cell
    {
        if(self.optionsSelectedIndex == 0)
        {
            return 30.0f + [self saltNamesStringHeightFromArray:self.drugDetailModel.saltInfoArray]; // 30.0 is for first label
        }
        else
            return kSearchMedicinesTableViewRowHeight;
    }
    else
    {
        if(self.optionsSelectedIndex == 0)
            return [self saltDetailsCellHeight:[self.drugDetailModel.saltInfoArray objectAtIndex:indexPath.row-3]];
        else
            return kSearchMedicinesTableViewRowHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier0 = @"MedicineDetailViewCell";
    NSString *cellIdentifier1 = @"MedicineOptionSegmentCell";
    NSString *cellIdentifier2 = @"MedicineDetailInfoCell";
    NSString *cellIdentifier3 = @"HKSearchMedicineCell";
    NSString *cellIdentifier4 = @"SaltNamesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
    if(indexPath.row ==0)
    {
        HKMedicineDetailViewCell *medicineDetailCell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
        if(medicineDetailCell1 == nil)
        {
            medicineDetailCell1 = (HKMedicineDetailViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"MedicineDetailViewCell" owner:self options:nil] objectAtIndex:0];
            [medicineDetailCell1 modifyCellSubviews];
            medicineDetailCell1.medicineDetailDelegate = self;
        }
        
        medicineDetailCell1.stockAvailability = self.drugModel.available;
        medicineDetailCell1.imageURL = self.drugDetailModel.imageUrl;
        medicineDetailCell1.medPForm = self.drugModel.pForm;
        [medicineDetailCell1 updateCellData];
        if(self.drugModel.drugName != nil)
            medicineDetailCell1.medicineNameLabel.text = self.drugModel.drugName;
        else
            medicineDetailCell1.medicineNameLabel.text = @"";
        if(self.drugModel.manufacturer != nil)
            medicineDetailCell1.medicineBrandLabel.text = self.drugModel.manufacturer;
        else
            medicineDetailCell1.medicineBrandLabel.text = @"";
        if(self.drugModel.packForm != nil)
            medicineDetailCell1.sheetsLabel.text = self.drugModel.packForm;
        else
            medicineDetailCell1.sheetsLabel.text = @"";
        
        medicineDetailCell1.cellMedicineCount = medicineCount;
        medicineDetailCell1.numberOfMedicineTextField.text = [NSString stringWithFormat:@"%d",medicineCount];
        if(self.drugModel.packSize != nil)
            medicineDetailCell1.numberOfMedicineInSheetLabel.text = [NSString stringWithFormat:@"(%@ in a %@)", self.drugModel.packSize, self.drugModel.packForm];
        else
            medicineDetailCell1.numberOfMedicineInSheetLabel.text = @"";
        if(self.drugModel.oPrice)
            medicineDetailCell1.medicineFinalPriceLabel.text = [NSString stringWithFormat:@"Rs. %.2f ",self.drugModel.oPrice];
        else
            medicineDetailCell1.medicineFinalPriceLabel.text = @"";
        if(self.drugModel.packSize != (id)[NSNull null])
            medicineDetailCell1.totalMedicineLabel.text = self.drugModel.packSize;
        else
            medicineDetailCell1.totalMedicineLabel.text = @"";
        
        float discountPercentage = ((self.drugModel.mrp - self.drugModel.oPrice)*100)/self.drugModel.mrp;
        if(self.drugModel.mrp)
            medicineDetailCell1.medicineBasePriceLabel.text = [NSString stringWithFormat:@"Rs. %.2f | %g%% off",self.drugModel.mrp , discountPercentage];
        else
            medicineDetailCell1.medicineBasePriceLabel.text = @"";
        
        if(self.drugModel.oPrice < self.drugModel.mrp){
            
            medicineDetailCell1.strikeLabel.hidden = NO;
        }else{
            medicineDetailCell1.strikeLabel.hidden = YES;
        }
        
        if(self.drugModel.oPrice)
        {
            float totalPrice = medicineCount*self.drugModel.oPrice;
            medicineDetailCell1.medicineFinalPriceLabel.text = [NSString stringWithFormat:@"Rs. %.2f", totalPrice];
        }
        else
            medicineDetailCell1.medicineFinalPriceLabel.text = @"";
        
        return medicineDetailCell1;
    }
    else if(indexPath.row == 1)
    {
        HKMedicineOptionSegmentCell *optionSegmentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!optionSegmentCell)
        {
            optionSegmentCell = (HKMedicineOptionSegmentCell *)[[[NSBundle mainBundle] loadNibNamed:@"MedicineOptionSegmentCell" owner:self options:nil] objectAtIndex:0];
        }
        optionSegmentCell.medicineOptionSegmentedControl.selectedSegmentIndex = self.optionsSelectedIndex;
        optionSegmentCell.medicineOptionSegmentDelegate = self;
        return optionSegmentCell;
        
    }
    else if (indexPath.row == 2) // Salt names cell
    {
        // Decide which cell to display on the basis of user selection of segment control
        if (self.optionsSelectedIndex == 0)
        {
            SaltNamesCell *saltNamesCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier4];
            [saltNamesCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if(saltNamesCell == nil)
            {
                saltNamesCell = [[SaltNamesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier4 withHeightForSaltNamesLabel:heightOfSaltsNamesLabel];
            }
            //Check whether array contains any object or not
            if([self.drugDetailModel.saltInfoArray count] > 0)
            {
                [saltNamesCell customiseSaltNamesLabelWithString:saltNamesString];
            }
            return saltNamesCell;
        }
        else
        {
            HKSearchMedicineCell *searchMedicineCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (!searchMedicineCell) {
                searchMedicineCell = [[HKSearchMedicineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
            }
            
            if ([self.medicineSubstituteArray count] > indexPath.row-2)
            {
                HKDrugModel *drugModel = [self.medicineSubstituteArray objectAtIndex:indexPath.row-2];
                searchMedicineCell.drugModel = drugModel;
                [searchMedicineCell updateDrugDetails];
            }
            return searchMedicineCell;
        }
    }
    else // if cells are more than 3 , it means we substitues cell are showing // For search cells
    {
        // Decide which cell to display on the basis of user selection of segment control
        if (self.optionsSelectedIndex == 0)
        {
            HKMedicineDetailInfoCell *medicineDetailInfoCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if(medicineDetailInfoCell == nil)
            {
                medicineDetailInfoCell = (HKMedicineDetailInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"MedicineDetailInfoCell" owner:self options:nil] objectAtIndex:0];
            }
            //Check whether array contains any object or not
            if([self.drugDetailModel.saltInfoArray count] > 0)
            {
                [medicineDetailInfoCell customiseLabels:[self.drugDetailModel.saltInfoArray objectAtIndex:indexPath.row-3] WithHeights:[arrayOFLabelsHeights objectAtIndex:indexPath.row-3]]; // since 3 rows are already there
            }
            return medicineDetailInfoCell;
        }
        else
        {
            HKSearchMedicineCell *searchMedicineCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (!searchMedicineCell) {
                searchMedicineCell = [[HKSearchMedicineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
            }
            
            if ([self.medicineSubstituteArray count] > indexPath.row-2)
            {
                HKDrugModel *drugModel = [self.medicineSubstituteArray objectAtIndex:indexPath.row-2];
                searchMedicineCell.drugModel = drugModel; // 2 rows are diffrent and aleady there
                [searchMedicineCell updateDrugDetails];
            }
            return searchMedicineCell;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= 2)
    {
        if (self.optionsSelectedIndex != 0)
        {
            // Check wheteher the medicine type is drug or OTC
            // IF Drug then SearchedMedicineDetailSegue
            // If OTC then OTCDetailView
            
            int row = indexPath.row-2;
            HKDrugModel *tempDrugModel = (HKDrugModel *)[self.medicineSubstituteArray objectAtIndex:row];
            
            if([tempDrugModel.drugType isEqualToString:DRUG_TYPE_OTC])
            {
                [self performSegueWithIdentifier:@"OTCDetailView" sender:[self.medicineSubstituteArray objectAtIndex:row]];
            }
            else if([tempDrugModel.drugType isEqualToString:DRUG_TYPE_DRUGS] || tempDrugModel.drugType == nil)
            {
                // programmatically creating the story board instance
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HKMedicineDetailController *medicineDetailsController = (HKMedicineDetailController *)[storyboard instantiateViewControllerWithIdentifier:@"MedicineDetail"];
                medicineDetailsController.drugModel = tempDrugModel;
                [self.navigationController pushViewController:medicineDetailsController animated:YES];
            }
        }
    }
}

#pragma mark - prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchedMedicineDetailSegue"])
    {
        HKMedicineDetailController *medicineDetailController = [segue destinationViewController];
        medicineDetailController.drugModel = (HKDrugModel*) sender;
    }
    else if([segue.identifier isEqualToString:@"OTCDetailView"])
    {
        HKOTCViewController *otcViewController =[segue destinationViewController];
        otcViewController.drugModel = (HKDrugModel *)sender;
    }
    
}


#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CHECKOUT_FLOW_ALERTVIEW) {
        switch (buttonIndex) {
            case 0:
            {
                //proceed with checkout flow
                [self performSegueWithIdentifier:@"goCheckout" sender:self];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getDrugDetails
{
    [self showSpinnerWithMessage:@"Loading"];
    NSString *drugDetailURL = [NSString stringWithFormat:@"%@/drugs/%d", BaseURLString, (int)self.drugModel.drugId];
    
    NSLog(@"medicine detail URL : %@", drugDetailURL);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block HKMedicineDetailController *blockSelf = self;
    [manager GET:drugDetailURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id drugDetail = [responseObject objectForKey:@"result"];
         
         if(drugDetail && [drugDetail isKindOfClass:[NSDictionary class]])
         {
             //populate drug detail model here and update the view
             [blockSelf createDrugDetailModelFromDrugDictionary:(NSDictionary*)drugDetail];
             
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

-(void)createDrugDetailModelFromDrugDictionary:(NSDictionary*)drugDetailInfo
{
    HKDrugDetailModel *drugDetail = [[HKDrugDetailModel alloc] initWithDrugDetailDictionary:drugDetailInfo];
    self.drugDetailModel = drugDetail;
    
    //NSLog(@"self.drugdetailmodel = %@",[self.drugDetailModel.saltInfoArray objectAtIndex:0]);
    if([self.drugDetailModel.saltInfoArray count]>0)
    {
        HKDrugSaltInfoModel *saltInfoModel = [self.drugDetailModel.saltInfoArray objectAtIndex:0];
        NSLog(@"saltinfomodel- name = %@",saltInfoModel.saltName);
    }
    
    
    // Assigning the tableview delegate and datasource when we have the drug detail whole information with a network call.
    self.medicineDetailTableview.delegate = self;
    self.medicineDetailTableview.dataSource = self;
    [self.medicineDetailTableview reloadData];
    
}

-(void)getDrugSubstitutes
{
    NSString *drugSubstitutesURL = [NSString stringWithFormat:@"%@/get/substitutes/%d", BaseURLString, (int)self.drugModel.drugId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __block HKMedicineDetailController *blockSelf = self;
    [manager GET:drugSubstitutesURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id drugSubstitutes = [responseObject objectForKey:@"result"];
         
         if(drugSubstitutes && [drugSubstitutes isKindOfClass:[NSArray class]])
         {
             [blockSelf createDrugSubstitutesModels:drugSubstitutes];
        }
         else
         {
             // TODO: handle else condition appropriately
         }
         [blockSelf.medicineDetailTableview reloadData];
         [blockSelf stopSpinner];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO:: handle error appropriately
         [blockSelf stopSpinner];
     }];
}

-(void)createDrugSubstitutesModels:(NSArray*)substitutes
{
    for (id drugSubstitute in substitutes) {
        if ([drugSubstitute isKindOfClass:[NSDictionary class]])
        {
            HKDrugModel *drugModel = [[HKDrugModel alloc] initWithSubstituteDictionary:drugSubstitute];
            [self.medicineSubstituteArray addObject:drugModel];
        }
    }
}

#pragma mark - HKMedicineDetailDelegate methods

-(void)buyButtonTappedWithMedicineCount:(NSUInteger)noOfMedicines
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


-(void)drugCountUpdated:(NSInteger)quantity
{
    medicineCount = quantity;
    NSLog(@"medicinecount = %ld",(long)medicineCount);

    NSInteger totalQuantity = 0;
    // updated the pack size property of drug model
    if(self.drugModel.packSize != (id)[NSNull null])
    {
        NSArray *arrayComponents = [self.drugModel.packSize componentsSeparatedByString:@" "];
        if(counter == 0)
        {
            originalQuantity = ((NSString *)[arrayComponents objectAtIndex:0]).integerValue;
            NSLog(@"original quantity = %ld",(long)originalQuantity);
            // Increasing the counter
            counter ++;
        }
        
        totalQuantity = medicineCount *originalQuantity;
        
        self.drugModel.packSize = [NSString stringWithFormat:@"%ld %@",  (long)totalQuantity, [arrayComponents objectAtIndex:1]];
        
        NSLog(@"packsize = %@",self.drugModel.packSize);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.medicineDetailTableview reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - HKMedicineOptionSegmentDelegate methods

-(void)optionSegmentedControlTappedWithSegmentIndex:(NSUInteger)segmentIndex
{
    NSLog(@"selected Segment index=%d",(int)segmentIndex);
    self.optionsSelectedIndex = segmentIndex;
    
    if(self.medicineSubstituteArray && [self.medicineSubstituteArray count]> 0)
    {
        [self.medicineDetailTableview reloadData];
    }
    else
    {
        [self showSpinnerWithMessage:@"Loading..."];
        [self getDrugSubstitutes];
    }
}

@end
