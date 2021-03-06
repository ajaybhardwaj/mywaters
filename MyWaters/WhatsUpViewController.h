//
//  WhatsUpViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FeedbackViewController.h"
#import "WebViewUrlViewController.h"
#import "SWTableViewCell.h"

@interface WhatsUpViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,SWTableViewCellDelegate> {
    
    AppDelegate *appDelegate;
    
    
    UISegmentedControl *segmentedControl;
    UIView *segmentedControlBackground;
    
    UITableView *feedTableView,*exploreTableView;
    
    NSMutableArray *feedDataSource,*chatterDataSource;
    BOOL isShowingFeedTable,isShowingChatterTable,isEditingChatterTable,isShowingHelpScreen;
    
    UIImageView *helpScreenImageView;
    UILabel *helpLabel;
}

@property (nonatomic, assign) BOOL isNotWhatsUpController,isDashboardChatter;
@property (nonatomic, strong) UIRefreshControl *refreshControlFeeds;
@property (nonatomic, strong) UIRefreshControl *refreshControlChatter;


@end
