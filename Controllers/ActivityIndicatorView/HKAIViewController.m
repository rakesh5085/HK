//
//  HKAIViewController.m
//  HealthKart+
//
//  Created by Udit Kakkad on 05/11/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKAIViewController.h"

typedef enum{
    VALID_BOUNDRIES,
    INVALID_BOUNDRIES,
    INVALID
}viewBoundries;

@interface HKAIViewController ()
{
    
    
    //Activity Indicator class members
    UIView *_backgroundView;
    UIView *_spinnerContainerView;
    UIActivityIndicatorView *_spinnerView;
    UILabel *_spinnerLabel;
    NSString *_spinnerLabelString;
    UIView *_containerView;
    
    CGPoint center;
}
#pragma mark - view controller properties

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *spinnerContainerView;
@property (nonatomic, retain) NSString *spinnerLabelString;
@property (nonatomic, retain) UIView *containerView;



/**
 -(void)loadAllRequiredView;
 * @desc - load activity indicator container view,
 * activity indicator view and its label.
 */
-(void)loadAllRequiredView;

/**
 -(viewBoundries)checkIfContainerViewBoundriesAreValidForSpinnerContainerView;
 * @desc check if provided view to show activiy indicator is having valid bounds to show black colored
 * spinner container view. The default bounds for the spinner container view is {0,0,150,150}
 * if provided view is smaller than these bounds, spinner will be shown directly on the provided view without
 * black colored container view
 * @return enum value of type viewBoundries
 */
-(viewBoundries)checkIfContainerViewBoundriesAreValidForSpinnerContainerView;

/**
 -(NSComparisonResult)compareFrame:(CGRect)frame1 withFrame:(CGRect)frame2;
 * @desc compares size of two frames
 * @param frame1 frame to be compared
 * @param frame2 frame to be compared with
 * @return NSComparisonResult values...Ascending if frame1 is of larger size
 * Descending if vice versa and same if size is same.
 */
-(NSComparisonResult)compareFrame:(CGRect)frame1 withFrame:(CGRect)frame2;
@end

@implementation HKAIViewController
@synthesize backgroundView          = _backgroundView;
@synthesize spinnerContainerView    = _spinnerContainerView;
@synthesize spinnerView             = _spinnerView;
@synthesize spinnerLabel            = _spinnerLabel;
@synthesize spinnerLabelString      = _spinnerLabelString;
@synthesize containerView           = _containerView;
@synthesize backgroundOpacity;

-(id)initToShowOnView:(UIView *)containerView WithSpinnerLabelText:(NSString *)labelText
{
    self = [super init];
    if(self)
    {
        if(containerView != nil)
        {
            self.containerView      = containerView;
            self.spinnerLabelString = labelText;
            [self loadAllRequiredView];
        }
    }
    return self;
}

/**
 \internal
 * The opacity of the activity background. Defaults to 0.7 (70% opacity).
 */
- (void)setBackgroundOpacity:(float)background_Opacity{
    
    if (self.backgroundView) {
        [self.backgroundView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:background_Opacity]];
    }
}

#pragma mark - view lifecycle methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)startAnimatingSpinner
{
    if(self.spinnerView != nil)
    {
        [self.containerView addSubview:self.backgroundView];
        [self.containerView setUserInteractionEnabled:NO];
        [self.spinnerView startAnimating];
    }
    
    
}

-(void)startAnimatingSpinnerWithMessage:(NSString *)message
{
    if(self.spinnerView != nil)
    {
        [self.backgroundView setTag:9999];
        self.spinnerLabel.text = message;
        [self.backgroundView setFrame:self.containerView.bounds];
        [self.containerView addSubview:self.backgroundView];
        [self.containerView setUserInteractionEnabled:NO];
        [self.spinnerView startAnimating];
    }
}

-(void)setTextForAnimatingSpinner:(NSString*)message
{
    if (self.spinnerView) {
        self.spinnerLabel.text = message;
    }
}

-(void)stopAnimatingSpinner
{
    if(self.spinnerView != nil && self.containerView != nil)
    {
        [self.spinnerView stopAnimating];
        [self.containerView setUserInteractionEnabled:YES];
        [self.backgroundView removeFromSuperview];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.backgroundView setFrame:self.containerView.bounds];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.backgroundView setFrame:self.containerView.bounds];
}

