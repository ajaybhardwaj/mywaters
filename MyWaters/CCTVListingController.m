//
//  CCTVListingController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "CCTVListingController.h"

@implementation CCTVListingController



//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
    [listinSearchBar resignFirstResponder];
}



//*************** Method To Get WLS Listing

- (void) fetchCCTVListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"SortBy",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"4",@"1",@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}


//*************** Method To ANimate Filter Table

- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -120;
        
        cctvListingTable.alpha = 1.0;
        cctvListingTable.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 128;
        
        if (isShowingSearchBar) {
            [self animateSearchBar];
        }
        
        cctvListingTable.alpha = 0.5;
        cctvListingTable.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}


//*************** Method To Animate Search Bar

- (void) animateSearchBar {
    
    [UIView beginAnimations:@"searchbar" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = listinSearchBar.center;
    
    if (isShowingSearchBar) {
        isShowingSearchBar = NO;
        pos.y = -150;
        
        cctvListingTable.alpha = 1.0;
        cctvListingTable.userInteractionEnabled = YES;
        
        [listinSearchBar resignFirstResponder];
    }
    else {
        isShowingSearchBar = YES;
        pos.y = 20;
        
        if (isShowingFilter) {
            [self animateFilterTable];
        }
        
        //        cctvListingTable.alpha = 0.5;
        //        cctvListingTable.userInteractionEnabled = NO;
        
        [listinSearchBar becomeFirstResponder];
    }
    listinSearchBar.center = pos;
    [UIView commitAnimations];
}




# pragma mark - UISearchBarDelegate Methods

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        [filteredDataSource removeAllObjects];
        
        for (int i=0; i<appDelegate.CCTV_LISTING_ARRAY.count; i++) {
            
            NSRange nameRange = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Name"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [filteredDataSource addObject:[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i]];
            }
        }
    }
    
    [cctvListingTable reloadData];
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self animateSearchBar];
    return YES;
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    DebugLog(@"%@",responseString);
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        //    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == false) {
        
        NSArray *tempArray = [[responseString JSONValue] objectForKey:CCTV_LISTING_RESPONSE_NAME];
        cctvPageCount = [[[responseString JSONValue] objectForKey:CCTV_LISTING_TOTAL_COUNT] intValue];
        
        if (tempArray.count==0) {
            //            cctvPageCount = 0;
        }
        else {
            //            cctvPageCount = cctvPageCount + 1;
            if (appDelegate.CCTV_LISTING_ARRAY.count==0) {
                [appDelegate.CCTV_LISTING_ARRAY setArray:tempArray];
            }
            else {
                if (appDelegate.CCTV_LISTING_ARRAY.count!=0) {
                    for (int i=0; i<tempArray.count; i++) {
                        [appDelegate.CCTV_LISTING_ARRAY addObject:[tempArray objectAtIndex:i]];
                    }
                }
            }
        }
        
        [appDelegate.hud hide:YES];
        [cctvListingTable reloadData];
        
    }
    
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    //    cctvPageCount = -1;
    
    [appDelegate.hud hide:YES];
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    else if (tableView==cctvListingTable) {
        return 80.0f;
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView==filterTableView) {
        
        selectedFilterIndex = indexPath.row;
        [filterTableView reloadData];
        [self animateFilterTable];
    }
    
    else if (tableView==cctvListingTable) {
        
        CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
        
        if (isFiltered) {
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"CCTVImageURL"] != (id)[NSNull null])
                viewObj.imageUrl = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"CCTVImageURL"];
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"] != (id)[NSNull null])
                viewObj.titleString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"] != (id)[NSNull null])
                viewObj.cctvID = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"];
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"Lat"] != (id)[NSNull null])
                viewObj.latValue = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"Lat"] doubleValue];
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"Lon"] != (id)[NSNull null])
                viewObj.longValue = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"Lon"] doubleValue];
        }
        else {
            if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"CCTVImageURL"] != (id)[NSNull null])
                viewObj.imageUrl = [[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"CCTVImageURL"];
            if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"Name"] != (id)[NSNull null])
                viewObj.titleString = [[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"Name"];
            if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"ID"] != (id)[NSNull null])
                viewObj.cctvID = [[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"ID"];
            if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"Lat"] != (id)[NSNull null])
                viewObj.latValue = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"Lat"] doubleValue];
            if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"Lon"] != (id)[NSNull null])
                viewObj.longValue = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"Lon"] doubleValue];
        }
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==cctvListingTable) {
        if (isFiltered) {
            return filteredDataSource.count;
        }
        else {
            return appDelegate.CCTV_LISTING_ARRAY.count;
        }
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
    else {
        
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/CCTV-2.png",appDelegate.RESOURCE_FOLDER_PATH]];
        [cell.contentView addSubview:cellImage];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, cctvListingTable.bounds.size.width-100, 60)];
        if (isFiltered) {
            titleLabel.text = [NSString stringWithFormat:@"%@",[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"]];
        }
        else {
            titleLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"Name"]];
        }
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, cctvListingTable.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
    }
    
    return cell;
}



# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    self.title = @"CCTV";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    
    
    UIButton *btnfilter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnfilter setImage:[UIImage imageNamed:@"icn_filter"] forState:UIControlStateNormal];
    [btnfilter addTarget:self action:@selector(animateFilterTable) forControlEvents:UIControlEventTouchUpInside];
    [btnfilter setFrame:CGRectMake(0, 0, 32, 32)];
    
    UIButton *btnSearch =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setImage:[UIImage imageNamed:@"icn_search"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(animateSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setFrame:CGRectMake(36, 0, 32, 32)];
    
    UIButton *btnLocation =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLocation setImage:[UIImage imageNamed:@"icn_location_top"] forState:UIControlStateNormal];
    //    [btnLocation addTarget:self action:@selector(animateSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [btnLocation setFrame:CGRectMake(72, 0, 32, 32)];
    
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 32)];
    [rightBarButtonItems addSubview:btnfilter];
    [rightBarButtonItems addSubview:btnSearch];
    [rightBarButtonItems addSubview:btnLocation];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    cctvListingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    cctvListingTable.delegate = self;
    cctvListingTable.dataSource = self;
    [self.view addSubview:cctvListingTable];
    cctvListingTable.backgroundColor = [UIColor clearColor];
    cctvListingTable.backgroundView = nil;
    cctvListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -256, self.view.bounds.size.width, 256) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    
    
    filtersArray = [[NSArray alloc] initWithObjects:@"Name",@"Distance", nil];
    filteredDataSource = [[NSMutableArray alloc] init];
    
    
    listinSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    listinSearchBar.delegate = self;
    listinSearchBar.placeholder = @"Search...";
    [listinSearchBar setBackgroundImage:[[UIImage alloc] init]];
    listinSearchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:listinSearchBar];
    
    UITextField *searchField=[((UIView *)[listinSearchBar.subviews objectAtIndex:0]).subviews lastObject];;//Changed this line in ios 7
    searchField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.borderStyle = UITextBorderStyleNone;
    searchField.textAlignment=NSTextAlignmentLeft;
    [searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    searchField.placeholder = @"Search...";
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.returnKeyType = UIReturnKeyDone;
    searchField.backgroundColor = [UIColor whiteColor];
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading..!!";
    [self fetchCCTVListing];
}



- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(71, 178, 182) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
}


@end
