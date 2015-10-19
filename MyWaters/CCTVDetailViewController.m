//
//  CCTVDetailViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 29/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "CCTVDetailViewController.h"

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



//*************** Method For Creating UI

- (void) createUI {
    
    
    for (UIView * view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    
    topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 249)];
    [self.view addSubview:topImageView];
    
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
    
    
    cctvListingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-(directionButton.bounds.size.height+topImageView.bounds.size.height+64))];
    cctvListingTable.delegate = self;
    cctvListingTable.dataSource = self;
    [self.view addSubview:cctvListingTable];
    cctvListingTable.backgroundColor = [UIColor clearColor];
    cctvListingTable.backgroundView = nil;
    
    //    [cctvListingTable reloadData];
    
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -160, self.view.bounds.size.width, 45)];
    topMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:topMenu];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, (topMenu.bounds.size.width/2), 35)];
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
    searchField.returnKeyType = UIReturnKeyDone;
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
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
    [shareButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:shareButton];
    
    addToFavlabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)+50, 30, topMenu.bounds.size.width/3, 10)];
    addToFavlabel.backgroundColor = [UIColor clearColor];
    addToFavlabel.textAlignment = NSTextAlignmentCenter;
    addToFavlabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addToFavlabel.text = @"Add To Fav";
    addToFavlabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:addToFavlabel];
    
    shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)*2+10, 30, topMenu.bounds.size.width/3, 10)];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    shareLabel.text = @"Share";
    shareLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:shareLabel];
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
    
    DirectionViewController *viewObj = [[DirectionViewController alloc] init];
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
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"long"];
    
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
    
    if (isAlreadyFav)
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_fav.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    else
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    
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
    }
    else {
        
        isShowingTopMenu = YES;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = 21;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
}



# pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag==2) {
        
        if (buttonIndex==0) {
            [CommonFunctions sharePostOnFacebook:imageUrl appUrl:@"https://itunes.apple.com/sg/app/mywaters/id533051315?mt=8" title:titleString desc:nil view:self];
        }
        else if (buttonIndex==1) {
            
            [CommonFunctions sharePostOnTwitter:@"https://itunes.apple.com/sg/app/mywaters/id533051315?mt=8" title:titleString view:self];
        }
    }
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
    
    return 80.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    
    latValue = [[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"Lat"] doubleValue];
    longValue = [[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"Lon"] doubleValue];
    imageUrl = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"CCTVImageURL"];
    titleString = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
    cctvID = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"ID"];
    
    [self createUI];
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!appDelegate.IS_COMING_FROM_DASHBOARD) {
        return 3;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 70, 70)];
    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/CCTV-2.png",appDelegate.RESOURCE_FOLDER_PATH]];
    [cell.contentView addSubview:cellImage];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, cctvListingTable.bounds.size.width-100, 50)];
    titleLabel.text = [NSString stringWithFormat:@"%@",[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, cctvListingTable.bounds.size.width-100, 20)];
    subTitleLabel.textColor = [UIColor lightGrayColor];
    subTitleLabel.text = [NSString stringWithFormat:@"%@ KM",[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    subTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:subTitleLabel];
    
    
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
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
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
    
    if (!appDelegate.IS_COMING_FROM_DASHBOARD) {
        tempNearByArray = appDelegate.CCTV_LISTING_ARRAY;
        
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
        
        [tempNearByArray sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,nil]];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(71, 178, 182) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
}

@end
