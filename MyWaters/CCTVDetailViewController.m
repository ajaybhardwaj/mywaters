//
//  CCTVDetailViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 29/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "CCTVDetailViewController.h"

//#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation CCTVDetailViewController
@synthesize imageUrl,titleString,latValue,longValue,cctvID;

//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To Share Site

- (void) shareSiteOnSocialNetwork {
    
    [self animateTopMenu];
    
    [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Share on" msg:nil cancel:nil tag:2 destructive:nil otherButton:@"Facebook",@"Twitter",@"Cancel",nil];
}


//*************** Method For Showing Zoomed In Image View

-(void) handleSingleTapToZoomIn:(UITapGestureRecognizer *)gesture {
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    fullImageScrollView.hidden = NO;
    closeButton.hidden = NO;
    
}


//*************** Method For Hiding Zoomed In Image View

- (void) removeFullViewImageView {
    
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    fullImageScrollView.hidden = YES;
    [fullImageScrollView setZoomScale:1.0];
    closeButton.hidden = YES;
}



//*************** Method To Close Top Menu For Outside Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    UITouch *touch = [touches anyObject];
    
    if(touch.view!=topMenu) {
        if (isShowingTopMenu) {
            [self animateTopMenu];
        }
    }
}


//*************** Method For Refreshing CCTV Image

- (void) refreshTopImageViewCCTVImage {
    
    topImageView.image = nil;
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@",imageUrl];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(topImageView.bounds.size.width/2, topImageView.bounds.size.height/2);
    [topImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            topImageView.image = image;
            
        }
        else {
            DebugLog(@"Image Loading Failed..!!");
            topImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        [activityIndicator stopAnimating];
    }];
}


//*************** Method To Get WLS Listing

- (void) fetchCCTVListing {
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"SortBy",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"4",@"1",[CommonFunctions getAppVersionNumber], nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}


//*************** Method For Refreshing UI

- (void) refreshContent {
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@",imageUrl];
    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            topImageView.image = image;
            
        }
        else {
            DebugLog(@"Image Loading Failed..!!");
            topImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
    }];
    
    cctvTitleLabel.text = titleString;
    
    //----- Change Current Location With Either Current Location Value or Default Location Value
    
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D desinationLocation;
    
    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
    
    desinationLocation.latitude = latValue;
    desinationLocation.longitude = longValue;
    distanceLabel.text = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
    
    if (appDelegate.CURRENT_LOCATION_LAT == 0.0 && appDelegate.CURRENT_LOCATION_LONG == 0.0) {
        
        distanceLabel.text = @"";
        arrowIcon.hidden = YES;
        directionButton.enabled = NO;
    }
    
    [cctvListingTable reloadData];
    
    [zoomedImageView setImageURL:[NSURL URLWithString:imageUrl]];
}



//*************** Method For Creating UI

