//
//  CommonFunctions.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 10/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions

static UIWindow *window;

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


//*************** Function To Add Google Tracking Code

+ (void) googleAnalyticsTracking:(NSString*) screenName {
    
    DebugLog(@"%@",screenName);
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


//*************** Function To Show Global MBProgressView

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    
    window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = title;
    return hud;
}

//*************** Function To Hide Global MBProgressView


+ (void)dismissGlobalHUD {
    
    window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:window animated:YES];
}


//*************** Function To Get App Version From Info Plist

+ (NSString *) getAppVersionNumber {
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
    
    return version;
}



//*************** A function for parsing URL parameters.

+ (NSDictionary*) parseURLParams:(NSString *)query {
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

//*************** Method For Sharing Content On Facebook

+ (void) sharePostOnFacebook:(NSString*)postImageUrl appUrl:(NSString*)appstoreUrl title:(NSString*)postTitle desc:(NSString*)postDescription view:(UIViewController*) viewObj abcIDValue:(NSString*)abcIdString {
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    // Present share dialog
    
    
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    appDelegate.IS_SHARING_ON_SOCIAL_MEDIA = YES;
    
    if (isInstalled) {
        
        [FBDialogs presentShareDialogWithLink:[NSURL URLWithString:appstoreUrl]
                                         name:postTitle
                                      caption:postTitle
                                  description:postDescription
                                      picture:[NSURL URLWithString:postImageUrl]
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              [self showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
                                          } else {
                                              // Success
                                              DebugLog(@"%@",results);
                                              [self showAlertView:nil title:nil msg:@"Sucessfully Posted." cancel:@"OK" otherButton:nil];
                                              // 0 - For Other modules than ABC Waters
                                              // -1 - For App Sharing
                                              
                                              if ([[NSString stringWithFormat:@"%@",abcIdString] isEqualToString:@"0"]) {
                                                  NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionID",@"ActionType",@"version", nil];
                                                  NSArray *values = [[NSArray alloc] initWithObjects:@"5",@"0",@"1",[CommonFunctions getAppVersionNumber], nil];
                                                  
                                                  [self grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
                                              }
                                              else if ([[NSString stringWithFormat:@"%@",abcIdString] isEqualToString:@"-1"]) {
                                                  NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionType",@"version", nil];
                                                  NSArray *values = [[NSArray alloc] initWithObjects:@"5",@"1",[CommonFunctions getAppVersionNumber], nil];
                                                  
                                                  [self grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
                                              }
                                              else {
                                                  NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionID",@"ActionType",@"version", nil];
                                                  NSArray *values = [[NSArray alloc] initWithObjects:@"5",abcIdString,@"1",[CommonFunctions getAppVersionNumber], nil];
                                                  
                                                  [self grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
                                              }
                                          }
                                      }];
    }
    else {
        
        NSArray *permissions = [NSArray arrayWithObjects: @"read_stream",@"publish_stream", nil];
        
        NSMutableDictionary *params =
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
         postTitle, @"name",
         postDescription, @"description",
         appstoreUrl, @"link",
         postImageUrl, @"picture",
         FACEBOOK_APP_ID, @"app_id",
         nil];
        
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError* error){
            if(!error) {
                [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                    
                    if (error) {
                        // An error occurred, we need to handle the error
                        // See: https://developers.facebook.com/docs/ios/errors
                        [self showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
                    }
                    else {
                        if (result == FBWebDialogResultDialogNotCompleted) {
                            // User canceled.
                            NSLog(@"User cancelled.");
                            [self showAlertView:nil title:nil msg:@"User cancelled sharing" cancel:@"OK" otherButton:nil];
                        }
                        else {
                            NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                            
                            if (![urlParams valueForKey:@"post_id"]) {
                                // User canceled.
                                NSLog(@"User cancelled.");
                                [self showAlertView:nil title:nil msg:@"User cancelled sharing" cancel:@"OK" otherButton:nil];
                            }
                            else {
                                // User clicked the Share button
                                
                                //                        NSLog(@"fb web dialog result=====>%@",result);
                                NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                NSLog(@"result %@", result);
                                [self showAlertView:nil title:nil msg:@"Sucessfully Posted." cancel:@"OK" otherButton:nil];
                                
                                
                                // 0 - For Other modules than ABC Waters
                                // -1 - For App Sharing
                                
                                if ([[NSString stringWithFormat:@"%@",abcIdString] isEqualToString:@"0"]) {
                                    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionID",@"ActionType",@"version", nil];
                                    NSArray *values = [[NSArray alloc] initWithObjects:@"5",@"0",@"1",[CommonFunctions getAppVersionNumber], nil];
                                    
                                    [self grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
                                }
                                else if ([[NSString stringWithFormat:@"%@",abcIdString] isEqualToString:@"-1"]) {
                                    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionType",@"version", nil];
                                    NSArray *values = [[NSArray alloc] initWithObjects:@"5",@"1",[CommonFunctions getAppVersionNumber], nil];
                                    
                                    [self grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
                                }
                                else {
                                    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionID",@"ActionType",@"version", nil];
                                    NSArray *values = [[NSArray alloc] initWithObjects:@"5",abcIdString,@"1",[CommonFunctions getAppVersionNumber], nil];
                                    
                                    [self grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
                                }
                                
                            }
                        }
                    }
                    
                }];
            }
            else{
                NSLog(@"error=>%@",[error localizedDescription]);
            }
        }];
    }
    
}


//*************** Method For Sharing On Twitter

+ (void) sharePostOnTwitter:(NSString *)appStoreUrl title:(NSString *)postTitle view:(UIViewController *)viewObj abcIDValue:(NSString*)abcIdString {
    
    
    SLComposeViewController *tweetSheet;
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@\n%@",postTitle,[NSURL URLWithString:appStoreUrl]]];
        [viewObj presentViewController:tweetSheet animated:YES completion:nil];
    }

    [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result){
        
        NSString *outout = [[NSString alloc] init];
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                outout = @"Post Canceled";
                break;
            case SLComposeViewControllerResultDone: {
                outout = @"Successfully Posted";
                
                if (![abcIdString isEqualToString:@"0"]) {
                    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionID",@"ActionType",@"version", nil];
                    NSArray *values = [[NSArray alloc] initWithObjects:@"5",abcIdString,@"1",[CommonFunctions getAppVersionNumber], nil];
                    
                    [self grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
                }
                else if ([abcIdString isEqualToString:@"-1"]) {
                    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionType",@"version", nil];
                    NSArray *values = [[NSArray alloc] initWithObjects:@"6",@"1",[CommonFunctions getAppVersionNumber], nil];
                    
                    [self grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
                }
                
            }
                
            default:
                break;
        }
        UIAlertView *myalertView = [[UIAlertView alloc]initWithTitle:nil message:outout delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myalertView show];
    }];
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
    locationManager.delegate = self;
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
    [rfc3339DateFormatter setDateFormat:@"EEE, dd MMM yyyy @ HH:mm a"];
    
    NSString *resultStrig = [rfc3339DateFormatter stringFromDate:result];
    return resultStrig;
}

//*************** Method For Converting Date String To Required Format String

+ (NSString *)dateTimeFromString:(NSString *)dateTimeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *result = [dateFormatter dateFromString:dateTimeString];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy @ HH:mm a"];
    
    NSString *resultStrig = [dateFormatter stringFromDate:result];
    return resultStrig;
}


//*************** Method For Converting Date String To Required Format String Without Time

+ (NSString *)dateWithoutTimeString:(NSString *)dateTimeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *result = [dateFormatter dateFromString:dateTimeString];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
    
    NSString *resultStrig = [dateFormatter stringFromDate:result];
    return resultStrig;
}


