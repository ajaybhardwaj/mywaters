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
    
    
    alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    alertButton.frame = CGRectMake((topMenu.bounds.size.width/2)+10, 10, 25, 25);
    alertButton.frame = CGRectMake((topMenu.bounds.size.width/3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [alertButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_ialert_disabled.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:alertButton];
    
    addToFavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addToFavButton.frame = CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)+15, 10, 25, 25);
    addToFavButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*2)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [addToFavButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:addToFavButton];
    
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    refreshButton.frame = CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)*2+18, 10, 25, 25);
    refreshButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [refreshButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_refresh_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:refreshButton];
    
    
    //    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+10, 40, (topMenu.bounds.size.width/2)/3, 10)];
    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, topMenu.bounds.size.width/3, 10)];
    iAlertLabel.backgroundColor = [UIColor clearColor];
    iAlertLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    iAlertLabel.text = @"iAlert";
    iAlertLabel.textAlignment = NSTextAlignmentCenter;
    [topMenu addSubview:iAlertLabel];
    
    UIImageView *seperatorOne =[[UIImageView alloc] initWithFrame:CGRectMake(iAlertLabel.frame.origin.x+iAlertLabel.bounds.size.width-1, 0, 0.5, 55)];
    [seperatorOne setBackgroundColor:[UIColor lightGrayColor]];
    [topMenu addSubview:seperatorOne];
    
    
    //    addToFavLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)-1.5, 40, (topMenu.bounds.size.width/2)/3, 10)];
    addToFavLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3), 40, topMenu.bounds.size.width/3, 10)];
    addToFavLabel.backgroundColor = [UIColor clearColor];
    addToFavLabel.textAlignment = NSTextAlignmentCenter;
    addToFavLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addToFavLabel.text = @"Add To Fav";
    [topMenu addSubview:addToFavLabel];
    
    UIImageView *seperatorTwo =[[UIImageView alloc] initWithFrame:CGRectMake(addToFavLabel.frame.origin.x+addToFavLabel.bounds.size.width-1, 0, 0.5, 55)];
    [seperatorTwo setBackgroundColor:[UIColor lightGrayColor]];
    [topMenu addSubview:seperatorTwo];
    
    //    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)*2+2, 40, (topMenu.bounds.size.width/2)/3, 10)];
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)*2, 40, topMenu.bounds.size.width/3, 10)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    refreshLabel.text = @"Refresh";
    [topMenu addSubview:refreshLabel];
    
    
    //    UIImageView *seperatorOne =[[UIImageView alloc] initWithFrame:CGRectMake(topSearchBar.frame.origin.x+topSearchBar.bounds.size.width-4, 0, 0.5, 55)];
    //    [seperatorOne setBackgroundColor:[UIColor lightGrayColor]];
    //    [topMenu addSubview:seperatorOne];
    //
    //    UIImageView *seperatorTwo =[[UIImageView alloc] initWithFrame:CGRectMake(alertButton.frame.origin.x+alertButton.bounds.size.width+13, 0, 0.5, 55)];
    //    [seperatorTwo setBackgroundColor:[UIColor lightGrayColor]];
    //    [topMenu addSubview:seperatorTwo];
    //
    //    UIImageView *seperatorThree =[[UIImageView alloc] initWithFrame:CGRectMake(addToFavButton.frame.origin.x+addToFavButton.bounds.size.width+14, 0, 0.5, 55)];
    //    [seperatorThree setBackgroundColor:[UIColor lightGrayColor]];
    //    [topMenu addSubview:seperatorThree];
    
}


//*************** Method To Create User Interface

