//
//  NotificationsViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface NotificationsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *notificationsTable,*filterTableView;
    NSArray *tableDataSource;
    
    NSArray *filtersArray;
    
    BOOL isShowingFilter;
    NSInteger selectedFilterIndex;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    UIButton *detailButton;
}

@end
