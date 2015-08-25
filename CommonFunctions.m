//
//  CommonFunctions.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 10/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions


# pragma mark - ASIHTTP Delegate Methods

//-(void)sendCommonError_MessageForRequest:(id)sender {
//    
////    if ([self respondsToSelector:@selector(didNotGetDataFromServer:messageToUser:title:urlCalled:)]) {
////        [self didNotGetDataFromServer:nil messageToUser:SERVER_COMMON_ERROR title:@"" urlCalled:sender];
////    }
//    
//}
//
//-(NSArray*) didLoadGetResponse:(ASIHTTPRequest*)getReq{
//    
//    // -- header got the over-all success failure status code..
//    DebugLog(@"\n\n - didLoadGetResponse Response header s- %d",getReq.responseStatusCode);
//    
//    @try {
//        [getReq setDelegate:nil];
//        
//        if ([getReq responseString]==nil) {
//            [self sendCommonError_MessageForRequest:getReq];
//            return nil;
//        }
//        // --- If no response string it will return here itself
//        NSDictionary *responseDictionary = [(NSString*)[getReq responseString] JSONValue];
//        if ([[responseDictionary allKeys] count]!=0) {
//            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:responseDictionary.count];
//            [responseDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//                [tempArray addObject:obj];
//            }];
//            
//            DebugLog(@"%@",tempArray);
//            
//            return tempArray;
//        }
//        // -- 400
//        else{
//            [self sendCommonError_MessageForRequest:getReq];
//        }
//    }
//    @catch (NSException *exception) {
//        DebugLog(@"\n\n - %s %@ ",__FUNCTION__,exception);
//    }
//}
//
//-(NSArray*) didNotLoadGetResponse:(ASIHTTPRequest*)getReq{
//    
//    DebugLog(@"DID NOT GET REPSONSE");
//    
//    @try {
//        
//        [getReq setDelegate:nil];
//        // --- If no response string it will return here itself
//        NSDictionary *responseDictionary = [(NSString*)[getReq responseString] JSONValue];
//        if (responseDictionary && [responseDictionary objectForKey:SERVER_MESSAGE]) {
//            
//            // -- if its invalid OAuth Creadintials please re-direct them to the sign in page..
//            //    message = "Invalid oauth token credentials.";
//            //    "status_code" = 403;
//            if ([[responseDictionary objectForKey:SERVER_STATUSCODE] integerValue] == INVALID_OAUTH_CREDENTIAL || [[responseDictionary objectForKey:SERVER_MESSAGE] isEqualToString:@"Invalid oauth token credentials."]) {
//                
//                return nil;
//            }
//        }
//        else{
//            [self sendCommonError_MessageForRequest:getReq];
//        }
//    }
//    @catch (NSException *exception) {
//        DebugLog(@"\n\n - %s %@ ",__FUNCTION__,exception);
//    }
//}
//
//- (NSArray*) didLoadPostResponse:(ASIFormDataRequest*)postReq{
//    
//    @try {
//        DebugLog(@"\n\n -- Post Request URL info - %@ ",postReq.username);
//        [postReq setDelegate:nil];
//        if ([postReq responseString]==nil) {
//            [self sendCommonError_MessageForRequest:postReq];
//            return nil;
//        }
//        
//        
//        // -- header got the over-all success failure status code..
//        DebugLog(@"\n\n - didLoadPostResponse Response header s- %d ",postReq.responseStatusCode);
//        
//        NSDictionary *responseDictionary = [(NSString*)[postReq responseString] JSONValue];
//        if ([[responseDictionary allKeys] count]!=0) {
//            
//            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:responseDictionary.count];
//            [responseDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//                [tempArray addObject:obj];
//            }];
//            
//            return tempArray;
//        }
//        else{
//            NSLog(@"responseString = %@",[postReq responseString]);
//            [self sendCommonError_MessageForRequest:postReq];
//        }
//    }
//    @catch (NSException *exception) {
//        DebugLog(@"\n\n - %s %@ ",__FUNCTION__,exception);
//    }
//}
//
//-(void) didNotLoadPostResponse:(ASIFormDataRequest*)postReq{
//    
//    
//    @try {
//        
//        // --- If no response string it will return here itself
//        NSDictionary *responseDictionary = [(NSString*)[postReq responseString] JSONValue];
//        if (responseDictionary && [responseDictionary objectForKey:SERVER_MESSAGE]) {
//            
//            // -- if its invalid OAuth Creadintials please re-direct them to the sign in page..
//            //    message = "Invalid oauth token credentials.";
//            //    "status_code" = 403;
//            if ([[responseDictionary objectForKey:SERVER_STATUSCODE] integerValue] == INVALID_OAUTH_CREDENTIAL || [[responseDictionary objectForKey:SERVER_MESSAGE] isEqualToString:@"Invalid oauth token credentials."]) {
//                
//                return;
//            }
//        }
//        else{
//            [self sendCommonError_MessageForRequest:postReq];
//        }
//    }
//    @catch (NSException *exception) {
//        DebugLog(@"\n\n - %s %@ ",__FUNCTION__,exception);
//    }
//    
//}



