//
//  AppDelegate.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "AppDelegate.h"


/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-69068035-1";
static NSString *const kAllowTracking = @"allowTracking";

@interface AppDelegate ()

// Used for sending Google Analytics traffic in the background.
@property(nonatomic, assign) BOOL okToWait;
@property(nonatomic, copy) void (^dispatchHandler)(GAIDispatchResult result);

@end

@implementation AppDelegate
@synthesize RESOURCE_FOLDER_PATH,database;
@synthesize DASHBOARD_PREFERENCES_ARRAY,NEW_DASHBOARD_STATUS,DASHBOARD_PREFERENCE_ID,ABC_WATERS_LISTING_ARRAY,POI_ARRAY,EVENTS_LISTING_ARRAY,WLS_LISTING_ARRAY,WLS_LISTING_ARRAY_FOR_DETAIL_VIEW,CCTV_LISTING_ARRAY,CCTV_LISTING_ARRAY_FOR_DETAIL_VIEW,USER_FAVOURITES_ARRAY,APP_CONFIG_DATA_ARRAY,TIPS_VIDEOS_ARRAY,USER_FLOOD_SUBMISSION_ARRAY,PUB_FLOOD_SUBMISSION_ARRAY,PUSH_NOTIFICATION_ARRAY,SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY;
@synthesize screen_width,left_deck_width;
@synthesize IS_COMING_AFTER_LOGIN;
@synthesize SELECTED_MENU_ID;
@synthesize IS_ARVIEW_CUSTOM_LABEL;
@synthesize IS_MOVING_TO_WLS_FROM_DASHBOARD,IS_MOVING_TO_CCTV_FROM_DASHBOARD,IS_SKIPPING_USER_LOGIN;
@synthesize hud;
@synthesize CURRENT_LOCATION_LAT,CURRENT_LOCATION_LONG,USER_CURRENT_LOCATION_COORDINATE,LONG_PRESS_USER_LOCATION_LAT,LONG_PRESS_USER_LOCATION_LONG,LONG_PRESS_USER_LOCATION_COORDINATE;
@synthesize IS_COMING_FROM_DASHBOARD,IS_RELAUNCHING_APP,IS_SHARING_ON_SOCIAL_MEDIA;
@synthesize DASHBOARD_PREFERENCES_CHANGED,IS_USER_LOCATION_SELECTED_BY_LONG_PRESS;
@synthesize RECEIVED_NOTIFICATION_TYPE,IS_PUSH_NOTIFICATION_RECEIVED,PUSH_NOTIFICATION_ALERT_MESSAGE;
@synthesize IS_CREATING_ACCOUNT;
@synthesize locationManager;
@synthesize IS_USER_FLOOD_SUBMISSION_SUCCESS;

//*************** Method To Register Device Toke For Push Notifications

- (void) registerDeviceToken {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"Token", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"device_token"], nil];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,REGISTER_PUSH_TOKEN]];
}


//*************** Method To Call Get Config API

- (void) getConfigData {
    
    //    [CommonFunctions grabGetRequest:@"ConfigData/" delegate:self isNSData:NO accessToken:@"NA"];
    [CommonFunctions grabGetRequest:@"ConfigData" delegate:self isNSData:NO accessToken:@"NA"];
}


//*************** Method To Send User Location For Flood Notifications

- (void) sendUserLocationForFloodNotifications {
    
    //    bgTask = [[UIApplication sharedApplication]
    //              beginBackgroundTaskWithExpirationHandler:
    //              ^{
    //                  [[UIApplication sharedApplication} endBackgroundTask:bgTask];
    //                   }];
    
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    }];
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"PushToken",@"Lat",@"Lon",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"device_token"],[NSString stringWithFormat:@"%f",CURRENT_LOCATION_LAT],[NSString stringWithFormat:@"%f",CURRENT_LOCATION_LONG],[CommonFunctions getAppVersionNumber], nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,LBS_NOTIFICATION_FOR_FLOOD]];
    
    if (bgTask != UIBackgroundTaskInvalid) {
        
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}



# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView==notificationAlert) {
        if (buttonIndex==1) {
            [[ViewControllerHelper viewControllerHelper] enableThisController:NOTIFICATIONS_CONTROLLER onCenter:YES withAnimate:NO];
        }
        else {
            
        }
    }
    else {
        if (buttonIndex==0) {
            
            NSString *appUrl;
            for (int i=0; i<APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        }
    }
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [APP_CONFIG_DATA_ARRAY removeAllObjects];
        
        [SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY removeAllObjects];
        APP_CONFIG_DATA_ARRAY = [[responseString JSONValue] objectForKey:APP_CONFIG_DATA_RESPONSE_NAME];
        SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY = [[responseString JSONValue] objectForKey:APP_SYSTEM_NOTIFICATION_DATA_RESPONSE_NAME];
        
        
        if (APP_CONFIG_DATA_ARRAY.count!=0) {
            
            NSString *configAppVersion;
            for (int i=0; i<APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSPUBAppVersion"]) {
                    configAppVersion = [[APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            if ([[CommonFunctions getAppVersionNumber] intValue] < [configAppVersion intValue]) {
                [CommonFunctions showAlertView:self title:nil msg:@"App update available." cancel:nil otherButton:@"Update",@"Cancel",nil];
            }
        }
        
        
        
        if (SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY.count!=0) {
            
            if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"systemNotifications"] isEqualToString:@"YES"]) {
                
                for (int i=0; i<SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY.count; i++) {
                    
                    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                    if (localNotif == nil)
                        return;
                    localNotif.fireDate = [CommonFunctions dateValueFromString:[[SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"ValidFrom"]];
                    localNotif.timeZone = [NSTimeZone defaultTimeZone];
                    
                    localNotif.alertBody = [NSString stringWithFormat:@"%@ From %@ - Till %@",[[SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Description"],[CommonFunctions dateTimeFromString:[[SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"ValidFrom"]],[CommonFunctions dateTimeFromString:[[SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"ValidTo"]]];
                    if (IS_IOS9())
                        localNotif.alertTitle = [[SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Title"];
                    
                    localNotif.soundName = UILocalNotificationDefaultSoundName;
                    localNotif.applicationIconBadgeNumber = 1;
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
                }
            }
        }
        
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
}


//*************** Create Deck View Controller For App ***************//

- (void) createViewDeckController {
    
    id deckCenterController = [_rootDeckController centerController];
    //    BOOL isIntroShown = [[NSUserDefaults standardUserDefaults] boolForKey:IS_INTRO_SCREEN_SHOWN_ALREADY];
    //    if (!isIntroShown) {
    //
    //        RDLog(@"\n\n - %s ",__FUNCTION__);
    //
    //        if (!deckCenterController) {
    //            _rootDeckController = [[IIViewDeckController alloc] initWithCenterViewController:nil leftViewController:nil rightViewController:nil topViewController:nil bottomViewController:nil];
    //            _rootDeckController.delegateMode = IIViewDeckDelegateOnly;
    //            _rootDeckController.delegate = self;
    //
    //            [[iMViewControllerHelper viewControllerHelper] enableThisController:INTRO_SCREEN_CONTROLLER onCenter:YES withAnimate:NO];
    //        }
    //        else{
    //            [[iMViewControllerHelper viewControllerHelper] enableThisController:INTRO_SCREEN_CONTROLLER onCenter:YES withAnimate:NO];
    //        }
    //
    //        return;
    //    }
    
    
    //-- after first time it will flow from this screen...
    if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"AccessToken"] length] == 0) {
        
        if (!deckCenterController && ![[(UINavigationController*)deckCenterController topViewController] isKindOfClass:[LoginViewController class]]) {
            
            _rootDeckController = [[IIViewDeckController alloc] initWithCenterViewController:nil leftViewController:nil rightViewController:nil topViewController:nil bottomViewController:nil];
            _rootDeckController.delegateMode = IIViewDeckDelegateOnly;
            _rootDeckController.delegate = self;
            
            [[ViewControllerHelper viewControllerHelper] enableThisController:SIGN_IN_CONTROLLER onCenter:YES withAnimate:NO];
        }
    }
    else{
        
        if (!deckCenterController && ![[(UINavigationController*)deckCenterController topViewController] isKindOfClass:[HomeViewController class]]) {
            
            _rootDeckController = [[IIViewDeckController alloc] initWithCenterViewController:nil leftViewController:nil rightViewController:nil topViewController:nil bottomViewController:nil];
            _rootDeckController.delegateMode = IIViewDeckDelegateOnly;
            _rootDeckController.delegate = self;
            
            [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:NO];
            
        }
        
    }
    
}



//*************** Method To Get Point Of Interests

- (void) retrievePointOfInterests:(int) abcwater_id {
    
    [POI_ARRAY removeAllObjects];
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT id, lat, long, name, poi_address FROM poi_listing WHERE abcwater_id=\"%d\"",abcwater_id];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                char *field0 = (char *)sqlite3_column_text(statement, 0);
                NSString *columnId = field0 ? [[NSString alloc] initWithUTF8String:field0] : @" ";
                char *field1 = (char *)sqlite3_column_text(statement, 1);
                NSString *latValue = field1 ? [[NSString alloc] initWithUTF8String:field1] : @" ";
                char *field2= (char *)sqlite3_column_text(statement, 2);
                NSString *longValue = field2 ? [[NSString alloc] initWithUTF8String:field2] : @" ";
                char *field3= (char *)sqlite3_column_text(statement, 3);
                NSString *name = field3 ? [[NSString alloc] initWithUTF8String:field3] : @" ";
                char *field4= (char *)sqlite3_column_text(statement, 4);
                NSString *address = field4 ? [[NSString alloc] initWithUTF8String:field4] : @" ";
                
                
                NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
                [dataDict setObject:columnId forKey:@"id"];
                [dataDict setObject:latValue forKey:@"lat"];
                [dataDict setObject:longValue forKey:@"long"];
                [dataDict setObject:name forKey:@"name"];
                [dataDict setObject:address forKey:@"address"];
                
                [POI_ARRAY addObject:dataDict];
            }
        }
        sqlite3_close(database);
    }
}


//*************** Method To Read Dashboard Preferences

- (void) retrieveDashboardPreferences {
    
    [DASHBOARD_PREFERENCES_ARRAY removeAllObjects];
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM dashboard_preferences"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                char *field0 = (char *)sqlite3_column_text(statement, 0);
                NSString *columnId = field0 ? [[NSString alloc] initWithUTF8String:field0] : @" ";
                char *field1 = (char *)sqlite3_column_text(statement, 1);
                NSString *component = field1 ? [[NSString alloc] initWithUTF8String:field1] : @" ";
                char *field2= (char *)sqlite3_column_text(statement, 2);
                NSString *status = field2 ? [[NSString alloc] initWithUTF8String:field2] : @" ";
                char *field3= (char *)sqlite3_column_text(statement, 3);
                NSString *height = field3 ? [[NSString alloc] initWithUTF8String:field3] : @" ";
                char *field4= (char *)sqlite3_column_text(statement, 4);
                NSString *color = field4 ? [[NSString alloc] initWithUTF8String:field4] : @" ";
                
                
                NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
                [dataDict setObject:columnId forKey:@"id"];
                [dataDict setObject:component forKey:@"component"];
                [dataDict setObject:status forKey:@"status"];
                [dataDict setObject:height forKey:@"height"];
                [dataDict setObject:color forKey:@"color"];
                
                
                [DASHBOARD_PREFERENCES_ARRAY addObject:dataDict];
            }
        }
        sqlite3_close(database);
    }
}


