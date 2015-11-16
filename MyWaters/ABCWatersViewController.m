//
//  ABCWatersViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 23/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ABCWatersViewController.h"
#import "ViewControllerHelper.h"

@interface ABCWatersViewController ()

@end

@implementation ABCWatersViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
    [listinSearchBar resignFirstResponder];
}



//*************** Method For Saving ABC Water Sites Data

- (void) saveABCWaterData {
    
    [appDelegate insertABCWatersData:appDelegate.ABC_WATERS_LISTING_ARRAY];
}



//*************** Method For Pull To Refresh

- (void) pullToRefreshTable {
    
    // Reload table data
    [listTabeView reloadData];
    
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


//*************** Method To Call ABCWaterSites API

- (void) fetchABCWaterSites {
    
    NSArray *parameters,*values;
    
    //    if (selectedFilterIndex==0) {
    parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"SortBy",@"version", nil];
    values = [[NSArray alloc] initWithObjects:@"2",@"2",[CommonFunctions getAppVersionNumber], nil];
    //    }
    //
    //    else if (selectedFilterIndex==1) {
    //
    //        CLLocationCoordinate2D coordinate = [CommonFunctions getUserCurrentLocation];
    //        NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    //        NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    //
    //        parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"SortBy",@"version",@"Lat",@"Lon", nil];
    //        values = [[NSArray alloc] initWithObjects:@"2",@"3",@"1.0",latitude,longitude, nil];
    //    }
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
    [self pullToRefreshTable];
}


//*************** Method To Handle Segmented Control Action

- (void) handleSegmentedControl:(UISegmentedControl*) sender {
    
    if (sender==gridListSegmentedControl) {
        
        if (sender.selectedSegmentIndex==0) {
            isShowingGrid = YES;
            isShowingTable = NO;
            listTabeView.hidden = YES;
            abcWatersScrollView.hidden = NO;
            [self createGridView];
            
        }
        else if (sender.selectedSegmentIndex==1) {
            isShowingGrid = NO;
            isShowingTable = YES;
            listTabeView.hidden = NO;
            abcWatersScrollView.hidden = YES;
            //            [appDelegate retrieveABCWatersListing];
            [listTabeView reloadData];
        }
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
        
        listTabeView.alpha = 1.0;
        listTabeView.userInteractionEnabled = YES;
        
        [listinSearchBar resignFirstResponder];
    }
    else {
        isShowingSearchBar = YES;
        pos.y = 20;
        
        if (isShowingFilter) {
            [self animateFilterTable];
        }
        
        //        listTabeView.alpha = 0.5;
        //        listTabeView.userInteractionEnabled = NO;
        
        [listinSearchBar becomeFirstResponder];
    }
    listinSearchBar.center = pos;
    [UIView commitAnimations];
}

//*************** Method To Animate Filter Table

