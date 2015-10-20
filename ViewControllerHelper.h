//
//  ViewControllerHelper.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 21/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "SideMenuOptionsViewController.h"
#import "HomeViewController.h"
#import "NotificationsViewController.h"
#import "WhatsUpViewController.h"
#import "QuickMapViewController.h"
#import "ABCWatersViewController.h"
#import "EventsViewController.h"
#import "BookingViewController.h"
#import "BookingWebViewController.h"
#import "FeedbackViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "FavouritesViewController.h"
#import "WelcomeViewController.h"
#import "AboutMyWatersViewController.h"
#import "CCTVListingController.h"
#import "WLSListingViewController.h"
#import "LoginViewController.h"
#import "TipsListingViewController.h"

typedef enum {
  
    HOME_CONTROLLER = 0,
    NOTIFICATIONS_CONTROLLER,
    PROFILE_CONTROLLER,
    FAVOURITES_CONTROLLER,
    WHATSUP_CONTROLLER,
    FLOODMAP_CONTROLLER,
    ABCWATERS_CONTROLLER,
    EVENTS_CONTROLLER,
    CCTV_CONTROLLER,
    WLS_CONTROLLER,
    BOOKING_CONTROLLER,
    FEEDBACK_CONTROLLER,
    TIPS_CONTROLLER,
    SETTINGS_CONTROLLER,
    ABOUT_PUB_CONTROLLER,
    SIGN_IN_CONTROLLER,
    
} appControllers;

typedef enum {
    
    right_controller = 0,
    left_controller,
    center_cotroller,
    
} controllerPosition;


@class SideMenuOptionsViewController;
@interface ViewControllerHelper : NSObject {
    
    AppDelegate *appDelegate;
}

#pragma mark constructor
+ (ViewControllerHelper*) viewControllerHelper;
- (id)init;
@property (nonatomic, assign) NSInteger currentDeckIndex;


@property (nonatomic, retain) UINavigationController *homeNavController,*notificationsNavController,*whatsupNavController,*floodmapNavController,*abcwatersNavController,*eventsNavController,*cctvNavController,*wlsController,*bookingNavController,*feedbackNavController,*settingsNavController,*profileNavController,*favouritesNavController,*signInController,*aboutPUBController,*tipsNavController;

- (void) clear_All_ControllersInThisNavigationCntrl:(UINavigationController*)navControl;
- (void) clearAllThe_Controllers;
- (void) singOut;


@property (nonatomic, retain) SideMenuOptionsViewController *sideMenuOptionsController;
- (SideMenuOptionsViewController*) getOptionsController;

//*************** Side Menu ***************//
- (UINavigationController*) getHomeController;
- (UINavigationController*) getNotificationsController;
- (UINavigationController*) getWhatsUpController;
- (UINavigationController*) getFloodMapController;
- (UINavigationController*) getABCWatersController;
- (UINavigationController*) getEventsController;
- (UINavigationController*) getCCTVController;
- (UINavigationController*) getWlsController;
- (UINavigationController*) getBookingController;
- (UINavigationController*) getFeedbackController;
- (UINavigationController*) getTipsController;
- (UINavigationController*) getSettingsController;
- (UINavigationController*) getProfileController;
- (UINavigationController*) getFavouritesController;
- (UINavigationController*) getSignInController;
- (UINavigationController*) getAboutPUBController;


//*************** Switch between controllers ***************//
-(void)enableDeckView:(id)sender;
-(void)enableThisController:(appControllers)sender onCenter:(BOOL)center withAnimate:(BOOL)animate;
-(void) signOut;

@end
