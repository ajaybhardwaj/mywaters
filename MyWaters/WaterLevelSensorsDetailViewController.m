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


//*************** Method To Animate Top Menu

- (void) animateTopMenu {
    
    if (isShowingTopMenu) {
        
        isShowingTopMenu = NO;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = -30;
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


//*************** Method To Create Top Menu

- (void) createTopMenu {
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, 45)];
    topMenu.backgroundColor = [UIColor blackColor];//RGB(254, 254, 254);
//    topMenu.alpha = 0.7;
    [self.view addSubview:topMenu];
    
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, (topMenu.bounds.size.width/2)-10, 35)];
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
    
    
    //    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+10, 40, (topMenu.bounds.size.width/2)/3, 10)];
    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2), 32, (topMenu.bounds.size.width/2)/3, 10)];
    iAlertLabel.backgroundColor = [UIColor clearColor];
    iAlertLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    iAlertLabel.text = @"iAlert";
    iAlertLabel.textAlignment = NSTextAlignmentCenter;
    iAlertLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:iAlertLabel];
    
    alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    alertButton.frame = CGRectMake((topMenu.bounds.size.width/2)+10, 10, 25, 25);
    alertButton.frame = CGRectMake((topMenu.bounds.size.width/2)/3/2 - 10 + (topMenu.bounds.size.width/2), 5, 20, 20);
    [alertButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_ialert_disabled.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [alertButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:alertButton];

    
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
    [addToFavButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
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


//*************** Method To Create User Interface

//- (void) createUI {
//    
//    wateLevelMapView = [[MKMapView alloc] init];
//    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
//        wateLevelMapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-154);
//    }
//    else if (IS_IPHONE_6) {
//        wateLevelMapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-160);
//    }
//    else if (IS_IPHONE_6P){
//        wateLevelMapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-150);
//    }
//    wateLevelMapView.delegate = self;
//    [self.view  addSubview:wateLevelMapView];
//    
//
//    currentLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [currentLocationButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
//    [currentLocationButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_quick_map.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
//    currentLocationButton.frame = CGRectMake(15, wateLevelMapView.bounds.size.height-65, 40, 40);
//    [wateLevelMapView addSubview:currentLocationButton];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSearchBarKeypad)];
//    [wateLevelMapView addGestureRecognizer:tap];
//    
//    
//    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(quickMap.userLocation.coordinate, 50, 50);
//    //    viewRegion.span.longitudeDelta  = 0.005;
//    //    viewRegion.span.latitudeDelta  = 0.005;
//    //    [quickMap setRegion:viewRegion animated:YES];
//    
//    //Set Default location to zoom
//    CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(1.287862, 103.845661); //Create the CLLocation from user cordinates
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); //Set zooming level
//    MKCoordinateRegion adjustedRegion = [wateLevelMapView regionThatFits:viewRegion]; //add location to map
//    [wateLevelMapView setRegion:adjustedRegion animated:YES]; // create animation zooming
//    
//    MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
//    annotationRegion.center.latitude = 1.287862; // Make lat dynamic later
//    annotationRegion.center.longitude = 103.845661; // Make long dynamic later
//    annotationRegion.span.latitudeDelta = 0.02f;
//    annotationRegion.span.longitudeDelta = 0.02f;
//    
//    
//    //    MKUserLocation *userLocation = wateLevelMapView.userLocation;
//    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
//    //    [wateLevelMapView setRegion:region animated:YES];
//    
//    
//    topSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, wateLevelMapView.bounds.size.width, 50)];
//    topSearchBar.barStyle = UISearchBarStyleMinimal;
//    topSearchBar.delegate = self;
//    topSearchBar.placeholder = @"Search...";
//    //    [topSearchBar setTintColor:RGB(247, 247, 247)];
//    [topSearchBar setBackgroundImage:[AuxilaryUIService imageWithColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 1, 44)]];
//    topSearchBar.backgroundColor = [UIColor clearColor];//RGB(247, 247, 247);
//    [wateLevelMapView addSubview:topSearchBar];
//    
//    //    cctvView = [[UIView alloc] initWithFrame:CGRectMake(10, wateLevelMapView.frame.origin.y+wateLevelMapView.bounds.size.height+10, self.view.bounds.size.width/2 - 10, self.view.bounds.size.width/2 -10)];
//    //    cctvView.layer.borderColor = [[UIColor blackColor] CGColor];
//    //    cctvView.layer.borderWidth = 1.0;
//    //    [self.view addSubview:cctvView];
//    
//    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, wateLevelMapView.frame.origin.y+wateLevelMapView.bounds.size.height+10, self.view.bounds.size.width - 40, 40)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
//    titleLabel.numberOfLines = 0;
//    titleLabel.text = @"Bukit Timah Rd";
//    [self.view addSubview:titleLabel];
//    [titleLabel sizeToFit];
//    
//    
//    
//    
//    //    measurementBar = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 +40, clockButton.frame.origin.y+clockButton.bounds.size.height+10, 20, 100)];
//    //    [measurementBar setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/meter_bar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//    //    [self.view addSubview:measurementBar];
//    
//    //    drainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x+measurementBar.bounds.size.width+5, titleLabel.frame.origin.y+titleLabel.bounds.size.height+40, 80, 80)];
//    drainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, self.view.bounds.size.width-40, 20)];
//    drainDepthLabel.text = @"Drain Depth: 2.8 m";
//    drainDepthLabel.textColor = RGB(26, 158, 241);
//    drainDepthLabel.backgroundColor = [UIColor clearColor];
//    drainDepthLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13.5];
//    drainDepthLabel.numberOfLines = 0;
//    [self.view addSubview:drainDepthLabel];
//    
//    
//    clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    clockButton.frame = CGRectMake(20, drainDepthLabel.frame.origin.y+drainDepthLabel.bounds.size.height+5, 15, 15);
//    [clockButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_time.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
//    [self.view addSubview:clockButton];
//    clockButton.userInteractionEnabled = NO;
//    
//    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockButton.frame.origin.x+clockButton.bounds.size.width+10, drainDepthLabel.frame.origin.y+drainDepthLabel.bounds.size.height+5, self.view.bounds.size.width-clockButton.frame.origin.x+clockButton.bounds.size.width+10, 15)];
//    timeLabel.text = @"23 May 2015 @ 4:16 PM";
//    timeLabel.backgroundColor = [UIColor clearColor];
//    timeLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
//    [self.view addSubview:timeLabel];
//    
//    measurementBar = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-75, titleLabel.frame.origin.y, 56, 50)];
//    [measurementBar setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_level2.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//    [self.view addSubview:measurementBar];
//    
//    
//    depthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-70, measurementBar.frame.origin.y+measurementBar.bounds.size.height+2, 50, 15)];
//    depthValueLabel.text = @"2.8 m";
//    depthValueLabel.backgroundColor = [UIColor clearColor];
//    depthValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11.0];
//    depthValueLabel.textColor = RGB(26, 158, 241);
//    depthValueLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:depthValueLabel];
//    
//    
//    //    UILabel *maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y, 10, 10)];
//    //    maxValueLabel.text = @"4";
//    //    maxValueLabel.backgroundColor = [UIColor clearColor];
//    //    maxValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
//    //    [self.view addSubview:maxValueLabel];
//    //
//    //    UILabel *midValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y+measurementBar.bounds.size.height/2-5, 10, 10)];
//    //    midValueLabel.text = @"2";
//    //    midValueLabel.backgroundColor = [UIColor clearColor];
//    //    midValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
//    //    [self.view addSubview:midValueLabel];
//    //
//    //    UILabel *minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y+measurementBar.bounds.size.height-10, 10, 10)];
//    //    minValueLabel.text = @"0";
//    //    minValueLabel.backgroundColor = [UIColor clearColor];
//    //    minValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
//    //    [self.view addSubview:minValueLabel];
//    
//    
//    
//    // Temp Code For Annotations
//    
//    annotation1 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
//    annotation1.coordinate = annotationRegion.center;
//    annotation1.title = @"Bukit Timah Rd";
//    annotation1.subtitle = @"Drain Depth 2.8 m";
//    [wateLevelMapView addAnnotation:annotation1];
//}



//*************** Method For Creating UI

- (void) createUI {
    
    
    topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/7b_waterlevelsensor_detail_options.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:topImageView];
    
    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionButton.frame = CGRectMake(0, topImageView.frame.origin.y+topImageView.bounds.size.height, self.view.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    cctvTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-120, 40)];
    cctvTitleLabel.backgroundColor = [UIColor whiteColor];
    cctvTitleLabel.textAlignment = NSTextAlignmentLeft;
    cctvTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    cctvTitleLabel.text = @"Balestier Road";
    [directionButton addSubview:cctvTitleLabel];
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-130, 0, 100, 40)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    distanceLabel.text = @"1.03 KM";
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
        sectionLabel.textColor = RGB(71, 178, 182);
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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7.5, 45, 45)];
    //    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/w%ld.png",appDelegate.RESOURCE_FOLDER_PATH,indexPath.row+1]];
//    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/CCTV-2.png",appDelegate.RESOURCE_FOLDER_PATH]];
    [cell.contentView addSubview:cellImage];

    if (indexPath.row==0) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==1) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==2) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75.png",appDelegate.RESOURCE_FOLDER_PATH]];
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
            NSLog(@"Geocoding for Address: %@\n", searchBar.text);
            [fwdGeocoding geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
                if (!error) {
                    // do stuff with the placemarks
                    
                    for (CLPlacemark *placemark in placemarks) {
                        NSLog(@"%@\n %.2f,%.2f",[placemark description], placemark.location.horizontalAccuracy, placemark.location.verticalAccuracy);
                    }
                } else {
                    NSLog(@"Geocoding error: %@", [error localizedDescription]);
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