//*************** Method To Get ABC Waters Listing

- (void) retrieveABCWatersListing {
    
    [ABC_WATERS_LISTING_ARRAY removeAllObjects];
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM mywaters_listing"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                char *field0 = (char *)sqlite3_column_text(statement, 0);
                NSString *columnId = field0 ? [[NSString alloc] initWithUTF8String:field0] : @" ";
                char *field1 = (char *)sqlite3_column_text(statement, 1);
                NSString *name = field1 ? [[NSString alloc] initWithUTF8String:field1] : @" ";
                char *field2= (char *)sqlite3_column_text(statement, 2);
                NSString *image = field2 ? [[NSString alloc] initWithUTF8String:field2] : @" ";
                
                NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
                [dataDict setObject:columnId forKey:@"id"];
                [dataDict setObject:name forKey:@"name"];
                [dataDict setObject:image forKey:@"image"];
                
                [ABC_WATERS_LISTING_ARRAY addObject:dataDict];
            }
        }
        sqlite3_close(database);
    }
}



//*************** Method To Update Dashboard Preferences

- (void) updateDashboardPreference {
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat: @"UPDATE dashboard_preferences SET status=\"%ld\" WHERE id = %ld", (long)NEW_DASHBOARD_STATUS, (long)DASHBOARD_PREFERENCE_ID];
        const char *update_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DebugLog(@"Row updated");
            DASHBOARD_PREFERENCES_CHANGED = YES;
        }
        
        else {
            DebugLog(@"Failed to update row");
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}




//*************** Method To Check If Item Is Favourite

- (BOOL) checkItemForFavourite:(NSString*)favType idValue:(NSString*)favID {
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    int recordCount =0;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *searchQuery = [NSString stringWithFormat: @"SELECT COUNT(*) FROM favourites WHERE fav_type=\"%@\" AND fav_id=\"%@\"",favType,favID];
        
        const char *query_stmt = [searchQuery UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                recordCount = sqlite3_column_int(statement, 0);
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    if (recordCount > 0) {
        return YES;
    }
    else {
        return NO;
    }
}



//*************** Method To Insert Favourite Items

- (void) updateWLSFavouriteItemForSubscribe:(NSString*)favouriteID update:(NSString*)updateValue {
    
    
    // Fav Types:
    // 1- CCTV, 2- Events, 3-ABC, 4-WLS
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        int recordCount =0;
        NSString *searchQuery = [NSString stringWithFormat: @"SELECT COUNT(*) FROM favourites WHERE fav_type=\"4\" AND fav_id=\"%@\"",favouriteID];
        
        const char *query_stmt = [searchQuery UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                recordCount = sqlite3_column_int(statement, 0);
            }
        }
        
        
        if (recordCount!=0) {
            
            NSString *updateSQL = [NSString stringWithFormat: @"UPDATE favourites SET isWlsSubscribed=\"%@\" WHERE fav_type=\"4\" AND fav_id=\"%@\"",updateValue,favouriteID];
            
            const char *update_stmt = [updateSQL UTF8String];
            
            DebugLog(@"Insert query %@",updateSQL);
            
            sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                DebugLog(@"Row updated");
            }
            
            else {
                DebugLog(@"Failed to update row");
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}



//*************** Method To Insert Favourite Items

- (void) insertFavouriteItems:(NSMutableDictionary*) parametersDict {
    
    
    // Fav Types:
    // 1- CCTV, 2- Events, 3-ABC, 4-WLS
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        int recordCount =0;
        NSString *searchQuery = [NSString stringWithFormat: @"SELECT COUNT(*) FROM favourites WHERE fav_type=\"%@\" AND fav_id=\"%@\"",[parametersDict objectForKey:@"fav_type"],[parametersDict objectForKey:@"fav_id"]];
        
        const char *query_stmt = [searchQuery UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                recordCount = sqlite3_column_int(statement, 0);
            }
        }
        
        
        if (recordCount==0) {
            
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT OR IGNORE INTO favourites (name, image, lat, long, address, phoneno, description, start_date_event, end_date_event, website_event, isCertified_ABC, water_level_wls, drain_depth_wls, water_level_percentage_wls, water_level_type_wls, observation_time_wls, fav_type, fav_id, isWlsSubscribed, hasPOI) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", [parametersDict objectForKey:@"name"],[parametersDict objectForKey:@"image"],[parametersDict objectForKey:@"lat"],[parametersDict objectForKey:@"long"],[parametersDict objectForKey:@"address"],[parametersDict objectForKey:@"phoneno"],[parametersDict objectForKey:@"description"],[parametersDict objectForKey:@"start_date_event"],[parametersDict objectForKey:@"end_date_event"],[parametersDict objectForKey:@"website_event"],[parametersDict objectForKey:@"isCertified_ABC"],[parametersDict objectForKey:@"water_level_wls"],[parametersDict objectForKey:@"drain_depth_wls"],[parametersDict objectForKey:@"water_level_percentage_wls"],[parametersDict objectForKey:@"water_level_type_wls"],[parametersDict objectForKey:@"observation_time_wls"],[parametersDict objectForKey:@"fav_type"],[parametersDict objectForKey:@"fav_id"],[parametersDict objectForKey:@"isWlsSubscribed"],[parametersDict objectForKey:@"hasPOI"]];
            const char *insert_stmt = [insertSQL UTF8String];
            
            DebugLog(@"Insert query %@",insertSQL);
            
            sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                DebugLog(@"Row inserted");
                [CommonFunctions showAlertView:nil title:nil msg:@"Favourites added!" cancel:@"OK" otherButton:nil];
            }
            
            else {
                DebugLog(@"Failed to insert row");
                [CommonFunctions showAlertView:nil title:nil msg:@"Failed to add as favourite. Please try later." cancel:@"OK" otherButton:nil];
            }
            
        }
        else {
            
            
            NSString *deleteSQL = [NSString stringWithFormat: @"DELETE FROM favourites WHERE fav_type=\"%@\" AND fav_id=\"%@\"",[parametersDict objectForKey:@"fav_type"],[parametersDict objectForKey:@"fav_id"]];
            
            DebugLog(@"query %@",deleteSQL);
            const char *insert_stmt = [deleteSQL UTF8String];
            
            sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                DebugLog(@"Rows Deleted");
                [CommonFunctions showAlertView:nil title:nil msg:@"Favourites removed." cancel:@"OK" otherButton:nil];
            }
            
            else {
                DebugLog(@"Failed to delete rows");
                [CommonFunctions showAlertView:nil title:nil msg:@"Failed to remove from favourites. Please try later." cancel:@"OK" otherButton:nil];
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}



