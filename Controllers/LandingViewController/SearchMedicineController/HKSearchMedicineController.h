//
//  HKSearchMedicineController.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSearchMedicineController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;

@end
