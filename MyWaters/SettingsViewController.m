//
//  SettingsViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewControllerHelper.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableTitleDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settings"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settings"];
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
    
    if (indexPath.row!=0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        hintsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        [hintsSwitch addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = hintsSwitch;
    }
    
    UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, settingsTableView.bounds.size.width, 0.5)];
    [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:cellSeperator];
    
    return cell;
}


# pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row==1) {
        DashboardSettingsViewController *viewObj = [[DashboardSettingsViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (indexPath.row==2) {
        NotificationsSettingsViewController *viewObj = [[NotificationsSettingsViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    
    
    tableTitleDataSource = [[NSArray alloc] initWithObjects:@"Hints",@"Dashboard",@"Notifications",@"About PUB",@"Terms and Conditions", nil];
    tableSubTitleDataSource = [[NSArray alloc] initWithObjects:@"App will remember where you last left off",@"",@"",@"",@"", nil];
    
    settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    settingsTableView.delegate = self;
    settingsTableView.dataSource = self;
    [self.view addSubview:settingsTableView];
    settingsTableView.backgroundColor = RGB(247, 247, 247);
    settingsTableView.backgroundView = nil;
    settingsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
