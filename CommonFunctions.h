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

@interface CommonFunctions : NSObject


+ (BOOL) hasConnectivity;
+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;
+ (BOOL) characterSet1Found:(NSString *) text;
+ (BOOL) characterSet2Found:(NSString *) text;
+ (void) showAlertView:(id)dele title:(NSString*)alertTitle msg:(NSString*)alertMessage cancel:(NSString *)cancelTitle otherButton:(NSString *)otherButtonTitles, ...;
+ (void) showActionSheet:(id)dele containerView:(UIView *) view title:(NSString*)sheetTitle msg:(NSString*)alertMessage cancel:(NSString *)cancelTitle tag:(NSInteger)tagValue destructive:(NSString *)destructiveButtonTitle otherButton:(NSString *)otherButtonTitles, ...;

@end
