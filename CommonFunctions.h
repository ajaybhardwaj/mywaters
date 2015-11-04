//
//  CommonFunctions.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 10/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <UIKit/UIKit.h>
#import "ViewControllerHelper.h"
#import "ApiClass.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "JSON.h"
#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "MBProgressHUD.h"

@interface CommonFunctions : NSObject <CLLocationManagerDelegate>


+ (BOOL) hasConnectivity;
+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)dismissGlobalHUD;

+ (NSString *) getAppVersionNumber;
+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (BOOL) characterSet1Found:(NSString *) text;
+ (BOOL) characterSet2Found:(NSString *) text;
+ (void) showAlertView:(id)dele title:(NSString*)alertTitle msg:(NSString*)alertMessage cancel:(NSString *)cancelTitle otherButton:(NSString *)otherButtonTitles, ...;
+ (void) showActionSheet:(id)dele containerView:(UIView *) view title:(NSString*)sheetTitle msg:(NSString*)alertMessage cancel:(NSString *)cancelTitle tag:(NSInteger)tagValue destructive:(NSString *)destructiveButtonTitle otherButton:(NSString *)otherButtonTitles, ...;
+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width;
+ (NSString*) kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to;
+ (NSString *)dateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;
+ (NSString *)dateTimeFromString:(NSString *)dateTimeString;
+ (NSString *)dateFromString:(NSString *)dateString;
+ (NSDate *)dateValueFromString:(NSString *)dateTimeString;
+ (NSMutableDictionary *)extractXML:(NSMutableDictionary *)XMLDictionary;
+ (void) checkForLocationSerives:(NSString*) titleString message:(NSString*) messageString view:(UIViewController*) viewObj;
+ (CLLocationCoordinate2D) getUserCurrentLocation;

# pragma mark - Server GET & POST Methods
+ (void) grabGetRequest:(NSString*)apiName delegate:(UIViewController*)viewObj isNSData:(BOOL)data accessToken:(NSString*)token;
+ (void) grabPostRequest:(NSArray *)paramters paramtersValue:(NSArray *)values delegate:(UIViewController *)viewObj isNSData:(BOOL)data baseUrl:(NSString*) baseUrl;



+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

# pragma mark - Facebook & Twitter Share Method
+ (void) sharePostOnFacebook:(NSString*)postImageUrl appUrl:(NSString*)appstoreUrl title:(NSString*)postTitle desc:(NSString*)postDescription view:(UIViewController*) viewObj abcIDValue:(NSString*)abcIdString;
+ (void) sharePostOnTwitter:(NSString *)appStoreUrl title:(NSString *)postTitle view:(UIViewController *)viewObj abcIDValue:(NSString*)abcIdString;
@end
