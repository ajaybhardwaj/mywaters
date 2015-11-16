//
//  LongPressUserLocationViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 22/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "LongPressUserLocationViewController.h"

@interface LongPressUserLocationViewController ()

@end

@implementation LongPressUserLocationViewController



//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Handle Long Press Gesture For Default Location PIN

- (void) handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:userLocMapView];
    CLLocationCoordinate2D touchMapCoordinate = [userLocMapView convertPoint:touchPoint toCoordinateFromView:userLocMapView];
    
    longPressLocationAnnotation = [[QuickMapAnnotations alloc] init];
    longPressLocationAnnotation.title = @"You are here.";
    longPressLocationAnnotation.coordinate = touchMapCoordinate;
    appDelegate.LONG_PRESS_USER_LOCATION_LAT = longPressLocationAnnotation.coordinate.latitude;
    appDelegate.LONG_PRESS_USER_LOCATION_LONG = longPressLocationAnnotation.coordinate.longitude;
    appDelegate.LONG_PRESS_USER_LOCATION_COORDINATE = touchMapCoordinate;
    
    [userLocMapView addAnnotation:longPressLocationAnnotation];
    [userLocMapView selectAnnotation:longPressLocationAnnotation animated:YES];
}


//*************** Method For Submitting User Location

- (void) submitLongPressLocation {
    
    appDelegate.IS_USER_LOCATION_SELECTED_BY_LONG_PRESS = YES;
    [self.navigationController popViewControllerAnimated:YES];
}



# pragma mark - MKMapViewDelegate Methods


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *pinView = nil;
    
    if (annotation == longPressLocationAnnotation) {
        
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[userLocMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"current_location_icon.png"];
        [userLocMapView.userLocation setTitle:@"You are here."];
        
    }
    return pinView;
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Select Location";
    self.view.backgroundColor = RGB(242, 242, 242);
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    userLocMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-104)];
    userLocMapView.delegate = self;
    [userLocMapView setMapType:MKMapTypeStandard];
    [userLocMapView setZoomEnabled:YES];
    [userLocMapView setShowsUserLocation:YES];
    [userLocMapView setScrollEnabled:YES];
    [self.view  addSubview:userLocMapView];
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        MKCoordinateRegion mapRegion;
        mapRegion.center = appDelegate.USER_CURRENT_LOCATION_COORDINATE;
        mapRegion.span.latitudeDelta = 0.013f;
        mapRegion.span.longitudeDelta = 0.013f;
        [userLocMapView setRegion:mapRegion animated: YES];
        
        appDelegate.LONG_PRESS_USER_LOCATION_LAT = appDelegate.CURRENT_LOCATION_LAT;
        appDelegate.LONG_PRESS_USER_LOCATION_LONG = appDelegate.CURRENT_LOCATION_LONG;
        appDelegate.LONG_PRESS_USER_LOCATION_COORDINATE = appDelegate.USER_CURRENT_LOCATION_COORDINATE;
    }
    
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, userLocMapView.bounds.size.width, 20)];
    instructionLabel.backgroundColor = [UIColor lightGrayColor];
    instructionLabel.text = @"Long Press To Select Location";
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    [userLocMapView addSubview:instructionLabel];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [userLocMapView addGestureRecognizer:lpgr];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"USE THIS LOCATION" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    submitButton.tag = 4;
    submitButton.frame = CGRectMake(0, userLocMapView.frame.origin.y+userLocMapView.bounds.size.height, self.view.bounds.size.width, 40);
    [submitButton setBackgroundColor:RGB(83, 83, 83)];
    [submitButton addTarget:self action:@selector(submitLongPressLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];

}

- (void) viewWillAppear:(BOOL)animated {
    
    [appDelegate setShouldRotate:NO];
    [CommonFunctions googleAnalyticsTracking:@"Page: Long Press User Location View"];
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
