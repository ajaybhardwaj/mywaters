//
//  TipsListingViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 20/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "TipsListingViewController.h"

@interface TipsListingViewController ()

@end

@implementation TipsListingViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To Get WLS Listing

- (void) fetchTipsListing {
    
    if ([CommonFunctions hasConnectivity]) {
        appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
        appDelegate.hud.labelText = @"Loading...";
        
        
        NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"MediaFeedMode",@"version", nil];
        NSArray *values = [[NSArray alloc] initWithObjects:@"12",@"3",@"1.0", nil];
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
        
        [self pullToRefreshTable];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
    }
}


//*************** Method For Pull To Refresh

- (void) pullToRefreshTable {
    
    // Reload table data
    [tipsListingTableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        //        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [appDelegate.hud hide:YES];
    
    DebugLog(@"%@",responseString);
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        NSArray *tempArray = [[responseString JSONValue] objectForKey:FEEDS_CHATTER_LISTING_RESPONSE_NAME];
        
        if (tempArray.count==0) {
            noDataLabel.hidden = NO;
            noDataLabel.text = @"No tips data available.";
            tipsListingTableView.hidden = YES;
        }
        else {
            [appDelegate.TIPS_VIDEOS_ARRAY removeAllObjects];
            [appDelegate.TIPS_VIDEOS_ARRAY setArray:tempArray];
            tipsListingTableView.hidden = NO;
            noDataLabel.hidden = YES;
        }
        
        [tipsListingTableView reloadData];
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
    
    return 190.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



# pragma mark - Youtube Video Method For Orientation

- (void)youTubeStarted:(NSNotification *)notification{
    // Entered Fullscreen code goes here..
}

- (void)youTubeFinished:(NSNotification *)notification{
    // Left fullscreen code goes here...
    
    //CODE BELOW FORCES APP BACK TO PORTRAIT ORIENTATION ONCE YOU LEAVE VIDEO.
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    //present/dismiss viewcontroller in order to activate rotating.
    UIViewController *mVC = [[UIViewController alloc] init];
    [self presentViewController:mVC animated:NO completion:NULL];
    [self dismissViewControllerAnimated:NO completion:NULL];
}




# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return appDelegate.TIPS_VIDEOS_ARRAY.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    //    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 80)];
    //
    //    NSString *imageURLString = [NSString stringWithFormat:@"%@",[[appDelegate.TIPS_VIDEOS_ARRAY objectAtIndex:indexPath.row] objectForKey:@"ImageURL"]];
    //    [cell.contentView addSubview:cellImage];
    //
    //
    //
    //    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    activityIndicator.center = CGPointMake(cellImage.bounds.size.width/2, cellImage.bounds.size.height/2);
    //    [cellImage addSubview:activityIndicator];
    //    [activityIndicator startAnimating];
    //
    //    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
    //        if (succeeded) {
    //
    //            cellImage.image = image;
    //        }
    //        else {
    //            DebugLog(@"Image Loading Failed..!!");
    //            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
    //        }
    //        [activityIndicator stopAnimating];
    //    }];
    
    
    UIWebView *localVideoWebview = [[UIWebView alloc] initWithFrame:CGRectMake(-10, -10, self.view.bounds.size.width+10, 150)];
    localVideoWebview.backgroundColor = [UIColor colorWithRed:28.0/256.0 green:27.0/256.0 blue:28.0/256.0 alpha:1.0];
    [cell.contentView addSubview:localVideoWebview];
    localVideoWebview.scrollView.scrollEnabled = NO;
    localVideoWebview.scrollView.bounces = NO;
    
    // iframe
    NSString *url = [[appDelegate.TIPS_VIDEOS_ARRAY objectAtIndex:indexPath.row] objectForKey:@"EmbedURL"];//@"https://www.youtube.com/embed/5fDrVA2_nbg";
    url = [NSString stringWithFormat:@"%@?rel=0&showinfo=0&controls=0",url];
    NSString* embedHTML = [NSString stringWithFormat:@"\
                           <iframe width=\"%f\" height=\"150\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                           ",tipsListingTableView.bounds.size.width+10,url];
    
    NSString* html = [NSString stringWithFormat:embedHTML, url, tipsListingTableView.bounds.size.width+10, 150];
    [localVideoWebview loadHTMLString:html baseURL:nil];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, localVideoWebview.frame.origin.y+localVideoWebview.bounds.size.height, tipsListingTableView.bounds.size.width-20, 40)];
    titleLabel.text = [[appDelegate.TIPS_VIDEOS_ARRAY objectAtIndex:indexPath.row] objectForKey:@"FeedText"];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 189.5, tipsListingTableView.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    
    return cell;
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(247, 247, 247);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    tipsListingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    tipsListingTableView.delegate = self;
    tipsListingTableView.dataSource = self;
    [self.view addSubview:tipsListingTableView];
    tipsListingTableView.backgroundColor = [UIColor clearColor];
    tipsListingTableView.backgroundView = nil;
    tipsListingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchTipsListing)
                  forControlEvents:UIControlEventValueChanged];
    [tipsListingTableView addSubview:self.refreshControl];
    
    
    noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height/2 - 40, self.view.bounds.size.width-20, 20)];
    noDataLabel.text = @"No tips found.";
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    noDataLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:noDataLabel];
    noDataLabel.hidden = YES;
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.title = @"Tips";
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(229,0,87) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    if ([CommonFunctions hasConnectivity]) {
        [self fetchTipsListing];
        noDataLabel.hidden = YES;
        tipsListingTableView.hidden = NO;
        
    }
    else {
        noDataLabel.hidden = NO;
        noDataLabel.text = @"No internet connection.";
        tipsListingTableView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate
{
    return NO;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;;
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
