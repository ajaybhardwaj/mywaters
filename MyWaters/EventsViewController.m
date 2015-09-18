//
//  EventsViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "EventsViewController.h"
#import "ViewControllerHelper.h"


@interface EventsViewController ()

@end

@implementation EventsViewController
@synthesize isNotEventController;


//*************** Method To Animate Search Bar

- (void) animateSearchBar {
    
    [UIView beginAnimations:@"searchbar" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = listinSearchBar.center;
    
    if (isShowingSearchBar) {
        isShowingSearchBar = NO;
        pos.y = -70;
        
        eventsListingTableView.alpha = 1.0;
        eventsListingTableView.userInteractionEnabled = YES;
        
        [listinSearchBar resignFirstResponder];
    }
    else {
        isShowingSearchBar = YES;
        pos.y = 20;
        
        if (isShowingFilter) {
            [self animateFilterTable];
        }
        
        //        eventsListingTableView.alpha = 0.5;
        //        eventsListingTableView.userInteractionEnabled = NO;
        
        [listinSearchBar becomeFirstResponder];
    }
    listinSearchBar.center = pos;
    [UIView commitAnimations];
}

//*************** Method To Animate Filter Table

- (void) animateFilterTable {
    
    listinSearchBar.text = @"";
    isFiltered = NO;
    [eventsListingTableView reloadData];
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -70;
        
        eventsListingTableView.alpha = 1.0;
        eventsListingTableView.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 63;
        
        if (isShowingSearchBar) {
            [self animateSearchBar];
        }
        
        eventsListingTableView.alpha = 0.5;
        eventsListingTableView.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
    [listinSearchBar resignFirstResponder];
}



//*************** Method To Call ABCWaterSites API

- (void) fetchEventsListing {
    
    if (eventsPageCount!=-1) {
        
        eventsPageCount = eventsPageCount + 1;
        NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"Offset",@"SortBy",@"Limit",@"version", nil];
        NSArray *values = [[NSArray alloc] initWithObjects:@"3",[NSString stringWithFormat:@"%ld",eventsPageCount],[NSString stringWithFormat:@"%ld",eventsSortOrder],@"10",@"1.0", nil];
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:BASE_MODULES_API_URL];
    }
}


// Temp Method