- (void) createUI {
    
    
    for (UIView * view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    
    topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 249)];
    [self.view addSubview:topImageView];
    topImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* zoomedTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapToZoomIn:)];
    zoomedTap.numberOfTapsRequired = 1;
    zoomedTap.numberOfTouchesRequired = 1;
    [topImageView addGestureRecognizer:zoomedTap];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@",imageUrl];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(topImageView.bounds.size.width/2, topImageView.bounds.size.height/2);
    [topImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            topImageView.image = image;
            
        }
        else {
            DebugLog(@"Image Loading Failed..!!");
            topImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        [activityIndicator stopAnimating];
    }];
    
    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionButton.frame = CGRectMake(0, topImageView.frame.origin.y+topImageView.bounds.size.height, self.view.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [directionButton addTarget:self action:@selector(moveToDirectionView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    cctvTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-140, 40)];
    cctvTitleLabel.backgroundColor = [UIColor whiteColor];
    cctvTitleLabel.textAlignment = NSTextAlignmentLeft;
    cctvTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    cctvTitleLabel.text = titleString;
    cctvTitleLabel.numberOfLines = 0;
    [directionButton addSubview:cctvTitleLabel];
    
    
    //----- Change Current Location With Either Current Location Value or Default Location Value
    
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D desinationLocation;
    
    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
    
    desinationLocation.latitude = latValue;
    desinationLocation.longitude = longValue;
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-130, 0, 100, 40)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    distanceLabel.text = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
    [directionButton addSubview:distanceLabel];
    
    arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-20, 12.5, 15, 15)];
    [arrowIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_grey.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:arrowIcon];
    
    if (appDelegate.CURRENT_LOCATION_LAT == 0.0 && appDelegate.CURRENT_LOCATION_LONG == 0.0) {
        
        distanceLabel.text = @"";
        arrowIcon.hidden = YES;
        directionButton.enabled = NO;
    }
    
    cctvListingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-(directionButton.bounds.size.height+topImageView.bounds.size.height+64))];
    cctvListingTable.delegate = self;
    cctvListingTable.dataSource = self;
    [self.view addSubview:cctvListingTable];
    cctvListingTable.backgroundColor = [UIColor clearColor];
    cctvListingTable.backgroundView = nil;
    cctvListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [cctvListingTable reloadData];
    
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -160, self.view.bounds.size.width, 45)];
    topMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:topMenu];
    
    //    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, (topMenu.bounds.size.width/2), 35)];
    //    searchField.textColor = RGB(35, 35, 35);
    //    searchField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    //    searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    //    searchField.leftViewMode = UITextFieldViewModeAlways;
    //    searchField.borderStyle = UITextBorderStyleNone;
    //    searchField.textAlignment=NSTextAlignmentLeft;
    //    [searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    //    searchField.placeholder = @"Search...";
    //    searchField.layer.borderWidth = 0.5;
    //    searchField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //    [topMenu addSubview:searchField];
    //    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    searchField.delegate = self;
    //    searchField.keyboardType = UIKeyboardTypeEmailAddress;
    //    searchField.backgroundColor = [UIColor whiteColor];
    //    searchField.returnKeyType = UIReturnKeyDone;
    //    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    listinSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, (topMenu.bounds.size.width/2), 35)];
    listinSearchBar.delegate = self;
    listinSearchBar.placeholder = @"Search...";
    [listinSearchBar setBackgroundImage:[[UIImage alloc] init]];
    listinSearchBar.backgroundColor = [UIColor whiteColor];
    [topMenu addSubview:listinSearchBar];
    
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
    
    
    favouritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favouritesButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*2)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5 + (50), 5, 20, 20);
    if (isAlreadyFav)
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_fav.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    else
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [favouritesButton addTarget:self action:@selector(addCCTVToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:favouritesButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5 + (10), 5, 20, 20);
    [shareButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_share.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareSiteOnSocialNetwork) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:shareButton];
    
    addToFavlabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)+50, 30, topMenu.bounds.size.width/3, 10)];
    addToFavlabel.backgroundColor = [UIColor clearColor];
    addToFavlabel.textAlignment = NSTextAlignmentCenter;
    addToFavlabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    if (isAlreadyFav) {
        addToFavlabel.text = @"Favourite";
    }
    else {
        addToFavlabel.text = @"Favourite";
    }
    addToFavlabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:addToFavlabel];
    
    shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)*2+10, 30, topMenu.bounds.size.width/3, 10)];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    shareLabel.text = @"Share";
    shareLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:shareLabel];
    
    
    UIButton *addFavOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addFavOverlayButton.frame = CGRectMake((topMenu.bounds.size.width/3)+50, 0, topMenu.bounds.size.width/3, 45);
    [addFavOverlayButton addTarget:self action:@selector(addCCTVToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addFavOverlayButton];
    
    UIButton *addShareOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addShareOverlayButton.frame = CGRectMake((topMenu.bounds.size.width/3)*2+10, 0, topMenu.bounds.size.width/3, 45);
    [addShareOverlayButton addTarget:self action:@selector(shareSiteOnSocialNetwork) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addShareOverlayButton];
    
    //    UIImageView *seperatorOne =[[UIImageView alloc] initWithFrame:CGRectMake(addPhotoLabel.frame.origin.x+addPhotoLabel.bounds.size.width-1, 0, 0.5, 45)];
    //    UIImageView *seperatorOne =[[UIImageView alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)+35+topMenu.bounds.size.width/3 - 1, 0, 0.5, 45)];
    //    [seperatorOne setBackgroundColor:[UIColor lightGrayColor]];
    //    [topMenu addSubview:seperatorOne];
    
    
    dimmedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [dimmedImageView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [self.view addSubview:dimmedImageView];
    dimmedImageView.hidden = YES;
    
    
    searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topMenu.frame.origin.y+topMenu.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-topMenu.bounds.size.height-10)];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    [self.view addSubview:searchTableView];
    searchTableView.backgroundColor = [UIColor clearColor];
    searchTableView.backgroundView = nil;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTableView.hidden = YES;
    
    
    fullImageScrollView = [[UIScrollView alloc] init];
    if (IS_IPHONE_6P) {
        fullImageScrollView.frame = CGRectMake(-162, 162, self.view.bounds.size.height, self.view.bounds.size.width);
    }
    else {
        fullImageScrollView.frame = CGRectMake(-124, 124, self.view.bounds.size.height, self.view.bounds.size.width);
    }
    fullImageScrollView.showsHorizontalScrollIndicator = NO;
    fullImageScrollView.showsVerticalScrollIndicator = NO;
    fullImageScrollView.minimumZoomScale=1.0;
    fullImageScrollView.maximumZoomScale=6.0;
    fullImageScrollView.delegate = self;
    fullImageScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:fullImageScrollView];
    fullImageScrollView.hidden = YES;
    
    zoomedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fullImageScrollView.bounds.size.width, fullImageScrollView.bounds.size.height)];
    zoomedImageView.backgroundColor = [UIColor blackColor];
    zoomedImageView.userInteractionEnabled = YES;
    if ([imageUrl length]!=0) {
        [zoomedImageView setImageURL:[NSURL URLWithString:imageUrl]];
    }
    zoomedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [fullImageScrollView addSubview:zoomedImageView];
    
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(removeFullViewImageView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(self.view.bounds.size.width-40, self.view.bounds.size.height-40, 29, 29);
    [self.view addSubview:closeButton];
    closeButton.hidden = YES;
    
    fullImageScrollView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90));
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Move To Map Direction View

