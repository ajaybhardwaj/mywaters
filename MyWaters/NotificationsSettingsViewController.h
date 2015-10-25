//
//  NotificationsSettingsViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WaterLevelAlertsSettingViewController.h"

@interface NotificationsSettingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    AppDelegate *appDelegate;
    
    UITableView *notificationSettingsTable;
    NSArray *tableTitleDataSource,*tableSubTitleDataSource;
    
    
    
    BOOL isGeneralNotification,isFloodAlerts,isSystemNotifications;
    BOOL isFloodAlertsTurningOn,isFloodAlertsTurningOff,isGeneralNotificationsTurningOff,isGeneralNotificationsTurningOn;
    BOOL isFloodAlertOff,isGeneralNotificationOff;
}
@property (nonatomic, strong) UISwitch *generalNotificationSwitch,*floodAlertsSwitch,*systemNotificationSwitch;

@end
