//
//  SettingsViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DashboardSettingsViewController.h"
#import "NotificationsSettingsViewController.h"
#import "AboutMyWatersViewController.h"
#import "WebViewUrlViewController.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    AppDelegate *appDelegate;
    
    UITableView *settingsTableView;
    NSArray *tableTitleDataSource,*tableSubTitleDataSource;
    
    UISwitch *hintsSwitch;
    UIButton *signoutButton;
}

@end