- (void) moveToDirectionView {
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
    viewObj.isShowingRoute = YES;
    viewObj.destinationLat = latValue;
    viewObj.destinationLong = longValue;
    [self.navigationController pushViewController:viewObj animated:YES];
}



//*************** Method To Add CCTV To Favourites

- (void) addCCTVToFavourites {
    
    [self animateTopMenu];
    
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];
    
    [parametersDict setValue:cctvID forKey:@"fav_id"];
    [parametersDict setValue:@"1" forKey:@"fav_type"];
    [parametersDict setValue:titleString forKey:@"name"];
    [parametersDict setValue:imageUrl forKey:@"image"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"lat"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",longValue] forKey:@"long"];
    
    [parametersDict setValue:@"NA" forKey:@"address"];
    [parametersDict setValue:@"NA" forKey:@"phoneno"];
    [parametersDict setValue:@"NA" forKey:@"description"];
    [parametersDict setValue:@"NA" forKey:@"start_date_event"];
    [parametersDict setValue:@"NA" forKey:@"end_date_event"];
    [parametersDict setValue:@"NA" forKey:@"website_event"];
    [parametersDict setValue:@"NA" forKey:@"isCertified_ABC"];
    [parametersDict setValue:@"NA" forKey:@"water_level_wls"];
    [parametersDict setValue:@"NA" forKey:@"drain_depth_wls"];
    [parametersDict setValue:@"NA" forKey:@"water_level_percentage_wls"];
    [parametersDict setValue:@"NA" forKey:@"water_level_type_wls"];
    [parametersDict setValue:@"NA" forKey:@"observation_time_wls"];
    
    
    [appDelegate insertFavouriteItems:parametersDict];
    
    isAlreadyFav = [appDelegate checkItemForFavourite:@"1" idValue:cctvID];
    
    if (isAlreadyFav) {
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_fav.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        addToFavlabel.text = @"Favourite";
    }
    else {
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        addToFavlabel.text = @"Favourite";
    }
    
}

//*************** Method To Animate Top Menu

- (void) animateTopMenu {
    
    if (isShowingTopMenu) {
        
        isShowingTopMenu = NO;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = -130;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
        
        searchTableView.hidden = YES;
        dimmedImageView.hidden = YES;
    }
    else {
        
        isShowingTopMenu = YES;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = 21;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
        
        searchTableView.frame = CGRectMake(0, topMenu.frame.origin.y+topMenu.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-topMenu.bounds.size.height-10);
        searchTableView.hidden = NO;
    }
}


