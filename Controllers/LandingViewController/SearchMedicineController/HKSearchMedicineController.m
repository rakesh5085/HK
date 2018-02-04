//
//  HKSearchMedicineController.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKSearchMedicineController.h"
#import "HKDrugModel.h"
#import "AFNetworking.h"
#import "HKSearchMedicineCell.h"
#import "HKMedicineDetailController.h"
#import "HKAIViewController.h"
#import "HKOTCViewController.h"

#import "HKConstants.h"

@interface HKSearchMedicineController ()

@property (nonatomic, strong) NSMutableArray *medicinSearchedArray;
@property (nonatomic, strong) HKAIViewController *activityIndicator;
@property (nonatomic, strong) NSTimer *searchDelayer;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, assign) NSInteger pageNumber;
-(void)createDrugModels:(NSArray*)drugResults;

@end

@implementation HKSearchMedicineController

//@synthesize maskView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.medicinSearchedArray = [[NSMutableArray alloc] initWithCapacity:0];

    self.automaticallyAdjustsScrollViewInsets = false;

    // Do any additional setup after loading the view.
    self.pageNumber = 0;
    // setings bg of view accordig to mocups
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-faded.PNG"]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeSearchBarResponder
{
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.navigationController.navigationBarHidden == NO)
    {
        self.navigationController.navigationBarHidden = YES;
    }
    
    [self performSelector:@selector(makeSearchBarResponder) withObject:nil afterDelay:0.5];
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

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return self.medicinSearchedArray.count;
}

// to set height of each row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchController.searchResultsTableView)
    {
        return kSearchMedicinesTableViewRowHeight;
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HKSearchMedicineCell *cell = nil;
    if(tableView == self.searchController.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"HKSearchMedicineCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[HKSearchMedicineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell modifyCellSubviews];
        }
        
        if ([self.medicinSearchedArray count] > indexPath.row) {
            cell.drugModel = [self.medicinSearchedArray objectAtIndex:indexPath.row];
            [cell updateDrugDetails];
        }
        else
            cell.drugModel = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hasMore && indexPath.row == self.medicinSearchedArray.count-2) {
        [self getMoreSearchResults];
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected medicine : %@", [self.medicinSearchedArray objectAtIndex:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Check wheteher the medicine type is drug or OTC
    // IF Drug then SearchedMedicineDetailSegue
    // If OTC then OTCDetailView
    HKDrugModel *tempDrugModel = (HKDrugModel *)[self.medicinSearchedArray objectAtIndex:indexPath.row];
    if([tempDrugModel.drugType isEqualToString:DRUG_TYPE_DRUGS])
    {
        [self performSegueWithIdentifier:@"SearchedMedicineDetailSegue" sender:[self.medicinSearchedArray objectAtIndex:indexPath.row]];
    }
    else
    {
        [self performSegueWithIdentifier:@"OTCDetailView" sender:[self.medicinSearchedArray objectAtIndex:indexPath.row]];
    }
    
}

#pragma mark - UISearchBarDelegate methods

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //NSLog(@"searchtext = %@",searchText);
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[searchText stringByTrimmingCharactersInSet: set] length] == 0)
    {
        // String contains only whitespace.
        [self.medicinSearchedArray removeAllObjects];
        //NSLog(@"contains nothing");
    }
    else
    {
        if(searchText)
        {
            //removing the whitespaces
            searchText = [searchText stringByTrimmingCharactersInSet: set];
            if ([searchText length]>1) {
                [self.searchDelayer invalidate],
                self.searchDelayer = nil;
                
                self.searchDelayer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(performDelayedSearch:) userInfo:searchText repeats:NO];
            }
        }
    }
    
    
}

#pragma mark - search display controller delegates

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) keyboardWillHide {
    
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    
    [tableView setContentInset:UIEdgeInsetsZero];
    
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}



// ** create array of drug models
-(void)createDrugModels:(NSArray*)drugsResult
{
    [self.medicinSearchedArray removeAllObjects];
    
    for (id drugModel in drugsResult) {
        if ([drugModel isKindOfClass:[NSDictionary class]]) {
            HKDrugModel *drug = [[HKDrugModel alloc] initWithDictionary:drugModel];
            [self.medicinSearchedArray addObject:drug];
        }
    }
}

