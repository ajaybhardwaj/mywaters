//
//  ARViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 17/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ARViewController.h"
#import "MarkerView.h"

@interface ARViewController () <MarkerViewDelegate>

@property (nonatomic, strong) AugmentedRealityController *arController;
@property (nonatomic, strong) NSMutableArray *geoLocations;

@end

@interface UIDevice (MyPrivateNameThatAppleWouldNeverUseGoesHere)
- (void) setOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation ARViewController


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//*************** Method To Dismiss ARView

- (void) dismissARView {
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}


//*************** Method To Remove Overlay ScrollView

- (void) removeOverlayScrollview {
    
    for (UIView * view in overlayScrollview.subviews) {
        [view removeFromSuperview];
    }
    
    overlayScrollview.hidden = YES;
}


//*************** Method To Create AR View Pointers

- (void)generateGeoLocations {
    
    [appDelegate retrievePointOfInterests:1];
    
    NSLog(@"%@",appDelegate.POI_ARRAY);
    
    if (appDelegate.POI_ARRAY.count!=0) {
        
        [self setGeoLocations:[NSMutableArray arrayWithCapacity:appDelegate.POI_ARRAY.count]];
        
        for (int i=0; i<appDelegate.POI_ARRAY.count; i++) {
            
            CLLocation *locationValue=[[CLLocation alloc] initWithLatitude:[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"lat"] doubleValue] longitude:[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"long"] doubleValue]];
            
            ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:locationValue locationTitle:[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"name"]];
            [coordinate calibrateUsingOrigin:[_userLocation location]];
            MarkerView *markerView = [[MarkerView alloc] initWithCoordinate:coordinate delegate:self];
            NSLog(@"Marker view %@", markerView);
            markerView.tag = i;
            
            [coordinate setDisplayView:markerView];
            [_arController addCoordinate:coordinate];
            [_geoLocations addObject:coordinate];
        }
    }
    
//        [self setGeoLocations:[NSMutableArray arrayWithCapacity:[_locations count]]];
//        
//        NSLog(@"%lu",(unsigned long)[_locations count]);
//        
//        for(Place *place in _locations) {
//            ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:[place location] locationTitle:[place placeName]];
//            
//            NSLog(@"%@---%@",[place location],[place placeName]);
//            
//            [coordinate calibrateUsingOrigin:[_userLocation location]];
//            MarkerView *markerView = [[MarkerView alloc] initWithCoordinate:coordinate delegate:self];
//            NSLog(@"Marker view %@", markerView);
//            
//            [coordinate setDisplayView:markerView];
//            [_arController addCoordinate:coordinate];
//            [_geoLocations addObject:coordinate];
//        }
    
}

#pragma mark - ARLocationDelegate

-(NSMutableArray *)geoLocations {
    
    if(!_geoLocations) {
        
        [self generateGeoLocations];
    }
    return _geoLocations;
}

- (void)locationClicked:(ARGeoCoordinate *)coordinate {
    NSLog(@"Tapped location %@", coordinate);
}

#pragma mark - ARDelegate

-(void)didUpdateHeading:(CLHeading *)newHeading {
    
}

-(void)didUpdateLocation:(CLLocation *)newLocation {
    
}

-(void)didUpdateOrientation:(UIDeviceOrientation)orientation {
    
}

#pragma mark - ARMarkerDelegate

-(void)didTapMarker:(ARGeoCoordinate *)coordinate {
 

}


- (void)didTouchMarkerView:(MarkerView *)markerView {
    
    overlayScrollview.hidden = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, self.view.bounds.size.height-120, 25)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:18.0];
    titleLabel.text = [[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"name"];
    [overlayScrollview addSubview:titleLabel];
    
    CLLocation *locationValue=[[CLLocation alloc] initWithLatitude:[[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"lat"] doubleValue] longitude:[[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"long"] doubleValue]];
    ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:locationValue locationTitle:[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"name"]];
    [coordinate calibrateUsingOrigin:[_userLocation location]];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.height-100, 50, 70, 25)];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:18.0];
    distanceLabel.text = [NSString stringWithFormat:@"%.2f km", [coordinate distanceFromOrigin] / 1000.0f];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [overlayScrollview addSubview:distanceLabel];
    
    UIImageView *seperatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, self.view.bounds.size.height-40, 2)];
    seperatorImageView.backgroundColor = [UIColor whiteColor];
    [overlayScrollview addSubview:seperatorImageView];
    
    
    UILabel___Extension *descriptionLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(20, seperatorImageView.frame.origin.y+seperatorImageView.bounds.size.height+10, self.view.bounds.size.height-40, 40)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.text = [NSString stringWithFormat:@"Dummy Description Text. Dummy Description Text. Dummy Description Text.\n\nDummy Description Text. Dummy Description Text. Dummy Description Text\nDummy Description Text. Dummy Description Text. Dummy Description Text. Dummy Description Text. Dummy Description Text\n\nDummy Description Text. Dummy Description Text. Dummy Description Text"];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    CGSize expectedDescriptionLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"description"]] sizeWithFont:descriptionLabel.font
    //                                                                                                              constrainedToSize:descriptionLabel.frame.size
    //                                                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
    CGSize expectedDescriptionLabelSize = [[NSString stringWithFormat:@"Dummy Description Text. Dummy Description Text. Dummy Description Text.\nDummy Description Text. Dummy Description Text. Dummy Description Text\nDummy Description Text. Dummy Description Text. Dummy Description Text. Dummy Description Text. Dummy Description Text\n Dummy Description Text. Dummy Description Text. Dummy Description Text"]
                                           sizeWithFont:descriptionLabel.font
                                           constrainedToSize:descriptionLabel.frame.size
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGRect newDescriptionLabelFrame = descriptionLabel.frame;
    newDescriptionLabelFrame.size.height = expectedDescriptionLabelSize.height;
    descriptionLabel.frame = newDescriptionLabelFrame;
    [overlayScrollview addSubview:descriptionLabel];
    [descriptionLabel sizeToFit];


    UIScrollView *picturesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, descriptionLabel.frame.origin.y+descriptionLabel.bounds.size.height+10, self.view.bounds.size.height, 80)];
    picturesScrollView.showsHorizontalScrollIndicator = NO;
    picturesScrollView.showsVerticalScrollIndicator = NO;
    [overlayScrollview addSubview:picturesScrollView];
    picturesScrollView.backgroundColor = [UIColor clearColor];
    
    
    int xAxis = 20;
    
    for (int i=0; i<pictureDataSource.count; i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, 5, 70, 70)];
        [image setBackgroundColor:[UIColor lightGrayColor]];
        image.tag = i;
        [picturesScrollView addSubview:image];
        
        xAxis = xAxis + 90;
    }
    
    UIButton *addPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPictureButton.frame = CGRectMake(xAxis, 5, 70, 70);
    [addPictureButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_add.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [picturesScrollView addSubview:addPictureButton];
    
    picturesScrollView.contentSize = CGSizeMake((pictureDataSource.count*70 + pictureDataSource.count*20 + 100), 80);
    
    overlayScrollview.contentSize = CGSizeMake(self.view.bounds.size.height, 10+titleLabel.bounds.size.height+10+seperatorImageView.bounds.size.height+10+descriptionLabel.bounds.size.height+10+picturesScrollView.bounds.size.height+30);
    
}

