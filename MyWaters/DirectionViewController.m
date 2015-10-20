//
//  DirectionViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 6/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "DirectionViewController.h"

@interface DirectionViewController () {
    
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
}

@end

@implementation DirectionViewController
@synthesize destinationLat,destinationLong;


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [directionMapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [directionMapView addOverlay:_routeOverlay];
    
}


//*************** Method To Request Apple Server For Route

- (void) sendRouteRequest {
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(destinationLat,destinationLong);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:[MKMapItem mapItemForCurrentLocation]];
    [request setDestination:destination];
    [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            
            _currentRoute = [response.routes firstObject];
            [self plotRouteOnMap:_currentRoute];
            
//            self.navigationItem.rightBarButtonItem = routesButton;
//            [stepsTableView reloadData];
            [appDelegate.hud hide:YES];

//            for (MKRoute *route in [response routes]) {
//                [directionMapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
//                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
//                
//                [appDelegate.hud hide:YES];
//            }
        }
    }];
    
}


//*************** Method To Animate Steps Table View

- (void) animateRouteStepsTable {
    
    [UIView beginAnimations:@"stepsTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = stepsTableView.center;
    
    if (isShowingStepsTable) {
        isShowingStepsTable = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        pos.y = self.view.bounds.size.height+150;
        
    }
    else {
        isShowingStepsTable = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        pos.y = self.view.bounds.size.height/2+110;
        
    }
    stepsTableView.center = pos;
    [UIView commitAnimations];
    
}



# pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, stepsTableView.bounds.size.width, 40)];
    headerView.backgroundColor = RGB(255, 255, 255);
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 10, 70, 20);
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:16];
    [closeButton addTarget:self action:@selector(animateRouteStepsTable) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeButton];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_currentRoute.steps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"steps"];
    
    // Pull out the correct step
    MKRouteStep *step = _currentRoute.steps[indexPath.row];
    
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%02ld) %@ - \n%0.1fkm", indexPath.row,step.instructions, step.distance / 1000.0];
    cell.detailTextLabel.text = step.notice;
    
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69.5, stepsTableView.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    return cell;
}



# pragma mark - MKMapViewDelegate Methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor blueColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation: (MKUserLocation *)userLocation {
    
    directionMapView.centerCoordinate = userLocation.location.coordinate;
    [self sendRouteRequest];

}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *pinView;// = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"UserLocation"];
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        pinView = (MKPinAnnotationView*)[directionMapView dequeueReusableAnnotationViewWithIdentifier:@"UserLocation"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];
            
        } else {
            pinView.annotation = annotation;
        }
        
        pinView.canShowCallout = YES;
        pinView.pinColor = MKPinAnnotationColorRed;
        
        return pinView;
    }
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        pinView = (MKPinAnnotationView*)[directionMapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        } else {
            pinView.annotation = annotation;
        }
        
        pinView.canShowCallout = YES;
        pinView.pinColor = MKPinAnnotationColorGreen;
        return pinView;
    }
    return nil;
}


# pragma mark - View Life Cycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Map Route";
    self.view.backgroundColor = RGB(242, 242, 242);
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
//    routesButton = [[UIBarButtonItem alloc] initWithTitle:@"Steps" style:UIBarButtonItemStyleDone target:self action:@selector(animateRouteStepsTable)];
//    self.navigationItem.rightBarButtonItem = nil;

    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    directionMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    directionMapView.delegate = self;
    [directionMapView setMapType:MKMapTypeStandard];
    [directionMapView setZoomEnabled:YES];
    [directionMapView setScrollEnabled:YES];
    [self.view  addSubview:directionMapView];
    
    
//    stepsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height/2) style:UITableViewStylePlain];
//    stepsTableView.dataSource = self;
//    stepsTableView.delegate = self;
//    stepsTableView.backgroundColor = [UIColor clearColor];
//    stepsTableView.backgroundView = nil;
//    [self.view addSubview:stepsTableView];
    
    [self sendRouteRequest];
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