-(void)createMoreSearchResultDrugModels:(NSArray*)drugResult
{
    for (id drugModel in drugResult) {
        if ([drugModel isKindOfClass:[NSDictionary class]]) {
            HKDrugModel *drug = [[HKDrugModel alloc] initWithDictionary:drugModel];
            [self.medicinSearchedArray addObject:drug];
        }
    }
}

#pragma mark - prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      if ([segue.identifier isEqualToString:@"SearchedMedicineDetailSegue"])
      {
          NSLog(@"salt info array for this medicine :- %@", ((HKDrugModel*) sender));
          
        HKMedicineDetailController *medicineDetailController = [segue destinationViewController];
        medicineDetailController.drugModel = (HKDrugModel*) sender;
      }
      else if([segue.identifier isEqualToString:@"OTCDetailView"])
      {
          HKOTCViewController *otcViewController =[segue destinationViewController];
          otcViewController.drugModel = (HKDrugModel *)sender;
      }
          
}

-(void)performDelayedSearch:(NSTimer*)timer
{
     /*
     Call api to search on each key press
     // *******************************************
     Parameters : @name, @pageSize
     @name : keyword to search medicine for
     @pageSize : Number of results
     URL sample: @"http://staging.healthkartplus.com/webservices/search/all?name=cr&pageSize=5"
     // *******************************************
     */
    self.searchText = (NSString*)timer.userInfo;
    //NSString *searchUrl = [NSString stringWithFormat:@"%@/search/all?name=%@&pageSize=10", BaseURLString, (NSString*)timer.userInfo];
    NSString *searchUrl = [NSString stringWithFormat:@"%@/search/all", BaseURLString];
    // Creating dictionary to give parameter
    NSDictionary *parameterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.searchText,@"name",PageSize,@"pageSize", [NSString stringWithFormat:@"%d",self.pageNumber],@"pageNumber", nil];
    searchUrl = [searchUrl stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"searchurl = %@",searchUrl);
    self.searchDelayer = nil;
    
    __block HKSearchMedicineController *blockSelf = self;
    __block UISearchDisplayController *blockSearchController = self.searchController;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchUrl parameters:parameterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         blockSelf.hasMore = [[responseObject valueForKey:@"hasMore"] boolValue];
         blockSelf.pageNumber++;
         NSArray *arrResult = [responseObject objectForKey:@"result"];
         
         if((responseObject  != (id)[NSNull null]) && (arrResult  != (id)[NSNull null]) && arrResult.count>0)
         {
             [blockSelf createDrugModels:arrResult];
             [blockSearchController.searchResultsTableView reloadData];
         }
         else
         {
             //TODO: handle else condition appropriately

         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO:: handle error appropriately

         
     }];
}

-(void)getMoreSearchResults
{
    /*
     Call api to search on each key press
     // *******************************************
     Parameters : @name, @pageSize
     @name : keyword to search medicine for
     @pageSize : Number of results
     URL sample: @"http://staging.healthkartplus.com/webservices/search/all?name=cr&pageSize=5"
     // *******************************************
     */
    
    //NSString *searchUrl = [NSString stringWithFormat:@"%@/search/all?name=%@&pageSize=10", BaseURLString, (NSString*)timer.userInfo];
    NSString *searchUrl = [NSString stringWithFormat:@"%@/search/all", BaseURLString];
    // Creating dictionary to give parameter
    NSDictionary *parameterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.searchText,@"name",PageSize,@"pageSize",[NSString stringWithFormat:@"%d",self.pageNumber],@"pageNumber", nil];
    searchUrl = [searchUrl stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"searchurl = %@",searchUrl);
    self.searchDelayer = nil;
    
    __block HKSearchMedicineController *blockSelf = self;
    __block UISearchDisplayController *blockSearchController = self.searchController;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:searchUrl parameters:parameterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"responseobject = %@",responseObject);
         blockSelf.hasMore = [[responseObject valueForKey:@"hasMore"] boolValue];
         blockSelf.pageNumber++;
         NSArray *arrResult = [responseObject objectForKey:@"result"];
         
         if((responseObject  != (id)[NSNull null]) && (arrResult  != (id)[NSNull null]) && arrResult.count>0)
         {
             [blockSelf createMoreSearchResultDrugModels:arrResult];
             [blockSearchController.searchResultsTableView reloadData];
         }
         else
         {
             //TODO: handle else condition appropriately
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO:: handle error appropriately
         
         
     }];
}

@end