//*************** Method To Insert ABC Site Data In Sqlite

- (void) insertABCWatersData:(NSMutableArray*) parametersArray {
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *truncateTableSQL = [NSString stringWithFormat: @"DELETE FROM abcwatersites"];
        const char *truncate_stmt = [truncateTableSQL UTF8String];
        
        sqlite3_prepare_v2(database, truncate_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DebugLog(@"Table Truncated");
            
            for (int i=0; i<ABC_WATERS_LISTING_ARRAY.count; i++) {
                
                NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO abcwatersites (abcSiteId, siteTitle, siteDescription, siteLat, siteLong, sitePhone, siteAddress, siteMainImage, isCertified, hasPOI) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", [NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"id"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"siteName"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"description"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"locationLatitude"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"locationLongitude"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"phoneNo"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"address"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"isCertified"]],[NSString stringWithFormat:@"%@",[[ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"hasPOI"]]];
                const char *insert_stmt = [insertSQL UTF8String];
                
                DebugLog(@"Insert query %@",insertSQL);
                
                sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    DebugLog(@"Row inserted");
                }
                
                else {
                    DebugLog(@"Failed to insert row");
                }
            }
        }
        
        else {
            DebugLog(@"Failed to truncate table");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}



//*************** Method To Insert CCTV Site Data In Sqlite

- (void) insertCCTVData:(NSMutableArray*) parametersArray {
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *truncateTableSQL = [NSString stringWithFormat: @"DELETE FROM cctvSites"];
        const char *truncate_stmt = [truncateTableSQL UTF8String];
        
        sqlite3_prepare_v2(database, truncate_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DebugLog(@"Table Truncated");
            
            for (int i=0; i<CCTV_LISTING_ARRAY.count; i++) {
                
                NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO cctvSites (cctvId, cctvName, cctvImageUrl, cctvLat, cctvLong) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", [NSString stringWithFormat:@"%@",[[CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"ID"]],[NSString stringWithFormat:@"%@",[[CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Name"]],[NSString stringWithFormat:@"%@",[[CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"CCTVImageURL"]],[NSString stringWithFormat:@"%@",[[CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Lat"]],[NSString stringWithFormat:@"%@",[[CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Lon"]]];
                const char *insert_stmt = [insertSQL UTF8String];
                
                DebugLog(@"Insert query %@",insertSQL);
                
                sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    DebugLog(@"Row inserted");
                }
                
                else {
                    DebugLog(@"Failed to insert row");
                }
            }
        }
        
        else {
            DebugLog(@"Failed to truncate table");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}


//*************** Method To Insert WLS Site Data In Sqlite

- (void) insertWLSData:(NSMutableArray*) parametersArray {
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *truncateTableSQL = [NSString stringWithFormat: @"DELETE FROM wlsSites"];
        const char *truncate_stmt = [truncateTableSQL UTF8String];
        
        sqlite3_prepare_v2(database, truncate_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DebugLog(@"Table Truncated");
            
            for (int i=0; i<WLS_LISTING_ARRAY.count; i++) {
                
                NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO wlsSites (wlsId, wlsName, wlsDrainDepth, wlsLat, wlsLong, wlsObservedTime, wlsWaterLevelValue, wlsWaterLevelPercentage, wlsWaterLevelTypeValue, wlsDrainDepthValue, isSubscribed) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", [NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"id"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevelType"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"latitude"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"longitude" ]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"observationTime"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevel"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevelPercentage"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevelType"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"drainDepth"]],[NSString stringWithFormat:@"%@",[[WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"isSubscribed"]]];
                const char *insert_stmt = [insertSQL UTF8String];
                
                DebugLog(@"Insert query %@",insertSQL);
                
                sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    DebugLog(@"Row inserted");
                }
                
                else {
                    DebugLog(@"Failed to insert row");
                }
            }
        }
        
        else {
            DebugLog(@"Failed to truncate table");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}


//*************** Method To Insert WLS Site Data In Sqlite