////*************** Method For Server POST Request
//
//+ (NSString*) postDataToServer:(NSString*)method parameters:(NSArray*)keys values:(NSArray*)values withClienrSecret:(NSString*)clienSec avatar:(NSData*)imageData {
//    
//    ASIHTTPRequest *getRequest = nil;
//    
//    NSMutableString *stringUrl = [NSMutableString string];
//    [stringUrl appendFormat:BASE_URL];
//    [stringUrl appendFormat:@"%@",method];
//    
//    if (keys!=nil && values!=nil && [keys count]!=0 && [values count]!=0) {
//        
//        [stringUrl appendFormat:@"%@=%@",[keys objectAtIndex:0],[values objectAtIndex:0]];
//        
//        for (int i = 1; i<[keys count]; i++) {
//            [stringUrl appendFormat:@"&%@=%@",[keys objectAtIndex:i],[values objectAtIndex:i]];
//        }
//    }
//    else{
//        
//        
//    }
//    
//    // -- common values for all apis
//    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
//    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
//    
//    [stringUrl appendFormat:@"&%@=%@",DEVICE_TYPE_KEY,DEVICE_TYPE_];
//    [stringUrl appendFormat:@"&%@=%@",APP_NAME_KEY,APP_NAME_];
//    [stringUrl appendFormat:@"&%@=%@",APP_VERSION_KEY,[NSString stringWithFormat:@"%ld",[build integerValue]]];
//    
//    
//    DebugLog(@"Get Request Values -- ==%s --  %@",__FUNCTION__, stringUrl);
//    getRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
////    [getRequest setDelegate:self];
////    [getRequest setDidFinishSelector:@selector(didLoadGetResponse:)];
////    [getRequest setDidFailSelector:@selector(didNotLoadGetResponse:)];
//    
//    //add access token to header
//    [self addAccessTokenToHeaderIfNeed:getRequest];
//    
//    /*SAVE URL METHOD Identifier*/
//    [getRequest setUsername:method];
//    [getRequest setValidatesSecureCertificate:NO];
//    
//    __block NSString *responseString = nil;
//    [getRequest setCompletionBlock:^{
//        
//        responseString = [getRequest responseString];
//        NSLog(@"%@",responseString);
//        
//    }];
//    
//    [getRequest setFailedBlock:^{
//        
//    }];
//    
//    [getRequest startAsynchronous];
//    
//    return responseString;
//}

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


