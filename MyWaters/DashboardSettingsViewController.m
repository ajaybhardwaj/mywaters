//
//  DashboardSettingsViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "DashboardSettingsViewController.h"

@implementation DashboardSettingsViewController


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


//*************** Method To Pop View Controller To Dashboard View

- (void) moveToDashboardView {
    
    [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:YES];
}


//*************** Method To Create Table Footer View

- (void) createTableFooter {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 130)];
    
    UIButton *goToDashboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goToDashboardButton.frame = CGRectMake(0, 40, self.view.bounds.size.width, 45);
    [goToDashboardButton setBackgroundColor:RGB(71, 178, 182)];
    [goToDashboardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goToDashboardButton setTitle:@"GO TO DASHBOARD" forState:UIControlStateNormal];
//    goToDashboardButton.titleLabel.font = [UIFont fontWithName:BEBAS_NEUE_FONT size:19];
    goToDashboardButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:19];
    [goToDashboardButton addTarget:self action:@selector(moveToDashboardView) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:goToDashboardButton];
    
    [dashboardSettingsTable setTableFooterView:footerView];
}


//*************** Method To Reload Dashboard Setting Table

- (void) reloadDashboardSettingTable {
    
    [dashboardSettingsTable reloadData];
}


//*************** Method To Change Dashboard Preferences

- (void) changeDashboardPreferences:(id) sender {
    
    UISwitch *switchControl = (id) sender;
    
    if ([switchControl isOn]) {
        [switchControl setOn:YES animated:YES];
        appDelegate.NEW_DASHBOARD_STATUS = 1;
    }
    else {
        [switchControl setOn:NO animated:YES];
        appDelegate.NEW_DASHBOARD_STATUS = 0;
    }
    appDelegate.DASHBOARD_PREFERENCE_ID = [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:switchControl.tag] objectForKey:@"id"] intValue];
    [appDelegate updateDashboardPreference];
    [appDelegate retrieveDashboardPreferences];
    
    [self performSelector:@selector(reloadDashboardSettingTable) withObject:nil afterDelay:0.5];
}



# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return appDelegate.DASHBOARD_PREFERENCES_ARRAY.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dashboard"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"dashboard"];
    }
    
    cell.backgroundColor = RGB(247, 247, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:indexPath.row] objectForKey:@"component"];
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    cell.textLabel.textColor = RGB(35, 35, 35);
    cell.textLabel.numberOfLines = 0;
    
    
    //***** Later Check the preference values and show on/off status accordingly
    
    UISwitch *switchControls = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    [switchControls addTarget:self action:@selector(changeDashboardPreferences:) forControlEvents:UIControlEventValueChanged];
    switchControls.tag = indexPath.row;
    
    if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString:@"1"]) {
        [switchControls setOn:YES];
    }
    else {
        [switchControls setOn:NO];
    }
    cell.accessoryView = switchControls;
    
    UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, dashboardSettingsTable.bounds.size.width, 0.5)];
    [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:cellSeperator];
    
    return cell;
}


# pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dashboardSettingsTable.bounds.size.width, 40)];
    headingLabel.backgroundColor = [UIColor clearColor];
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.textColor = RGB(35, 35, 35);
    headingLabel.text = @"Turn off the following to hide in dashboard view:";
    headingLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
    headingLabel.numberOfLines = 0;
    
    return headingLabel;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Dashboard";
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
        
    dashboardSettingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    dashboardSettingsTable.delegate = self;
    dashboardSettingsTable.dataSource = self;
    [self.view addSubview:dashboardSettingsTable];
    dashboardSettingsTable.backgroundColor = RGB(247, 247, 247);
    dashboardSettingsTable.backgroundView = nil;
    dashboardSettingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self createTableFooter];
    
    UIButton *goToDashboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goToDashboardButton.frame = CGRectMake(0, self.view.bounds.size.height-109, self.view.bounds.size.width, 45);
    [goToDashboardButton setBackgroundColor:RGB(71, 178, 182)];
    [goToDashboardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goToDashboardButton setTitle:@"GO TO DASHBOARD" forState:UIControlStateNormal];
//    goToDashboardButton.titleLabel.font = [UIFont fontWithName:BEBAS_NEUE_FONT size:19];
    goToDashboardButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:19];
    [goToDashboardButton addTarget:self action:@selector(moveToDashboardView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goToDashboardButton];
}


- (void) viewDidAppear:(BOOL)animated {
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
//    swipeGesture.numberOfTouchesRequired = 1;
//    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
//    
//    [self.view addGestureRecognizer:swipeGesture];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [appDelegate setShouldRotate:NO];
    
    [CommonFunctions googleAnalyticsTracking:@"Page: Dashboard Settings"];
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