- (void) insertEventsData:(NSMutableArray*) parametersArray {
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *truncateTableSQL = [NSString stringWithFormat: @"DELETE FROM events"];
        const char *truncate_stmt = [truncateTableSQL UTF8String];
        
        sqlite3_prepare_v2(database, truncate_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DebugLog(@"Table Truncated");
            
            for (int i=0; i<EVENTS_LISTING_ARRAY.count; i++) {
                
                
                NSString *eventID,*titleString,*descriptionString,*latValue,*longValue,*phoneNoString,*addressString,*startDateString,*endDateString,*imageName,*timeValue;
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"id"] != (id)[NSNull null])
                    eventID = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"id"];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"title"] != (id)[NSNull null])
                    titleString = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"title"];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"description"] != (id)[NSNull null])
                    descriptionString = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"description"];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"locationLatitude"] != (id)[NSNull null])
                    latValue = [NSString stringWithFormat:@"%@",[[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"locationLatitude"]];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"locationLongitude"] != (id)[NSNull null])
                    longValue = [NSString stringWithFormat:@"%@",[[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"locationLongitude"]];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"phoneNo"] != (id)[NSNull null])
                    phoneNoString = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"phoneNo"];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"location"] != (id)[NSNull null])
                    addressString = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"location"];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"startDate"] != (id)[NSNull null])
                    startDateString = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"startDate"];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"endDate"] != (id)[NSNull null])
                    endDateString = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"endDate"];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"] != (id)[NSNull null])
                    imageName = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"];
                
                if ([[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"timeText"] != (id)[NSNull null])
                    timeValue = [[EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"timeText"];
                
                
                NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO events (eventId, eventTitle, eventDescription, eventLat, eventlong, eventPhone, eventAddress, eventStartDate, eventEndDate, eventImageName, eventTime) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",, \"%@\")", eventID,titleString,descriptionString,latValue,longValue,phoneNoString,addressString,startDateString,endDateString,imageName,timeValue];
                const char *insert_stmt = [insertSQL UTF8String];
                
                DebugLog(@"Insert query %@",insertSQL);
                
                sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    DebugLog(@"Row inserted");
                }
                
                else {
                    DebugLog(@"Failed to insert row");
                }
            }
        }
        
        else {
            DebugLog(@"Failed to truncate table");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}



//*************** Method To Retrieve Favourites

- (void) retrieveFavouriteItems:(NSInteger) favouriteType {
    
    [USER_FAVOURITES_ARRAY removeAllObjects];
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL;
        if (favouriteType==0) {
            querySQL = [NSString stringWithFormat: @"SELECT * FROM favourites ORDER BY fav_type"];
            
        }
        else {
            querySQL = [NSString stringWithFormat: @"SELECT * FROM favourites WHERE fav_type=\"%ld\" ORDER BY id",(long)favouriteType];
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *idValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *nameValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *image = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *lat = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *lon = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *address = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *phoneno = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                NSString *description = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                NSString *eventStartDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                NSString *eventEndDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                NSString *eventWebsite = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                NSString *isCertified = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                NSString *waterLevel = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                NSString *drainDepth = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                NSString *waterLevelPercentage = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                NSString *waterLevelType = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                NSString *observationTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                NSString *favType = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                NSString *favId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                
                
                [USER_FAVOURITES_ARRAY addObject:idValue];
                [USER_FAVOURITES_ARRAY addObject:nameValue];
                [USER_FAVOURITES_ARRAY addObject:image];
                [USER_FAVOURITES_ARRAY addObject:lat];
                [USER_FAVOURITES_ARRAY addObject:lon];
                [USER_FAVOURITES_ARRAY addObject:address];
                [USER_FAVOURITES_ARRAY addObject:phoneno];
                [USER_FAVOURITES_ARRAY addObject:description];
                [USER_FAVOURITES_ARRAY addObject:eventStartDate];
                [USER_FAVOURITES_ARRAY addObject:eventEndDate];
                [USER_FAVOURITES_ARRAY addObject:eventWebsite];
                [USER_FAVOURITES_ARRAY addObject:isCertified];
                [USER_FAVOURITES_ARRAY addObject:waterLevel];
                [USER_FAVOURITES_ARRAY addObject:drainDepth];
                [USER_FAVOURITES_ARRAY addObject:waterLevelPercentage];
                [USER_FAVOURITES_ARRAY addObject:waterLevelType];
                [USER_FAVOURITES_ARRAY addObject:observationTime];
                [USER_FAVOURITES_ARRAY addObject:favType];
                [USER_FAVOURITES_ARRAY addObject:favId];
                
                CLLocationCoordinate2D currentLocation;
                currentLocation.latitude = CURRENT_LOCATION_LAT;
                currentLocation.longitude = CURRENT_LOCATION_LONG;
                
                CLLocationCoordinate2D desinationLocation;
                desinationLocation.latitude = [lat floatValue];
                desinationLocation.longitude = [lon floatValue];
                
                NSString *distanceValue = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                [USER_FAVOURITES_ARRAY addObject:distanceValue];
            }
        }
        sqlite3_close(database);
    }
}


//*************** Method To Delete Favourites

- (void) deleteFavouriteItems:(int) rowID {
    
    sqlite3_stmt *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        NSString *deleteSQL = [NSString stringWithFormat: @"DELETE FROM favourites WHERE id=\"%d\"",rowID];
        
        DebugLog(@"query %@",deleteSQL);
        const char *insert_stmt = [deleteSQL UTF8String];
        
        sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DebugLog(@"Rows Deleted");
        }
        
        else {
            DebugLog(@"Failed to delete rows");
        }
        //sqlite3_finalize(statement);
        sqlite3_close(database);
    }
}


//*************** Method To Get Random Favourite ABC Water

