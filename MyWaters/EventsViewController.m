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




//*************** Method For Pull To Refresh

- (void) pullToRefreshTable {
    
    // Reload table data
    [eventsListingTableView reloadData];
    
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


//*************** Method For Saving ABC Water Sites Data

- (void) saveEventsData {
    
    [appDelegate insertEventsData:appDelegate.EVENTS_LISTING_ARRAY];
}



//*************** Method To Animate Search Bar

- (void) animateSearchBar {
    
    [UIView beginAnimations:@"searchbar" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = listinSearchBar.center;
    
    if (isShowingSearchBar) {
        isShowingSearchBar = NO;
        pos.y = -100;
        
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
        pos.y = -220;
        
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
    
    
    if ([CommonFunctions hasConnectivity]) {
        
        [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
        //    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
        //    appDelegate.hud.labelText = @"Loading...";
        
        NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"PushToken",@"version", nil];
        NSArray *values = [[NSArray alloc] initWithObjects:@"3",[[SharedObject sharedClass] getPUBUserSavedDataValue:@"device_token"],[CommonFunctions getAppVersionNumber], nil];
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
        
        [self pullToRefreshTable];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
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
        if(filteredDataSource.count!=0)
            [filteredDataSource removeAllObjects];
        
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
    
    [textField resignFirstResponder];
    [self animateSearchBar];
    return YES;
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [CommonFunctions dismissGlobalHUD];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        NSArray *tempArray = [[responseString JSONValue] objectForKey:EVENTS_RESPONSE_NAME];
        //        eventsTotalCount = [[[responseString JSONValue] objectForKey:EVENTS_TOTAL_COUNT] intValue];
        
        if (tempArray.count==0) {
            //                eventsPageCount = 0;
        }
        else {
            //                eventsPageCount = eventsPageCount + 1;
            
            if (appDelegate.EVENTS_LISTING_ARRAY.count!=0)
                [appDelegate.EVENTS_LISTING_ARRAY removeAllObjects];
            
            [appDelegate.EVENTS_LISTING_ARRAY setArray:tempArray];
            
            CLLocationCoordinate2D currentLocation;
            currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
            currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
            
            
            for (int idx = 0; idx<[appDelegate.EVENTS_LISTING_ARRAY count];idx++) {
                
                NSMutableDictionary *dict = [appDelegate.EVENTS_LISTING_ARRAY[idx] mutableCopy];
                
                CLLocationCoordinate2D desinationLocation;
                desinationLocation.latitude = [dict[@"locationLatitude"] doubleValue];
                desinationLocation.longitude = [dict[@"locationLongitude"] doubleValue];
                
                
                dict[@"distance"] = [CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation];//[NSString stringWithFormat:@"%@",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                appDelegate.EVENTS_LISTING_ARRAY[idx] = dict;
                
            }
            
            
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
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
            
            [appDelegate.EVENTS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDate,sortByName,sortByDistance,nil]];
            
            // Temp commented for UAT
            //            if (appDelegate.EVENTS_LISTING_ARRAY.count!=0)
            //                [self performSelectorInBackground:@selector(saveEventsData) withObject:nil];
            
            
            [eventsListingTableView reloadData];
            [self.refreshControl endRefreshing];
            
        }
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"Ok" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    //    eventsPageCount = -1;
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"Ok" otherButton:nil];
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 44.0f;
    }
    else if (tableView==eventsListingTableView) {
        
        float titleHeight = 0.0;
        float subTitleHeight = 0.0;
        float dateHeight = 0.0;
        int subtractComponent = 0;
        
        if (isFiltered) {
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"title"] != (id)[NSNull null]) {
                titleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"title"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:14.0] withinWidth:eventsListingTableView.bounds.size.width-85];
                subtractComponent = subtractComponent + 25;
            }
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"startDate"] != (id)[NSNull null]) {
                subTitleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"startDate"]]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:eventsListingTableView.bounds.size.width-90];
                subtractComponent = subtractComponent + 25;
            }
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"endDate"] != (id)[NSNull null]) {
                dateHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"endDate"]]] font:[UIFont fontWithName:ROBOTO_REGULAR size:13.0] withinWidth:eventsListingTableView.bounds.size.width-85];
                subtractComponent = subtractComponent + 25;
            }
            
            if ((titleHeight+subTitleHeight+dateHeight) < 100) {
                return 100.0f;
            }
            
            return titleHeight+subTitleHeight+dateHeight-subtractComponent;
            
        }
        else {
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"title"] != (id)[NSNull null]) {
                titleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"title"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:14.0] withinWidth:eventsListingTableView.bounds.size.width-85];
                subtractComponent = subtractComponent + 25;
            }
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"startDate"] != (id)[NSNull null]) {
                subTitleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"startDate"]]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:eventsListingTableView.bounds.size.width-90];
                subtractComponent = subtractComponent + 25;
            }
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"endDate"] != (id)[NSNull null]) {
                dateHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"endDate"]]] font:[UIFont fontWithName:ROBOTO_REGULAR size:13.0] withinWidth:eventsListingTableView.bounds.size.width-85];
                subtractComponent = subtractComponent + 25;
            }
            
            if ((titleHeight+subTitleHeight+dateHeight) < 100) {
                return 100.0f;
            }
            
            return titleHeight+subTitleHeight+dateHeight-subtractComponent;
        }
        
    }
    
    return 0;
}


