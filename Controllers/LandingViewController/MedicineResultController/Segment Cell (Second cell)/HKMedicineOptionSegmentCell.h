//
//  HKMedicineOptionSegmentCell.h
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 01/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKMedicineOptionSegmentDelegate <NSObject>

-(void)optionSegmentedControlTappedWithSegmentIndex:(NSUInteger)segmentIndex;

@end

@interface HKMedicineOptionSegmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *medicineOptionSegmentedControl;
@property (assign, nonatomic) id <HKMedicineOptionSegmentDelegate> medicineOptionSegmentDelegate;

- (IBAction)optionSegmentedControlTapped:(id)sender;

@end