- (NSMutableArray*) getRandomFavouriteForDashBoard:(NSString *) favouriteType {
    
    // Fav Types:
    // 1- CCTV, 2- Events, 3-ABC, 4-WLS
    
    sqlite3_stmt    *statement;
    
    NSMutableDictionary *favouriteDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *favouriteArray = [[NSMutableArray alloc] init];
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        int recordCount =0;
        NSString *searchQuery = [NSString stringWithFormat: @"SELECT COUNT(*) FROM favourites WHERE fav_type=\"%@\"",favouriteType];
        
        const char *query_stmt = [searchQuery UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                recordCount = sqlite3_column_int(statement, 0);
            }
        }
        
        
        if (recordCount!=0) {
            
            NSString *getSQL = [NSString stringWithFormat: @"SELECT * FROM favourites WHERE fav_type=\"%@\" ORDER BY RANDOM() LIMIT 1",favouriteType];
            const char *get_stmt = [getSQL UTF8String];
            
            DebugLog(@"Insert query %@",getSQL);
            
            sqlite3_prepare_v2(database, get_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                if ([favouriteType isEqualToString:@"1"]) {
                    
                    NSString *nameValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *image = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    NSString *lat = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    NSString *lon = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    NSString *favId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                    
                    [favouriteDict setObject:favId forKey:@"ID"];
                    [favouriteDict setObject:nameValue forKey:@"Name"];
                    [favouriteDict setObject:lat forKey:@"Lat"];
                    [favouriteDict setObject:lon forKey:@"Lon"];
                    [favouriteDict setObject:image forKey:@"CCTVImageURL"];
                    
                    [favouriteArray addObject:favouriteDict];
                    
                }
                else if ([favouriteType isEqualToString:@"2"]) {
                    
                    DebugLog(@"No case of favorite events in dashboard");
                }
                else if ([favouriteType isEqualToString:@"3"]) {
                    
                    NSString *nameValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *image = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    NSString *lat = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    NSString *lon = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    NSString *address = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    NSString *phoneno = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    NSString *description = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    NSString *isCertified = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                    NSString *favId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                    NSString *hasPOI = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 20)];
                    
                    [favouriteDict setObject:favId forKey:@"id"];
                    [favouriteDict setObject:nameValue forKey:@"siteName"];
                    [favouriteDict setObject:lat forKey:@"locationLatitude"];
                    [favouriteDict setObject:lon forKey:@"locationLongitude"];
                    [favouriteDict setObject:address forKey:@"address"];
                    [favouriteDict setObject:phoneno forKey:@"phoneNo"];
                    [favouriteDict setObject:image forKey:@"image"];
                    [favouriteDict setObject:description forKey:@"description"];
                    [favouriteDict setObject:isCertified forKey:@"isCertified"];
                    [favouriteDict setObject:hasPOI forKey:@"hasPOI"];
                    
                    [favouriteArray addObject:favouriteDict];
                    
                }
                else if ([favouriteType isEqualToString:@"4"]) {
                    
                    NSString *nameValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *lat = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    NSString *lon = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    NSString *waterLevel = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                    NSString *drainDepth = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                    NSString *waterLevelPercentage = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                    NSString *waterLevelType = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                    NSString *observationTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                    NSString *favId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                    NSString *isWlsSubscribed = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                    
                    [favouriteDict setObject:favId forKey:@"id"];
                    [favouriteDict setObject:nameValue forKey:@"name"];
                    [favouriteDict setObject:lat forKey:@"latitude"];
                    [favouriteDict setObject:lon forKey:@"longitude"];
                    [favouriteDict setObject:waterLevel forKey:@"waterLevel"];
                    [favouriteDict setObject:drainDepth forKey:@"drainDepth"];
                    [favouriteDict setObject:waterLevelPercentage forKey:@"waterLevelPercentage"];
                    [favouriteDict setObject:waterLevelType forKey:@"waterLevelType"];
                    [favouriteDict setObject:observationTime forKey:@"observationTime"];
                    [favouriteDict setObject:isWlsSubscribed forKey:@"isSubscribed"];
                    
                    [favouriteArray addObject:favouriteDict];
                }
            }
            
            else {
                DebugLog(@"Can not get favourite. Some error occured.");
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    return favouriteArray;
}



//*************** Method To Insert Favourite Items

- (int) checkNotificationReadStatus:(NSInteger) notificationID {
    
    
    sqlite3_stmt    *statement;
    int recordCount =0;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *searchQuery = [NSString stringWithFormat: @"SELECT COUNT(*) FROM notifications_read WHERE notif_id=\"%ld\"",(long)notificationID];
        
        const char *query_stmt = [searchQuery UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                recordCount = sqlite3_column_int(statement, 0);
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    return recordCount;
}


//*************** Method To Insert Favourite Items

- (void) insertNotificationReadStatus:(NSInteger) notificationID {
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        int recordCount =0;
        NSString *searchQuery = [NSString stringWithFormat: @"SELECT COUNT(*) FROM notifications_read WHERE notif_id=\"%ld\"",(long)notificationID];
        
        const char *query_stmt = [searchQuery UTF8String];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                recordCount = sqlite3_column_int(statement, 0);
            }
        }
        
        
        if (recordCount==0) {
            
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT OR IGNORE INTO notifications_read (notif_id) VALUES (\"%ld\")",(long)notificationID];
            const char *insert_stmt = [insertSQL UTF8String];
            
            DebugLog(@"Insert query %@",insertSQL);
            
            sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                DebugLog(@"Row inserted");
            }
            
            else {
                DebugLog(@"Failed to insert row");
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}


//*************** Method To Insert WLS Site Data In Sqlite

