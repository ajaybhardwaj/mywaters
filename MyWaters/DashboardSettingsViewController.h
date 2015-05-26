//
//  DashboardSettingsViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DashboardSettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *dashboardSettingsTable;
    
}

@end