- (void) animateFilterTable {
    
    listinSearchBar.text = @"";
    isFiltered = NO;
    [listTabeView reloadData];
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -130;
        hideFilterButton.hidden = YES;
        
        listTabeView.alpha = 1.0;
        listTabeView.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 45;
        hideFilterButton.hidden = NO;
        
        if (isShowingSearchBar) {
            [self animateSearchBar];
        }
        
        listTabeView.alpha = 0.5;
//        listTabeView.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}

//*************** Method To Move To ABC Water Detail View

- (void) moveToDetailsView:(id) sender {
    
    UIButton *button = (id) sender;
    
    
    if (!isShowingFilter) {
        ABCWaterDetailViewController *viewObj = [[ABCWaterDetailViewController alloc] init];
        
        if (isFiltered) {
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"id"] != (id)[NSNull null])
                viewObj.abcSiteId = [[filteredDataSource objectAtIndex:button.tag] objectForKey:@"id"];
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"siteName"] != (id)[NSNull null])
                viewObj.titleString = [[filteredDataSource objectAtIndex:button.tag] objectForKey:@"siteName"];
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"description"] != (id)[NSNull null])
                viewObj.descriptionString = [[filteredDataSource objectAtIndex:button.tag] objectForKey:@"description"];
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"locationLatitude"] != (id)[NSNull null])
                viewObj.latValue = [[[filteredDataSource objectAtIndex:button.tag] objectForKey:@"locationLatitude"] doubleValue];
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"locationLongitude"] != (id)[NSNull null])
                viewObj.longValue = [[[filteredDataSource objectAtIndex:button.tag] objectForKey:@"locationLongitude"] doubleValue];
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"phoneNo"] != (id)[NSNull null])
                viewObj.phoneNoString = [[filteredDataSource objectAtIndex:button.tag] objectForKey:@"phoneNo"];
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"address"] != (id)[NSNull null])
                viewObj.addressString = [[filteredDataSource objectAtIndex:button.tag] objectForKey:@"address"];
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"image"] != (id)[NSNull null]) {
                viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[filteredDataSource objectAtIndex:button.tag] objectForKey:@"image"]];
                viewObj.imageName = [[filteredDataSource objectAtIndex:button.tag] objectForKey:@"image"];
            }
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"isCertified"] != (id)[NSNull null])
                viewObj.isCertified = [[[filteredDataSource objectAtIndex:button.tag] objectForKey:@"isCertified"] intValue];
            
            if ([[filteredDataSource objectAtIndex:button.tag] objectForKey:@"hasPOI"] != (id)[NSNull null])
                viewObj.isHavingPOI = [[[filteredDataSource objectAtIndex:button.tag] objectForKey:@"hasPOI"] intValue];
            
        }
        else {
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"id"] != (id)[NSNull null])
                viewObj.abcSiteId = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"id"];
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"siteName"] != (id)[NSNull null])
                viewObj.titleString = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"siteName"];
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"description"] != (id)[NSNull null])
                viewObj.descriptionString = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"description"];
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"locationLatitude"] != (id)[NSNull null])
                viewObj.latValue = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"locationLatitude"] doubleValue];
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"locationLongitude"] != (id)[NSNull null])
                viewObj.longValue = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"locationLongitude"] doubleValue];
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"phoneNo"] != (id)[NSNull null])
                viewObj.phoneNoString = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"phoneNo"];
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"address"] != (id)[NSNull null])
                viewObj.addressString = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"address"];
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"image"] != (id)[NSNull null]) {
                viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"image"]];
                viewObj.imageName = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"image"];
            }
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"isCertified"] != (id)[NSNull null])
                viewObj.isCertified = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"isCertified"] intValue];
            
            if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"hasPOI"] != (id)[NSNull null])
                viewObj.isHavingPOI = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:button.tag] objectForKey:@"hasPOI"] intValue];
            
        }
        
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else {
        [self animateFilterTable];
    }
}




//*************** Method For Removing Filter Table For WLS

- (void) hideFilterTable {
    
    if (isShowingFilter) {
        [self animateFilterTable];
    }
}



//*************** Method To Create Grid View For ABC Waters

