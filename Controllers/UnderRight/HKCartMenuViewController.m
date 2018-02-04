//
//  HKCartMenuViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKCartMenuViewController.h"
#import "HKCartMenuCell.h"
#import "HKGlobal.h"
#import "HKCartMenuModel.h"

# define KEYBOARD_HEIGHT (CGSizeMake([[UIScreen mainScreen ] bounds ].size.width, 190))

@interface HKCartMenuViewController ()
{
    HKCartMenuCell *cartMenuCell;
    HKGlobal *sharedHKGlobal;
}

@property (weak, nonatomic) IBOutlet UIView *cartTopView;

@property (weak, nonatomic) IBOutlet UITableView *cartTableView;

@property (weak, nonatomic) IBOutlet UIView *cartBottomView;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

@property (weak, nonatomic) IBOutlet UILabel *numberOfItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic, assign) CGFloat peekLeftAmount;

@end

@implementation HKCartMenuViewController

@synthesize peekLeftAmount;
@synthesize cartTopView = _cartTopView;
@synthesize cartBottomView = _cartBottomView;
@synthesize cartTableView = _cartTableView;

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
    // Initialising HLGlobal Object
    sharedHKGlobal = [HKGlobal sharedHKGlobal];
    
    self.peekLeftAmount = 40.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat heightOfScreen = screenSize.height;
    if(heightOfScreen == 480.0f)
    {
        [_cartTableView setFrame:CGRectMake(_cartTableView.frame.origin.x, _cartTableView.frame.origin.y, 320, 289)];
        [_cartBottomView setFrame:CGRectMake(_cartBottomView.frame.origin.x, 394, _cartBottomView.frame.size.width, _cartBottomView.frame.size.height)];
    }
    
    // This is done to resignn the keyboard down.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    // Updating numberofitems label text.
    self.numberOfItemsLabel.text = [NSString stringWithFormat:@"Total %d Items",[sharedHKGlobal.cartItemsGlobalArray count]];
    // Updating total price label text
    self.totalPriceLabel.text = [self returnTotalPriceOfCartItems];
    
    [self.cartTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)viewWillAppear:(BOOL)animated
{
    // Updating numberofitems label text.
    self.numberOfItemsLabel.text = [NSString stringWithFormat:@"Total %d Items",[sharedHKGlobal.cartItemsGlobalArray count]];
    // Updating total price label text
    self.totalPriceLabel.text = [self returnTotalPriceOfCartItems];
    [self.cartTableView reloadData];
    
    if(sharedHKGlobal.cartItemsGlobalArray.count == 0 )
    {
        [self.checkoutButton setEnabled:NO];
    }else{
        
        [self.checkoutButton setEnabled:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tap gesture
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [sharedHKGlobal.cartItemsGlobalArray count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO - Follow this up with model class
    // Get the model object with index.
    HKCartMenuModel *cartMenuModel = (HKCartMenuModel *)[sharedHKGlobal.cartItemsGlobalArray objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"CartMenuCell";
    HKCartMenuCell *cartMenuCell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cartMenuCell1 == nil)
    {
        cartMenuCell1 = (HKCartMenuCell *)[[[NSBundle mainBundle] loadNibNamed:@"CartMenuCell" owner:self options:nil] objectAtIndex:0];
        cartMenuCell1.cartmenuMedicineCountTextField.layer.cornerRadius = 5.0f;
        cartMenuCell1.cartmenuMedicineCountTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        cartMenuCell1.cartmenuMedicineCountTextField.layer.borderWidth = 1.0f;
        cartMenuCell1.cartMenuDelegate = self;
    }
    
    if([cartMenuModel.medPForm isEqualToString:@"Bottle"]) // if feedimage string is not nil
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Syrup_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Capsule"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Capsule_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Tube"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Tube_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Tablet"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Tablet_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Strip"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Tablet_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Box"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Box_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Syrup"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Syrup_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Aerosol"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Aerosol_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Device"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Device_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Drops"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Drops_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"EA"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"EA_white1"];
        
    }else if([cartMenuModel.medPForm isEqualToString:@"Injection"])
    {
            cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"Injection_white1 "];
    }
    
    
    //cartMenuCell1.cartMenuMedicineImageview.image = [UIImage imageNamed:@"profile"];
    cartMenuCell1.cartMenuMedicineNameLabel.text = cartMenuModel.cartMenuMedicineName;
    cartMenuCell1.cartMenuMedicinePriceLabel.text = [NSString stringWithFormat:@"Rs. %.2f",cartMenuModel.cartMenuMedicineTotalPrice];//*cartMenuModel.cartMenuMedicineCount];
    cartMenuCell1.cartmenuMedicineCountTextField.text = [NSString stringWithFormat:@"%d",cartMenuModel.cartMenuMedicineCount];
    cartMenuCell1.sheetsLabel.text = cartMenuModel.cartMenuSheetType;
    
    return cartMenuCell1;
}

#pragma mark - UITableviewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexpath.row = %d",indexPath.row);
    //cartMenuCell = (HKCartMenuCell *)[[[cartMenuCell.contentView viewWithTag:10] superview] superview];
}


