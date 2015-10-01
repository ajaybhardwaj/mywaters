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


//*************** Method For Checking If Location Services Are Enabled Or Not

+ (void) checkForLocationSerives:(NSString*) titleString message:(NSString*) messageString view:(UIViewController*) viewObj {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString( titleString, @"" ) message:NSLocalizedString( messageString, @"" ) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Cancel", @"" ) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"" ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:settingsAction];
        
        [viewObj presentViewController:alertController animated:YES completion:nil];

}


//*************** Method For Getting User Current Location Latitude And Location Values

+ (CLLocationCoordinate2D) getUserCurrentLocation {
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}



//*************** Method For Downloading Image Asynchronously

+ (void) downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   DebugLog(@"%@",[error description]);
                                   completionBlock(NO,nil);
                               }
                           }];
}



//*************** Method For Converting XML Dict To JSON Dict

+ (NSMutableDictionary *)extractXML:(NSMutableDictionary *)XMLDictionary {
    
    for (NSString *key in [XMLDictionary allKeys]) {
        // get the current object for this key
        id object = [XMLDictionary objectForKey:key];
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            if ([[object allKeys] count] == 1 &&
                [[[object allKeys] objectAtIndex:0] isEqualToString:@"text"] &&
                ![[object objectForKey:@"text"] isKindOfClass:[NSDictionary class]]) {
                // this means the object has the key "text" and has no node
                // or array (for multiple values) attached to it.
                [XMLDictionary setObject:[object objectForKey:@"text"] forKey:key];
            }
            else {
                // go deeper
                [self extractXML:object];
            }
        }
        else if ([object isKindOfClass:[NSArray class]]) {
            // this is an array of dictionaries, iterate
            for (id inArrayObject in (NSArray *)object) {
                if ([inArrayObject isKindOfClass:[NSDictionary class]]) {
                    // if this is a dictionary, go deeper
                    [self extractXML:inArrayObject];
                }
            }
        }
    }
    
    return XMLDictionary;
}


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

//*************** Method For Converting Date String To NSDate

+ (NSString *)dateTimeFromString:(NSString *)dateTimeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *result = [dateFormatter dateFromString:dateTimeString];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy @ HH:mm a"];
    
    NSString *resultStrig = [dateFormatter stringFromDate:result];
    return resultStrig;
}


//*************** Method For Converting Date String To NSDate

+ (NSString *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *result = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
    
    NSString *resultStrig = [dateFormatter stringFromDate:result];
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


+ (void) grabPostRequest:(NSArray *)paramters paramtersValue:(NSArray *)values delegate:(UIViewController *)viewObj isNSData:(BOOL)data baseUrl:(NSString*) baseUrl {
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",baseUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = viewObj;
    
    for (int i=0; i<paramters.count; i++) {
        [request setPostValue:[values objectAtIndex:i] forKey:[paramters objectAtIndex:i]];
    }
    
    
    NSString *access_token = [[SharedObject sharedClass] getPhysicalABuseAccessToken];
    if (access_token)
        [request setPostValue:access_token forKey:ACCOUNT_ACCESS_TOKEN];
    
    [request setPostValue:API_CLIENT_TAG_VALUE forKey:API_CLIENT_TAG];
//    [request setCompletionBlock:^{
//        
//        NSString *responseString = [request responseString];
//        
//        NSLog(@"%@",responseString);
//        
//        if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] isEqualToString:@"true"]) {
//            
//        }
//        else
//        {
//            
//        }
//    }];
//    
//    [request setFailedBlock:^{
//        
//    }];
    
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
    
    return size.height+40;
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
