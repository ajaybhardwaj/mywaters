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


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Animate Top Menu

- (void) animateTopMenu {
    
    if (isShowingTopMenu) {
        
        isShowingTopMenu = NO;
        [topSearchBar resignFirstResponder];
        
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
        topMenuPos.y = 28;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
}


//*************** Method To Create Top Menu

- (void) createTopMenu {
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, 55)];
    topMenu.backgroundColor = RGB(254, 254, 254);
    [self.view addSubview:topMenu];
    
    topSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 2.5, topMenu.bounds.size.width/2, 50)];
    topSearchBar.barStyle = UISearchBarStyleMinimal;
    topSearchBar.delegate = self;
    topSearchBar.placeholder = @"Search...";
    [topSearchBar setTintColor:RGB(247, 247, 247)];
    [topSearchBar setBackgroundImage:[AuxilaryUIService imageWithColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 1, 44)]];
    topSearchBar.backgroundColor = RGB(247, 247, 247);
    [topMenu addSubview:topSearchBar];

    
    alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alertButton.frame = CGRectMake((topMenu.bounds.size.width/2)+10, 10, 25, 25);
    [alertButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_ialert_disabled.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:alertButton];
    
    addToFavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addToFavButton.frame = CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)+15, 10, 25, 25);
    [addToFavButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:addToFavButton];

    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)*2+18, 10, 25, 25);
    [refreshButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_refresh_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:refreshButton];
    
    
    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+10, 40, (topMenu.bounds.size.width/2)/3, 10)];
    iAlertLabel.backgroundColor = [UIColor clearColor];
    iAlertLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    iAlertLabel.text = @"iAlert";
    [topMenu addSubview:iAlertLabel];
    
    
    addToFavLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)-1.5, 40, (topMenu.bounds.size.width/2)/3, 10)];
    addToFavLabel.backgroundColor = [UIColor clearColor];
    addToFavLabel.textAlignment = NSTextAlignmentCenter;
    addToFavLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addToFavLabel.text = @"Add To Fav";
    [topMenu addSubview:addToFavLabel];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)*2+2, 40, (topMenu.bounds.size.width/2)/3, 10)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    refreshLabel.text = @"Refresh";
    [topMenu addSubview:refreshLabel];
    
    
    UIImageView *seperatorOne =[[UIImageView alloc] initWithFrame:CGRectMake(topSearchBar.frame.origin.x+topSearchBar.bounds.size.width-4, 0, 0.5, 55)];
    [seperatorOne setBackgroundColor:[UIColor lightGrayColor]];
    [topMenu addSubview:seperatorOne];
    
    UIImageView *seperatorTwo =[[UIImageView alloc] initWithFrame:CGRectMake(alertButton.frame.origin.x+alertButton.bounds.size.width+13, 0, 0.5, 55)];
    [seperatorTwo setBackgroundColor:[UIColor lightGrayColor]];
    [topMenu addSubview:seperatorTwo];
    
    UIImageView *seperatorThree =[[UIImageView alloc] initWithFrame:CGRectMake(addToFavButton.frame.origin.x+addToFavButton.bounds.size.width+14, 0, 0.5, 55)];
    [seperatorThree setBackgroundColor:[UIColor lightGrayColor]];
    [topMenu addSubview:seperatorThree];
    
}


//*************** Method To Create User Interface

- (void) createUI {
    
    wateLevelMapView = [[MKMapView alloc] init];
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        wateLevelMapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-234);
    }
    else {
        wateLevelMapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-280);
    }
    wateLevelMapView.delegate = self;
    [self.view  addSubview:wateLevelMapView];
    
    
    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(quickMap.userLocation.coordinate, 50, 50);
    //    viewRegion.span.longitudeDelta  = 0.005;
    //    viewRegion.span.latitudeDelta  = 0.005;
    //    [quickMap setRegion:viewRegion animated:YES];
    
    MKUserLocation *userLocation = wateLevelMapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    [wateLevelMapView setRegion:region animated:YES];
    
    
    cctvView = [[UIView alloc] initWithFrame:CGRectMake(10, wateLevelMapView.frame.origin.y+wateLevelMapView.bounds.size.height+10, self.view.bounds.size.width/2 - 10, self.view.bounds.size.width/2 -10)];
    cctvView.layer.borderColor = [[UIColor blackColor] CGColor];
    cctvView.layer.borderWidth = 1.0;
    [self.view addSubview:cctvView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 +10, wateLevelMapView.frame.origin.y+wateLevelMapView.bounds.size.height+10, self.view.bounds.size.width/2 - 20, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"Bukit Timah Rd";
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    
    clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clockButton.frame = CGRectMake(self.view.bounds.size.width/2 +10, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 15, 15);
    [clockButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_time.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [self.view addSubview:clockButton];
    clockButton.userInteractionEnabled = NO;
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockButton.frame.origin.x+clockButton.bounds.size.width+10, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 100, 15)];
    timeLabel.text = @"4:16 PM";
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    [self.view addSubview:timeLabel];
    
    
    measurementBar = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 +40, clockButton.frame.origin.y+clockButton.bounds.size.height+10, 20, 100)];
    [measurementBar setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/meter_bar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:measurementBar];
    
    drainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x+measurementBar.bounds.size.width+5, titleLabel.frame.origin.y+titleLabel.bounds.size.height+40, 80, 80)];
    drainDepthLabel.text = @"Drain Depth (m)";
    drainDepthLabel.backgroundColor = [UIColor clearColor];
    drainDepthLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    drainDepthLabel.textAlignment = NSTextAlignmentCenter;
    drainDepthLabel.numberOfLines = 0;
    [self.view addSubview:drainDepthLabel];
    
    UILabel *maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y, 10, 10)];
    maxValueLabel.text = @"4";
    maxValueLabel.backgroundColor = [UIColor clearColor];
    maxValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    [self.view addSubview:maxValueLabel];
    
    UILabel *midValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y+measurementBar.bounds.size.height/2-5, 10, 10)];
    midValueLabel.text = @"2";
    midValueLabel.backgroundColor = [UIColor clearColor];
    midValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    [self.view addSubview:midValueLabel];
    
    UILabel *minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y+measurementBar.bounds.size.height-10, 10, 10)];
    minValueLabel.text = @"0";
    minValueLabel.backgroundColor = [UIColor clearColor];
    minValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    [self.view addSubview:minValueLabel];

}


# pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar==topSearchBar) {
        
        if ([topSearchBar.text length]!=0) {
            
            [topSearchBar resignFirstResponder];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    if (searchBar==topSearchBar) {
        
        topSearchBar.text = @"";
        [topSearchBar resignFirstResponder];
    }
}




# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Water Level Sensor";
    self.view.backgroundColor = RGB(247, 247, 247);
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots.png"]];
    
    
    [self createUI];
    [self createTopMenu];
}


- (void) viewWillAppear:(BOOL)animated {
    
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
