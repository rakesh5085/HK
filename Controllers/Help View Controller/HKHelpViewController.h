//
//  HKHelpViewController.h
//  HealthKart+
//
//  Created by vivek on 28/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKHelpViewController : UIViewController<UIScrollViewDelegate> {
	UIScrollView* scrollView;
	UIPageControl* pageControl;
	
    int scrollOffset;
    
	BOOL pageControlBeingUsed;
}

@property (nonatomic) NSTimer *timer;
@property (nonatomic) IBOutlet UIButton *btnClose;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

- (IBAction)changePage;

@end
