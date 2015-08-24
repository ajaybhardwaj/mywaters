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


# pragma mark - Server GET & POST Methods
+ (void) getDataFromServer:(NSString*)method parameters:(NSArray*)keys values:(NSArray*)values withClienrSecret:(NSString*)clienSec;
+ (void) postDataToServer:(NSString*)method parameters:(NSArray*)keys values:(NSArray*)values withClienrSecret:(NSString*)clienSec avatar:(NSData*)imageData;

+ (void) grabGetRequest:(NSString*)apiName delegate:(UIViewController*)viewObj isNSData:(BOOL)data;

@end
