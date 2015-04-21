//
//  QuickMapViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "QuickMapViewController.h"
#import "ViewControllerHelper.h"


@interface QuickMapViewController ()

@end

@implementation QuickMapViewController
@synthesize isNotQuickMapController;


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Demo App Controls Action Handler

- (void) handleExpandingControls {
    
    if (isControlMaximize) {
        isControlMaximize = NO;
        optionsView.hidden = YES;
    }
    else if (!isControlMaximize) {
        isControlMaximize = YES;
        optionsView.hidden = NO;
    }
}


//*************** Method To ANimate Filter Table

- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -70;
        
        quickMap.alpha = 1.0;
        quickMap.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 64;
        
        quickMap.alpha = 0.5;
        quickMap.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}


//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/quickmap.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//*************** Method To Handle Map Options

- (void) handleMapOptions:(id) sender {
    
    
    //copy your annotations to an array
    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithArray: quickMap.annotations];
    //Remove the object userlocation
    [annotationsToRemove removeObject: quickMap.userLocation];
    //Remove all annotations in the array from the mapView
    [quickMap removeAnnotations: annotationsToRemove];
    
    UIButton *button = (id) sender;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    if (button.tag==1) {
        
        isShowingFlood = YES;
        isShowingUserFeedback = NO;
        isShowingRain = NO;
        isShowingCamera = NO;
        isShowingDrain = NO;
        
        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_pub_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (button.tag==2) {
        
        isShowingFlood = NO;
        isShowingUserFeedback = YES;
        isShowingRain = NO;
        isShowingCamera = NO;
        isShowingDrain = NO;
        
        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (button.tag==3) {
        
        isShowingFlood = NO;
        isShowingUserFeedback = NO;
        isShowingRain = YES;
        isShowingCamera = NO;
        isShowingDrain = NO;
        
        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (button.tag==4) {
        
        isShowingFlood = NO;
        isShowingUserFeedback = NO;
        isShowingRain = NO;
        isShowingCamera = YES;
        isShowingDrain = NO;
        
        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (button.tag==5) {
        
        isShowingFlood = NO;
        isShowingUserFeedback = NO;
        isShowingRain = NO;
        isShowingCamera = NO;
        isShowingDrain = YES;
        
        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        
        [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    }
    
    //Set Default location to zoom
    CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(51.900708, -2.083160); //Create the CLLocation from user cordinates
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 50000, 50000); //Set zooming level
    MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
    [quickMap setRegion:adjustedRegion animated:YES]; // create animation zooming
    
    MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
    annotationRegion.center.latitude = 51.900708; // Make lat dynamic later
    annotationRegion.center.longitude = -2.083160; // Make long dynamic later
    annotationRegion.span.latitudeDelta = 0.02f;
    annotationRegion.span.longitudeDelta = 0.02f;
    
    // Place Annotation Point
    QuickMapAnnotations *annotation1 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
    annotation1.coordinate = annotationRegion.center;
    annotation1.title = @"Test Annotation 1";
    annotation1.subtitle = @"Subtitle For Annotation 1";
    [quickMap addAnnotation:annotation1];
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==filterTableView) {
        selectedFilterIndex = indexPath.row;
        [filterTableView reloadData];
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==filterTableView) {
        return filterDataSource.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (tableView==filterTableView) {
        
        cell.backgroundColor = RGB(247, 247, 247);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, filterTableView.bounds.size.width-10, cell.bounds.size.height)];
        titleLabel.text = [filterDataSource objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5, filterTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        if (indexPath.row==selectedFilterIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    
    return cell;
}



# pragma mark - MKMapViewDelegate Methods


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *pinView = nil;
    
    if(annotation != quickMap.userLocation) {
        
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        if (isShowingFlood) {
            pinView.image = [UIImage imageNamed:@"icn_floodinfo_small.png"];
        }
        else if (isShowingUserFeedback) {
            pinView.image = [UIImage imageNamed:@"icn_floodinfo_userfeedback_submission_small.png"];
        }
        else if (isShowingRain) {
            pinView.image = [UIImage imageNamed:@"icn_rainarea_small.png"];
        }
        else if (isShowingCamera) {
            pinView.image = [UIImage imageNamed:@"icn_cctv_small.png"];
        }
        else if (isShowingDrain) {
            pinView.image = [UIImage imageNamed:@"icn_waterlevel_small.png"];
        }
    }
    else {
        [quickMap.userLocation setTitle:@"You are here..!!"];
    }
    return pinView;
}


# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedFilterIndex = 0;

    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    quickMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    quickMap.delegate = self;
    [quickMap setMapType:MKMapTypeStandard];
    [quickMap setZoomEnabled:YES];
    [quickMap setScrollEnabled:YES];
    [self.view  addSubview:quickMap];
    
    
    
    isShowingFlood = NO;
    isShowingUserFeedback = NO;
    isShowingRain = NO;
    isShowingCamera = NO;
    isShowingDrain = YES;
    
    //Set Default location to zoom
    CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(51.900708, -2.083160); //Create the CLLocation from user cordinates
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 50000, 50000); //Set zooming level
    MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
    [quickMap setRegion:adjustedRegion animated:YES]; // create animation zooming
    
    MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
    annotationRegion.center.latitude = 51.900708;
    annotationRegion.center.longitude = -2.083160;
    annotationRegion.span.latitudeDelta = 0.02f;
    annotationRegion.span.longitudeDelta = 0.02f;
    
    // Place Annotation Point
    QuickMapAnnotations *annotation1 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
    annotation1.coordinate = annotationRegion.center;
//    [annotation1 setTitleString:@"Test Annotation 1"];
//    [annotation1 setSubtitleString:@"Subtitle For Annotation 1"];
    annotation1.title = @"Test Annotation 1";
    annotation1.subtitle = @"Subtitle For Annotation 1";
    [quickMap addAnnotation:annotation1];
    
    
    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(quickMap.userLocation.coordinate, 50, 50);
//    viewRegion.span.longitudeDelta  = 0.005;
//    viewRegion.span.latitudeDelta  = 0.005;
//    [quickMap setRegion:viewRegion animated:YES];

//    MKUserLocation *userLocation = quickMap.userLocation;
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
//    [quickMap setRegion:region animated:YES];
    
    maximizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [maximizeButton addTarget:self action:@selector(handleExpandingControls) forControlEvents:UIControlEventTouchUpInside];
    [maximizeButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_expand.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    
    if (IS_IPHONE_4_OR_LESS) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-55, quickMap.bounds.size.height-60, 40, 40);
    }
    else if (IS_IPHONE_5) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-55, quickMap.bounds.size.height-65, 40, 40);
    }
    else if (IS_IPHONE_6) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-65, quickMap.bounds.size.height-75, 45, 45);
    }
    else if (IS_IPHONE_6P) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-75, quickMap.bounds.size.height-85, 50, 50);
    }
    [quickMap addSubview:maximizeButton];
    
    
    optionsView = [[UIView alloc] init];
    optionsView.backgroundColor = [UIColor clearColor];
    if (IS_IPHONE_4_OR_LESS) {
        optionsView.frame = CGRectMake(quickMap.bounds.size.width-55, maximizeButton.frame.origin.y-300, 40, 300);
    }
    else if (IS_IPHONE_5) {
        optionsView.frame = CGRectMake(quickMap.bounds.size.width-55, maximizeButton.frame.origin.y-300, 40, 300);
    }
    else if (IS_IPHONE_6) {
        optionsView.frame = CGRectMake(quickMap.bounds.size.width-65, maximizeButton.frame.origin.y-325, 45, 325);
    }
    else if (IS_IPHONE_6P) {
        optionsView.frame = CGRectMake(quickMap.bounds.size.width-75, maximizeButton.frame.origin.y-350, 50, 350);
    }
    [quickMap addSubview:optionsView];
    optionsView.hidden = YES;
    
    
    carButton = [UIButton buttonWithType:UIButtonTypeCustom];
    carButton.frame = CGRectMake(0, 10, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    carButton.tag = 1;
    [carButton addTarget:self action:@selector(handleMapOptions:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:carButton];
    
    chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.frame = CGRectMake(0, carButton.frame.origin.y+carButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    chatButton.tag = 2;
    [chatButton addTarget:self action:@selector(handleMapOptions:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:chatButton];
    
    cloudButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cloudButton.frame = CGRectMake(0, chatButton.frame.origin.y+chatButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    cloudButton.tag = 3;
    [cloudButton addTarget:self action:@selector(handleMapOptions:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:cloudButton];
    
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(0, cloudButton.frame.origin.y+cloudButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    cameraButton.tag = 4;
    [cameraButton addTarget:self action:@selector(handleMapOptions:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:cameraButton];
    
    dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dropButton.frame = CGRectMake(0, cameraButton.frame.origin.y+cameraButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    dropButton.tag = 5;
    [dropButton addTarget:self action:@selector(handleMapOptions:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:dropButton];
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -128, self.view.bounds.size.width, 128) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    filterDataSource = [[NSArray alloc] initWithObjects:@"<75%",@"75%-90%",@">90%", nil];

    //[self createDemoAppControls];
    
    
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    
    if (!isNotQuickMapController) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    }
    else {
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(229,0,87) frame:CGRectMake(0, 0, 1, 1)];
        [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
        [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
        [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
        
        self.title = @"Quick Map";
        
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
        
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
