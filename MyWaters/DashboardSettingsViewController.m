//
//  DashboardSettingsViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "DashboardSettingsViewController.h"

@implementation DashboardSettingsViewController


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableTitleDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dashboard"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"dashboard"];
    }
    
    cell.backgroundColor = RGB(247, 247, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [tableTitleDataSource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    cell.textLabel.textColor = RGB(35, 35, 35);
    cell.textLabel.numberOfLines = 0;
    
    
    //***** Later Check the preference values and show on/off status accordingly
    
    UISwitch *switchControls = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    [switchControls addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    switchControls.tag = indexPath.row;
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
    
    
    tableTitleDataSource = [[NSArray alloc] initWithObjects:@"CCTV",@"Events",@"Quick Map",@"What's Up",@"Weather",@"Water Level Sensor", nil];
    
    dashboardSettingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    dashboardSettingsTable.delegate = self;
    dashboardSettingsTable.dataSource = self;
    [self.view addSubview:dashboardSettingsTable];
    dashboardSettingsTable.backgroundColor = RGB(247, 247, 247);
    dashboardSettingsTable.backgroundView = nil;
    dashboardSettingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