- (void) createUI {
    
    wateLevelMapView = [[MKMapView alloc] init];
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        wateLevelMapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-154);
    }
    else if (IS_IPHONE_6) {
        wateLevelMapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-160);
    }
    else if (IS_IPHONE_6P){
        wateLevelMapView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-150);
    }
    wateLevelMapView.delegate = self;
    [self.view  addSubview:wateLevelMapView];
    

    currentLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [currentLocationButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [currentLocationButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_quick_map.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    currentLocationButton.frame = CGRectMake(15, wateLevelMapView.bounds.size.height-65, 40, 40);
    [wateLevelMapView addSubview:currentLocationButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSearchBarKeypad)];
    [wateLevelMapView addGestureRecognizer:tap];
    
    
    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(quickMap.userLocation.coordinate, 50, 50);
    //    viewRegion.span.longitudeDelta  = 0.005;
    //    viewRegion.span.latitudeDelta  = 0.005;
    //    [quickMap setRegion:viewRegion animated:YES];
    
    //Set Default location to zoom
    CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(1.287862, 103.845661); //Create the CLLocation from user cordinates
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); //Set zooming level
    MKCoordinateRegion adjustedRegion = [wateLevelMapView regionThatFits:viewRegion]; //add location to map
    [wateLevelMapView setRegion:adjustedRegion animated:YES]; // create animation zooming
    
    MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
    annotationRegion.center.latitude = 1.287862; // Make lat dynamic later
    annotationRegion.center.longitude = 103.845661; // Make long dynamic later
    annotationRegion.span.latitudeDelta = 0.02f;
    annotationRegion.span.longitudeDelta = 0.02f;
    
    
    //    MKUserLocation *userLocation = wateLevelMapView.userLocation;
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    //    [wateLevelMapView setRegion:region animated:YES];
    
    
    topSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, wateLevelMapView.bounds.size.width, 50)];
    topSearchBar.barStyle = UISearchBarStyleMinimal;
    topSearchBar.delegate = self;
    topSearchBar.placeholder = @"Search...";
    //    [topSearchBar setTintColor:RGB(247, 247, 247)];
    [topSearchBar setBackgroundImage:[AuxilaryUIService imageWithColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 1, 44)]];
    topSearchBar.backgroundColor = [UIColor clearColor];//RGB(247, 247, 247);
    [wateLevelMapView addSubview:topSearchBar];
    
    //    cctvView = [[UIView alloc] initWithFrame:CGRectMake(10, wateLevelMapView.frame.origin.y+wateLevelMapView.bounds.size.height+10, self.view.bounds.size.width/2 - 10, self.view.bounds.size.width/2 -10)];
    //    cctvView.layer.borderColor = [[UIColor blackColor] CGColor];
    //    cctvView.layer.borderWidth = 1.0;
    //    [self.view addSubview:cctvView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, wateLevelMapView.frame.origin.y+wateLevelMapView.bounds.size.height+10, self.view.bounds.size.width - 40, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"Bukit Timah Rd";
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    
    
    
    
    //    measurementBar = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 +40, clockButton.frame.origin.y+clockButton.bounds.size.height+10, 20, 100)];
    //    [measurementBar setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/meter_bar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    //    [self.view addSubview:measurementBar];
    
    //    drainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x+measurementBar.bounds.size.width+5, titleLabel.frame.origin.y+titleLabel.bounds.size.height+40, 80, 80)];
    drainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, self.view.bounds.size.width-40, 20)];
    drainDepthLabel.text = @"Drain Depth: 2.8 m";
    drainDepthLabel.textColor = RGB(26, 158, 241);
    drainDepthLabel.backgroundColor = [UIColor clearColor];
    drainDepthLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13.5];
    drainDepthLabel.numberOfLines = 0;
    [self.view addSubview:drainDepthLabel];
    
    
    clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clockButton.frame = CGRectMake(20, drainDepthLabel.frame.origin.y+drainDepthLabel.bounds.size.height+5, 15, 15);
    [clockButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_time.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [self.view addSubview:clockButton];
    clockButton.userInteractionEnabled = NO;
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockButton.frame.origin.x+clockButton.bounds.size.width+10, drainDepthLabel.frame.origin.y+drainDepthLabel.bounds.size.height+5, self.view.bounds.size.width-clockButton.frame.origin.x+clockButton.bounds.size.width+10, 15)];
    timeLabel.text = @"23 May 2015 @ 4:16 PM";
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    [self.view addSubview:timeLabel];
    
    measurementBar = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-70, titleLabel.frame.origin.y, 56, 50)];
    [measurementBar setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/filled_bucket_level.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:measurementBar];
    
    
    depthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-70, measurementBar.frame.origin.y+measurementBar.bounds.size.height+2, 50, 15)];
    depthValueLabel.text = @"2.8 m";
    depthValueLabel.backgroundColor = [UIColor clearColor];
    depthValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11.0];
    depthValueLabel.textColor = RGB(26, 158, 241);
    depthValueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:depthValueLabel];
    
    
    //    UILabel *maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y, 10, 10)];
    //    maxValueLabel.text = @"4";
    //    maxValueLabel.backgroundColor = [UIColor clearColor];
    //    maxValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    //    [self.view addSubview:maxValueLabel];
    //
    //    UILabel *midValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y+measurementBar.bounds.size.height/2-5, 10, 10)];
    //    midValueLabel.text = @"2";
    //    midValueLabel.backgroundColor = [UIColor clearColor];
    //    midValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    //    [self.view addSubview:midValueLabel];
    //
    //    UILabel *minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(measurementBar.frame.origin.x-15, measurementBar.frame.origin.y+measurementBar.bounds.size.height-10, 10, 10)];
    //    minValueLabel.text = @"0";
    //    minValueLabel.backgroundColor = [UIColor clearColor];
    //    minValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    //    [self.view addSubview:minValueLabel];
    
    
    
    // Temp Code For Annotations
    
    annotation1 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
    annotation1.coordinate = annotationRegion.center;
    annotation1.title = @"Bukit Timah Rd";
    annotation1.subtitle = @"Drain Depth 2.8 m";
    [wateLevelMapView addAnnotation:annotation1];
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
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots.png"]];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];

    
    [self createUI];
    [self createTopMenu];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    
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