////*************** Method For Adding Access Token To Header
//
//+ (void) addAccessTokenToHeaderIfNeed:(ASIHTTPRequest *) request {
//    
//    NSString *access_token = [[SharedObject sharedClass] getPhysicalABuseAccessToken];
//    if (access_token && [access_token isKindOfClass:[NSString class]])
//        [request addRequestHeader:AUTHORIZATION_TOKEN value:access_token];
//}
//
//
////*************** Method For Getting Data From Server
//
//+ (void) getDataFromServer:(NSString*)method parameters:(NSArray*)keys values:(NSArray*)values withClienrSecret:(NSString*)clienSec {
//    
//    ASIHTTPRequest *getRequest = nil;
//    
//    @try {
//        
//        NSMutableString *stringUrl = [NSMutableString string];
//        [stringUrl appendFormat:BASE_URL];
//        [stringUrl appendFormat:@"%@",method];
//        
//        if (keys!=nil && values!=nil && [keys count]!=0 && [values count]!=0) {
//            
//            [stringUrl appendFormat:@"%@=%@",[keys objectAtIndex:0],[values objectAtIndex:0]];
//            
//            for (int i = 1; i<[keys count]; i++) {
//                [stringUrl appendFormat:@"&%@=%@",[keys objectAtIndex:i],[values objectAtIndex:i]];
//            }
//        }
//        else{
//            
//            
//        }
//        
//        // -- common values for all apis
//        NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
//        NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
//        
////        [stringUrl appendFormat:@"&%@=%@",DEVICE_TYPE_KEY,DEVICE_TYPE_];
////        [stringUrl appendFormat:@"&%@=%@",APP_NAME_KEY,APP_NAME_];
////        [stringUrl appendFormat:@"&%@=%@",APP_VERSION_KEY,[NSString stringWithFormat:@"%ld",[build integerValue]]];
//        
//        
//        DebugLog(@"Get Request Values -- ==%s --  %@",__FUNCTION__, stringUrl);
//        getRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        [getRequest setDelegate:self];
//        [getRequest setDidFinishSelector:@selector(didLoadGetResponse:)];
//        [getRequest setDidFailSelector:@selector(didNotLoadGetResponse:)];
//        
//        //add access token to header
//        [self addAccessTokenToHeaderIfNeed:getRequest];
//        
//        /*SAVE URL METHOD Identifier*/
//        [getRequest setUsername:method];
//        [getRequest setValidatesSecureCertificate:NO];
//        
//        [getRequest startAsynchronous];
//        
//    }
//    @catch (NSException *exception) {
//        
//        DebugLog(@" %s Exception  3 -- %@",__FUNCTION__, exception);
//    }
//    @finally {
//    }
//    
//}
//
//
//+ (void) postDataToServer:(NSString*)method parameters:(NSArray*)keys values:(NSArray*)values withClienrSecret:(NSString*)clienSec avatar:(NSData*)imageData {
//    
//    
//}



//*************** Method For Converting RFC Date String To NSDate

+ (NSString *)dateForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *result = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    [rfc3339DateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *resultStrig = [rfc3339DateFormatter stringFromDate:result];
    return resultStrig;
}



//*************** Method For ASIHTTPRequest

+ (void) grabGetRequest:(NSString*)apiName delegate:(UIViewController*)viewObj isNSData:(BOOL)data {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,apiName]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setName:apiName];
    [request setDelegate:viewObj];
    [request startAsynchronous];
}



//*************** Method For Calculating Distance Between Two Points

+ (NSString*) kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000;
    
    //NSLog(@"%f",dist);
    NSString *distance = [NSString stringWithFormat:@"%.2f",dist];
    
    return distance;
    
}


//*************** Method For Dynamic UILabel Height

+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    
    CGSize constraint = CGSizeMake(width, 20000.0f);
    CGSize size;
    
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height+60;
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


//*************** Common Method For Action Sheet Options

+ (void) showActionSheet:(id)dele containerView:(UIView *) view title:(NSString*)sheetTitle msg:(NSString*)alertMessage cancel:(NSString *)cancelTitle tag:(NSInteger)tagValue destructive:(NSString *)destructiveButtonTitle otherButton:(NSString *)otherButtonTitles, ... {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:dele cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    actionSheet.tag = tagValue;
    
    int destructiveButtonIndex = 0;
    
    if (otherButtonTitles != nil) {
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) {
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [actionSheet addButtonWithTitle:eachObject];
                
                destructiveButtonIndex = destructiveButtonIndex + 1;
            }
            va_end(argumentList);
        }
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.destructiveButtonIndex = destructiveButtonIndex;
    [actionSheet showInView:view];
}


@end
