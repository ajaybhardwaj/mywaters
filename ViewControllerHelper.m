//
//  ViewControllerHelper.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 21/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ViewControllerHelper.h"
#import "AuxilaryService.h"

@implementation ViewControllerHelper

static ViewControllerHelper *sharedViewHelper = nil;

+ (ViewControllerHelper*) viewControllerHelper {
    
    if (!sharedViewHelper) {
        sharedViewHelper = [[ViewControllerHelper alloc] init];
    }
    return sharedViewHelper;
}


- (id) init {
    
    self = [super init];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (self) {
        // -- do initialization
        _currentDeckIndex = -1;
    }
    return self;
}




-(void) signOut {
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:@"N" forKey:@"isLoginAlready"];
//    [prefs synchronize];
//    
//    [self deactivateDeviceToken];
//    appdelegate.IS_SWIM_PASSES_LOADED_FIRST_TIME = NO;
//    
//    if ([[AuxilaryService auxFunctions] isFileExists:SUPER_SPORTS_CLUB_USER_PROFILE_DICT]) {
//        NSError *err;
//        [[NSFileManager defaultManager] removeItemAtPath:[[AuxilaryService auxFunctions] getDocumentDirectory:SUPER_SPORTS_CLUB_USER_PROFILE_DICT] error:&err];
//    }
    
    
    // -- Animations
    
    //    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //    if ([[prefs stringForKey:@"shopping_cart_timer_running"] isEqualToString:@"Y"]) {
    //
    //        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //
    //        NSArray *param = [[NSArray alloc] initWithObjects:@"shopping_cart_id", nil];
    //        NSArray *value = [[NSArray alloc] initWithObjects:[prefs stringForKey:@"shopping_cart_id"], nil];
    //
    //        DebugLog(@"%@",[prefs stringForKey:@"shopping_cart_id"]);
    //
    //        RDBaseNetworkController *controller = [[RDBaseNetworkController alloc] init];
    //        [controller postDataToServer:SHOPPING_CART_CLEAR parameters:param values:value avatar:nil];
    //
    //        [param release];
    //        [value release];
    //
    //        [prefs setObject:@"N" forKey:@"shopping_cart_timer_running"];
    //        [prefs synchronize];
    //
    //    }
    
    // -- remove the user data and enable landing page
//    [[SharedObject sharedClass] removeSaved_SUPER_SPORTS_CLUB_User];
    [[SharedObject sharedClass] clearPUBUserSavedData];
    _currentDeckIndex = -1;
    [appDelegate removeNotificationsReadData];
    
    
    
    [[appDelegate rootDeckController] closeLeftView];
    appDelegate.left_deck_width = 320-180;
    
    // -- Clear all the datas.
    [self clearAllThe_Controllers];
    [[appDelegate rootDeckController] setLeftController:nil];
    // -- Push to home page..
    [[ViewControllerHelper viewControllerHelper] enableThisController:SIGN_IN_CONTROLLER onCenter:YES withAnimate:FALSE];
    
}



# pragma mark - Common Navigation Bar Styles

-(void)setNavigationBar_Style:(UINavigationBar*)navigationBar_{
    
    [navigationBar_ setBackgroundColor:[UIColor clearColor]];
    [navigationBar_ setBarStyle:UIBarStyleBlack];
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]){
        
        [navigationBar_ setBackgroundImage:HEADER_BACKGROUND forBarMetrics:UIBarMetricsDefault];
        [AuxilaryService setNavigationTitleStyle_ToPY:navigationBar_];
    }
    
}

-(void)setNavigationBarStyle_Transclucent:(UINavigationBar*)navigationBar_{
    
    [navigationBar_ setBackgroundColor:[UIColor clearColor]];
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        
        navigationBar_.translucent = YES; // Setting this slides the view up, underneath the nav bar (otherwise it'll appear black)
        const CGFloat colorMask[6] = {222, 255, 222, 255, 222, 255};
        UIImage *img = [[UIImage alloc] init];
        UIImage *maskedImage = [UIImage imageWithCGImage:CGImageCreateWithMaskingColors(img.CGImage, colorMask)];//imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage, colorMask)];
        [navigationBar_ setBackgroundImage:maskedImage forBarMetrics:UIBarMetricsDefault];
        [AuxilaryService setNavigationTitleStyle_ToPY:navigationBar_];
    }
}



# pragma mark - Controllers