- (void) removeNotificationsReadData {
    
    sqlite3_stmt    *statement;
    
    NSString *destinationPath = [self getdestinationPath];
    
    const char *dbpath = [destinationPath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *truncateTableSQL = [NSString stringWithFormat: @"DELETE FROM notifications_read"];
        const char *truncate_stmt = [truncateTableSQL UTF8String];
        
        sqlite3_prepare_v2(database, truncate_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            DebugLog(@"Table Truncated");
            
        }
        
        else {
            DebugLog(@"Failed to truncate table");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
}




# pragma mark - SQLite Create & Open Methods


//*************** Method To Give The Destination Path To Save Database

- (NSString*) getdestinationPath{
    
    NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:@"MyWaters/MyWaters.sqlite"];
    
    DebugLog(@"Destination Path %@",destinationPath);
    
    return destinationPath;
}



//*************** Method To Check Availability Of Database

- (void) chkAndCreateDatbase {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyWaters"];
    
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError* error;
    
    if (![fileManger fileExistsAtPath:dataPath]){
        
        
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
    
    
    NSString *destinationPath=[self getdestinationPath];
    if ([fileManger fileExistsAtPath:destinationPath]){
        //DebugLog(@"database localtion %@",destinationPath);
        return;
    }
    NSString *sourcePath=[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"MyWaters.sqlite"];
    [fileManger copyItemAtPath:sourcePath toPath:destinationPath error:&error];
}



//*************** Method For Opening The Database

- (void) openDatabase {
    
    NSString *path=[self getdestinationPath];
    if (sqlite3_open([path UTF8String], &database)==SQLITE_OK) {
        DebugLog(@"dataBaseOpen");
    }
    else {
        sqlite3_close(database);
        DebugLog(@"dataBaseNotOpen");
    }
}



// This method sends hits in the background until either we're told to stop background processing,
// we run into an error, or we run out of hits.  We use this to send any pending Google Analytics
// data since the app won't get a chance once it's in the background.
- (void)sendHitsInBackground {
    
    self.okToWait = YES;
    __weak AppDelegate *weakSelf = self;
    __block UIBackgroundTaskIdentifier backgroundTaskId =
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        weakSelf.okToWait = NO;
    }];
    
    if (backgroundTaskId == UIBackgroundTaskInvalid) {
        return;
    }
    
    self.dispatchHandler = ^(GAIDispatchResult result) {
        // If the last dispatch succeeded, and we're still OK to stay in the background then kick off
        // again.
        if (result == kGAIDispatchGood && weakSelf.okToWait ) {
            [[GAI sharedInstance] dispatchWithCompletionHandler:weakSelf.dispatchHandler];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
        }
    };
    [[GAI sharedInstance] dispatchWithCompletionHandler:self.dispatchHandler];
}


# pragma mark - CLLocationManagerDelegate Methods

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CURRENT_LOCATION_LAT = newLocation.coordinate.latitude;
    CURRENT_LOCATION_LONG = newLocation.coordinate.longitude;
    
    DebugLog(@"Current Location Lat & Long %f---%f",CURRENT_LOCATION_LAT,CURRENT_LOCATION_LONG);
    
    USER_CURRENT_LOCATION_COORDINATE = [newLocation coordinate];
    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    
    // Handle location updates as normal, code omitted for brevity.
    // The omitted code should determine whether to reject the location update for being too
    // old, too close to the previous one, too inaccurate and so forth according to your own
    // application design.
    
    if (isInBackground)
    {
        [self sendUserLocationForFloodNotifications];
    }
    else
    {
        // ...
    }
    
    [locationManager stopUpdatingLocation];
    
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
//    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[HomeViewController class]] && ([(HomeViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[iPadHomeViewController class]]) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}


# pragma mark - App Lifecycle Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self chkAndCreateDatbase];
    
    [FBLoginView class];
    [FBProfilePictureView class];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    DASHBOARD_PREFERENCES_ARRAY = [[NSMutableArray alloc] init];
    ABC_WATERS_LISTING_ARRAY = [[NSMutableArray alloc] init];
    EVENTS_LISTING_ARRAY = [[NSMutableArray alloc] init];
    WLS_LISTING_ARRAY = [[NSMutableArray alloc] init];
    CCTV_LISTING_ARRAY = [[NSMutableArray alloc] init];
    POI_ARRAY = [[NSMutableArray alloc] init];
    USER_FAVOURITES_ARRAY = [[NSMutableArray alloc] init];
    APP_CONFIG_DATA_ARRAY = [[NSMutableArray alloc] init];
    TIPS_VIDEOS_ARRAY = [[NSMutableArray alloc] init];
    USER_FLOOD_SUBMISSION_ARRAY = [[NSMutableArray alloc] init];
    PUB_FLOOD_SUBMISSION_ARRAY = [[NSMutableArray alloc] init];
    PUSH_NOTIFICATION_ARRAY = [[NSMutableArray alloc] init];
    SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY = [[NSMutableArray alloc] init];
    WLS_LISTING_ARRAY_FOR_DETAIL_VIEW = [[NSMutableArray alloc] init];
    CCTV_LISTING_ARRAY_FOR_DETAIL_VIEW = [[NSMutableArray alloc] init];
    
    LONG_PRESS_USER_LOCATION_LAT = 0.0;
    LONG_PRESS_USER_LOCATION_LONG = 0.0;
    IS_USER_LOCATION_SELECTED_BY_LONG_PRESS = NO;
    
    SELECTED_MENU_ID = 0;
    
    IS_RELAUNCHING_APP = YES;
    
    [self retrieveDashboardPreferences];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs stringForKey:@"floodAlert"] == (id)[NSNull null] || [[prefs stringForKey:@"floodAlert"] length] == 0) {
        [prefs setValue:@"YES" forKey:@"floodAlert"];
    }
    if ([prefs stringForKey:@"generalNotifications"] == (id)[NSNull null] || [[prefs stringForKey:@"generalNotifications"] length] == 0) {
        [prefs setValue:@"YES" forKey:@"generalNotifications"];
    }
    if ([prefs stringForKey:@"quickMapHints"] == (id)[NSNull null] || [[prefs stringForKey:@"quickMapHints"] length] == 0) {
        [prefs setValue:@"YES" forKey:@"quickMapHints"];
    }
    if ([prefs stringForKey:@"systemNotifications"] == (id)[NSNull null] || [[prefs stringForKey:@"systemNotifications"] length] == 0) {
        [prefs setValue:@"YES" forKey:@"systemNotifications"];
    }
    [prefs synchronize];
    
    screen_width = self.window.bounds.size.width;
    
    RESOURCE_FOLDER_PATH = [[NSBundle mainBundle] resourcePath];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = RGB(247, 247, 247);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        _splitViewController = [[UISplitViewController alloc] init];
        iPadMenuViewController *root = [[iPadMenuViewController alloc] init];
        iPadHomeViewController *detail = [[iPadHomeViewController alloc] init];
        UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:root];
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detail];
        rootNav.topViewController.navigationItem.leftBarButtonItem = _splitViewController.displayModeButtonItem;
        _splitViewController.viewControllers = [NSArray arrayWithObjects:rootNav, detailNav, nil];
        _splitViewController.delegate = self;
        [self.window setRootViewController:(UIViewController*)_splitViewController];
        