//-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if ([indexPath row] == appDelegate.EVENTS_LISTING_ARRAY.count - 1) {
//        if (appDelegate.EVENTS_LISTING_ARRAY.count!=eventsTotalCount) {
//
//            [self fetchEventsListing];
//        }
//    }
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (isShowingSearchBar) {
    //        [self animateSearchBar];
    //        return;
    //    }
    
    if (tableView==filterTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        selectedFilterIndex = indexPath.row;
        
        if (indexPath.row==0) {
            
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
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
            
            [appDelegate.EVENTS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDate,sortByName,sortByDistance,nil]];
        }
        else if (indexPath.row==1) {
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
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
            
            [appDelegate.EVENTS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,sortByDate,sortByDistance,nil]];
        }
        else if (indexPath.row==2) {
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
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
            
            [appDelegate.EVENTS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,sortByDate,sortByName,nil]];
        }
        
        [self animateFilterTable];
        [filterTableView reloadData];
        [eventsListingTableView reloadData];
        [eventsListingTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        
    }
    else if (tableView==eventsListingTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (isShowingSearchBar) {
            [self animateSearchBar];
        }
        
        EventsDetailsViewController *viewObj = [[EventsDetailsViewController alloc] init];
        
        if (isFiltered) {
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"id"] != (id)[NSNull null])
                viewObj.eventID = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"id"];
            
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
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"location"] != (id)[NSNull null])
                viewObj.addressString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"location"];
            
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
            
            if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] != (id)[NSNull null])
                viewObj.isSubscribed = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] intValue];
            
        }
        else {
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"id"] != (id)[NSNull null])
                viewObj.eventID = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"id"];
            
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
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"location"] != (id)[NSNull null])
                viewObj.addressString = [[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"location"];
            
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
            
            if ([[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] != (id)[NSNull null])
                viewObj.isSubscribed = [[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] intValue];
            
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
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, filterTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
    }
    else if (tableView==eventsListingTableView) {
        
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
        
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 9, eventsListingTableView.bounds.size.width-110, 40)];
        if (isFiltered) {
            titleLabel.text = [NSString stringWithFormat:@"%@",[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"title"]];
        }
        else {
            titleLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"title"]];
        }
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        
        
        CGRect newTitleLabelLabelFrame = titleLabel.frame;
        if (isFiltered) {
            newTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"title"]] font:titleLabel.font withinWidth:eventsListingTableView.bounds.size.width-110];
        }
        else {
            newTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[appDelegate.EVENTS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"title"]] font:titleLabel.font withinWidth:eventsListingTableView.bounds.size.width-110];
        }
        titleLabel.frame = newTitleLabelLabelFrame;
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
        
        UILabel *startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, titleLabel.bounds.origin.y+titleLabel.bounds.size.height+10, eventsListingTableView.bounds.size.width-110, 40)];
        startDateLabel.text = [NSString stringWithFormat:@"Start: %@\nEnd: %@",startDateString,endDateString];
        startDateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        startDateLabel.backgroundColor = [UIColor clearColor];
        startDateLabel.numberOfLines = 0;
        startDateLabel.textColor = [UIColor darkGrayColor];
        
        
        CGRect newStartDateLabelLabelFrame = startDateLabel.frame;
        newStartDateLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"Start: %@\nEnd: %@",startDateString,endDateString] font:startDateLabel.font withinWidth:eventsListingTableView.bounds.size.width-110];//expectedDescriptionLabelSize.height;
        startDateLabel.frame = newStartDateLabelLabelFrame;
        [cell.contentView addSubview:startDateLabel];
        [startDateLabel sizeToFit];
        
        
//        UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, startDateLabel.bounds.origin.y+startDateLabel.bounds.size.height+10, eventsListingTableView.bounds.size.width-110, 20)];
//        endDateLabel.text = [NSString stringWithFormat:@"End: %@",endDateString];
//        endDateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
//        endDateLabel.backgroundColor = [UIColor clearColor];
//        endDateLabel.textColor = [UIColor darkGrayColor];
//        endDateLabel.textAlignment = NSTextAlignmentLeft;
//        
//        CGRect newEndDateLabelLabelFrame = endDateLabel.frame;
//        newEndDateLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",endDateString] font:endDateLabel.font withinWidth:eventsListingTableView.bounds.size.width-110];//expectedDescriptionLabelSize.height;
//        endDateLabel.frame = newEndDateLabelLabelFrame;
//        [cell.contentView addSubview:endDateLabel];
//        [endDateLabel sizeToFit];
        
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-0.5, eventsListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
    }
    
    return cell;
}


# pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [self animateSearchBar];
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
    [btnSearch setFrame:CGRectMake(44, 0, 32, 32)];
    
    UIButton *btnfilter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnfilter setImage:[UIImage imageNamed:@"icn_filter"] forState:UIControlStateNormal];
    [btnfilter addTarget:self action:@selector(animateFilterTable) forControlEvents:UIControlEventTouchUpInside];
    [btnfilter setFrame:CGRectMake(0, 0, 32, 32)];
    
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
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -200, self.view.bounds.size.width, 128) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    filterTableView.scrollEnabled = NO;
    filterTableView.alwaysBounceVertical = NO;
    
    
    filtersArray = [[NSArray alloc] initWithObjects:@"Date",@"Name",@"Distance", nil];
    filteredDataSource = [[NSMutableArray alloc] init];
    
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
                            action:@selector(fetchEventsListing)
                  forControlEvents:UIControlEventValueChanged];
    [eventsListingTableView addSubview:self.refreshControl];
    
    
    [self fetchEventsListing];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [appDelegate setShouldRotate:NO];
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