#pragma mark - Private Methods

- (IBAction)checkoutButtonClicked:(id)sender
{
    //TODO: Checkout Network Call
    
    if([sharedHKGlobal.cartItemsGlobalArray count]> 0 )
    {
        //CheckoutNavigation
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutNavigation"];
        [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
            
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    else
    {
        UIAlertView *itemAlert = [[UIAlertView alloc] initWithTitle:@"HealthKart PLus" message:@"No items to checkout" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [itemAlert show];
    }
    
}

// Method to return price of Items in list
-(NSString *)returnTotalPriceOfCartItems
{
    NSString *totalPrice = nil;
    float priceOfItem = 0.0;
    for (HKCartMenuModel *cartMenuModelObj in sharedHKGlobal.cartItemsGlobalArray)
    {
        priceOfItem += cartMenuModelObj.cartMenuMedicineTotalPrice;
    }
    totalPrice = [NSString stringWithFormat:@"Rs. %.2f",priceOfItem];
    
    return totalPrice;
}

-(void)scrollTableViewRowUpWithSelectedCell
{
    CGSize kbSize = KEYBOARD_HEIGHT;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.cartTableView.contentInset = contentInsets;
    self.cartTableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.cartTableView.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, cartMenuCell.cartmenuMedicineCountTextField.frame.origin) ) {
        [self.cartTableView scrollRectToVisible:cartMenuCell.frame animated:YES];
    }
    
    
}

-(void)scrollTableViewRowDownWithSelectedCell
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.cartTableView.contentInset = contentInsets;
    self.cartTableView.scrollIndicatorInsets = contentInsets;
    
}

#pragma mark - HKCartMenuDelegate
-(void)medicineCountUpdated:(NSInteger)count withSelectedCell:(HKCartMenuCell *)cartMenuSelectedCell
{
    // Get the indexpath from cell i.e cartMenuSelectedCell
    NSIndexPath *selectedIndexPath = [self.cartTableView indexPathForCell:cartMenuSelectedCell];
    // Get the modal from global array at selected indexpath row
    HKCartMenuModel *tempCartMenuModel = (HKCartMenuModel *)[sharedHKGlobal.cartItemsGlobalArray objectAtIndex:selectedIndexPath.row];
    //  Update the price in the modal
    tempCartMenuModel.cartMenuMedicineTotalPrice = tempCartMenuModel.cartMenuMedicinePrice * count;
    // Update the count in model
    tempCartMenuModel.cartMenuMedicineCount = count;
    // reload the selected cell
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:selectedIndexPath, nil];
    [self.cartTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    // Updating total price label text
    self.totalPriceLabel.text = [self returnTotalPriceOfCartItems];
    
}




@end
