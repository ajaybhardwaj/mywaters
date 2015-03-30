//
//  AppDelegate.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "SharedObject.h"
#import "HomeViewController.h"
#import "ViewControllerHelper.h"
#import <sqlite3.h>
#import "CommonFunctions.h"
#import "WelcomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IIViewDeckControllerDelegate> {
    
    NSString *DATABASE_PATH;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IIViewDeckController *rootDeckController;
@property (nonatomic,assign) sqlite3 *database;
@property (nonatomic, assign) NSInteger left_deck_width,screen_width;
@property (nonatomic, retain) NSString *RESOURCE_FOLDER_PATH;
@property (nonatomic, retain) NSMutableArray *DASHBOARD_PREFERENCES_ARRAY,*ABC_WATERS_LISTING_ARRAY,*POI_ARRAY;
@property (nonatomic, assign) NSInteger NEW_DASHBOARD_STATUS,DASHBOARD_PREFERENCE_ID;
@property (nonatomic, retain) NSString *LOGGED_IN_USER_NAME;
@property (nonatomic, assign) BOOL IS_COMING_AFTER_LOGIN;

- (void) createViewDeckController;
- (void) retrieveDashboardPreferences;
- (void) updateDashboardPreference;
- (void) retrieveABCWatersListing;
- (void) retrievePointOfInterests:(int) abcwater_id;

@end

