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
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Pop View Controller To Login View

- (void) moveToLoginView {
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:NULL forKey:@"userPassword"];
//    [prefs synchronize];
    [[ViewControllerHelper viewControllerHelper] signOut];
}



//*************** Method To Register User For Flood Alerts

- (void) registerForHints:(id) sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (isHintsOn) {
        isHintsOn = NO;
        [hintsSwitch setOn:NO animated:YES];
        [prefs setValue:@"NO" forKey:@"quickMapHints"];
    }
    else {
        isHintsOn = YES;
        [hintsSwitch setOn:YES animated:YES];
        [prefs setValue:@"YES" forKey:@"quickMapHints"];
    }
    [prefs synchronize];
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
        NSString *hintStatus = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"quickMapHints"];
        hintsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        [hintsSwitch addTarget:self action:@selector(registerForHints:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = hintsSwitch;
        
        if ([hintStatus isEqualToString:@"YES"]) {
            isHintsOn = YES;
            [hintsSwitch setOn:YES];
        }
        else {
            isHintsOn = NO;
            [hintsSwitch setOn:NO];
        }
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
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (indexPath.row==2) {
        NotificationsSettingsViewController *viewObj = [[NotificationsSettingsViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (indexPath.row==3) {
        
        WebViewUrlViewController *viewObj = [[WebViewUrlViewController alloc] init];
        for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
            if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"TermsAndConditions"]) {
                viewObj.headerTitle = @"Terms & Conditions";
                viewObj.termsConditionsHTML = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                break;
            }
        }
        viewObj.isShowingTermsAndConditions = YES;
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    
    
    tableTitleDataSource = [[NSArray alloc] initWithObjects:@"Quick Map Hints",@"Dashboard",@"Notifications",@"Terms and Conditions", nil];
//    tableSubTitleDataSource = [[NSArray alloc] initWithObjects:@"App will remember where you last left off",@"",@"",@"",@"", nil];
    tableSubTitleDataSource = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"", nil];
    
    settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    settingsTableView.delegate = self;
    settingsTableView.dataSource = self;
    [self.view addSubview:settingsTableView];
    settingsTableView.backgroundColor = RGB(247, 247, 247);
    settingsTableView.backgroundView = nil;
    settingsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    signoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signoutButton.frame = CGRectMake(0, self.view.bounds.size.height-114, self.view.bounds.size.width, 50);
    [signoutButton setBackgroundColor:[UIColor redColor]];
    [signoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signoutButton setTitle:@"SIGN OUT" forState:UIControlStateNormal];
    signoutButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:19];
    [signoutButton addTarget:self action:@selector(moveToLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signoutButton];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [appDelegate setShouldRotate:NO];
}


- (void) viewDidAppear:(BOOL)animated {
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
//    swipeGesture.numberOfTouchesRequired = 1;
//    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
//    
//    [self.view addGestureRecognizer:swipeGesture];
    
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