//- (void)showInfoViewForPlace:(Place *)place {
//    CGRect frame = [[self view] frame];
//    UITextView *infoView = [[UITextView alloc] initWithFrame:CGRectMake(50.0f, 50.0f, frame.size.width - 100.0f, frame.size.height - 100.0f)];
//    [infoView setCenter:[[self view] center]];
//    [infoView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
//    [infoView setText:[place infoText]];
//    [infoView setTag:kInfoViewTag];
//    [infoView setEditable:NO];
//    [[self view] addSubview:infoView];
//}
//

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UIView *infoView = [[self view] viewWithTag:kInfoViewTag];
//    [infoView removeFromSuperview];
}



# pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //1
    CLLocation *lastLocation = [locations lastObject];
    
    //2
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
    
    //3
    if(accuracy < 100.0) {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
        MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
        
        [_mapView setRegion:region animated:YES];
        
        NSMutableArray *temp = [NSMutableArray array];
        
        for (int i=0; i<appDelegate.POI_ARRAY.count; i++) {
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"lat"] doubleValue] longitude:[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"long"] doubleValue]];
            Place *currentPlace = [[Place alloc] initWithLocation:location reference:nil name:[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"name"] address:[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"address"]];
            [temp addObject:currentPlace];
            
        }
        
        _locations = [temp copy];
        NSLog(@"Locations: %@", _locations);

    }
    
    [manager stopUpdatingLocation];

}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.IS_ARVIEW_CUSTOM_LABEL = YES;

    // Temp data set
    pictureDataSource = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    
    _locations = [[NSArray alloc] init];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
//    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
    
    if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self view] parentViewController:self withDelgate:self];
    }
    
    [_arController setMinimumScaleFactor:0.5];
    [_arController setScaleViewsBasedOnDistance:YES];
    [_arController setRotateViewsBasedOnPerspective:YES];
    [_arController setDebugMode:NO];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    if (IS_IPHONE_4_OR_LESS) {
        toolBar.frame = CGRectMake(60, 218, self.view.bounds.size.height, 44);
    }
    else if (IS_IPHONE_5) {
        toolBar.frame = CGRectMake(15, 262, self.view.bounds.size.height, 44);
    }
    else if (IS_IPHONE_6) {
        toolBar.frame = CGRectMake(20, 312, self.view.bounds.size.height, 44);
    }
    else if (IS_IPHONE_6P) {
        toolBar.frame = CGRectMake(25, 347, self.view.bounds.size.height, 44);
    }
    
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissARView)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:doneButton,flexibleSpace, nil]];
    [self.view addSubview:toolBar];
    
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
    
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, degreesToRadians(90));
    toolBar.transform = rotationTransform;
    
    overlayScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(-125, 125, self.view.bounds.size.height, self.view.bounds.size.width)];
    overlayScrollview.backgroundColor = [UIColor blackColor];
    overlayScrollview.showsHorizontalScrollIndicator = NO;
    overlayScrollview.showsVerticalScrollIndicator = NO;
    overlayScrollview.alpha = 0.5;
    [self.view addSubview:overlayScrollview];
    overlayScrollview.hidden = YES;
    
    overlayScrollview.transform = rotationTransform;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [self generateGeoLocations];
    self.navigationController.navigationBar.hidden = YES;
    
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    }
    // add whatever logic you would otherwise have
    return YES;
}



//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return NO;
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setLocations:_locations];
        [[segue destinationViewController] setUserLocation:[_mapView userLocation]];
    }
}


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