- (void) createGridView {
    
    for (UIView * view in abcWatersScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int gridCount = 0;
    float xAxis = 0.30;
    float yAxis = 0;
    
    if (isFiltered) {
        
        if (filteredDataSource.count !=0) {
            
            for (int i=0; i<filteredDataSource.count; i++) {
                
                UIImageView *gridImage = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (segmentedControlBackground.bounds.size.width-2)/3, (segmentedControlBackground.bounds.size.width-2)/3)];
                
                NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
                NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ABCWaters"]];
                
                NSString *localFile = [destinationPath stringByAppendingPathComponent:[[filteredDataSource objectAtIndex:i] objectForKey:@"image"]];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
                    if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:[[filteredDataSource objectAtIndex:i] objectForKey:@"image"]]] != nil)
                        gridImage.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:[[filteredDataSource objectAtIndex:i] objectForKey:@"image"]]];
                }
                else {
                    
                    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[filteredDataSource objectAtIndex:i] objectForKey:@"image"]];
                    
                    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    activityIndicator.center = CGPointMake(gridImage.bounds.size.width/2, gridImage.bounds.size.height/2);
                    [gridImage addSubview:activityIndicator];
                    [activityIndicator startAnimating];
                    
                    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                        if (succeeded) {
                            
                            gridImage.image = image;
                            
                            
                            
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
                            [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[filteredDataSource objectAtIndex:i] objectForKey:@"image"]]] atomically:YES];
                        }
                        else {
                            DebugLog(@"Image Loading Failed..!!");
                            gridImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
                        }
                        [activityIndicator stopAnimating];
                    }];
                }
                
                [abcWatersScrollView addSubview:gridImage];
                gridImage.userInteractionEnabled = YES;
                
                UIImageView *certifiedLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 29.5, 12.5)];
                [certifiedLogo setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwater_certified_logo.png",appDelegate.RESOURCE_FOLDER_PATH]]];
                [gridImage addSubview:certifiedLogo];
                if (![[[filteredDataSource objectAtIndex:i] objectForKey:@"isCertified"] intValue]) {
                    certifiedLogo.hidden = YES;
                }
                
                UIButton *gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
                gridButton.frame = CGRectMake(0, 0, gridImage.bounds.size.width, gridImage.bounds.size.height);
                gridButton.tag = i;
                [gridButton addTarget:self action:@selector(moveToDetailsView:) forControlEvents:UIControlEventTouchUpInside];
                [gridImage addSubview:gridButton];
                
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, gridButton.bounds.size.height-40, gridButton.bounds.size.width-10, 40)];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.text = [NSString stringWithFormat:@"%@",[[filteredDataSource objectAtIndex:i] objectForKey:@"siteName"]];
                nameLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                nameLabel.textColor = [UIColor whiteColor];
                nameLabel.textAlignment = NSTextAlignmentCenter;
                nameLabel.numberOfLines = 0;
                [gridButton addSubview:nameLabel];
                
                gridCount = gridCount + 1;
                if (gridCount!=3) {
                    xAxis = xAxis + (segmentedControlBackground.bounds.size.width)/3;
                }
                else {
                    xAxis = 0.25;
                    gridCount = 0;
                    yAxis = yAxis +(segmentedControlBackground.bounds.size.width)/3;
                }
            }
        }
    }
    else {
        if (appDelegate.ABC_WATERS_LISTING_ARRAY.count !=0) {
            
            for (int i=0; i<appDelegate.ABC_WATERS_LISTING_ARRAY.count; i++) {
                
                UIImageView *gridImage = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (segmentedControlBackground.bounds.size.width-2)/3, (segmentedControlBackground.bounds.size.width-2)/3)];
                
                NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
                NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ABCWaters"]];
                
                NSString *localFile = [destinationPath stringByAppendingPathComponent:[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
                    if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]]] != nil)
                        gridImage.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]]];
                }
                else {
                    
                    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]];
                    
                    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    activityIndicator.center = CGPointMake(gridImage.bounds.size.width/2, gridImage.bounds.size.height/2);
                    [gridImage addSubview:activityIndicator];
                    [activityIndicator startAnimating];
                    
                    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                        if (succeeded) {
                            
                            gridImage.image = image;
                            
                            
                            
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
                            [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]]] atomically:YES];
                        }
                        else {
                            DebugLog(@"Image Loading Failed..!!");
                            gridImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
                        }
                        [activityIndicator stopAnimating];
                    }];
                }
                
                [abcWatersScrollView addSubview:gridImage];
                gridImage.userInteractionEnabled = YES;
                
                UIImageView *certifiedLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 29.5, 12.5)];
                [certifiedLogo setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwater_certified_logo.png",appDelegate.RESOURCE_FOLDER_PATH]]];
                [gridImage addSubview:certifiedLogo];
                if (![[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"isCertified"] intValue]) {
                    certifiedLogo.hidden = YES;
                }
                
                UIButton *gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
                gridButton.frame = CGRectMake(0, 0, gridImage.bounds.size.width, gridImage.bounds.size.height);
                gridButton.tag = i;
                [gridButton addTarget:self action:@selector(moveToDetailsView:) forControlEvents:UIControlEventTouchUpInside];
                [gridImage addSubview:gridButton];
                
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, gridButton.bounds.size.height-40, gridButton.bounds.size.width-10, 40)];
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"siteName"]];
                nameLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                nameLabel.textColor = [UIColor whiteColor];
                nameLabel.textAlignment = NSTextAlignmentCenter;
                nameLabel.numberOfLines = 0;
                [gridButton addSubview:nameLabel];
                
                gridCount = gridCount + 1;
                if (gridCount!=3) {
                    xAxis = xAxis + (segmentedControlBackground.bounds.size.width)/3;
                }
                else {
                    xAxis = 0.30;
                    gridCount = 0;
                    yAxis = yAxis +(segmentedControlBackground.bounds.size.width)/3;
                }
            }
        }
    }
    
    [abcWatersScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, yAxis+segmentedControlBackground.bounds.size.width/3+65)];
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    DebugLog(@"%@",responseString);
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [appDelegate.ABC_WATERS_LISTING_ARRAY removeAllObjects];
        
        NSArray *tempArray = [[responseString JSONValue] objectForKey:ABC_WATER_SITES_RESPONSE_NAME];
        abcWatersTotalCount = [[[responseString JSONValue] objectForKey:ABC_WATER_SITES_TOTAL_COUNT] intValue];
        
        
        if (tempArray.count==0) {
            //            abcWatersPageCount = 0;
        }
        else {
            //            abcWatersPageCount = abcWatersPageCount + 1;
            if (appDelegate.ABC_WATERS_LISTING_ARRAY.count!=0)
                [appDelegate.ABC_WATERS_LISTING_ARRAY removeAllObjects];
            
            [appDelegate.ABC_WATERS_LISTING_ARRAY setArray:tempArray];
            
            
            CLLocationCoordinate2D currentLocation;
            currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
            currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
            
            DebugLog(@"%f---%f",appDelegate.CURRENT_LOCATION_LAT,appDelegate.CURRENT_LOCATION_LONG);
            DebugLog(@"%f---%f",currentLocation.latitude,currentLocation.longitude);
            
            for (int idx = 0; idx<[appDelegate.ABC_WATERS_LISTING_ARRAY count];idx++) {
                
                NSMutableDictionary *dict = [appDelegate.ABC_WATERS_LISTING_ARRAY[idx] mutableCopy];
                
                CLLocationCoordinate2D desinationLocation;
                desinationLocation.latitude = [dict[@"locationLatitude"] doubleValue];
                desinationLocation.longitude = [dict[@"locationLongitude"] doubleValue];
                
                DebugLog(@"%f---%f",desinationLocation.latitude,desinationLocation.longitude);
                
                dict[@"distance"] = [CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation];//[NSString stringWithFormat:@"%@",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                appDelegate.ABC_WATERS_LISTING_ARRAY[idx] = dict;
                
            }
            
            DebugLog(@"%@",appDelegate.ABC_WATERS_LISTING_ARRAY);
            
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"siteName" ascending:YES];
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
            
            if (selectedFilterIndex==0)
                [appDelegate.ABC_WATERS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,nil]];
            else
                [appDelegate.ABC_WATERS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,nil]];
            // Temp commented for UAT
            //            if (appDelegate.ABC_WATERS_LISTING_ARRAY.count!=0)
            //                [self performSelectorInBackground:@selector(saveABCWaterData) withObject:nil];
            
        }
        [CommonFunctions dismissGlobalHUD];
        //        [appDelegate.hud hide:YES];
        [self createGridView];
        [self.refreshControl endRefreshing];
    }
    
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    //    [appDelegate.hud hide:YES];
    [CommonFunctions dismissGlobalHUD];
}