//*************** Method For Converting Date String To Required Format String Without Date

+ (NSString *)timeWithoutDateString:(NSString *)dateTimeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *result = [dateFormatter dateFromString:dateTimeString];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *resultStrig = [dateFormatter stringFromDate:result];
    return resultStrig;
}



//*************** Method For Converting Date String To NSDate

+ (NSDate *)dateValueFromString:(NSString *)dateTimeString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *result = [dateFormatter dateFromString:dateTimeString];
    //    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy @ HH:mm a"];
    //
    //    NSString *resultStrig = [dateFormatter stringFromDate:result];
    return result;
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

+ (void) grabGetRequest:(NSString*)apiName delegate:(UIViewController*)viewObj isNSData:(BOOL)data accessToken:(NSString*)token {
    
    NSURL *url;
    if ([token isEqualToString:@"NA"])
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?ClientTag=%@",API_BASE_URL,apiName,API_CLIENT_TAG_VALUE]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?accessToken=%@&ClientTag=%@",API_BASE_URL,apiName,token,API_CLIENT_TAG_VALUE]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    if (!IOS7)
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
    
    
    NSString *access_token = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"AccessToken"];
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
    
    NSLog(@"%f",dist);
    NSString *distance = [NSString stringWithFormat:@"%.2f",dist];
    
    return distance;
    
}


//*************** Method For Dynamic UILabel Height

+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    
    CGSize constraint = CGSizeMake(width, 20000.0f);
    CGSize size;
    
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
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
    //    [actionSheet showInView:view];
    [actionSheet showInView:view.window];
}


@end
