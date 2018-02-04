//
//  HKMyOrderDetailViewController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 16/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKMyOrderDetailViewController.h"
#import "HKMyOrderDetailCell.h"
#import "HKReorderViewController.h"
#import "HKNavigationReorderController.h"


@interface HKMyOrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myOrderDetailTableView;

@property (weak, nonatomic) IBOutlet UIView *myOrderdetailTopView;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *reorderButton;

@end

@implementation HKMyOrderDetailViewController

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
    self.reorderButton.layer.cornerRadius = 3.0f;
    self.reorderButton.layer.borderWidth = 1.0f;
    self.reorderButton.layer.borderColor = [[UIColor colorWithRed:0.580f green:.714f blue:1.0f alpha:1.0] CGColor];
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"Order# %@", [self.orderModel valueForKey:@"orderId"] ];
    
    NSDate * newNow = [NSDate dateWithTimeIntervalSince1970:self.orderModel.orderTimeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yy"];
    NSString *dateString = [formatter stringFromDate:newNow];
    
    self.orderDateLabel.text = [NSString stringWithFormat:@"Ordered On %@",dateString];
    
    self.status = self.orderModel.status;
    
    if([self.status isEqualToString:@"cancelled"]){
        
    }else if([self.status isEqualToString:@"delivered"]){
        
    }else {
        
        [self.reorderButton setHidden:YES];
        
    }
    
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - reorder tapped

- (IBAction)reorderButtonClicked:(id)sender
{
    HKNavigationReorderController *newTopViewController = (HKNavigationReorderController *)[self.storyboard instantiateViewControllerWithIdentifier:@"NavigationReorder"];
    
    HKReorderViewController *reorderController = (HKReorderViewController *)[newTopViewController.viewControllers objectAtIndex:0];
    
    reorderController.fromScene = COMINGFROM_MYORDERS;
    
    [self presentViewController:newTopViewController animated:YES completion:nil];
}

#pragma mark - UITableview Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.orderItems count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MyOrderDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        HKMyOrderDetailCell *myOrderDetailCell = (HKMyOrderDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyOrderDetailCell" owner:self options:nil] objectAtIndex:0];
        
        [myOrderDetailCell loadMedicineImageWithURL:[[self.orderItems objectAtIndex:indexPath.row] valueForKey:@"packForm"]];
        
        myOrderDetailCell.medicineNameLabel.text = [[self.orderItems objectAtIndex:indexPath.row] valueForKey:@"productName"];
        
        myOrderDetailCell.numberOfSheetsLabel.text = [NSString stringWithFormat:@"%@ %@(s)",[[self.orderItems objectAtIndex:indexPath.row] valueForKey:@"productQuantity"],[[self.orderItems objectAtIndex:indexPath.row] valueForKey:@"packForm"] ];
        
        myOrderDetailCell.priceLabel.text = [NSString stringWithFormat:@"Rs. %@",[[self.orderItems objectAtIndex:indexPath.row] valueForKey:@"unitPrice"] ];
        
        myOrderDetailCell.totalAmountLabel.text = [NSString stringWithFormat:@"Rs. %@",[[self.orderItems objectAtIndex:indexPath.row] valueForKey:@"offeredPrice"] ];
        
        return myOrderDetailCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}


@end
