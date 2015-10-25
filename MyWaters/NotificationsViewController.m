//
//  NotificationsViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "NotificationsViewController.h"
#import "ViewControllerHelper.h"


@interface NotificationsViewController ()

@end

@implementation NotificationsViewController
@synthesize player;


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method For Pull To Refresh

- (void) pullToRefreshTable {
    
    // Reload table data
    [notificationsTable reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}


//*************** Method To Toggle Notifications Reading

- (void) toggleNotificationSpeech {
    
    if (canReadNotifications) {
        canReadNotifications = NO;
        [btnSpeaker setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_speaker_mute.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else {
        canReadNotifications = YES;
        [btnSpeaker setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_speaker.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
}


//*************** Method To ANimate Filter Table

- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -320;
        
        notificationsTable.alpha = 1.0;
        notificationsTable.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 128;
        
        notificationsTable.alpha = 0.5;
        notificationsTable.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}


//*************** Method To Call ABCWaterSites API

- (void) fetchNotificationListing {
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"pushtoken",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"7",@"12345",@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
    
    [self pullToRefreshTable];
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    
    selectedFilterIndex = -1;
    [filterTableView reloadData];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        NSArray *tempArray = [[responseString JSONValue] objectForKey:PUSH_NOTIFICATIONS_RESPONSE_NAME];
        
        if (tempArray.count==0) {
            
        }
        else {
            
            [appDelegate.PUSH_NOTIFICATION_ARRAY removeAllObjects];
            [appDelegate.PUSH_NOTIFICATION_ARRAY setArray:tempArray];
            [tableDataSource setArray:tempArray];
        }
        
        [appDelegate.hud hide:YES];
        [notificationsTable reloadData];
        [self.refreshControl endRefreshing];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    
    [appDelegate.hud hide:YES];
}

# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    else if (tableView==notificationsTable) {
        
        float titleHeight = 0.0;
        float dateHeight = 0.0;
        int subtractComponent = 0;
        
        
        if ([[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Message"] != (id)[NSNull null]) {
            titleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Message"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:14.0] withinWidth:notificationsTable.bounds.size.width-80];
            subtractComponent = subtractComponent + 30;
        }
        
        if ([[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"notificationDate"] != (id)[NSNull null]) {
            dateHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"notificationDate"]]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:notificationsTable.bounds.size.width-80];
            subtractComponent = subtractComponent + 30;
        }
        
        if ((titleHeight+dateHeight) < 80) {
            return 80.0f;
        }
        
        return titleHeight+dateHeight-subtractComponent;
        
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==filterTableView) {
        
        selectedFilterIndex = indexPath.row;
        
        if (indexPath.row==0) {
            
            [tableDataSource removeAllObjects];
            for (int i=0; i<appDelegate.PUSH_NOTIFICATION_ARRAY.count; i++) {
                if ([[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i] objectForKey:@"Type"] intValue] == 1 || [[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i] objectForKey:@"Type"] intValue] == 2) {
                    [tableDataSource addObject:[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i]];
                }
            }
        }
        else if (indexPath.row==1) {
            
            [tableDataSource removeAllObjects];
            for (int i=0; i<appDelegate.PUSH_NOTIFICATION_ARRAY.count; i++) {
                if ([[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i] objectForKey:@"Type"] intValue] == 1 || [[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i] objectForKey:@"Type"] intValue] == 3) {
                    [tableDataSource addObject:[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i]];
                }
            }
        }
        else if (indexPath.row==2) {
            
            [tableDataSource removeAllObjects];
            for (int i=0; i<appDelegate.PUSH_NOTIFICATION_ARRAY.count; i++) {
                if ([[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i] objectForKey:@"Type"] intValue] == 1 || [[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i] objectForKey:@"Type"] intValue] == 4) {
                    [tableDataSource addObject:[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i]];
                }
            }
        }
        else if (indexPath.row==3) {
            
            [tableDataSource removeAllObjects];
            for (int i=0; i<appDelegate.PUSH_NOTIFICATION_ARRAY.count; i++) {
                if ([[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i] objectForKey:@"Type"] intValue] == 1 || [[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i] objectForKey:@"Type"] intValue] == 5) {
                    [tableDataSource addObject:[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:i]];
                }
            }
        }
        
        [filterTableView reloadData];
        [self animateFilterTable];
        
        [notificationsTable reloadData];
        
    }
    else {
        if (canReadNotifications) {
            
            currentIndex = indexPath.row;
            
            //            DebugLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
            //
            //            //    if (self.synthesizer.speaking == NO) {
            //            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:indexPath.row] objectForKey:@"Message"]];
            //            utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
            //            AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
            //            [synth speakUtterance:utterance];
            
            DebugLog(@"%@",[NSString stringWithFormat:@"%@FloodVoice/%d.mp3",IMAGE_BASE_URL,[[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"] intValue]]);
            
            NSData *fetchedData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@FloodVoice/%d.mp3",IMAGE_BASE_URL,[[[appDelegate.PUSH_NOTIFICATION_ARRAY objectAtIndex:indexPath.row] objectForKey:@"ID"] intValue]]]];
            
            if (currentIndex!=previousIndex) {
                
                previousIndex = currentIndex;
                
                player = [[AVAudioPlayer alloc] initWithData:fetchedData error:nil];
                player.delegate = self;
                [player prepareToPlay];
                [player play];
                
            }
            else {
                [player pause];
                player = nil;
                
            }
        }
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==notificationsTable) {
        return tableDataSource.count;
    }
    else if (tableView==filterTableView) {
        return filtersArray.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    if (tableView==filterTableView) {
        
        cell.backgroundColor = [UIColor blackColor];//RGB(247, 247, 247);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, filterTableView.bounds.size.width-10, cell.bounds.size.height)];
        titleLabel.text = [filtersArray objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5, filterTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        if (indexPath.row==selectedFilterIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    else if (tableView==notificationsTable) {
        
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        // ***** Temp Code For DEmo Only
        if ([[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Type"] intValue]==1) {
            [cellImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_announcements_notification.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        }
        else if ([[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Type"] intValue]==2) {
            [cellImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_events_notification.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        }
        else if ([[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Type"] intValue]==3) {
            [cellImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_heavyrain_notification.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        }
        else if ([[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Type"] intValue]==4) {
            [cellImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_notification.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        }
        else if ([[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Type"] intValue]==5) {
            [cellImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_iAlerts_notification.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        }
        [cell.contentView addSubview:cellImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, notificationsTable.bounds.size.width-80, 40)];
        titleLabel.text = [[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Message"];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        
        CGRect newTitleLabelLabelFrame = titleLabel.frame;
        newTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"Message"]] font:titleLabel.font withinWidth:notificationsTable.bounds.size.width-80];//expectedDescriptionLabelSize.height;
        titleLabel.frame = newTitleLabelLabelFrame;
        [cell.contentView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, notificationsTable.bounds.size.width-80, 20)];
        dateLabel.text = [CommonFunctions dateTimeFromString:[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"notificationDate"]];
        dateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.numberOfLines = 0;
        dateLabel.textAlignment = NSTextAlignmentRight;
        
        CGRect newDateLabelLabelFrame = dateLabel.frame;
        newDateLabelLabelFrame.size.height = [CommonFunctions heightForText:[CommonFunctions dateTimeFromString:[[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"notificationDate"]] font:dateLabel.font withinWidth:notificationsTable.bounds.size.width-80];//expectedDescriptionLabelSize.height;
        dateLabel.frame = newDateLabelLabelFrame;
        [cell.contentView addSubview:dateLabel];
        [dateLabel sizeToFit];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-1, notificationsTable.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
    }
    
    return cell;
}


# pragma mark - AVAudioPlayerDelegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (flag) {
        previousIndex = -1;
    }
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = RGB(247, 247, 247);
    
    selectedFilterIndex = -1;
    canReadNotifications = YES;
    currentIndex = 0;
    previousIndex = -1;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    //    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    
    
    UIButton *btnfilter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnfilter setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_filter.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [btnfilter addTarget:self action:@selector(animateFilterTable) forControlEvents:UIControlEventTouchUpInside];
    [btnfilter setFrame:CGRectMake(0, 0, 32, 32)];
    
    btnSpeaker =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSpeaker setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_speaker.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [btnSpeaker addTarget:self action:@selector(toggleNotificationSpeech) forControlEvents:UIControlEventTouchUpInside];
    [btnSpeaker setFrame:CGRectMake(44, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:btnfilter];
    [rightBarButtonItems addSubview:btnSpeaker];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    notificationsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    notificationsTable.delegate = self;
    notificationsTable.dataSource = self;
    [self.view addSubview:notificationsTable];
    notificationsTable.backgroundColor = [UIColor clearColor];
    notificationsTable.backgroundView = nil;
    notificationsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    tableDataSource = [[NSMutableArray alloc] init];
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -456, self.view.bounds.size.width, 256) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    filterTableView.scrollEnabled = NO;
    filterTableView.alwaysBounceVertical = NO;
    
    
    //    filtersArray = [[NSArray alloc] initWithObjects:@"Announcements",@"Events",@"Flood",@"Heavy Rain",@"iAlerts",@"Tips", nil];
    filtersArray = [[NSArray alloc] initWithObjects:@"Events",@"Heavy Rain",@"Flood",@"iAlerts", nil];
    
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchNotificationListing)
                  forControlEvents:UIControlEventValueChanged];
    [notificationsTable addSubview:self.refreshControl];
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    [self fetchNotificationListing];
    
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