# pragma mark - UISearchBarDelegate Methods

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        if(filteredDataSource.count!=0)
            [filteredDataSource removeAllObjects];
        
        for (int i=0; i<appDelegate.ABC_WATERS_LISTING_ARRAY.count; i++) {
            
            NSRange nameRange = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"siteName"] rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"description"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [filteredDataSource addObject:[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i]];
            }
        }
    }
    
    if (isShowingTable)
        [listTabeView reloadData];
    else if (isShowingGrid)
        [self createGridView];
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self animateSearchBar];
    return YES;
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 44.0f;
    }
    else if (tableView==listTabeView) {
        return 80.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==filterTableView) {
        
        selectedFilterIndex = indexPath.row;
        
        if (isShowingFilter) {
            [self animateFilterTable];
        }
        
        if (indexPath.row==0) {
            
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"siteName" ascending:YES];
            //            NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES comparator:^(id left, id right) {
            //                float v1 = [left floatValue];
            //                float v2 = [right floatValue];
            //                if (v1 < v2)
            //                    return NSOrderedAscending;
            //                else if (v1 > v2)
            //                    return NSOrderedDescending;
            //                else
            //                    return NSOrderedSame;
            //            }];
            
            //            [appDelegate.ABC_WATERS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,sortByDistance,nil]];
            [appDelegate.ABC_WATERS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,nil]];
            
            
            [filterTableView reloadData];
            
            if (isShowingGrid) {
                [self createGridView];
            }
            else if (isShowingTable) {
                [listTabeView reloadData];
                [listTabeView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            }
        }
        else if (indexPath.row==1) {
            
            if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
                //            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"siteName" ascending:YES];
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
                
                //            [appDelegate.ABC_WATERS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,sortByName,nil]];
                [appDelegate.ABC_WATERS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,nil]];
                
                [filterTableView reloadData];
                
                if (isShowingGrid) {
                    [self createGridView];
                }
                else if (isShowingTable) {
                    [listTabeView reloadData];
                    [listTabeView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                }
            }
            else {
                
                [self animateFilterTable];
                [CommonFunctions showAlertView:nil title:nil msg:@"Turn on location to filter by distance." cancel:@"OK" otherButton:nil];
            }
        }
        
        
    }
    else {
        
        if (isShowingSearchBar) {
            [self animateSearchBar];
        }
        
        
        if (!isShowingFilter) {
            ABCWaterDetailViewController *viewObj = [[ABCWaterDetailViewController alloc] init];
            
            if (isFiltered) {
                
                if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"id"] != (id)[NSNull null])
                    viewObj.abcSiteId = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"id"];
                
                if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"siteName"] != (id)[NSNull null])
                    viewObj.titleString = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"siteName"];
                
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
                
                if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null]) {
                    viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"]];
                    viewObj.imageName = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"];
                }
                
                if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"isCertified"] != (id)[NSNull null])
                    viewObj.isCertified = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"isCertified"] intValue];
                
                if ([[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"hasPOI"] != (id)[NSNull null])
                    viewObj.isHavingPOI = [[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"hasPOI"] intValue];
                
            }
            else {
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"id"] != (id)[NSNull null])
                    viewObj.abcSiteId = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"id"];
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"siteName"] != (id)[NSNull null])
                    viewObj.titleString = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"siteName"];
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"description"] != (id)[NSNull null])
                    viewObj.descriptionString = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"description"];
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"locationLatitude"] != (id)[NSNull null])
                    viewObj.latValue = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"locationLatitude"] doubleValue];
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"locationLongitude"] != (id)[NSNull null])
                    viewObj.longValue = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"locationLongitude"] doubleValue];
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"phoneNo"] != (id)[NSNull null])
                    viewObj.phoneNoString = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"phoneNo"];
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"address"] != (id)[NSNull null])
                    viewObj.addressString = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"address"];
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null]) {
                    viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"]];
                    viewObj.imageName = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"];
                }
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"isCertified"] != (id)[NSNull null])
                    viewObj.isCertified = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"isCertified"] intValue];
                
                if ([[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"hasPOI"] != (id)[NSNull null])
                    viewObj.isHavingPOI = [[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"hasPOI"] intValue];
                
            }
            
            [self.navigationController pushViewController:viewObj animated:YES];
        }
        else {
            [self animateFilterTable];
        }
    }
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==listTabeView) {
        if (isFiltered) {
            return filteredDataSource.count;
        }
        else {
            return appDelegate.ABC_WATERS_LISTING_ARRAY.count;
        }
    }
    else if (tableView==filterTableView) {
        return filtersArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abclisting"];
    
    
    if (tableView==filterTableView) {
        
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
    
    else {
        
        
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 60)];
        
        NSString *imageURLString,*imageName;
        if (isFiltered) {
            imageName = [[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"];
            imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"image"]];
        }
        else {
            imageName = [[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"];
            imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"]];
        }
        
        DebugLog(@"Image Url-%@",imageURLString);
        [cell.contentView addSubview:cellImage];
        
        
        NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
        NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ABCWaters"]];
        
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
        
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, listTabeView.bounds.size.width-100, 50)];
        if (isFiltered) {
            titleLabel.text = [NSString stringWithFormat:@"%@",[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"siteName"]];
        }
        else {
            titleLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"siteName"]];
        }
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        
        
        UIImageView *certifiedLogo = [[UIImageView alloc] initWithFrame:CGRectMake(80, 55, 42.5, 20.5)];
        [certifiedLogo setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwater_certified_logo.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        [cell.contentView addSubview:certifiedLogo];
        
        if (isFiltered) {
            if (![[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"isCertified"] intValue]) {
                certifiedLogo.hidden = YES;
            }
        }
        else {
            if (![[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"isCertified"] intValue]) {
                certifiedLogo.hidden = YES;
            }
        }
        
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, listTabeView.bounds.size.width-100, 20)];
        subTitleLabel.textColor = [UIColor lightGrayColor];
        if (isFiltered) {
            subTitleLabel.text = [NSString stringWithFormat:@"%@ KM",[[filteredDataSource objectAtIndex:indexPath.row] objectForKey:@"distance"]];
        }
        else {
            subTitleLabel.text = [NSString stringWithFormat:@"%@ KM",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"distance"]];
        }
        subTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.numberOfLines = 0;
        subTitleLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:subTitleLabel];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            
            subTitleLabel.text = @"";
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, listTabeView.bounds.size.width, 0.5)];
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
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    self.view.backgroundColor = RGB(247, 247, 247);
    
    isShowingTable = NO;
    isShowingGrid = YES;
    
    selectedFilterIndex = 0;
    
    UIButton *btnfilter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnfilter setImage:[UIImage imageNamed:@"icn_filter"] forState:UIControlStateNormal];
    [btnfilter addTarget:self action:@selector(animateFilterTable) forControlEvents:UIControlEventTouchUpInside];
    [btnfilter setFrame:CGRectMake(0, 0, 32, 32)];
    
    UIButton *btnSearch =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setImage:[UIImage imageNamed:@"icn_search"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(animateSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setFrame:CGRectMake(44, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:btnfilter];
    [rightBarButtonItems addSubview:btnSearch];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    segmentedControlBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    segmentedControlBackground.backgroundColor = RGB(76,175,238);//RGB(229,0,87);//RGB(52, 156, 249);
    [self.view addSubview:segmentedControlBackground];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"GRID", @"LIST", nil];
    
    gridListSegmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    if (IS_IPHONE_4_OR_LESS) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-85, 12.5, 170, 25);
    }
    else if (IS_IPHONE_5) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-90, 12.5, 180, 25);
    }
    else if (IS_IPHONE_6) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-100, 12.5, 200, 25);
    }
    else if (IS_IPHONE_6P) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-110, 12.5, 220, 25);
    }
    gridListSegmentedControl.selectedSegmentIndex = 0;
    [gridListSegmentedControl addTarget:self action:@selector(handleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [segmentedControlBackground addSubview:gridListSegmentedControl];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:ROBOTO_MEDIUM size:13], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [gridListSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:RGB(52, 156, 249) forKey:NSForegroundColorAttributeName];
    [gridListSegmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    segmentedControlBackground.tintColor = [UIColor whiteColor];
    
    
    abcWatersScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentedControlBackground.frame.origin.y+segmentedControlBackground.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-segmentedControlBackground.bounds.size.height)];
    abcWatersScrollView.showsHorizontalScrollIndicator = NO;
    abcWatersScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:abcWatersScrollView];
    abcWatersScrollView.backgroundColor = [UIColor whiteColor];
    
    
    listTabeView = [[UITableView alloc] initWithFrame:CGRectMake(0, segmentedControlBackground.frame.origin.y+segmentedControlBackground.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-segmentedControlBackground.bounds.size.height-65) style:UITableViewStylePlain];
    listTabeView.delegate = self;
    listTabeView.dataSource = self;
    [self.view addSubview:listTabeView];
    listTabeView.backgroundColor = [UIColor clearColor];
    listTabeView.backgroundView = nil;
    listTabeView.hidden = YES;
    listTabeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    hideFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideFilterButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [hideFilterButton addTarget:self action:@selector(hideFilterTable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideFilterButton];
    hideFilterButton.hidden = YES;
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -150, self.view.bounds.size.width, 90) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    filterTableView.scrollEnabled = NO;
    filterTableView.alwaysBounceVertical = NO;
    
    filtersArray = [[NSArray alloc] initWithObjects:@"Name",@"Distance", nil];
    filteredDataSource = [[NSMutableArray alloc] init];
    
    abcWatersPageCount = 0;
    
    
    
    listinSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -150, self.view.bounds.size.width, 40)];
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
    
    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
    //    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    //    appDelegate.hud.labelText = @"Loading...";
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchABCWaterSites)
                  forControlEvents:UIControlEventValueChanged];
    [listTabeView addSubview:self.refreshControl];
    
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController setNavigationBarHidden:NO];
    
    [CommonFunctions googleAnalyticsTracking:@"Page: Our Waters Listing"];
    
    [appDelegate setShouldRotate:NO];
    [appDelegate.locationManager startUpdatingLocation];
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(76,175,238) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    if ([CommonFunctions hasConnectivity]) {
        [self fetchABCWaterSites];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"No internet connectivity." msg:nil cancel:@"OK" otherButton:nil];
    }
    
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
