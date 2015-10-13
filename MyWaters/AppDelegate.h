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
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IIViewDeckControllerDelegate> {
    
    NSString *DATABASE_PATH;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IIViewDeckController *rootDeckController;
@property (nonatomic,assign) sqlite3 *database;
@property (nonatomic, assign) NSInteger left_deck_width,screen_width;
@property (nonatomic, retain) NSString *RESOURCE_FOLDER_PATH;
@property (nonatomic, retain) NSMutableArray *DASHBOARD_PREFERENCES_ARRAY,*ABC_WATERS_LISTING_ARRAY,*POI_ARRAY,*EVENTS_LISTING_ARRAY,*WLS_LISTING_ARRAY,*CCTV_LISTING_ARRAY,*USER_FAVOURITES_ARRAY,*APP_CONFIG_DATA_ARRAY;
@property (nonatomic, assign) NSInteger NEW_DASHBOARD_STATUS,DASHBOARD_PREFERENCE_ID,SELECTED_MENU_ID;
@property (nonatomic, assign) BOOL IS_COMING_AFTER_LOGIN,IS_ARVIEW_CUSTOM_LABEL,IS_MOVING_TO_WLS_FROM_DASHBOARD,IS_MOVING_TO_CCTV_FROM_DASHBOARD,DASHBOARD_PREFERENCES_CHANGED;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSDictionary *USER_PROFILE_DICTIONARY;
@property (nonatomic, assign) double CURRENT_LOCATION_LAT,CURRENT_LOCATION_LONG;
@property (nonatomic, assign) CLLocationCoordinate2D USER_CURRENT_LOCATION_COORDINATE;
@property (nonatomic, assign) BOOL IS_COMING_FROM_DASHBOARD;

- (void) createViewDeckController;
- (void) retrieveDashboardPreferences;
- (void) updateDashboardPreference;
- (void) retrieveABCWatersListing;
- (void) retrievePointOfInterests:(int) abcwater_id;


//***** Method For Sqlite For Favourites
- (void) insertFavouriteItems:(NSMutableDictionary*) parametersDict;
- (void) retrieveFavouriteItems:(NSInteger) favouriteType;
- (void) deleteFavouriteItems:(int) rowID;
- (BOOL) checkItemForFavourite:(NSString*)favType idValue:(NSString*)favID;

@end

