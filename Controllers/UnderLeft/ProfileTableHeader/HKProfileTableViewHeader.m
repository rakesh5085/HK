//
//  HKProfileTableViewHeader.m
//  HealthKart+
//
//  Created by Sourabh Shekhar Singh on 21/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKProfileTableViewHeader.h"

@implementation HKProfileTableViewHeader
@synthesize tableEmailField,headerImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSString *email = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
        if([email isEqualToString:@""]){
            self.tableEmailField.text = @"Guest";
        }else{
        self.tableEmailField.text = email;
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void) setProfileHeader
{
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"username"];
    
    if(username == nil || [username isKindOfClass:[NSNull class]]){
        self.tableEmailField.text = @"Guest";
    }else{
        self.tableEmailField.text = username;
    }
    
}


@end
