//
//  AppDelegate.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize RESOURCE_FOLDER_PATH,database;
@synthesize DASHBOARD_PREFERENCES_ARRAY,NEW_DASHBOARD_STATUS,DASHBOARD_PREFERENCE_ID,ABC_WATERS_LISTING_ARRAY,POI_ARRAY,EVENTS_LISTING_ARRAY,WLS_LISTING_ARRAY,CCTV_LISTING_ARRAY;
@synthesize screen_width,left_deck_width;
@synthesize IS_COMING_AFTER_LOGIN;
@synthesize SELECTED_MENU_ID;
@synthesize IS_ARVIEW_CUSTOM_LABEL;
@synthesize IS_MOVING_TO_WLS_FROM_DASHBOARD,IS_MOVING_TO_CCTV_FROM_DASHBOARD;
@synthesize hud;
@synthesize USER_PROFILE_DICTIONARY;

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
    if (![[SharedObject sharedClass] isSSCUserSignedIn]) {
        
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
        }
        
        else {
            DebugLog(@"Failed to update row");
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



# pragma mark - App Lifecycle Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self chkAndCreateDatbase];
    
    DASHBOARD_PREFERENCES_ARRAY = [[NSMutableArray alloc] init];
    ABC_WATERS_LISTING_ARRAY = [[NSMutableArray alloc] init];
    EVENTS_LISTING_ARRAY = [[NSMutableArray alloc] init];
    WLS_LISTING_ARRAY = [[NSMutableArray alloc] init];
    CCTV_LISTING_ARRAY = [[NSMutableArray alloc] init];
    POI_ARRAY = [[NSMutableArray alloc] init];
    USER_PROFILE_DICTIONARY = [[NSDictionary alloc] init];
    SELECTED_MENU_ID = 0;
    
        
    [self retrieveDashboardPreferences];
    
    screen_width = self.window.bounds.size.width;
    
    RESOURCE_FOLDER_PATH = [[NSBundle mainBundle] resourcePath];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = RGB(247, 247, 247);
    
    [self createViewDeckController];
    [self.window setRootViewController:_rootDeckController];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    _rootDeckController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    // Override point for customization after application launch.
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