-(BOOL)isAnimating
{
    return (self.spinnerView && self.spinnerView.isAnimating);
}

-(void)loadAllRequiredView
{
    CGFloat width   = 0.0f;
    CGFloat height  = 0.0f;
    CGFloat xPos    = 0.0f;
    CGFloat yPos    = 0.0f;
    
    if(self.containerView != nil)
    {
        //container view
        UIView *contView                = [[UIView alloc] init];
        contView.backgroundColor        = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        contView.opaque                 = NO;
        contView.userInteractionEnabled = NO;
        contView.autoresizingMask       = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        // place holder
        UIView *placeHolderView           = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, self.containerView.frame.size.width, 100)];
        placeHolderView.backgroundColor   = [UIColor clearColor];
        placeHolderView.autoresizingMask  = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        placeHolderView.center = center;
        [contView addSubview:placeHolderView];
        
        self.backgroundView             = contView;
        [self.backgroundView setFrame:self.containerView.bounds];
        [self.containerView setUserInteractionEnabled:NO];
        //        [self.containerView addSubview:self.backgroundView];
        center = self.backgroundView.center;
        //[contView release];//post ARC
        contView = nil;
        
        
        //activity indicator view
        
        UIActivityIndicatorView *actIndctr  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        actIndctr.frame                     = CGRectMake(placeHolderView.frame.size.width/2 - 37/2, placeHolderView.bounds.origin.y + 5, 37, 37); // 37 is the default width and height of indicator
        actIndctr.hidden                    = NO;
        actIndctr.hidesWhenStopped          = YES;
        self.spinnerView = actIndctr;
        if(self.spinnerContainerView != nil)
        {
            [self.spinnerContainerView addSubview:self.spinnerView];
        }
        else
        {
            [placeHolderView addSubview:self.spinnerView];
        }
        actIndctr = nil;
        
        
        //activity label view
        if(self.spinnerLabelString == nil)
        {
            NSString *string = [NSString stringWithString:NSLocalizedString(@"Loading...", @"")];
            self.spinnerLabelString = string;
        }
        width   = self.spinnerView.superview.bounds.size.width;
        height  = 30.0f;
        
        CGRect labelFrame               = CGRectMake(0, 55, width, height);
        UILabel *label                  = [[UILabel alloc]initWithFrame:labelFrame];
        label.backgroundColor           = [UIColor clearColor];
        label.textColor                 = [UIColor whiteColor];
        label.text                      = self.spinnerLabelString;
        label.textAlignment             = NSTextAlignmentCenter;
        label.font                  = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        label.userInteractionEnabled    = NO;
        label.shadowColor               = [UIColor lightGrayColor];
        label.minimumScaleFactor           = 10.0f;
        label.lineBreakMode             = NSLineBreakByTruncatingTail;
        label.adjustsFontSizeToFitWidth = YES;
        self.spinnerLabel               = label;
        if(self.spinnerContainerView != nil)
        {
            [self.spinnerContainerView addSubview:self.spinnerLabel];
        }
        else
        {
            [placeHolderView addSubview:self.spinnerLabel];
        }
        label = nil;
    }
    
}

-(viewBoundries)checkIfContainerViewBoundriesAreValidForSpinnerContainerView
{
    if(self.containerView != nil)
    {
        CGRect defaultBoundsForSpinnerContainerView = CGRectMake(0.0, 0.0, 150.0, 150.0);
        switch([self compareFrame:self.containerView.bounds withFrame:defaultBoundsForSpinnerContainerView])
        {
            case NSOrderedAscending:
                return VALID_BOUNDRIES;
            case NSOrderedDescending:
                return INVALID_BOUNDRIES;
            default:
                return INVALID;
        }
    }
    return INVALID;
}

-(NSComparisonResult)compareFrame:(CGRect)frame1 withFrame:(CGRect)frame2
{
    if((frame1.size.width > frame2.size.width) && (frame1.size.height > frame2.size.height))
    {
        return NSOrderedAscending;
    }
    else
    {
        return NSOrderedDescending;
    }
}

@end
