//
//  WaterLevelSensorsDetailViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 14/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WaterLevelSensorsDetailViewController.h"

@interface WaterLevelSensorsDetailViewController ()

@end

@implementation WaterLevelSensorsDetailViewController
@synthesize wlsID,drainDepthType,latValue,longValue,wlsName,observedTime,waterLevelValue,waterLevelPercentageValue,waterLevelTypeValue,drainDepthValue,isSubscribed;

//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Hide Search Bar Keypad

- (void) hideSearchBarKeypad {
    
    [topSearchBar resignFirstResponder];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Register User For Flood Alerts

- (void) registerForWLSALerts {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSArray *parameters,*values;
    
    if (isSubscribed) {
        parameters = [[NSArray alloc] initWithObjects:@"Token",@"SubscriptionType",@"SubscriptionMode",@"WLSAlertLevel",@"WLSID", nil];
        values = [[NSArray alloc] initWithObjects:[prefs stringForKey:@"device_token"],@"2", @"2", @"3", wlsID, nil];
    }
    else {
        parameters = [[NSArray alloc] initWithObjects:@"Token",@"SubscriptionType",@"SubscriptionMode",@"WLSAlertLevel",@"WLSID", nil];
        values = [[NSArray alloc] initWithObjects:[prefs stringForKey:@"device_token"],@"2", @"1", @"3", wlsID, nil];
    }
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,REGISTER_FOR_SUBSCRIPTION]];
}


//*************** Method To Animate Top Menu

- (void) animateTopMenu {
    
    if (isShowingTopMenu) {
        
        isShowingTopMenu = NO;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = -140;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
    else {
        
        isShowingTopMenu = YES;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = 22;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
}



//*************** Method To Move To Map Direction View

- (void) moveToDirectionView {
    
    DirectionViewController *viewObj = [[DirectionViewController alloc] init];
    viewObj.destinationLat = latValue;
    viewObj.destinationLong = longValue;
    [self.navigationController pushViewController:viewObj animated:YES];
}



//*************** Method To Add WLS To Favourites

- (void) addWLSToFavourites {
    
    [self animateTopMenu];
    
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];
    
    [parametersDict setValue:wlsID forKey:@"fav_id"];
    [parametersDict setValue:@"4" forKey:@"fav_type"];
    [parametersDict setValue:wlsName forKey:@"name"];
    [parametersDict setValue:@"NA" forKey:@"image"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"lat"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"long"];
    [parametersDict setValue:@"NA" forKey:@"address"];
    [parametersDict setValue:@"NA" forKey:@"phoneno"];
    [parametersDict setValue:@"NA" forKey:@"description"];
    [parametersDict setValue:@"NA" forKey:@"start_date_event"];
    [parametersDict setValue:@"NA" forKey:@"end_date_event"];
    [parametersDict setValue:@"NA" forKey:@"website_event"];
    [parametersDict setValue:@"NA" forKey:@"isCertified_ABC"];
    
    
    if (waterLevelValue != (id)[NSNull null] && [waterLevelValue length] !=0)
        [parametersDict setValue:waterLevelValue forKey:@"water_level_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"water_level_wls"];
    
    if (drainDepthValue != (id)[NSNull null] && [drainDepthValue length] !=0)
        [parametersDict setValue:drainDepthValue forKey:@"drain_depth_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"drain_depth_wls"];
    
    if (waterLevelPercentageValue != (id)[NSNull null] && [waterLevelPercentageValue length] !=0)
        [parametersDict setValue:waterLevelPercentageValue forKey:@"water_level_percentage_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"water_level_percentage_wls"];
    
    if (waterLevelTypeValue != (id)[NSNull null] && [waterLevelTypeValue length] !=0)
        [parametersDict setValue:waterLevelTypeValue forKey:@"water_level_type_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"water_level_type_wls"];
    
    if (observedTime != (id)[NSNull null] && [observedTime length] !=0)
        [parametersDict setValue:observedTime forKey:@"observation_time_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"observation_time_wls"];
    
    [appDelegate insertFavouriteItems:parametersDict];
}


//*************** Method To Create Top Menu

- (void) createTopMenu {
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -140, self.view.bounds.size.width, 45)];
    topMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:topMenu];
    
    
    //    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, (topMenu.bounds.size.width/2)-10, 35)];
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, (topMenu.bounds.size.width/2)+30, 35)];
    searchField.textColor = RGB(35, 35, 35);
    searchField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.borderStyle = UITextBorderStyleNone;
    searchField.textAlignment=NSTextAlignmentLeft;
    [searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    searchField.placeholder = @"Search...";
    searchField.layer.borderWidth = 0.5;
    searchField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [topMenu addSubview:searchField];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.delegate = self;
    searchField.keyboardType = UIKeyboardTypeEmailAddress;
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.returnKeyType = UIReturnKeyNext;
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    //    //    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+10, 40, (topMenu.bounds.size.width/2)/3, 10)];
    //    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2), 32, (topMenu.bounds.size.width/2)/3, 10)];
    //    iAlertLabel.backgroundColor = [UIColor clearColor];
    //    iAlertLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    //    iAlertLabel.text = @"iAlert";
    //    iAlertLabel.textAlignment = NSTextAlignmentCenter;
    //    iAlertLabel.textColor = [UIColor whiteColor];
    //    [topMenu addSubview:iAlertLabel];
    //
    //    alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    //    alertButton.frame = CGRectMake((topMenu.bounds.size.width/2)+10, 10, 25, 25);
    //    alertButton.frame = CGRectMake((topMenu.bounds.size.width/2)/3/2 - 10 + (topMenu.bounds.size.width/2), 5, 20, 20);
    //    [alertButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_ialert_disabled.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    //    [alertButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    //    [topMenu addSubview:alertButton];
    
    
    //    addToFavLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)-1.5, 40, (topMenu.bounds.size.width/2)/3, 10)];
    addToFavLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/2)/3, 32, (topMenu.bounds.size.width/2)/3, 10)];
    addToFavLabel.backgroundColor = [UIColor clearColor];
    addToFavLabel.textAlignment = NSTextAlignmentCenter;
    addToFavLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addToFavLabel.text = @"Add To Fav";
    addToFavLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:addToFavLabel];
    
    addToFavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addToFavButton.frame = CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)+15, 10, 25, 25);
    addToFavButton.frame = CGRectMake((topMenu.bounds.size.width/2)/3/2 - 10 + (topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/2)/3, 5, 20, 20);
    [addToFavButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [addToFavButton addTarget:self action:@selector(addWLSToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addToFavButton];
    
    
    //    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)*2+2, 40, (topMenu.bounds.size.width/2)/3, 10)];
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/2)/3+(topMenu.bounds.size.width/2)/3, 32, (topMenu.bounds.size.width/2)/3, 10)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    refreshLabel.text = @"Refresh";
    refreshLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:refreshLabel];
    
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    refreshButton.frame = CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)*2+18, 10, 25, 25);
    refreshButton.frame = CGRectMake((topMenu.bounds.size.width/2)/3/2 - 10 + (topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/2)/3+(topMenu.bounds.size.width/2)/3, 5, 20, 20);
    [refreshButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_refresh_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:refreshButton];
    
}


