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

//    ARGeoCoordinate *tappedCoordinate = [markerView coordinate];
//    CLLocation *location = [tappedCoordinate geoLocation];
//
//    int index = [_locations indexOfObjectPassingTest:^(id obj, NSUInteger index, BOOL *stop) {
//        return [[obj location] isEqual:location];
//    }];
//
//    if(index != NSNotFound) {
//        Place *tappedPlace = [_locations objectAtIndex:index];
//        [[PlacesLoader sharedInstance] loadDetailInformation:tappedPlace successHanlder:^(NSDictionary *response) {
//            NSLog(@"Response: %@", response);
//            NSDictionary *resultDict = [response objectForKey:@"result"];
//            [tappedPlace setPhoneNumber:[resultDict objectForKey:kPhoneKey]];
//            [tappedPlace setWebsite:[resultDict objectForKey:kWebsiteKey]];
//            [self showInfoViewForPlace:tappedPlace];
//        } errorHandler:^(NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
//    }
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
    
    _locations = [[NSArray alloc] init];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
    
    if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self view] parentViewController:self withDelgate:self];
    }
    
    [_arController setMinimumScaleFactor:0.5];
    [_arController setScaleViewsBasedOnDistance:YES];
    [_arController setRotateViewsBasedOnPerspective:YES];
    [_arController setDebugMode:NO];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissARView)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:doneButton,flexibleSpace, nil]];
    [self.view addSubview:toolBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [self generateGeoLocations];
    
    self.navigationController.navigationBar.hidden = YES;
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
//    return YES;
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setLocations:_locations];
        [[segue destinationViewController] setUserLocation:[_mapView userLocation]];
    }
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
