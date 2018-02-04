//
//  HKGlobal.m
//  HealthKart+
//
//  Created by Letsgomo Labs on 23/10/13.
//  Copyright (c) 2013 LetsgomoLabs. All rights reserved.
//

#import "HKGlobal.h"

#import "HKAIViewController.h"

#import "AFNetworking.h"

@implementation HKGlobal

@synthesize globalDelegate;


#pragma mark - shared instance GNGlobal

+(HKGlobal*)sharedHKGlobal
{
    static dispatch_once_t onceToken;
    static HKGlobal *hkGlobal = nil;
    dispatch_once(&onceToken, ^{
        hkGlobal = [[HKGlobal alloc] init];
        NSLog(@"Creating a shared object");
        hkGlobal.cartItemsGlobalArray = [[NSMutableArray alloc] init];
    });
    return hkGlobal;
}

#pragma mark - helper uiimage methods
// image resizing method
+(UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth: (float)i_width
{
    // To Resize the image maintaining the aspect ratio
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - for dynamic size of Label

+ (UILabel *)adjustHeightOfLabel:(UILabel *)lbl
{
    CGRect textRect = [lbl.text boundingRectWithSize:CGSizeMake(lbl.frame.size.width, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:lbl.font}
                                                 context:nil];
    
    
    CGRect newFrame = lbl.frame;
    newFrame.size.height = textRect.size.height;
    lbl.frame = newFrame;
    return lbl;
}

#pragma mark - adjust frame from a given text

+(float) heightOfGivenText: (NSString *)string ofWidth: (float)width andFont:(UIFont *)font
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(width, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName:font}
                                                 context:nil];
    

    return textRect.size.height;
}


#pragma mark - auto sign in to app
-(void) autoSignIn
{
    /*
     Sign in API
     // *******************************************
     TYPE : POST
     Parameters :emailId & password
     URL sample: @" http://www.healthkartplus.com/authenticate?username={emailID}&password={password}"
     // *******************************************
     */
    
    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"emailAddress"];
    NSString *password = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"password"];
    if(username && username.length > 0)
    {
        NSString *signInURLString = ProductionBaseURLString;
        // Creating dictionary to give parameter
        NSDictionary *parameterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",@"rest",@"protocol",nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:signInURLString parameters:parameterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             if([[responseObject objectForKey:@"result"] objectForKey:@"uid"])
             {
                 
                 NSDictionary *headers = [operation.response allHeaderFields];
                 NSString *str = [headers valueForKey:@"Set-Cookie"];
                 
                 NSArray *arr = [str componentsSeparatedByString:@"."];
                 NSArray *arrr2 = [[arr objectAtIndex:0] componentsSeparatedByString:@"="];
                 NSString *cookieValue = [arrr2 objectAtIndex:1];
                 NSDictionary *properties1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"staging.healthkartplus.com", NSHTTPCookieDomain,
                                              @"/", NSHTTPCookiePath,
                                              @"JSESSIONID", NSHTTPCookieName,
                                              cookieValue, NSHTTPCookieValue,
                                              nil];
                 NSHTTPCookie *httpCookie = [NSHTTPCookie cookieWithProperties:properties1];
                 NSArray *cookieArray = [NSArray arrayWithObjects:httpCookie, nil];
                 [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookieArray forURL:operation.response.URL mainDocumentURL:operation.response.URL];
                 
                 NSDictionary *userInfo;
                 if([[responseObject objectForKey:@"result"] objectForKey:@"profession"] != (id) [NSNull null])
                 {
                     userInfo = @{@"emailAddress":[[responseObject objectForKey:@"result"] objectForKey:@"emailAddress"],@"userid":[[responseObject objectForKey:@"result"] objectForKey:@"uid"],@"username":[[responseObject objectForKey:@"result"] objectForKey:@"username"],
                                  @"password":password,@"profession":[[responseObject objectForKey:@"result"] objectForKey:@"profession"]};
                 }
                 else
                 {
                     userInfo = @{@"emailAddress":[[responseObject objectForKey:@"result"] objectForKey:@"emailAddress"],@"userid":[[responseObject objectForKey:@"result"] objectForKey:@"uid"],@"username":[[responseObject objectForKey:@"result"] objectForKey:@"username"], @"password":password};
                 }
                 // Save user prefrences ..
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:userInfo forKey:@"userInfo"];
                 
                 if (self.globalDelegate && [self.globalDelegate respondsToSelector:@selector(signInResponseReceived)]) {
                     [self.globalDelegate signInResponseReceived];
                 }
                 
                 NSLog(@"user id at the time of signing in : %@", [defaults objectForKey:@"userInfo"]);
             }
             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             //FAILURE STEPS
             NSLog(@"failure - response object = %@",[error description]);
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"Some error occurred. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertView show];
             

             if (self.globalDelegate && [self.globalDelegate respondsToSelector:@selector(signInResponseReceived)]) {
                 [self.globalDelegate signInResponseReceived];
             }
         }
         ];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"HealthKart Plus" message:@"Please sign in to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        if (self.globalDelegate && [self.globalDelegate respondsToSelector:@selector(signInResponseReceived)]) {
            [self.globalDelegate signInResponseReceived]; //
        }
    }
}




@end