//*************** Method For Creating UI

- (void) createUI {
    
    
    notifiyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notifiyButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    [notifiyButton setBackgroundColor:[UIColor lightGrayColor]];
    [notifiyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (isSubscribed) {
        [notifiyButton setTitle:@"UNSUBSCRIBE ME" forState:UIControlStateNormal];
    }
    else {
        [notifiyButton setTitle:@"NOTIFY ME" forState:UIControlStateNormal];
    }
    notifiyButton.titleLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:16];
    [self.view addSubview:notifiyButton];
    
    topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, notifiyButton.frame.origin.y+notifiyButton.bounds.size.height+30, 80, 80)];
    [self.view addSubview:topImageView];
    
    riskLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, notifiyButton.frame.origin.y+notifiyButton.bounds.size.height+30, self.view.bounds.size.width/2 -30, 60)];
    riskLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:17];
    riskLabel.textColor = [UIColor blackColor];//RGB(26, 158, 241);
    riskLabel.backgroundColor = [UIColor clearColor];
    riskLabel.numberOfLines = 0;
    [self.view addSubview:riskLabel];
    if (drainDepthType==1) {
        riskLabel.text = @"Low Flood Risk";
        [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (drainDepthType==2) {
        riskLabel.text = @"Moderate Flood Risk";
        [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (drainDepthType==3) {
        riskLabel.text = @"High Flood Risk";
        [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else {
        riskLabel.text = @"Under Maintenance";
        [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_undermaintenance.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    [riskLabel sizeToFit];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, riskLabel.frame.origin.y+riskLabel.bounds.size.height+5, self.view.bounds.size.width/2 -50, 35)];
    timeLabel.text = observedTime;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.numberOfLines = 0;
    timeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    [self.view addSubview:timeLabel];

    
    depthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, timeLabel.frame.origin.y+timeLabel.bounds.size.height+5, self.view.bounds.size.width/2 -10, 15)];
    depthValueLabel.backgroundColor = [UIColor clearColor];
    depthValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    depthValueLabel.textColor = [UIColor darkGrayColor];//RGB(26, 158, 241);
    [self.view addSubview:depthValueLabel];
    

    if (drainDepthType==1) {
        depthValueLabel.text = @"Drain Below 75% Full";
    }
    else if (drainDepthType==2) {
        depthValueLabel.text = @"Drain 75%-90% Full";
    }
    else if (drainDepthType==3) {
        depthValueLabel.text = @"Drain Above 90% Full";
    }
    else {
        depthValueLabel.text = @"";
    }
    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    directionButton.frame = CGRectMake(0, topImageView.frame.origin.y+topImageView.bounds.size.height, self.view.bounds.size.width, 40);
    directionButton.frame = CGRectMake(0, 200, self.view.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [directionButton addTarget:self action:@selector(moveToDirectionView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions_blue.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    cctvTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-140, 40)];
    cctvTitleLabel.backgroundColor = [UIColor whiteColor];
    cctvTitleLabel.textAlignment = NSTextAlignmentLeft;
    cctvTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    cctvTitleLabel.text = wlsName;
    cctvTitleLabel.numberOfLines = 0;
    [directionButton addSubview:cctvTitleLabel];
    
    
    //----- Change Current Location With Either Current Location Value or Default Location Value
    
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D desinationLocation;
    
    currentLocation.latitude = 1.2912500;
    currentLocation.longitude = 103.7870230;
    
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
    
    
    wlsListingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-(directionButton.bounds.size.height+topImageView.bounds.size.height+64))];
    wlsListingTable.delegate = self;
    wlsListingTable.dataSource = self;
    [self.view addSubview:wlsListingTable];
    wlsListingTable.backgroundColor = [UIColor clearColor];
    wlsListingTable.backgroundView = nil;
    wlsListingTable.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //    [cctvListingTable reloadData];
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [CommonFunctions showAlertView:self title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
    
    [appDelegate.hud hide:YES];
}



# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
}



# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



# pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section==0) {
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        sectionLabel.text = @"    Nearby";
        sectionLabel.textColor = RGB(51, 149, 255);
        sectionLabel.backgroundColor = RGB(234, 234, 234);
        sectionLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
        
        return sectionLabel;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return eventsTableDataSource.count;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7.5, 45, 45)];
    //    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/w%ld.png",appDelegate.RESOURCE_FOLDER_PATH,indexPath.row+1]];
    //    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/CCTV-2.png",appDelegate.RESOURCE_FOLDER_PATH]];
    [cell.contentView addSubview:cellImage];
    
    if (indexPath.row==0) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==1) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==2) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    
    
    UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, wlsListingTable.bounds.size.width-80, 30)];
    //        titleLabel.text = [[eventsTableDataSource objectAtIndex:indexPath.row] objectForKey:@"eventTitle"];
    cellTitleLabel.text = [nearbyWlsDatasource objectAtIndex:indexPath.row];
    cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    cellTitleLabel.backgroundColor = [UIColor clearColor];
    cellTitleLabel.numberOfLines = 0;
    [cell.contentView addSubview:cellTitleLabel];
    
    
    UILabel *cellDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, wlsListingTable.bounds.size.width-80, 15)];
    cellDistanceLabel.text = @"1.5 KM";
    cellDistanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:10.0];
    cellDistanceLabel.backgroundColor = [UIColor clearColor];
    cellDistanceLabel.textColor = [UIColor lightGrayColor];
    cellDistanceLabel.numberOfLines = 0;
    cellDistanceLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:cellDistanceLabel];
    
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59.5, wlsListingTable.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    
    return cell;
}



# pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar==topSearchBar) {
        
        if ([topSearchBar.text length]!=0) {
            
            [topSearchBar resignFirstResponder];
            
            CLGeocoder *fwdGeocoding = [[CLGeocoder alloc] init];
            DebugLog(@"Geocoding for Address: %@\n", searchBar.text);
            [fwdGeocoding geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
                if (!error) {
                    // do stuff with the placemarks
                    
                    for (CLPlacemark *placemark in placemarks) {
                        DebugLog(@"%@\n %.2f,%.2f",[placemark description], placemark.location.horizontalAccuracy, placemark.location.verticalAccuracy);
                    }
                } else {
                    DebugLog(@"Geocoding error: %@", [error localizedDescription]);
                }
            }];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    if (searchBar==topSearchBar) {
        
        topSearchBar.text = @"";
        [topSearchBar resignFirstResponder];
    }
}



# pragma mark - MKMapViewDelegate Methods


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *pinView = nil;
    
    if(annotation != wateLevelMapView.userLocation) {
        
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[wateLevelMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"icn_waterlevel_75-90.png"];
    }
    else {
        [wateLevelMapView.userLocation setTitle:@"You are here..!!"];
    }
    return pinView;
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Water Level Sensor";
    self.view.backgroundColor = RGB(247, 247, 247);
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    if (appDelegate.IS_MOVING_TO_WLS_FROM_DASHBOARD) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
        appDelegate.IS_MOVING_TO_WLS_FROM_DASHBOARD = NO;
    }
    else {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    }
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots.png"]];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    nearbyWlsDatasource = [[NSArray alloc] initWithObjects:@"Sun Yat-sen Nanyang memorial hall",@"Mandalay Rd",@"Kim Keat Rd", nil];
    
    [self createUI];
    [self createTopMenu];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(52,158,240) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
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
