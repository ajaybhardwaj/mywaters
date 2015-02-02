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
@synthesize RESOURCE_FOLDER_PATH;

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
    
    
    // -- after first time it will flow from this screen...
    //    if (![[SharedObject sharedClass] isSSCUserSignedIn]) {
    //        if (!deckCenterController && ![[(UINavigationController*)deckCenterController topViewController] isKindOfClass:[iMSigninController class]]) {
    //
    //
    //            _rootDeckController = [[IIViewDeckController alloc] initWithCenterViewController:nil leftViewController:nil rightViewController:nil topViewController:nil bottomViewController:nil];
    //            _rootDeckController.delegateMode = IIViewDeckDelegateOnly;
    //            _rootDeckController.delegate = self;
    //
    //            [[iMViewControllerHelper viewControllerHelper] enableThisController:SIGN_IN_CONTROLLER onCenter:YES withAnimate:NO];
    //        }
    //    }
    //    else{
    
    if (!deckCenterController && ![[(UINavigationController*)deckCenterController topViewController] isKindOfClass:[HomeViewController class]]) {
        
        _rootDeckController = [[IIViewDeckController alloc] initWithCenterViewController:nil leftViewController:nil rightViewController:nil topViewController:nil bottomViewController:nil];
        _rootDeckController.delegateMode = IIViewDeckDelegateOnly;
        _rootDeckController.delegate = self;
        
        [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:NO];
        
        //        }
        
    }
    
}



# pragma mark - App Lifecycle Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    RESOURCE_FOLDER_PATH = [[NSBundle mainBundle] resourcePath];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor clearColor];
    
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
    
    // Override point for customization after application launch.
    return YES;
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
