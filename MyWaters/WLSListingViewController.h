//
//  WLSListingViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 13/7/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WaterLevelSensorsDetailViewController.h"

@interface WLSListingViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    AppDelegate *appDelegate;
    
    UITableView *wlsListingtable;
    NSArray *wlsDataSource;
}

@end
