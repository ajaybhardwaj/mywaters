//
//  CommonFunctions.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 10/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions


//*************** For Checking Internet Connectivity

+ (BOOL) hasConnectivity {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    return NO;
}


//*************** Method For Checking Valid Email

+ (BOOL) NSStringIsValidEmail:(NSString *)checkString {
    
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:checkString];
    return result;
}


//*************** Method For Checking Character Set In String

+ (BOOL) characterSet1Found:(NSString *) text {
    
    NSCharacterSet *set1 = [NSCharacterSet characterSetWithCharactersInString:@"0123456789<>,.?/:;}{[]|)(*&^!@#$%+=-_"];
    return [text rangeOfCharacterFromSet:set1].location != NSNotFound;
}


//*************** Method For Checking Character Set In String

+ (BOOL) characterSet2Found:(NSString *) text {
    
    NSCharacterSet *set2 = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ<>,.?/:;}{[]|)(*&^!@#$%+=-_"];
    return [text rangeOfCharacterFromSet:set2].location != NSNotFound;
}



//*************** Common Method For AlertViews

+ (void) showAlertView:(id)dele title:(NSString*)alertTitle msg:(NSString*)alertMessage cancel:(NSString *)cancelTitle otherButton:(NSString *)otherButtonTitles, ... {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:dele cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    
    if (otherButtonTitles != nil) {
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) {
            [alert addButtonWithTitle:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [alert addButtonWithTitle:eachObject];
            }
            va_end(argumentList);
        }
    }
    
    [alert show];
}


@end
