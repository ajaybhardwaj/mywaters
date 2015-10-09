//
//  WhatsUpViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WhatsUpViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    AppDelegate *appDelegate;
    
    
    UISegmentedControl *segmentedControl;
    UIView *segmentedControlBackground;
    
    UITableView *feedTableView,*exploreTableView;
    
    NSMutableArray *feedDataSource,*chatterDataSource;
    BOOL isShowingFeedTable,isShowingChatterTable;
}

@property (nonatomic, assign) BOOL isNotWhatsUpController;

@end
