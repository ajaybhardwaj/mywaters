//
//  WLSListingViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 13/7/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WLSListingViewController.h"

@interface WLSListingViewController ()

@end

@implementation WLSListingViewController
@synthesize responseData;

//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
    [listinSearchBar resignFirstResponder];
}


//*************** Method For Saving ABC Water Sites Data

- (void) saveWLSData {
    
    [appDelegate insertWLSData:appDelegate.WLS_LISTING_ARRAY];
}



//*************** Method To Get WLS Listing

- (void) fetchWLSListing {
    
    if ([CommonFunctions hasConnectivity]) {
        
        [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"PushToken",@"version", nil];
        NSArray *values = [[NSArray alloc] initWithObjects:@"6",[[SharedObject sharedClass] getPUBUserSavedDataValue:@"device_token"],[CommonFunctions getAppVersionNumber], nil];

        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
        
        [self pullToRefreshTable];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"No internet connectivity." msg:nil cancel:@"OK" otherButton:nil];
    }
}


//*************** Method To Animate Search Bar

- (void) animateSearchBar {
    
    [UIView beginAnimations:@"searchbar" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = listinSearchBar.center;
    
    if (isShowingSearchBar) {
        isShowingSearchBar = NO;
        pos.y = -100;
        
        wlsListingtable.alpha = 1.0;
        wlsListingtable.userInteractionEnabled = YES;
        
        [listinSearchBar resignFirstResponder];
    }
    else {
        isShowingSearchBar = YES;
        pos.y = 20;
        
        [listinSearchBar becomeFirstResponder];
    }
    listinSearchBar.center = pos;
    [UIView commitAnimations];
}


//*************** Method For Pull To Refresh

- (void) pullToRefreshTable {
    
    // Reload table data
    [wlsListingtable reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateFormat:@"MMM d, h:mm a"];
        //        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        //        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
        //                                                                    forKey:NSForegroundColorAttributeName];
        //        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        //        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}




# pragma mark - UISearchBarDelegate Methods

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        if(filteredDataSource.count!=0)
            [filteredDataSource removeAllObjects];
        
        for (int i=0; i<appDelegate.WLS_LISTING_ARRAY.count; i++) {
            
            NSRange nameRange = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"name"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filteredDataSource addObject:[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i]];
            }
        }
    }
    
    [wlsListingtable reloadData];
}



# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self animateSearchBar];
    [textField resignFirstResponder];
    return YES;
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        //    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == false) {
        
        [appDelegate.WLS_LISTING_ARRAY removeAllObjects];
        
        NSArray *tempArray = [[responseString JSONValue] objectForKey:WLS_LISTING_RESPONSE_NAME];
        //        wlsTotalCount = [[[responseString JSONValue] objectForKey:WLS_LISTING_TOTAL_COUNT] intValue];
        
        if (tempArray.count==0) {
            
        }
        else {
            
            if (appDelegate.WLS_LISTING_ARRAY.count!=0)
                [appDelegate.WLS_LISTING_ARRAY removeAllObjects];
            
            [appDelegate.WLS_LISTING_ARRAY setArray:tempArray];
            
            CLLocationCoordinate2D currentLocation;
            currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
            currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
            
            
            for (int idx = 0; idx<[appDelegate.WLS_LISTING_ARRAY count];idx++) {
                
                NSMutableDictionary *dict = [appDelegate.WLS_LISTING_ARRAY[idx] mutableCopy];
                
                CLLocationCoordinate2D desinationLocation;
                desinationLocation.latitude = [dict[@"latitude"] doubleValue];
                desinationLocation.longitude = [dict[@"longitude"] doubleValue];
                
                DebugLog(@"%f---%f",desinationLocation.latitude,desinationLocation.longitude);
                
                dict[@"distance"] = [CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation];//[NSString stringWithFormat:@"%@",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                appDelegate.WLS_LISTING_ARRAY[idx] = dict;
                
            }
            
            DebugLog(@"%@",appDelegate.WLS_LISTING_ARRAY);
            
            //            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            [appDelegate.WLS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,nil]];
            
            NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES comparator:^(id left, id right) {
                float v1 = [left floatValue];
                float v2 = [right floatValue];
                if (v1 < v2)
                    return NSOrderedAscending;
                else if (v1 > v2)
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
            }];
            
            [appDelegate.WLS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,nil]];
            
            // Temp commented for UAT
            //            if (appDelegate.WLS_LISTING_ARRAY.count!=0)
            //                [self performSelectorInBackground:@selector(saveWLSData) withObject:nil];
            
        }
        
        [CommonFunctions dismissGlobalHUD];
        //        [appDelegate.hud hide:YES];
        [wlsListingtable reloadData];
        [self.refreshControl endRefreshing];
    }
    
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isShowingSearchBar) {
        [self animateSearchBar];
    }
    
    WaterLevelSensorsDetailViewController *viewObj = [[WaterLevelSensorsDetailViewController alloc] init];
    
    if (isFiltered) {
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"id"] != (id)[NSNull null])
            viewObj.wlsID = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"name"] != (id)[NSNull null])
            viewObj.wlsName = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] != (id)[NSNull null])
            viewObj.drainDepthType = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"latitude"] != (id)[NSNull null])
            viewObj.latValue = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"latitude"] doubleValue];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"longitude"] != (id)[NSNull null])
            viewObj.longValue = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"longitude"] doubleValue];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"observationTime"] != (id)[NSNull null])
            viewObj.observedTime = [CommonFunctions dateTimeFromString:[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"observationTime"]];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevel"] != (id)[NSNull null])
            viewObj.waterLevelValue = [NSString stringWithFormat:@"%d",[[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevel"] intValue]];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelPercentage"] != (id)[NSNull null])
            viewObj.waterLevelPercentageValue = [NSString stringWithFormat:@"%d",[[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelPercentage"] intValue]];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] != (id)[NSNull null])
            viewObj.waterLevelTypeValue = [NSString stringWithFormat:@"%d",[[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue]];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"drainDepth"] != (id)[NSNull null])
            viewObj.drainDepthValue = [NSString stringWithFormat:@"%d",[[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"drainDepth"] intValue]];
        
        if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] != (id)[NSNull null])
            viewObj.isSubscribed = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] intValue];
        
    }
    else {
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"id"] != (id)[NSNull null])
            viewObj.wlsID = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"name"] != (id)[NSNull null])
            viewObj.wlsName = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] != (id)[NSNull null])
            viewObj.drainDepthType = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"latitude"] != (id)[NSNull null])
            viewObj.latValue = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"latitude"] doubleValue];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"longitude"] != (id)[NSNull null])
            viewObj.longValue = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"longitude"] doubleValue];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"observationTime"] != (id)[NSNull null])
            viewObj.observedTime = [CommonFunctions dateTimeFromString:[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"observationTime"]];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevel"] != (id)[NSNull null])
            viewObj.waterLevelValue = [NSString stringWithFormat:@"%d",[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevel"] intValue]];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelPercentage"] != (id)[NSNull null])
            viewObj.waterLevelPercentageValue = [NSString stringWithFormat:@"%d",[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelPercentage"] intValue]];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] != (id)[NSNull null])
            viewObj.waterLevelTypeValue = [NSString stringWithFormat:@"%d",[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue]];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"drainDepth"] != (id)[NSNull null])
            viewObj.drainDepthValue = [NSString stringWithFormat:@"%d",[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"drainDepth"] intValue]];
        
        if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] != (id)[NSNull null])
            viewObj.isSubscribed = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] intValue];
        
    }
    [self.navigationController pushViewController:viewObj animated:YES];
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isFiltered) {
        return filteredDataSource.count;
    }
    else {
        return appDelegate.WLS_LISTING_ARRAY.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
    
    if (isFiltered) {
        if ([[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 1) {
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        else if ([[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 2) {
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        else if ([[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 3) {
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        else if ([[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 4){
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_undermaintenance.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
    }
    else {
        if ([[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 1) {
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        else if ([[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 2) {
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        else if ([[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 3) {
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        else if ([[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 4){
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_undermaintenance.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
    }
    [cell.contentView addSubview:cellImage];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, wlsListingtable.bounds.size.width-90, 50)];
    if (isFiltered)
        titleLabel.text = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"name"];
    else
        titleLabel.text = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"name"];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *subscribedLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, wlsListingtable.bounds.size.width-90, 20)];
    subscribedLabel.textColor = [UIColor lightGrayColor];
    if (isFiltered) {
        if ([[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] intValue]) {
            subscribedLabel.text = @"Subscribed";
        }
        else {
            subscribedLabel.text = @"";
        }
    }
    else {
        if ([[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] intValue]) {
            subscribedLabel.text = @"Subscribed";
        }
        else {
            subscribedLabel.text = @"";
            
        }
    }
    subscribedLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    subscribedLabel.backgroundColor = [UIColor clearColor];
    subscribedLabel.numberOfLines = 0;
    [cell.contentView addSubview:subscribedLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, wlsListingtable.bounds.size.width-100, 20)];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    if (isFiltered)
        subTitleLabel.text = [NSString stringWithFormat:@"%@ KM",[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    else
        subTitleLabel.text = [NSString stringWithFormat:@"%@ KM",[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    subTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:subTitleLabel];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        subTitleLabel.text = @"";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, wlsListingtable.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    
    return cell;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Water Level Sensor";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    filteredDataSource = [[NSMutableArray alloc] init];
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateSearchBar) withIconName:@"icn_search"]];
    
    wlsListingtable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    wlsListingtable.delegate = self;
    wlsListingtable.dataSource = self;
    [self.view addSubview:wlsListingtable];
    wlsListingtable.backgroundColor = [UIColor clearColor];
    wlsListingtable.backgroundView = nil;
    wlsListingtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    responseData = [[NSMutableData alloc] init];
    
    wlsPageCount = 0;
    
    listinSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -120, self.view.bounds.size.width, 40)];
    listinSearchBar.delegate = self;
    listinSearchBar.placeholder = @"Search...";
    [listinSearchBar setBackgroundImage:[[UIImage alloc] init]];
    listinSearchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:listinSearchBar];
    
    for (id object in [listinSearchBar subviews]) {
        
        if ([object isKindOfClass:[UITextField class]]) {
            
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:ROBOTO_REGULAR size:14]];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)]];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftViewMode:UITextFieldViewModeAlways];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBorderStyle:UITextBorderStyleNone];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextAlignment:NSTextAlignmentLeft];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setPlaceholder:@"Search..."];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setClearButtonMode:UITextFieldViewModeWhileEditing];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setReturnKeyType:UIReturnKeyDone];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor whiteColor]];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDelegate:self];
        }
    }
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchWLSListing)
                  forControlEvents:UIControlEventValueChanged];
    [wlsListingtable addSubview:self.refreshControl];
    

}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [appDelegate setShouldRotate:NO];
    [appDelegate.locationManager startUpdatingLocation];
    [CommonFunctions googleAnalyticsTracking:@"Page: WLS Listing"];
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(51,148,228) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    [self fetchWLSListing];
    
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
