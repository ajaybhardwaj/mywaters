//
//  SideMenuOptionsViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 21/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewControllerHelper.h"
#import "Constants.h"

typedef enum {
    
    OPTION_HOME = 0,
    OPTION_NOTIFICATIONS,
    OPTION_WHATSUP,
    OPTION_FLOODMAP,
    OPTION_ABCWATERS,
    OPTION_EVENTS,
    OPTION_BOOKING,
    OPTION_FEEDBACK,
    OPTION_SETTINGS,
    OPTION_PROFILE,
    OPTION_FAVOURITES,
    
} SideMenuOptions;


@interface SideMenuOptionsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    UITableView *optionsTableView;
    AppDelegate *appDelegate;
}
@property (nonatomic, retain) NSArray *optionsArray;
@property (nonatomic, assign) NSInteger currentIndex;


- (void) resetView;
- (void) resetDataSource;
-(void)setCurrentIndex:(NSInteger)currentIndex_;
-(void)signOutClicked:(id)sender;

@end