# pragma mark - UISearchBarDelegate Methods

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    
    if(text.length == 0)
    {
        isFiltered = NO;
        searchTableView.hidden = YES;
        dimmedImageView.hidden = YES;
    }
    else
    {
        searchTableView.hidden = NO;
        dimmedImageView.hidden = NO;
        isFiltered = YES;
        [filterDataSource removeAllObjects];
        
        for (int i=0; i<appDelegate.CCTV_LISTING_ARRAY.count; i++) {
            
            NSRange nameRange = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Name"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filterDataSource addObject:[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i]];
            }
        }
    }
    
    [searchTableView reloadData];
}


# pragma mark - UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    if (scrollView==fullImageScrollView) {
        return zoomedImageView;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        //    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == false) {
        
        NSArray *tempArray = [[NSArray alloc] init];
        
        tempArray = [[responseString JSONValue] objectForKey:CCTV_LISTING_RESPONSE_NAME];
        
        if (tempArray.count==0) {
            //            cctvPageCount = 0;
        }
        else {
            //            cctvPageCount = cctvPageCount + 1;
            //            if (appDelegate.CCTV_LISTING_ARRAY.count==0) {
            
            if (appDelegate.CCTV_LISTING_ARRAY.count!=0)
                [appDelegate.CCTV_LISTING_ARRAY removeAllObjects];
            
            [appDelegate.CCTV_LISTING_ARRAY setArray:tempArray];
            
            CLLocationCoordinate2D currentLocation;
            currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
            currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
            
            
            for (int idx = 0; idx<[appDelegate.CCTV_LISTING_ARRAY count];idx++) {
                
                NSMutableDictionary *dict = [appDelegate.CCTV_LISTING_ARRAY[idx] mutableCopy];
                
                CLLocationCoordinate2D desinationLocation;
                desinationLocation.latitude = [dict[@"Lat"] doubleValue];
                desinationLocation.longitude = [dict[@"Lon"] doubleValue];
                
                DebugLog(@"%f---%f",desinationLocation.latitude,desinationLocation.longitude);
                
                dict[@"distance"] = [CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation];//[NSString stringWithFormat:@"%@",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                appDelegate.CCTV_LISTING_ARRAY[idx] = dict;
                
            }
            
            
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
            
            [appDelegate.CCTV_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,nil]];
            
            if (!tempNearByArray) {
                tempNearByArray = [[NSMutableArray alloc] init];
            }
            int count = 0;

            for (int i=0; i<appDelegate.CCTV_LISTING_ARRAY.count; i++) {
                if (![[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"ID"] isEqualToString:cctvID]) {
                    if (count!=3) {
                        [tempNearByArray addObject:[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i]];
                        count++;
                    }
                    else {
                        break;
                    }
                }
            }
            
        }
        
        [appDelegate.hud hide:YES];
        [cctvListingTable reloadData];
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"Ok" otherButton:nil];
    }
    
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"Ok" otherButton:nil];
    [appDelegate.hud hide:YES];
}



# pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag==2) {
        
        if (buttonIndex==0) {
            
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            [CommonFunctions sharePostOnFacebook:imageUrl appUrl:appUrl title:titleString desc:nil view:self abcIDValue:@"0"];
        }
        else if (buttonIndex==1) {
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            [CommonFunctions sharePostOnTwitter:appUrl title:titleString view:self abcIDValue:@"0"];
        }
    }
}




# pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==cctvListingTable)
        return 30.0f;
    else
        return 0.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView==cctvListingTable) {
        if (section==0) {
            
            UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
            sectionLabel.text = @"    Nearby";
            sectionLabel.textColor = RGB(71, 178, 182);
            sectionLabel.backgroundColor = RGB(234, 234, 234);
            sectionLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            
            return sectionLabel;
        }
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    
    
    if (isFiltered) {
        
        latValue = [[[filterDataSource objectAtIndex:indexPath.row] objectForKey:@"Lat"] doubleValue];
        longValue = [[[filterDataSource objectAtIndex:indexPath.row] objectForKey:@"Lon"] doubleValue];
        imageUrl = [[filterDataSource objectAtIndex:indexPath.row] objectForKey:@"CCTVImageURL"];
        titleString = [[filterDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cctvID = [[filterDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"];
        
        int count = 0;
        [tempNearByArray removeAllObjects];
        
        if (!tempNearByArray) {
            tempNearByArray = [[NSMutableArray alloc] init];
        }
        for (int i=0; i<appDelegate.CCTV_LISTING_ARRAY.count; i++) {
            if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"ID"] != cctvID) {
                if (count!=3) {
                    [tempNearByArray addObject:[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i]];
                    count++;
                }
                else {
                    break;
                }
            }
        }
        
        dimmedImageView.hidden = YES;
        searchTableView.hidden = YES;
        listinSearchBar.text = @"";
        [filterDataSource removeAllObjects];
    }
    else {
        latValue = [[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"Lat"] doubleValue];
        longValue = [[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"Lon"] doubleValue];
        imageUrl = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"CCTVImageURL"];
        titleString = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cctvID = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
        
        int count = 0;
        [tempNearByArray removeAllObjects];
        
        if (!tempNearByArray) {
            tempNearByArray = [[NSMutableArray alloc] init];
        }
        for (int i=0; i<appDelegate.CCTV_LISTING_ARRAY.count; i++) {
            if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"ID"] != cctvID) {
                if (count!=3) {
                    [tempNearByArray addObject:[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i]];
                    count++;
                }
                else {
                    break;
                }
            }
        }
    }
    
    [self refreshContent];
    [cctvListingTable reloadData];
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==cctvListingTable) {
        if (tempNearByArray.count!=0)
            return 3;
    }
    else if (tableView==searchTableView) {
        return filterDataSource.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    [cell.contentView addSubview:cellImage];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, cctvListingTable.bounds.size.width-100, 50)];
    if (tableView==cctvListingTable)
        titleLabel.text = [NSString stringWithFormat:@"%@",[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    if (tableView==searchTableView)
        titleLabel.text = [NSString stringWithFormat:@"%@",[[filterDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, cctvListingTable.bounds.size.width-100, 20)];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    if (tableView==cctvListingTable)
        subTitleLabel.text = [NSString stringWithFormat:@"%@ KM",[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    if (tableView==searchTableView)
        subTitleLabel.text = [NSString stringWithFormat:@"%@ KM",[[filterDataSource objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    
    subTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:subTitleLabel];
    
    if (appDelegate.CURRENT_LOCATION_LAT == 0.0 && appDelegate.CURRENT_LOCATION_LONG == 0.0) {
        
        subTitleLabel.text = @"";
    }
    
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, cctvListingTable.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    return cell;
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CCTVs";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    isAlreadyFav = [appDelegate checkItemForFavourite:@"1" idValue:cctvID];
    filterDataSource = [[NSMutableArray alloc] init];
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    
    UIButton *btnrefresh =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnrefresh setImage:[UIImage imageNamed:@"icn_refresh_white"] forState:UIControlStateNormal];
    [btnrefresh addTarget:self action:@selector(refreshTopImageViewCCTVImage) forControlEvents:UIControlEventTouchUpInside];
    [btnrefresh setFrame:CGRectMake(0, 0, 32, 32)];
    
    UIButton *btnDots =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDots setImage:[UIImage imageNamed:@"icn_3dots"] forState:UIControlStateNormal];
    [btnDots addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [btnDots setFrame:CGRectMake(44, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:btnrefresh];
    [rightBarButtonItems addSubview:btnDots];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    //    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots"]];
    
    
    [self createUI];
    
//    if (!appDelegate.IS_COMING_FROM_DASHBOARD) {
//        
//        if (!tempNearByArray) {
//            tempNearByArray = [[NSMutableArray alloc] init];
//        }
//        
//        
//        NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES comparator:^(id left, id right) {
//            float v1 = [left floatValue];
//            float v2 = [right floatValue];
//            if (v1 < v2)
//                return NSOrderedAscending;
//            else if (v1 > v2)
//                return NSOrderedDescending;
//            else
//                return NSOrderedSame;
//        }];
//        
//        [appDelegate.CCTV_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,nil]];
//        
//        int count = 0;
////        [tempNearByArray removeAllObjects];
//        for (int i=0; i<appDelegate.CCTV_LISTING_ARRAY.count; i++) {
//            if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"ID"] != cctvID) {
//                if (count!=3) {
//                    [tempNearByArray addObject:[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i]];
//                    count++;
//                }
//                else {
//                    break;
//                }
//            }
//        }
//        
//    }
//    else {
    if ([CommonFunctions hasConnectivity]) {
        [self fetchCCTVListing];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
        return;
    }
    //    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [appDelegate setShouldRotate:NO];
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(71, 178, 182) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO];
    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        [req cancel];
        [req setDelegate:nil];
    }
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
