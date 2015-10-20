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



//*************** Method To Get WLS Listing

- (void) fetchWLSListing {
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";

    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
//    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"PushToken",@"SortBy",@"version", nil];
//    NSArray *values = [[NSArray alloc] initWithObjects:@"6",[prefs stringForKey:@"device_token"],[NSString stringWithFormat:@"1"],@"1.0", nil];
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"SortBy",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"6",[NSString stringWithFormat:@"1"],@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
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
            
//            else {
//                if (appDelegate.WLS_LISTING_ARRAY.count!=0) {
//                    for (int i=0; i<tempArray.count; i++) {
//                        [appDelegate.WLS_LISTING_ARRAY addObject:[tempArray objectAtIndex:i]];
//                    }
//                }
//            }
        }
        
        [appDelegate.hud hide:YES];
        [wlsListingtable reloadData];
        
    }
    
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    
    [appDelegate.hud hide:YES];
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
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
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
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
    
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59.5, wlsListingtable.bounds.size.width, 0.5)];
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
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
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
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(52,158,240) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    [self fetchWLSListing];
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
