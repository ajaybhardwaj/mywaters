//
//  WaterLevelAlertsSettingViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WaterLevelAlertsSettingViewController.h"

@implementation WaterLevelAlertsSettingViewController


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableTitleDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alerts"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"alerts"];
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
    
    
    UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, iAlertsTable.bounds.size.width, 0.5)];
    [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:cellSeperator];
    
    return cell;
}


# pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Water Level Sensors iAlerts";
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:nil withIconName:@"icn_3dots"]];

    
    tableTitleDataSource = [[NSArray alloc] initWithObjects:@"Sensor 1",@"Sensor 2", nil];
    
    iAlertsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    iAlertsTable.delegate = self;
    iAlertsTable.dataSource = self;
    [self.view addSubview:iAlertsTable];
    iAlertsTable.backgroundColor = RGB(247, 247, 247);
    iAlertsTable.backgroundView = nil;
    iAlertsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