- (void) moveToEventDetails {
    
    EventsDetailsViewController *viewObj = [[EventsDetailsViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
    
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/events_listing.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    UIButton *moveToEventDetails = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moveToEventDetails.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [moveToEventDetails addTarget:self action:@selector(moveToEventDetails) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moveToEventDetails];
    
    
    //    if (IS_IPHONE_4_OR_LESS) {
    //        quickMapButton.frame = CGRectMake(10, 75, (self.view.bounds.size.width-30)/2, 105);
    //        cctvButton.frame = CGRectMake(10, 300, (self.view.bounds.size.width-30)/2, 100);
    //        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 75, (self.view.bounds.size.width-30)/2, 210);
    //        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 300, (self.view.bounds.size.width-30)/2, 100);
    //    }
    //    else if (IS_IPHONE_5) {
    //        quickMapButton.frame = CGRectMake(10, 90, (self.view.bounds.size.width-30)/2, 125);
    //        cctvButton.frame = CGRectMake(10, 360, (self.view.bounds.size.width-30)/2, 130);
    //        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 90, (self.view.bounds.size.width-30)/2, 260);
    //        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 360, (self.view.bounds.size.width-30)/2, 130);
    //    }
    //    else if (IS_IPHONE_6) {
    //        quickMapButton.frame = CGRectMake(10, 110, (self.view.bounds.size.width-30)/2, 145);
    //        cctvButton.frame = CGRectMake(10, 430, (self.view.bounds.size.width-30)/2, 150);
    //        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 110, (self.view.bounds.size.width-30)/2, 305);
    //        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 430, (self.view.bounds.size.width-30)/2, 150);
    //    }
    //    else if (IS_IPHONE_6P) {
    //        quickMapButton.frame = CGRectMake(10, 125, (self.view.bounds.size.width-30)/2, 160);
    //        cctvButton.frame = CGRectMake(10, 480, (self.view.bounds.size.width-30)/2, 165);
    //        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 125, (self.view.bounds.size.width-30)/2, 335);
    //        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 480, (self.view.bounds.size.width-30)/2, 165);
    //    }
    
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
        filteredDataSource = [[NSMutableArray alloc] init];
        
        for (int i=0; i<appDelegate.EVENTS_LISTING_ARRAY.count; i++) {
            
            NSRange nameRange = [[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"title"] rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"description"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [filteredDataSource addObject:[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:i]];
            }
        }
    }
    
    [eventsListingTableView reloadData];
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
    
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        NSArray *tempArray = [[responseString JSONValue] objectForKey:EVENTS_RESPONSE_NAME];
        eventsTotalCount = [[[responseString JSONValue] objectForKey:EVENTS_TOTAL_COUNT] intValue];
        
            if (tempArray.count==0) {
                eventsPageCount = 0;
            }
            else {
                eventsPageCount = eventsPageCount + 1;
                if (appDelegate.EVENTS_LISTING_ARRAY.count==0) {
                    [appDelegate.EVENTS_LISTING_ARRAY setArray:tempArray];
                }
                else {
                    if (appDelegate.EVENTS_LISTING_ARRAY.count!=0) {
                        for (int i=0; i<tempArray.count; i++) {
                            [appDelegate.EVENTS_LISTING_ARRAY addObject:[tempArray objectAtIndex:i]];
                        }
                    }
                }
            }
        
        [appDelegate.hud hide:YES];
        [eventsListingTableView reloadData];

        }
    
//    DebugLog(@"%@",responseString);
    DebugLog(@"%ld",appDelegate.EVENTS_LISTING_ARRAY.count);
    DebugLog(@"%@",appDelegate.EVENTS_LISTING_ARRAY);
    // Use when fetching binary data
    //    NSData *responseData = [request responseData];
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    eventsPageCount = -1;
    [appDelegate.hud hide:YES];
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    else if (tableView==eventsListingTableView) {
        return 100.0f;
    }
    
    return 0;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == appDelegate.EVENTS_LISTING_ARRAY.count - 1) {
        if (appDelegate.EVENTS_LISTING_ARRAY.count!=eventsTotalCount) {

            [self fetchEventsListing];
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (isShowingSearchBar) {
        [self animateSearchBar];
        return;
    }
    
    if (tableView==filterTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        selectedFilterIndex = indexPath.row;
        
        [filterTableView reloadData];
        [self animateFilterTable];
        
        [appDelegate.EVENTS_LISTING_ARRAY removeAllObjects];
        eventsSortOrder = indexPath.row+1;
        eventsPageCount = 0;
        
        [self fetchEventsListing];
    }
    else if (tableView==eventsListingTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        EventsDetailsViewController *viewObj = [[EventsDetailsViewController alloc] init];
        
        if (isFiltered) {
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"title"] != (id)[NSNull null])
            viewObj.titleString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"description"] != (id)[NSNull null])
            viewObj.descriptionString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"description"];
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"locationLatitude"] != (id)[NSNull null])
                viewObj.latValue = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"locationLatitude"] doubleValue];
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"locationLongitude"] != (id)[NSNull null])
                viewObj.longValue = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"locationLongitude"] doubleValue];
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"phoneNo"] != (id)[NSNull null])
            viewObj.phoneNoString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"phoneNo"];
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"address"] != (id)[NSNull null])
            viewObj.addressString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"address"];
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"startDate"] != (id)[NSNull null]) {
                viewObj.startDateString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"startDate"];
                viewObj.startDateString = [CommonFunctions dateTimeFromString:viewObj.startDateString];
            }
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"endDate"] != (id)[NSNull null]) {
                viewObj.endDateString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"endDate"];
                viewObj.endDateString = [CommonFunctions dateTimeFromString:viewObj.endDateString];
            }
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null]) {
                viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"]];
                viewObj.imageName = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"];
            }
        }
        else {
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"title"] != (id)[NSNull null])
            viewObj.titleString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"title"];
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"description"] != (id)[NSNull null])
            viewObj.descriptionString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"description"];
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"locationLatitude"] != (id)[NSNull null])
            viewObj.latValue = [[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"locationLatitude"] doubleValue];
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"locationLongitude"] != (id)[NSNull null])
            viewObj.longValue = [[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"locationLongitude"] doubleValue];
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"phoneNo"] != (id)[NSNull null])
            viewObj.phoneNoString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"phoneNo"];
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"address"] != (id)[NSNull null])
            viewObj.addressString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"address"];

            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"startDate"] != (id)[NSNull null]) {
                viewObj.startDateString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"startDate"];
                viewObj.startDateString = [CommonFunctions dateTimeFromString:viewObj.startDateString];
            }
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"endDate"] != (id)[NSNull null]) {
                viewObj.endDateString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"endDate"];
                viewObj.endDateString = [CommonFunctions dateTimeFromString:viewObj.endDateString];
            }
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null]) {
                viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"]];
                viewObj.imageName = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"];
            }
        }
        
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==eventsListingTableView) {
        if (isFiltered) {
            return filteredDataSource.count;
        }
        else {
            return appDelegate.EVENTS_LISTING_ARRAY.count;
        }
    }
    else if (tableView==filterTableView) {
        return filtersArray.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    UITableViewCell *cell;
    
    if (tableView==filterTableView) {
    
//        cell = [tableView dequeueReusableCellWithIdentifier:@"filterCells"];
//        
//        if (cell==nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterCells"];
//        }
        
        cell.backgroundColor = [UIColor blackColor];//RGB(247, 247, 247);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, filterTableView.bounds.size.width-10, cell.bounds.size.height)];
        titleLabel.text = [filtersArray objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row==selectedFilterIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5, filterTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
    }
    else if (tableView==eventsListingTableView) {
        
//        cell = [tableView dequeueReusableCellWithIdentifier:@"eventCells"];
//        
//        if (cell==nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventCells"];
//        }
        
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 80, 80)];
        
        NSString *imageURLString,*imageName;
        if (isFiltered) {
            imageName = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"];
            imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"]];
        }
        else {
            imageName = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"];
            imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"]];
        }
        [cell.contentView addSubview:cellImage];
        
        
        NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
        NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Events"]];
        
        NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
            if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
        }
        
        else {
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.center = CGPointMake(cellImage.bounds.size.width/2, cellImage.bounds.size.height/2);
            [cellImage addSubview:activityIndicator];
            [activityIndicator startAnimating];
            
            [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    
                    cellImage.image = image;
                    
                    DebugLog(@"Path %@",destinationPath);
                    
                    NSFileManager *fileManger=[NSFileManager defaultManager];
                    NSError* error;
                    
                    if (![fileManger fileExistsAtPath:destinationPath]){
                        
                        if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                            ;// success
                        else
                        {
                            DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                        }
                    }
                    
                    NSData *data = UIImageJPEGRepresentation(image, 0.8);
                    [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
                }
                else {
                    DebugLog(@"Image Loading Failed..!!");
                    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
                }
                [activityIndicator stopAnimating];
            }];
        }

        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, eventsListingTableView.bounds.size.width-100, 40)];
        if (isFiltered) {
            titleLabel.text = [NSString stringWithFormat:@"%@",[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"title"]];
        }
        else {
            titleLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"title"]];
        }
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        NSString *startDateString,*endDateString;
        if (isFiltered) {
            startDateString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"startDate"];
            endDateString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"endDate"];
        }
        else {
            startDateString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"startDate"];
            endDateString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"endDate"];
        }
        
        startDateString = [CommonFunctions dateTimeFromString:startDateString];
        endDateString = [CommonFunctions dateTimeFromString:endDateString];
        
        UILabel *startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, eventsListingTableView.bounds.size.width-100, 20)];
        startDateLabel.text = [NSString stringWithFormat:@"Start: %@",startDateString];
        startDateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        startDateLabel.backgroundColor = [UIColor clearColor];
        startDateLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:startDateLabel];
        [startDateLabel sizeToFit];

        
        UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 70, eventsListingTableView.bounds.size.width-100, 20)];
        endDateLabel.text = [NSString stringWithFormat:@"End: %@",endDateString];
        endDateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        endDateLabel.backgroundColor = [UIColor clearColor];
        endDateLabel.textColor = [UIColor darkGrayColor];
        endDateLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:endDateLabel];
        [endDateLabel sizeToFit];

        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99.5, eventsListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
    }
    
    return cell;
}

# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    eventsPageCount = 0;
    
    UIButton *btnSearch =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setImage:[UIImage imageNamed:@"icn_search"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(animateSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setFrame:CGRectMake(0, 0, 32, 32)];
    
    UIButton *btnfilter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnfilter setImage:[UIImage imageNamed:@"icn_filter"] forState:UIControlStateNormal];
    [btnfilter addTarget:self action:@selector(animateFilterTable) forControlEvents:UIControlEventTouchUpInside];
    [btnfilter setFrame:CGRectMake(44, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:btnSearch];
    [rightBarButtonItems addSubview:btnfilter];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    //    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    
    self.view.backgroundColor = RGB(247, 247, 247);
    selectedFilterIndex = 0;
    eventsSortOrder = 1;
    
    eventsListingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    eventsListingTableView.delegate = self;
    eventsListingTableView.dataSource = self;
    [self.view addSubview:eventsListingTableView];
    eventsListingTableView.backgroundColor = [UIColor clearColor];
    eventsListingTableView.backgroundView = nil;
    eventsListingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -128, self.view.bounds.size.width, 128) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    
    filtersArray = [[NSArray alloc] initWithObjects:@"Date",@"Name",@"Distance", nil];
    
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

    [self fetchEventsListing];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    //    if (!isNotEventController) {
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    //    }
    //    else {
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    self.title = @"Events";
    
    //        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    //
    //    }
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