//        _splitViewController = (UISplitViewController *)self.window.rootViewController;
//        iPadHomeViewController *ipadHome = [[iPadHomeViewController alloc] init];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ipadHome];
//        navigationController.topViewController.navigationItem.leftBarButtonItem = _splitViewController.displayModeButtonItem;
//        _splitViewController.delegate = self;
//        [self.window setRootViewController:navigationController];
        
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
//        splitViewController.delegate = self;
        
    }
    else {
        [self createViewDeckController];
        [self.window setRootViewController:_rootDeckController];
        
        _rootDeckController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    
#ifdef __IPHONE_8_0
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
#endif
    
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeNewsstandContentAvailability;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    
    
    // Override point for customization after application launch.
    
    self.window.backgroundColor = RGB(247, 247, 247);
    
    if ([CommonFunctions hasConnectivity]) {
        [self getConfigData];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Connection error. Check your internet connection." msg:nil cancel:@"OK" otherButton:nil];
    }
    
    /////// GOOGLE ANALYTICS ///////
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"MyWaters-iOS"
                                              trackingId:kTrackingId];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    //    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication  fallbackHandler:^(FBAppCall *call)
    //            {
    //                NSLog(@"Facebook handler");
    //            }
    //            ];
    
    //    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    //    return wasHandled;
    if (IS_SHARING_ON_SOCIAL_MEDIA) {
        IS_SHARING_ON_SOCIAL_MEDIA = NO;
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication];
        //        return [FBSession.activeSession handleOpenURL:url];
    }
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    
    //        return [FBSession.activeSession handleOpenURL:url];
    
    
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (self.shouldRotate)
        return UIInterfaceOrientationMaskLandscapeRight;
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self sendHitsInBackground];
    
    // Commented Out For Version 2.0 AS no flood notifications
    //    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [locationManager startUpdatingLocation];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ([CommonFunctions hasConnectivity]) {
        [self getConfigData];
        // Register Device Token
        if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"device_token"] length] !=0)
            [self registerDeviceToken];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Connection error. Check your internet connection." msg:nil cancel:@"OK" otherButton:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //    [FBSession.activeSession handleDidBecomeActive];
    
    [locationManager startUpdatingLocation];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
    
    [locationManager stopMonitoringSignificantLocationChanges];
    
    
    //***** Code To Exclude MyWaters Document Directory From Being Synced With iCloud
    NSString *documentDirectoryUrl = [[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingPathComponent:[NSString stringWithFormat:@"/MyWaters/"]];
    NSURL *url = [NSURL fileURLWithPath:documentDirectoryUrl];
    assert([[NSFileManager defaultManager] fileExistsAtPath:documentDirectoryUrl]);
    
    NSError *error = nil;
    BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
    }
    else {
        NSLog(@"Excluded");
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}



# pragma mark - APN Methods For Push Notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    DebugLog(@"%@",userInfo);
    
    IS_PUSH_NOTIFICATION_RECEIVED = YES;
    RECEIVED_NOTIFICATION_TYPE = [[userInfo objectForKey:@"type"] intValue];
    PUSH_NOTIFICATION_ALERT_MESSAGE = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    DebugLog(@"%ld---%@",(long)RECEIVED_NOTIFICATION_TYPE,PUSH_NOTIFICATION_ALERT_MESSAGE);
    
    //    {
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    
    if (state == UIApplicationStateBackground || state==UIApplicationStateInactive) {
        //            if (![[SharedObject sharedClass] isSSCUserSignedIn]) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:NO];
        //            }
        //            else {
        //                [[ViewControllerHelper viewControllerHelper] enableThisController:SIGN_IN_CONTROLLER onCenter:YES withAnimate:NO];
        //            }
    }
    else if (state == UIApplicationStateActive) {
        
        notificationAlert = [[UIAlertView alloc] initWithTitle:nil message:PUSH_NOTIFICATION_ALERT_MESSAGE delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Open", nil];
        [notificationAlert show];
    }
    //    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    DebugLog(@"APNS ERROR: %@",[error description]);
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    
}



- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    DebugLog(@"%@",deviceTokenString);
    
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:deviceTokenString forKey:@"device_token"];
    [prefs synchronize];
    
    DebugLog(@"%@",deviceTokenString);
    
    [self registerDeviceToken];
    
}


@end
