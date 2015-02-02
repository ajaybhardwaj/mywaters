//
//  NotificationsSettingsViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "NotificationsSettingsViewController.h"

@implementation NotificationsSettingsViewController

//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    if (indexPath.row==3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        //***** Later Check the preference values and show on/off status accordingly

        UISwitch *switchControls = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        [switchControls addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
        switchControls.tag = indexPath.row;
        cell.accessoryView = switchControls;
    }
    
    
    UIImageView *cellSeperator;
    if (indexPath.row==0) {
        cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-0.5, cell.bounds.size.width, 0.5)];
    }
    else if (indexPath.row==1) {
        cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80-0.5, cell.bounds.size.width, 0.5)];
    }
    else if (indexPath.row==2) {
        cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80-0.5, cell.bounds.size.width, 0.5)];
    }
    else if (indexPath.row==3) {
        cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-0.5, cell.bounds.size.width, 0.5)];
    }
    [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:cellSeperator];
    
    return cell;
}


# pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row==3) {
        WaterLevelAlertsSettingViewController *viewObj = [[WaterLevelAlertsSettingViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==1 || indexPath.row==2) {
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
    
    
    tableTitleDataSource = [[NSArray alloc] initWithObjects:@"General Notifications",@"Flash Flood Warnings",@"System Notifications",@"Water Level Sensors iAlerts", nil];
    tableSubTitleDataSource = [[NSArray alloc] initWithObjects:@"",@"A push notification to notify user of current flood area",@"An in-app notification to notify user of app updates or maintenance",@"", nil];

    notificationSettingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    notificationSettingsTable.delegate = self;
    notificationSettingsTable.dataSource = self;
    [self.view addSubview:notificationSettingsTable];
    notificationSettingsTable.backgroundColor = RGB(247, 247, 247);
    notificationSettingsTable.backgroundView = nil;
    notificationSettingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
