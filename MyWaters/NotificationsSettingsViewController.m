//
//  NotificationsSettingsViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "NotificationsSettingsViewController.h"

@implementation NotificationsSettingsViewController
@synthesize generalNotificationSwitch,floodAlertsSwitch,systemNotificationSwitch;


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//*************** Method To Register For System Notifications

- (void) registerForSystemNotifications:(id) sender {
    
//    isGeneralNotification = NO;
//    isSystemNotifications = YES;
//    isFloodAlerts = NO;

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (isSystemNotifications) {
        
        isSystemNotifications = NO;
        [systemNotificationSwitch setOn:NO animated:YES];
        [prefs setValue:@"NO" forKey:@"systemNotifications"];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    else {
        
        isSystemNotifications = YES;
        [systemNotificationSwitch setOn:YES animated:YES];
        [prefs setValue:@"YES" forKey:@"systemNotifications"];
        
        if (appDelegate.SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY.count!=0) {
            
            for (int i=0; i<appDelegate.SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY.count; i++) {
                
                UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                if (localNotif == nil)
                    return;
                localNotif.fireDate = [CommonFunctions dateValueFromString:[[appDelegate.SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"ValidFrom"]];
                localNotif.timeZone = [NSTimeZone defaultTimeZone];
                
                localNotif.alertBody = [NSString stringWithFormat:@"%@ From %@ - Till %@",[[appDelegate.SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Description"],[CommonFunctions dateTimeFromString:[[appDelegate.SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"ValidFrom"]],[CommonFunctions dateTimeFromString:[[appDelegate.SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"ValidTo"]]];
                localNotif.alertTitle = [[appDelegate.SYSTEM_NOTIFICATIONS_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Title"];
                
                localNotif.soundName = UILocalNotificationDefaultSoundName;
                localNotif.applicationIconBadgeNumber = 1;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            }
        }
    }
    [prefs synchronize];
}


//*************** Method To Register User For Flood Alerts

- (void) registerForFloodALerts:(id) sender {
    
    isGeneralNotification = NO;
    isSystemNotifications = NO;
    isFloodAlerts = YES;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([CommonFunctions hasConnectivity]) {
        
        NSArray *parameters,*values;
        if (isFloodAlertOff) {
            isFloodAlertsTurningOff = YES;
            isFloodAlertsTurningOn = NO;
            parameters = [[NSArray alloc] initWithObjects:@"Token",@"SubscriptionType",@"SubscriptionMode", nil];
            values = [[NSArray alloc] initWithObjects:[prefs stringForKey:@"device_token"],@"1", @"2", nil];
        }
        else {
            locationManager = [[CLLocationManager alloc] init];
            [locationManager requestAlwaysAuthorization];
            
            isFloodAlertsTurningOff = NO;
            isFloodAlertsTurningOn = YES;
            parameters = [[NSArray alloc] initWithObjects:@"Token",@"SubscriptionType",@"SubscriptionMode", nil];
            values = [[NSArray alloc] initWithObjects:[prefs stringForKey:@"device_token"],@"1", @"1", nil];
        }
        
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,REGISTER_FOR_SUBSCRIPTION]];
    }
    else {
        if (isFloodAlertOff) {
            [floodAlertsSwitch setOn:YES animated:YES];
        }
        else {
            [floodAlertsSwitch setOn:NO animated:YES];
        }
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
    }
}



//*************** Method To Register User For Flood Alerts

- (void) registerForGeneralNotifications:(id) sender {
    
    isGeneralNotification = YES;
    isSystemNotifications = NO;
    isFloodAlerts = NO;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([CommonFunctions hasConnectivity]) {
        
        NSArray *parameters,*values;
        if (isGeneralNotificationOff) {
            isGeneralNotificationsTurningOff = YES;
            isGeneralNotificationsTurningOn = NO;
            parameters = [[NSArray alloc] initWithObjects:@"Token",@"SubscriptionType",@"SubscriptionMode", nil];
            values = [[NSArray alloc] initWithObjects:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"device_token"],@"4", @"2", nil];
        }
        else {
            isGeneralNotificationsTurningOff = NO;
            isGeneralNotificationsTurningOn = YES;
            parameters = [[NSArray alloc] initWithObjects:@"Token",@"SubscriptionType",@"SubscriptionMode", nil];
            values = [[NSArray alloc] initWithObjects:[prefs stringForKey:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"device_token"]],@"4", @"1", nil];
        }
        
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,REGISTER_FOR_SUBSCRIPTION]];
    }
    else {
        
        if (isGeneralNotificationOff) {
            [generalNotificationSwitch setOn:YES animated:YES];
        }
        else {
            [generalNotificationSwitch setOn:NO animated:YES];
        }
        
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
    }
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    DebugLog(@"%@",responseString);
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        //        [CommonFunctions showAlertView:self title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
        if (isFloodAlerts) {
            if (isFloodAlertsTurningOff) {
                isFloodAlertOff = NO;
                [prefs setValue:@"NO" forKey:@"floodAlert"];
            }
            else if (isFloodAlertsTurningOn) {
                isFloodAlertOff = YES;
                [prefs setValue:@"YES" forKey:@"floodAlert"];
            }
        }
        else if (isGeneralNotification) {
            if (isGeneralNotificationsTurningOff) {
                isGeneralNotification = NO;
                [prefs setValue:@"NO" forKey:@"generalNotifications"];
            }
            else if (isGeneralNotificationsTurningOn) {
                isGeneralNotificationOff = YES;
                [prefs setValue:@"YES" forKey:@"generalNotifications"];
            }
        }
        
        [prefs synchronize];
        [notificationSettingsTable reloadData];
    }
    else {
        
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
    
    if (isFloodAlerts) {
        [floodAlertsSwitch setOn:NO];
    }
    
    [appDelegate.hud hide:YES];
}



# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
}



# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableTitleDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notification"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"notification"];
    }
    
    cell.backgroundColor = RGB(247, 247, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [tableTitleDataSource objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [tableSubTitleDataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    
    cell.textLabel.textColor = RGB(35, 35, 35);
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    
    
    UIImageView *cellSeperator;
    if (indexPath.row==0) {
        
        generalNotificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        generalNotificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"generalNotifications"] isEqualToString:@"YES"]) {
            [generalNotificationSwitch setOn:YES];
            isGeneralNotificationOff = YES;
        }
        else {
            [generalNotificationSwitch setOn:NO];
            isGeneralNotificationOff = NO;
        }
        [generalNotificationSwitch addTarget:self action:@selector(registerForGeneralNotifications:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = generalNotificationSwitch;
        
        cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-0.5, notificationSettingsTable.bounds.size.width, 0.5)];
    }
    else if (indexPath.row==1) {
        
        floodAlertsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"floodAlert"] isEqualToString:@"YES"]) {
            [floodAlertsSwitch setOn:YES];
            isFloodAlertOff = YES;
        }
        else {
            [floodAlertsSwitch setOn:NO];
            isFloodAlertOff = NO;
        }
        [floodAlertsSwitch addTarget:self action:@selector(registerForFloodALerts:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = floodAlertsSwitch;
        
        cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80-0.5, notificationSettingsTable.bounds.size.width, 0.5)];
    }
    else if (indexPath.row==2) {
        
        systemNotificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"systemNotifications"] isEqualToString:@"YES"]) {
            [systemNotificationSwitch setOn:YES];
            isSystemNotifications = YES;
        }
        else {
            [systemNotificationSwitch setOn:NO];
            isSystemNotifications = NO;
        }
        [systemNotificationSwitch addTarget:self action:@selector(registerForSystemNotifications:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = systemNotificationSwitch;
        
        cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80-0.5, notificationSettingsTable.bounds.size.width, 0.5)];
    }
    //    else if (indexPath.row==3) {
    //        cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80-0.5, notificationSettingsTable.bounds.size.width, 0.5)];
    //    }
    
    [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:cellSeperator];
    
    return cell;
}


# pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row==3) {
        //        WaterLevelAlertsSettingViewController *viewObj = [[WaterLevelAlertsSettingViewController alloc] init];
        //        [self.navigationController pushViewController:viewObj animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==1 || indexPath.row==2 || indexPath.row==3) {
        return 80.0f;
    }
    return 44.0f;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Notifications";
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    
    //    tableTitleDataSource = [[NSArray alloc] initWithObjects:@"General Notifications",@"Flash Flood Warnings",@"System Notifications",@"Read Out Message", nil];
    //    tableSubTitleDataSource = [[NSArray alloc] initWithObjects:@"",@"A push notification to notify user of current flood area",@"An in-app notification to notify user of app updates or maintenance",@"Notifications will be read out when received.", nil];
    
    tableTitleDataSource = [[NSArray alloc] initWithObjects:@"General Notifications",@"Flash Flood Warnings",@"System Notifications", nil];
    tableSubTitleDataSource = [[NSArray alloc] initWithObjects:@"",@"A push notification to notify user of current flood area",@"An in-app notification to notify user of app updates or maintenance", nil];
    
    
    notificationSettingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    notificationSettingsTable.delegate = self;
    notificationSettingsTable.dataSource = self;
    [self.view addSubview:notificationSettingsTable];
    notificationSettingsTable.backgroundColor = RGB(247, 247, 247);
    notificationSettingsTable.backgroundView = nil;
    notificationSettingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [appDelegate setShouldRotate:NO];
}


- (void) viewDidAppear:(BOOL)animated {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    
    [self.view addGestureRecognizer:swipeGesture];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */




@end