- (SideMenuOptionsViewController*) getOptionsController{
    
    if (!_sideMenuOptionsController) {
        _sideMenuOptionsController = [[SideMenuOptionsViewController alloc] init];
    }
    return _sideMenuOptionsController;
}


-(UINavigationController*)getSignInController{
    
    if (!_signInController) {
        
//        WelcomeViewController *signin = [[WelcomeViewController alloc] init];
        LoginViewController *signin = [[LoginViewController alloc] init];
        _signInController = [[UINavigationController alloc] initWithRootViewController:signin];
        [self setNavigationBarStyle_Transclucent:_signInController.navigationBar];
        
        [[[signin navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
        [[[signin navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        
        [_signInController.view setAutoresizesSubviews:TRUE];
        [_signInController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = SIGN_IN_CONTROLLER;
        
        return _signInController;
        
    }

    return _signInController;
}


- (UINavigationController*) getHomeController {
    
    if (!_homeNavController) {
        
        HomeViewController *home = [[HomeViewController alloc] init];
        [home setTitle:@"Home"];
        _homeNavController = [[UINavigationController alloc] initWithRootViewController:home];
        
        [self setNavigationBarStyle_Transclucent:_homeNavController.navigationBar];
        [[[home navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(242,242,242) frame:CGRectMake(0, 0, 1, 1)];
        [[[home navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_homeNavController.view setAutoresizesSubviews:TRUE];
        [_homeNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = HOME_CONTROLLER;
        
        [_homeNavController popToRootViewControllerAnimated:NO];
    }
    else {
        [_homeNavController popToRootViewControllerAnimated:NO];
    }
    
    return _homeNavController;
}


- (UINavigationController*) getNotificationsController {
    
    if (!_notificationsNavController) {
        
        NotificationsViewController *notification = [[NotificationsViewController alloc] init];
        [notification setTitle:@"Notifications"];
        _notificationsNavController = [[UINavigationController alloc] initWithRootViewController:notification];
        
        [self setNavigationBarStyle_Transclucent:_notificationsNavController.navigationBar];
        [[[notification navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(71, 178, 182) frame:CGRectMake(0, 0, 1, 1)];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(113, 75, 51) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(115, 177, 17) frame:CGRectMake(0, 0, 1, 1)];
        [[[notification navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_notificationsNavController.view setAutoresizesSubviews:TRUE];
        [_notificationsNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = NOTIFICATIONS_CONTROLLER;
        
        [_notificationsNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_notificationsNavController popToRootViewControllerAnimated:NO];
    }
    
    return _notificationsNavController;
}


- (UINavigationController*) getWhatsUpController {
    
    if (!_whatsupNavController) {
        
        WhatsUpViewController *whatsup = [[WhatsUpViewController alloc] init];
        [whatsup setTitle:@"What's Up"];
        _whatsupNavController = [[UINavigationController alloc] initWithRootViewController:whatsup];
        
        [self setNavigationBarStyle_Transclucent:_whatsupNavController.navigationBar];
        [[[whatsup navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,206,0) frame:CGRectMake(0, 0, 1, 1)];
        [[[whatsup navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_whatsupNavController.view setAutoresizesSubviews:TRUE];
        [_whatsupNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = WHATSUP_CONTROLLER;
        
        [_whatsupNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_whatsupNavController popToRootViewControllerAnimated:NO];
    }
    
    return _whatsupNavController;
}


- (UINavigationController*) getFloodMapController {
    
    if (!_floodmapNavController) {
        
        QuickMapViewController *floodmap = [[QuickMapViewController alloc] init];
        [floodmap setTitle:@"Quick Map"];
        _floodmapNavController = [[UINavigationController alloc] initWithRootViewController:floodmap];
        
        [self setNavigationBarStyle_Transclucent:_floodmapNavController.navigationBar];
        [[[floodmap navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(229,0,87) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(208,11,76) frame:CGRectMake(0, 0, 1, 1)];
        [[[floodmap navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_floodmapNavController.view setAutoresizesSubviews:TRUE];
        [_floodmapNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = FLOODMAP_CONTROLLER;
        
        [_floodmapNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_floodmapNavController popToRootViewControllerAnimated:NO];
    }
    
    return _floodmapNavController;
}


- (UINavigationController*) getABCWatersController {
    
    if (!_abcwatersNavController) {
        
        ABCWatersViewController *abcwaters = [[ABCWatersViewController alloc] init];
        [abcwaters setTitle:@"Our Waters"];
        _abcwatersNavController = [[UINavigationController alloc] initWithRootViewController:abcwaters];
        
        [self setNavigationBarStyle_Transclucent:_abcwatersNavController.navigationBar];
        [[[abcwaters navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(76,175,238) frame:CGRectMake(0, 0, 1, 1)];
        [[[abcwaters navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_abcwatersNavController.view setAutoresizesSubviews:TRUE];
        [_abcwatersNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = ABCWATERS_CONTROLLER;
        
        [_abcwatersNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_abcwatersNavController popToRootViewControllerAnimated:NO];
    }
    
    return _abcwatersNavController;
}


- (UINavigationController*) getEventsController {
    
    if (!_eventsNavController) {
        
        EventsViewController *events = [[EventsViewController alloc] init];
        [events setTitle:@"Events"];
        _eventsNavController = [[UINavigationController alloc] initWithRootViewController:events];
        
        [self setNavigationBarStyle_Transclucent:_eventsNavController.navigationBar];
        [[[events navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(244,155,0) frame:CGRectMake(0, 0, 1, 1)];
        [[[events navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_eventsNavController.view setAutoresizesSubviews:TRUE];
        [_eventsNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = EVENTS_CONTROLLER;
        
        [_eventsNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_eventsNavController popToRootViewControllerAnimated:NO];
    }
    
    return _eventsNavController;
}


- (UINavigationController*) getCCTVController {
    
    if (!_cctvNavController) {
        
        CCTVListingController *cctv = [[CCTVListingController alloc] init];
        [cctv setTitle:@"CCTVs"];
        _cctvNavController = [[UINavigationController alloc] initWithRootViewController:cctv];
        
        [self setNavigationBarStyle_Transclucent:_cctvNavController.navigationBar];
        [[[cctv navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(71, 178, 182) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(33, 131, 142) frame:CGRectMake(0, 0, 1, 1)];
        [[[cctv navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_cctvNavController.view setAutoresizesSubviews:TRUE];
        [_cctvNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = CCTV_CONTROLLER;
        
        [_cctvNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_cctvNavController popToRootViewControllerAnimated:NO];
    }
    
    return _cctvNavController;
}


- (UINavigationController*) getWlsController {
    
    if (!_wlsController) {
        
        WLSListingViewController *wls = [[WLSListingViewController alloc] init];
        [wls setTitle:@"Water Level Sensor"];
        _wlsController = [[UINavigationController alloc] initWithRootViewController:wls];
        
        [self setNavigationBarStyle_Transclucent:_wlsController.navigationBar];
        [[[wls navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(52,158,240) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(51,148,228) frame:CGRectMake(0, 0, 1, 1)];
        [[[wls navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_wlsController.view setAutoresizesSubviews:TRUE];
        [_wlsController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = WLS_CONTROLLER;
        
        [_wlsController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_wlsController popToRootViewControllerAnimated:NO];
    }
    
    return _wlsController;
}


- (UINavigationController*) getBookingController {
    
    if (!_bookingNavController) {
        
//        BookingViewController *booking = [[BookingViewController alloc] init];
        BookingWebViewController *booking = [[BookingWebViewController alloc] init];
        [booking setTitle:@"Booking"];
        _bookingNavController = [[UINavigationController alloc] initWithRootViewController:booking];
        
        [self setNavigationBarStyle_Transclucent:_bookingNavController.navigationBar];
        [[[booking navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(231,95,39) frame:CGRectMake(0, 0, 1, 1)];
        [[[booking navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_bookingNavController.view setAutoresizesSubviews:TRUE];
        [_bookingNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = BOOKING_CONTROLLER;
        
        [_bookingNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_bookingNavController popToRootViewControllerAnimated:NO];
    }
    
    return _bookingNavController;
}


- (UINavigationController*) getFeedbackController {
    
    if (!_feedbackNavController) {
        
        FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
        [feedback setTitle:@"Report/Feedback"];
        _feedbackNavController = [[UINavigationController alloc] initWithRootViewController:feedback];
        
        [self setNavigationBarStyle_Transclucent:_feedbackNavController.navigationBar];
        [[[feedback navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(113, 75, 51) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(219, 22, 31) frame:CGRectMake(0, 0, 1, 1)];
        [[[feedback navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_feedbackNavController.view setAutoresizesSubviews:TRUE];
        [_feedbackNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = FEEDBACK_CONTROLLER;
        
        [_feedbackNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_feedbackNavController popToRootViewControllerAnimated:NO];
    }
    
    return _feedbackNavController;
}


- (UINavigationController*) getTipsController {
    
    if (!_tipsNavController) {
        
        TipsListingViewController *feedback = [[TipsListingViewController alloc] init];
        [feedback setTitle:@"Tips"];
        _tipsNavController = [[UINavigationController alloc] initWithRootViewController:feedback];
        
        [self setNavigationBarStyle_Transclucent:_tipsNavController.navigationBar];
        [[[feedback navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        //        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(140,164,0) frame:CGRectMake(0, 0, 1, 1)];
        //        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(71, 178, 182) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(229,0,87) frame:CGRectMake(0, 0, 1, 1)];
        [[[feedback navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_tipsNavController.view setAutoresizesSubviews:TRUE];
        [_tipsNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = TIPS_CONTROLLER;
        
        [_tipsNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_tipsNavController popToRootViewControllerAnimated:NO];
    }
    
    return _tipsNavController;
}


- (UINavigationController*) getSettingsController {
    
    if (!_settingsNavController) {
        
        SettingsViewController *settings = [[SettingsViewController alloc] init];
        [settings setTitle:@"Settings"];
        _settingsNavController = [[UINavigationController alloc] initWithRootViewController:settings];
        
        [self setNavigationBarStyle_Transclucent:_settingsNavController.navigationBar];
        [[[settings navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(135, 135, 135) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(196, 197, 200) frame:CGRectMake(0, 0, 1, 1)];
        [[[settings navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_settingsNavController.view setAutoresizesSubviews:TRUE];
        [_settingsNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = SETTINGS_CONTROLLER;
        
        [_settingsNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_settingsNavController popToRootViewControllerAnimated:NO];
    }
    
    return _settingsNavController;
}


- (UINavigationController*) getProfileController {
    
    if (!_profileNavController) {
        
        ProfileViewController *profile = [[ProfileViewController alloc] init];
        [profile setTitle:@"My Profile"];
        _profileNavController = [[UINavigationController alloc] initWithRootViewController:profile];
        
        [self setNavigationBarStyle_Transclucent:_profileNavController.navigationBar];
        [[[profile navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(85,49,118) frame:CGRectMake(0, 0, 1, 1)];
        [[[profile navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_profileNavController.view setAutoresizesSubviews:TRUE];
        [_profileNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = PROFILE_CONTROLLER;
        
        [_profileNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_profileNavController popToRootViewControllerAnimated:NO];
    }
    
    return _profileNavController;
}


- (UINavigationController*) getFavouritesController {
    
    if (!_favouritesNavController) {
        
        FavouritesViewController *favourites = [[FavouritesViewController alloc] init];
        [favourites setTitle:@"Favourites"];
        _favouritesNavController = [[UINavigationController alloc] initWithRootViewController:favourites];
        
        [self setNavigationBarStyle_Transclucent:_favouritesNavController.navigationBar];
        [[[favourites navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(85,49,118) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(249,172,0) frame:CGRectMake(0, 0, 1, 1)];
        [[[favourites navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_favouritesNavController.view setAutoresizesSubviews:TRUE];
        [_favouritesNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = FAVOURITES_CONTROLLER;
        
        [_favouritesNavController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_favouritesNavController popToRootViewControllerAnimated:NO];
    }
    
    return _favouritesNavController;
}


- (UINavigationController*) getWeatherForecastController {
    
    if (!_weatherForecastNavController) {
        
        WeatherForecastViewController *weather = [[WeatherForecastViewController alloc] init];
        [weather setTitle:@"Home"];
        _weatherForecastNavController = [[UINavigationController alloc] initWithRootViewController:weather];
        
        [self setNavigationBarStyle_Transclucent:_homeNavController.navigationBar];
        [[[weather navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(36,160,236) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(184,213,239) frame:CGRectMake(0, 0, 1, 1)];
        [[[weather navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_weatherForecastNavController.view setAutoresizesSubviews:TRUE];
        [_weatherForecastNavController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = WEATHER_FORECAST_CONTROLLER;
        
        [_weatherForecastNavController popToRootViewControllerAnimated:NO];
    }
    else {
        [_weatherForecastNavController popToRootViewControllerAnimated:NO];
    }
    
    return _weatherForecastNavController;
}


- (UINavigationController*) getAboutPUBController {
    
    if (!_aboutPUBController) {
        
        AboutMyWatersViewController *aboutPUB = [[AboutMyWatersViewController alloc] init];
        [aboutPUB setTitle:@"About PUB"];
        _aboutPUBController = [[UINavigationController alloc] initWithRootViewController:aboutPUB];
        
        [self setNavigationBarStyle_Transclucent:_aboutPUBController.navigationBar];
        [[[aboutPUB navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(135, 135, 135) frame:CGRectMake(0, 0, 1, 1)];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(134, 144, 156) frame:CGRectMake(0, 0, 1, 1)];
        [[[aboutPUB navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        [_aboutPUBController.view setAutoresizesSubviews:TRUE];
        [_aboutPUBController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        _currentDeckIndex = ABOUT_PUB_CONTROLLER;
        
        [_aboutPUBController popToRootViewControllerAnimated:NO];
        
    }
    else {
        [_aboutPUBController popToRootViewControllerAnimated:NO];
    }
    
    return _aboutPUBController;
}




# pragma mark - Deck View Methods

- (void) enableDeckView:(id)sender {
    
    if ([[appDelegate rootDeckController] leftController] == nil) {
        [[appDelegate rootDeckController] setLeftController:[[ViewControllerHelper viewControllerHelper] getOptionsController]];
        
        //***** Code added to add side menu on app window
        [appDelegate.window addSubview:_sideMenuOptionsController.view];
        [appDelegate.window bringSubviewToFront:_sideMenuOptionsController.optionsTableView];
    }

    appDelegate.left_deck_width = appDelegate.screen_width - 1;
    
    [[appDelegate rootDeckController] setLeftSize:appDelegate.left_deck_width];
    [[appDelegate rootDeckController] toggleLeftViewAnimated:YES];

    [[appDelegate rootDeckController] setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];

    
    //***** Code added to bring menu on the top of view, remove it of want menu below the view and minus the "appDelegate.left_deck_width = appDelegate.screen_width - 180;"
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = _sideMenuOptionsController.optionsTableView.center;
    if (IS_IPHONE_4_OR_LESS) {
        pos.x = 85;
    }
    else if (IS_IPHONE_5) {
        pos.x = 85;
    }
    else if (IS_IPHONE_6) {
        pos.x = 112;
    }
    else if (IS_IPHONE_6P) {
        pos.x = 130;
    }
    _sideMenuOptionsController.optionsTableView.center = pos;
    [UIView commitAnimations];
    
//    [_sideMenuOptionsController.view.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
//    [_sideMenuOptionsController.view.layer setShadowOffset:CGSizeMake(3, 3)];
//    [_sideMenuOptionsController.view.layer setShadowOpacity:3];
//    [_sideMenuOptionsController.view.layer setShadowRadius:3.0];

}


- (void) enableThisController:(appControllers)sender onCenter:(BOOL)center withAnimate:(BOOL)animate {
    
    NSInteger selectedIndex = sender;
    switch (selectedIndex) {
            
        case HOME_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getHomeController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getHomeController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:HOME_CONTROLLER];
            break;
            
        case BOOKING_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getBookingController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getBookingController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:BOOKING_CONTROLLER];
            break;
            
        case CCTV_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getCCTVController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getCCTVController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:CCTV_CONTROLLER];
            break;
            
        case EVENTS_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getEventsController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getEventsController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:EVENTS_CONTROLLER];
            break;
            
        case FAVOURITES_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getFavouritesController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getFavouritesController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:FAVOURITES_CONTROLLER];
            break;
            
        case FEEDBACK_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getFeedbackController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getFeedbackController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:FEEDBACK_CONTROLLER];
            break;
            
        case PROFILE_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getProfileController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getProfileController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:PROFILE_CONTROLLER];
            break;
            
        case NOTIFICATIONS_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getNotificationsController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getNotificationsController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:NOTIFICATIONS_CONTROLLER];
            break;
            
        case ABCWATERS_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getABCWatersController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getABCWatersController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:ABCWATERS_CONTROLLER];
            break;
            
        case FLOODMAP_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getFloodMapController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getFloodMapController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:FLOODMAP_CONTROLLER];
            break;
            
            
        case TIPS_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getTipsController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getTipsController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:TIPS_CONTROLLER];
            break;
            
        case WLS_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getWlsController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getWlsController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:WLS_CONTROLLER];
            break;
            
        case WEATHER_FORECAST_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getWeatherForecastController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getWeatherForecastController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:WEATHER_FORECAST_CONTROLLER];
            break;
            
        case WHATSUP_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getWhatsUpController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getWhatsUpController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:WHATSUP_CONTROLLER];
            break;
            
        case SETTINGS_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getSettingsController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getSettingsController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:SETTINGS_CONTROLLER];
            break;
            
        case ABOUT_PUB_CONTROLLER:
            if (center) {
                [[appDelegate rootDeckController] setCenterController:nil];
                [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getAboutPUBController]];
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getAboutPUBController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:ABOUT_PUB_CONTROLLER];
            break;
            
        case SIGN_IN_CONTROLLER:
            if (center) {
//                if (!appdelegate.IS_SKIP_REGISTRATION_ACTIVE) {
                    [[appDelegate rootDeckController] setCenterController:nil];
                    [[appDelegate rootDeckController] setCenterController:[[ViewControllerHelper viewControllerHelper] getSignInController]];
//                }
            }
            else{
                [[appDelegate rootDeckController] setRightController:nil];
                [[appDelegate rootDeckController] setRightController:[[ViewControllerHelper viewControllerHelper] getSignInController]];
                if (animate) {
                    [[appDelegate rootDeckController] toggleRightViewAnimated:TRUE];
                }
            }
            [[[ViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:SIGN_IN_CONTROLLER];
            // -- No need to set the current index here for signin....
            break;
            
//        case INTRO_SCREEN_CONTROLLER:
//            if (center) {
//                
//                RDLog(@"\n -- INTRO_SCREEN_CONTROLLER \n");
//                [[delegate rootDeckController] setCenterController:nil];
//                [[delegate rootDeckController] setCenterController:[[iMViewControllerHelper viewControllerHelper] getIntroScreenController]];
//            }
//            else{
//                [[delegate rootDeckController] setRightController:nil];
//                [[delegate rootDeckController] setRightController:[[iMViewControllerHelper viewControllerHelper] getIntroScreenController]];
//                if (animate) {
//                    [[delegate rootDeckController] toggleRightViewAnimated:TRUE];
//                }
//            }
//            [[[iMViewControllerHelper viewControllerHelper] getOptionsController] setCurrentIndex:invalid_selected_index];
//            break;
            
        default:
            break;
    }
}


# pragma mark - Clear Controllers


- (void) clear_All_ControllersInThisNavigationCntrl:(UINavigationController*)navControl {
    
    @try {
        for (id viewControllers in [navControl viewControllers]) {
            if ([viewControllers respondsToSelector:@selector(resetView)]) {
                [viewControllers performSelector:@selector(resetView)];
            }
            if ([viewControllers respondsToSelector:@selector(resetDataSource)]) {
                [viewControllers performSelector:@selector(resetDataSource)];
            }
        }
    }
    @catch (NSException *exception) {
//        RDLog(@"\n\n\n -- Reset Data Source Exception -- %@ ",exception);
    }
}

- (void) clearAllThe_Controllers {
    
    // -- set the deck controller to Nil..
    if ([self.sideMenuOptionsController respondsToSelector:@selector(resetView)]) {
        [self.sideMenuOptionsController resetView];
    }
    if ([self.sideMenuOptionsController respondsToSelector:@selector(resetDataSource)]) {
        [self.sideMenuOptionsController resetDataSource];
    }
    
    [self setSideMenuOptionsController:nil];
    // -- Nav Controller
//    [self clear_All_ControllersInThisNavigationCntrl:[self signInController]];
//    [self setSignInController:nil];

    [self clear_All_ControllersInThisNavigationCntrl:[self signInController]];
    [self setSignInController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self homeNavController]];
    [self setHomeNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self notificationsNavController]];
    [self setNotificationsNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self whatsupNavController]];
    [self setWhatsupNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self floodmapNavController]];
    [self setFloodmapNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self abcwatersNavController]];
    [self setAbcwatersNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self eventsNavController]];
    [self setEventsNavController:nil];

    [self clear_All_ControllersInThisNavigationCntrl:[self cctvNavController]];
    [self setCctvNavController:nil];

    [self clear_All_ControllersInThisNavigationCntrl:[self wlsController]];
    [self setWlsController:nil];

    [self clear_All_ControllersInThisNavigationCntrl:[self bookingNavController]];
    [self setBookingNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self feedbackNavController]];
    [self setFeedbackNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self tipsNavController]];
    [self setTipsNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self settingsNavController]];
    [self setSettingsNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self profileNavController]];
    [self setProfileNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self favouritesNavController]];
    [self setFavouritesNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self aboutPUBController]];
    [self setAboutPUBController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self weatherForecastNavController]];
    [self setWeatherForecastNavController:nil];

}




@end
