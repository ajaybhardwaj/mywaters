//
//  AboutMyWatersViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/3/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "AboutMyWatersViewController.h"

@interface AboutMyWatersViewController ()

@end

@implementation AboutMyWatersViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To Share App

- (void) shareSiteOnSocialNetwork {
    
    [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Share via" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"Facebook",@"Twitter",@"Email",@"SMS",@"Cancel",nil];
}



//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Create Table Header View

- (void) createTableHeader {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aboutTableView.bounds.size.width, 380)];
    
    NSString *aboutPUB;
    for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
        if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"AboutPUB"]) {
            aboutPUB = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
            break;
        }
    }
    
    //    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[aboutPUB dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, aboutTableView.bounds.size.width-20, 380)];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    descriptionLabel.text = [NSString stringWithFormat:@"%@",aboutPUB];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.numberOfLines = 0;
    
    CGRect newDescLabelLabelFrame = descriptionLabel.frame;
    newDescLabelLabelFrame.size.height = [CommonFunctions heightForText:descriptionLabel.text font:descriptionLabel.font withinWidth:aboutTableView.bounds.size.width-20];
    descriptionLabel.frame = newDescLabelLabelFrame;
    [headerView addSubview:descriptionLabel];
    
    headerView.frame = newDescLabelLabelFrame;
    
    [aboutTableView setTableHeaderView:headerView];
}


//*************** Method To Create Table Header View

- (void) createTableFooter {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aboutTableView.bounds.size.width, 40)];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, aboutTableView.bounds.size.width, 40)];
    versionLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
    versionLabel.text = [NSString stringWithFormat:@"App Version - %@",[CommonFunctions getAppVersionNumber]];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:versionLabel];
    
    [aboutTableView setTableFooterView:footerView];
}



//*************** Method To Call Get Config API

- (void) getConfigData {
    
    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
    //    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    //    appDelegate.hud.labelText = @"Loading...";
    
    [CommonFunctions grabGetRequest:APP_CONFIG_DATA delegate:self isNSData:NO accessToken:@"NA"];
    
    
    
}



//*************** Method For Creating MFMail Composer

- (void) showMailComposer:(NSString*) appStoreUrl {

    NSString *sharingString = [NSString stringWithFormat:@"Click the link to download MyWaters from App Store to stay updated! - %@",appStoreUrl];

        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
            if (mailClass != nil) {
                //Test to ensure that device is configured for sending mails
                if ([mailClass canSendMail]) {
    
                    if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0) {
                    }
                    else {
                        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                    }
    
                    MFMailComposeViewController *mailpicker = [[MFMailComposeViewController alloc] init];
                    [[mailpicker navigationBar] setTintColor:RGB(134, 144, 156)];
                    mailpicker.mailComposeDelegate = self;
    
                    [mailpicker setSubject:[NSString stringWithFormat:@"MyWaters - iOS App"]];
                    [mailpicker setMessageBody:sharingString isHTML:NO];
                    [self presentViewController:mailpicker animated:YES completion:nil];
                }
    
                else {
    
                    [CommonFunctions showAlertView:nil title:nil msg:@"This device is not configured to send E-mails." cancel:@"OK" otherButton:nil];
                }
            }
}


//*************** Method For Creating MSMessage Composer

- (void) showMessageComposer:(NSString*) appStoreUrl {
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if ([MFMessageComposeViewController canSendText]) {
        
        controller.body = [NSString stringWithFormat:@"Download MyWater iOS app - %@",appStoreUrl];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else {
        
        [CommonFunctions showAlertView:nil title:nil msg:@"This device is not configured to send SMS." cancel:@"OK" otherButton:nil];
    }
}


# pragma mark - MFMessageComposeViewControllerDelegate Methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    NSString *msg = nil;
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            [controller dismissViewControllerAnimated:YES completion:^(void){}];
            break;
        case MessageComposeResultFailed:
            
            msg = @"Fail to send.";
            break;
        case MessageComposeResultSent:
            
            msg = @"SMS sent";
            break;
        default:
            
            msg = @"There seems to be problems sending. Please try again.";
            break;
    }
    
    if (msg) {

        [CommonFunctions showAlertView:nil title:nil msg:msg cancel:@"OK" otherButton:nil];
    }
    
    [controller dismissViewControllerAnimated:YES completion:^(void){}];
}



# pragma mark - MFMailComposeViewControllerDelegate Methods

-(void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {

    [self dismissViewControllerAnimated:YES completion:nil];

    switch (result) {

        case MFMailComposeResultCancelled:

            break;

        case MFMailComposeResultSaved:

            break;

        case MFMailComposeResultSent: {
            
            NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionType",@"version", nil];
            NSArray *values = [[NSArray alloc] initWithObjects:@"6",@"1",[CommonFunctions getAppVersionNumber], nil];
            
            [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
            }

            break;

        case MFMailComposeResultFailed:

            break;

        default:

            break;
    }
}



# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        
        [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        [parameters addObject:@"IsFriendOfWater"];
        [values addObject:@"True"];
        
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,PROFILE_API_URL]];
    }
}


# pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag==1) {
        if (buttonIndex==0) {
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            [CommonFunctions sharePostOnFacebook:@"http://52.74.251.44/PUB.MyWater.Api.New/uploads/info/Icon_180.png" appUrl:appUrl title:@"MyWaters" desc:@"Download app from app store." view:self abcIDValue:@"-1"];
        }
        else if (buttonIndex==1) {
            
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            [CommonFunctions sharePostOnTwitter:appUrl title:@"Download MyWaters app from app store." view:self abcIDValue:@"-1"];
        }
        else if (buttonIndex==2) {
            
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            [self showMailComposer:appUrl];
        }
        else if (buttonIndex==3) {
            
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            [self showMessageComposer:appUrl];
        }
    }
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        if (isGettingAppConfigData) {
            isGettingAppConfigData = NO;
            [appDelegate.APP_CONFIG_DATA_ARRAY removeAllObjects];
            appDelegate.APP_CONFIG_DATA_ARRAY = [[responseString JSONValue] objectForKey:APP_CONFIG_DATA_RESPONSE_NAME];
        }
        else {
            
            [[SharedObject sharedClass] savePUBUserData:[responseString JSONValue]];
            
            if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userIsFriendOfWater"] intValue] == 1) {
                tableTitleDataSource = [[NSMutableArray alloc] initWithObjects:@"Website",@"Facebook",@"Twitter",@"Instagram",@"YouTube",@"Share MyWaters App", nil];
            }
            else {
                tableTitleDataSource = [[NSMutableArray alloc] initWithObjects:@"Website",@"Facebook",@"Twitter",@"Instagram",@"YouTube",@"Share MyWaters App",@"Join Friends of Water", nil];
            }
            
            [aboutTableView reloadData];
            [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
        }
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
}



# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableTitleDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = RGB(247, 247, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [tableTitleDataSource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    cell.textLabel.textColor = RGB(35, 35, 35);
    cell.textLabel.numberOfLines = 0;
    
    if (indexPath.row!=6)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row==0) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_web_settings.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==1) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook_settings.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==2) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_twitter_settings.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==3) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_instagram_settings.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==4) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_youtube-1.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==5) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_share_new.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    
    
    UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, aboutTableView.bounds.size.width, 0.5)];
    [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:cellSeperator];
    
    return cell;
}


# pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([CommonFunctions hasConnectivity]) {
        if (indexPath.row==0) {
            
            WebViewUrlViewController *viewObj = [[WebViewUrlViewController alloc] init];
            
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"WebsiteURL"]) {
                    viewObj.headerTitle = @"About PUB";
                    viewObj.webUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            [self.navigationController pushViewController:viewObj animated:YES];
        }
        else if (indexPath.row==1) {
            
            WebViewUrlViewController *viewObj = [[WebViewUrlViewController alloc] init];
            
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"FacebookURL"]) {
                    viewObj.headerTitle = @"Facebook";
                    viewObj.webUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            [self.navigationController pushViewController:viewObj animated:YES];
            
        }
        else if (indexPath.row==2) {
            
            WebViewUrlViewController *viewObj = [[WebViewUrlViewController alloc] init];
            
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"TwitterURL"]) {
                    viewObj.headerTitle = @"Twitter";
                    viewObj.webUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            [self.navigationController pushViewController:viewObj animated:YES];
            
        }
        else if (indexPath.row==3) {
            
            WebViewUrlViewController *viewObj = [[WebViewUrlViewController alloc] init];
            
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"InstagramURL"]) {
                    viewObj.headerTitle = @"Instagram";
                    viewObj.webUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            [self.navigationController pushViewController:viewObj animated:YES];
            
        }
        else if (indexPath.row==4) {
            
            WebViewUrlViewController *viewObj = [[WebViewUrlViewController alloc] init];
            
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"YoutubeURL"]) {
                    viewObj.headerTitle = @"YouTube";
                    viewObj.webUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            
            [self.navigationController pushViewController:viewObj animated:YES];
            
        }
        else if (indexPath.row==5) {
            [self shareSiteOnSocialNetwork];
        }
        
        else if (indexPath.row==6) {
            
            [CommonFunctions showAlertView:self title:nil msg:@"Tap OK to be a Friend of Water." cancel:nil otherButton:@"OK",@"Cancel",nil];
        }
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Connection error. Check your internet connection." msg:nil cancel:@"OK" otherButton:nil];
    }
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.title = @"About PUB";
    //    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    
    if (!appDelegate.IS_SKIPPING_USER_LOGIN) {
        
        if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userIsFriendOfWater"] intValue] == 1) {
            tableTitleDataSource = [[NSMutableArray alloc] initWithObjects:@"Website",@"Facebook",@"Twitter",@"Instagram",@"YouTube",@"Share MyWaters App", nil];
        }
        else {
            tableTitleDataSource = [[NSMutableArray alloc] initWithObjects:@"Website",@"Facebook",@"Twitter",@"Instagram",@"YouTube",@"Share MyWaters App",@"Join Friends of Water", nil];
        }
    }
    else {
        tableTitleDataSource = [[NSMutableArray alloc] initWithObjects:@"Website",@"Facebook",@"Twitter",@"Instagram",@"YouTube",@"Share MyWaters App", nil];
        
    }
    aboutTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    aboutTableView.delegate = self;
    aboutTableView.dataSource = self;
    [self.view addSubview:aboutTableView];
    aboutTableView.backgroundColor = RGB(247, 247, 247);
    aboutTableView.backgroundView = nil;
    aboutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self createTableHeader];
    [self createTableFooter];
    
    if (appDelegate.APP_CONFIG_DATA_ARRAY.count==0) {
        isGettingAppConfigData = YES;
        [self getConfigData];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    [CommonFunctions googleAnalyticsTracking:@"Page: About MyWaters"];
    
    [appDelegate setShouldRotate:NO];
}

- (void) viewDidAppear:(BOOL)animated {
    
    //    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    //    swipeGesture.numberOfTouchesRequired = 1;
    //    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    //
    //    [self.view addGestureRecognizer:swipeGesture];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        [req cancel];
        [req setDelegate:nil];
    }
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
