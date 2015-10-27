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
}


//*************** Method For Saving ABC Water Sites Data

- (void) saveWLSData {
    
    [appDelegate insertWLSData:appDelegate.WLS_LISTING_ARRAY];
}



//*************** Method To Get WLS Listing

- (void) fetchWLSListing {
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";

    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"PushToken",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"6",[[SharedObject sharedClass] getPUBUserSavedDataValue:@"device_token"],@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
    
    [self pullToRefreshTable];
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
            
            
            if (appDelegate.WLS_LISTING_ARRAY.count!=0)
                [self performSelectorInBackground:@selector(saveWLSData) withObject:nil];

        }
        
        [appDelegate.hud hide:YES];
        [wlsListingtable reloadData];
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
    
    return 80.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WaterLevelSensorsDetailViewController *viewObj = [[WaterLevelSensorsDetailViewController alloc] init];
    
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
    
    
    [self.navigationController pushViewController:viewObj animated:YES];
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return appDelegate.WLS_LISTING_ARRAY.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
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
    [cell.contentView addSubview:cellImage];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, wlsListingtable.bounds.size.width-90, 50)];
    titleLabel.text = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"name"];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, wlsListingtable.bounds.size.width-100, 20)];
    subTitleLabel.textColor = [UIColor lightGrayColor];
        subTitleLabel.text = [NSString stringWithFormat:@"%@ KM",[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    subTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:subTitleLabel];
    if (appDelegate.CURRENT_LOCATION_LAT == 0.0 && appDelegate.CURRENT_LOCATION_LONG == 0.0) {
        
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
    
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    
    
    wlsListingtable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    wlsListingtable.delegate = self;
    wlsListingtable.dataSource = self;
    [self.view addSubview:wlsListingtable];
    wlsListingtable.backgroundColor = [UIColor clearColor];
    wlsListingtable.backgroundView = nil;
    wlsListingtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    responseData = [[NSMutableData alloc] init];
    
    wlsPageCount = 0;
    
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
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(52,158,240) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];

    
    if ([CommonFunctions hasConnectivity]) {
        [self fetchWLSListing];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
    }}


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
