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

@interface NotificationsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *notificationsTable,*filterTableView;
    NSMutableArray *tableDataSource;
    
    NSArray *filtersArray;
    
    BOOL isShowingFilter,canReadNotifications,isPlayingNotification;
    UIButton *btnSpeaker;
    NSInteger selectedFilterIndex,previousIndex,currentIndex;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    UIButton *detailButton;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) AVAudioPlayer *player;

@end
