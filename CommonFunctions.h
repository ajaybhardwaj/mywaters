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

@interface CommonFunctions : NSObject


+ (BOOL) hasConnectivity;
+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (BOOL) characterSet1Found:(NSString *) text;
+ (BOOL) characterSet2Found:(NSString *) text;
+ (void) showAlertView:(id)dele title:(NSString*)alertTitle msg:(NSString*)alertMessage cancel:(NSString *)cancelTitle otherButton:(NSString *)otherButtonTitles, ...;
+ (void) showActionSheet:(id)dele containerView:(UIView *) view title:(NSString*)sheetTitle msg:(NSString*)alertMessage cancel:(NSString *)cancelTitle tag:(NSInteger)tagValue destructive:(NSString *)destructiveButtonTitle otherButton:(NSString *)otherButtonTitles, ...;
+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width;
+ (NSString*) kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to;
+ (NSString *)dateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;
+ (NSString *)dateTimeFromString:(NSString *)dateTimeString;
+ (NSMutableDictionary *)extractXML:(NSMutableDictionary *)XMLDictionary;
+ (void) checkForLocationSerives:(NSString*) titleString message:(NSString*) messageString view:(UIViewController*) viewObj;

# pragma mark - Server GET & POST Methods
+ (void) grabGetRequest:(NSString*)apiName delegate:(UIViewController*)viewObj isNSData:(BOOL)data;
+ (void) grabPostRequest:(NSArray *)paramters paramtersValue:(NSArray *)values delegate:(UIViewController *)viewObj isNSData:(BOOL)data baseUrl:(NSString*) baseUrl;



+ (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end
