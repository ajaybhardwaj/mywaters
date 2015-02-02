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


- (UINavigationController*) getHomeController {
    
    if (!_homeNavController) {
        
        HomeViewController *home = [[HomeViewController alloc] init];
        [home setTitle:@"HOME"];
        _homeNavController = [[UINavigationController alloc] initWithRootViewController:home];
        
        [self setNavigationBarStyle_Transclucent:_homeNavController.navigationBar];
        [[[home navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
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
        [notification setTitle:@"NOTIFICATIONS"];
        _notificationsNavController = [[UINavigationController alloc] initWithRootViewController:notification];
        
        [self setNavigationBarStyle_Transclucent:_notificationsNavController.navigationBar];
        [[[notification navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(139,163,13) frame:CGRectMake(0, 0, 1, 1)];
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
        [whatsup setTitle:@"WHAT'S UP"];
        _whatsupNavController = [[UINavigationController alloc] initWithRootViewController:whatsup];
        
        [self setNavigationBarStyle_Transclucent:_whatsupNavController.navigationBar];
        [[[whatsup navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
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
        [floodmap setTitle:@"QUICK MAP"];
        _floodmapNavController = [[UINavigationController alloc] initWithRootViewController:floodmap];
        
        [self setNavigationBarStyle_Transclucent:_floodmapNavController.navigationBar];
        [[[floodmap navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(229,0,87) frame:CGRectMake(0, 0, 1, 1)];
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
        [abcwaters setTitle:@"ABC WATERS"];
        _abcwatersNavController = [[UINavigationController alloc] initWithRootViewController:abcwaters];
        
        [self setNavigationBarStyle_Transclucent:_abcwatersNavController.navigationBar];
        [[[abcwaters navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(36,158,242) frame:CGRectMake(0, 0, 1, 1)];
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
        [events setTitle:@"EVENTS"];
        _eventsNavController = [[UINavigationController alloc] initWithRootViewController:events];
        
        [self setNavigationBarStyle_Transclucent:_eventsNavController.navigationBar];
        [[[events navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
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


- (UINavigationController*) getBookingController {
    
    if (!_bookingNavController) {
        
        BookingViewController *booking = [[BookingViewController alloc] init];
        [booking setTitle:@"BOOKING"];
        _bookingNavController = [[UINavigationController alloc] initWithRootViewController:booking];
        
        [self setNavigationBarStyle_Transclucent:_bookingNavController.navigationBar];
        [[[booking navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
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
        [feedback setTitle:@"FEEDBACK"];
        _feedbackNavController = [[UINavigationController alloc] initWithRootViewController:feedback];
        
        [self setNavigationBarStyle_Transclucent:_feedbackNavController.navigationBar];
        [[[feedback navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(139,163,13) frame:CGRectMake(0, 0, 1, 1)];
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


- (UINavigationController*) getSettingsController {
    
    if (!_settingsNavController) {
        
        SettingsViewController *settings = [[SettingsViewController alloc] init];
        [settings setTitle:@"SETTINGS"];
        _settingsNavController = [[UINavigationController alloc] initWithRootViewController:settings];
        
        [self setNavigationBarStyle_Transclucent:_settingsNavController.navigationBar];
        [[[settings navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(139,163,11) frame:CGRectMake(0, 0, 1, 1)];
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
        [profile setTitle:@"PROFILE"];
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
        [favourites setTitle:@"FAVOURITES"];
        _favouritesNavController = [[UINavigationController alloc] initWithRootViewController:favourites];
        
        [self setNavigationBarStyle_Transclucent:_favouritesNavController.navigationBar];
        [[[favourites navigationController] navigationBar] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(85,49,118) frame:CGRectMake(0, 0, 1, 1)];
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



# pragma mark - Deck View Methods

- (void) enableDeckView:(id)sender {
    
    if ([[appDelegate rootDeckController] leftController] == nil)
        [[appDelegate rootDeckController] setLeftController:[[ViewControllerHelper viewControllerHelper] getOptionsController]];
        
    [[appDelegate rootDeckController] setLeftSize:appDelegate.left_deck_width];
    [[appDelegate rootDeckController] toggleLeftViewAnimated:YES];
    
    [[appDelegate rootDeckController] setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];
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
    
    [self clear_All_ControllersInThisNavigationCntrl:[self bookingNavController]];
    [self setBookingNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self feedbackNavController]];
    [self setFeedbackNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self settingsNavController]];
    [self setSettingsNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self profileNavController]];
    [self setProfileNavController:nil];
    
    [self clear_All_ControllersInThisNavigationCntrl:[self favouritesNavController]];
    [self setFavouritesNavController:nil];
    
}




@end
