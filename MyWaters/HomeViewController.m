//
//  HomeViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewControllerHelper.h"
#import "QuickMapAnnotations.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize locationManager;
@synthesize region;

//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
//    isExpandingMenu = YES;
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To Get Nowcast Weather XML Data

- (void) getTwelveHourWeatherData {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TWELVE_HOUR_FORECAST] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *responseString  = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLString:responseString];
    twelveHourForecastDictionary = [[xmlDictionary objectForKey:@"channel"] valueForKey:@"item"];
    
    if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"FD"]) {
        bigTempSubtitle.text = @"FAIR";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/FD.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"FN"]) {
        bigTempSubtitle.text = @"FAIR";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/FN.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"PC"]) {
        bigTempSubtitle.text = @"PARTLY CLOUDY";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/PC.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"CD"]) {
        bigTempSubtitle.text = @"CLOUDY";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/CD.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"HZ"]) {
        bigTempSubtitle.text = @"HAZY";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/HZ.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"WD"]) {
        bigTempSubtitle.text = @"WINDY";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/WD.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"RA"]) {
        bigTempSubtitle.text = @"RAINY";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/RA.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"PS"]) {
        bigTempSubtitle.text = @"PASSING SHOWERS";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/PS.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"SH"]) {
        bigTempSubtitle.text = @"SHOWERS";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/SH.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if ([[twelveHourForecastDictionary objectForKey:@"wxmain"] isEqualToString:@"TS"]) {
        bigTempSubtitle.text = @"THUNDERY SHOWERS";
        [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/TS.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    
    
    bigWeatherTempTitle.text = [NSString stringWithFormat:@"Max %@°C - Min %@°C",[[twelveHourForecastDictionary objectForKey:@"temperature"] objectForKey:@"_high"],[[twelveHourForecastDictionary objectForKey:@"temperature"] objectForKey:@"_low"]];
    bigTimeLabel.text = [NSString stringWithFormat:@"%@ - %@",[[twelveHourForecastDictionary objectForKey:@"forecastValidityFrom"] objectForKey:@"_time"],[[twelveHourForecastDictionary objectForKey:@"forecastValidityTill"] objectForKey:@"_time"]];
}



//*************** Method To Handle Long Press Gesture For Default Location PIN

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:quickMap];
    CLLocationCoordinate2D touchMapCoordinate = [quickMap convertPoint:touchPoint toCoordinateFromView:quickMap];
    
    longPressLocationAnnotation = [[QuickMapAnnotations alloc] init];
    longPressLocationAnnotation.coordinate = touchMapCoordinate;
    NSNumber *latitude = [NSNumber numberWithDouble:longPressLocationAnnotation.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:longPressLocationAnnotation.coordinate.longitude];
    
    DebugLog(@"Lat %@ --- Long %@",latitude,longitude);
    [quickMap addAnnotation:longPressLocationAnnotation];
}


//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
        viewObj.isNotQuickMapController = YES;
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==2) {
        CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==3) {
        WhatsUpViewController *viewObj = [[WhatsUpViewController alloc] init];
        viewObj.isNotWhatsUpController = YES;
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==4) {
        FeedbackViewController *viewObj = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    
}


//*************** Demo App UI

- (void) createDemoAppControls {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/dashboard.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    quickMapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quickMapButton.tag = 1;
    [quickMapButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quickMapButton];
    
    cctvButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cctvButton.tag = 2;
    [cctvButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cctvButton];
    
    whatsUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    whatsUpButton.tag = 3;
    [whatsUpButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whatsUpButton];
    
    reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reportButton.tag = 4;
    [reportButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportButton];
    
    if (IS_IPHONE_4_OR_LESS) {
        quickMapButton.frame = CGRectMake(10, 75, (self.view.bounds.size.width-30)/2, 105);
        cctvButton.frame = CGRectMake(10, 300, (self.view.bounds.size.width-30)/2, 100);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 75, (self.view.bounds.size.width-30)/2, 210);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 300, (self.view.bounds.size.width-30)/2, 100);
    }
    else if (IS_IPHONE_5) {
        quickMapButton.frame = CGRectMake(10, 90, (self.view.bounds.size.width-30)/2, 125);
        cctvButton.frame = CGRectMake(10, 360, (self.view.bounds.size.width-30)/2, 130);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 90, (self.view.bounds.size.width-30)/2, 260);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 360, (self.view.bounds.size.width-30)/2, 130);
    }
    else if (IS_IPHONE_6) {
        quickMapButton.frame = CGRectMake(10, 110, (self.view.bounds.size.width-30)/2, 145);
        cctvButton.frame = CGRectMake(10, 430, (self.view.bounds.size.width-30)/2, 150);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 110, (self.view.bounds.size.width-30)/2, 305);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 430, (self.view.bounds.size.width-30)/2, 150);
    }
    else if (IS_IPHONE_6P) {
        quickMapButton.frame = CGRectMake(10, 125, (self.view.bounds.size.width-30)/2, 160);
        cctvButton.frame = CGRectMake(10, 480, (self.view.bounds.size.width-30)/2, 165);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 125, (self.view.bounds.size.width-30)/2, 335);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 480, (self.view.bounds.size.width-30)/2, 165);
    }
    
}



//*************** Method To Create Specific Corner Round For Views

- (void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}


//*************** Method To Move To Selected Views

- (void) handleColumnsTouchEvent:(UIButton *) sender {
    
    UIButton *touchedView = (id) sender;
    appDelegate.IS_COMING_FROM_DASHBOARD = YES;
    
    if (touchedView.tag==1) {
        QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (touchedView.tag==2) {
        // Water Level Sensors
        WaterLevelSensorsDetailViewController *viewObj = [[WaterLevelSensorsDetailViewController alloc] init];
        appDelegate.IS_MOVING_TO_WLS_FROM_DASHBOARD = YES;
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"id"] != (id)[NSNull null])
            viewObj.wlsID = [[wlsDataArray objectAtIndex:0] objectForKey:@"id"];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"name"] != (id)[NSNull null])
            viewObj.wlsName = [[wlsDataArray objectAtIndex:0] objectForKey:@"name"];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] != (id)[NSNull null])
            viewObj.drainDepthType = [[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"latitude"] != (id)[NSNull null])
            viewObj.latValue = [[[wlsDataArray objectAtIndex:0] objectForKey:@"latitude"] doubleValue];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"longitude"] != (id)[NSNull null])
            viewObj.longValue = [[[wlsDataArray objectAtIndex:0] objectForKey:@"longitude"] doubleValue];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"observationTime"] != (id)[NSNull null])
            viewObj.observedTime = [CommonFunctions dateTimeFromString:[[wlsDataArray objectAtIndex:0] objectForKey:@"observationTime"]];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevel"] != (id)[NSNull null])
            viewObj.waterLevelValue = [NSString stringWithFormat:@"%d",[[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevel"] intValue]];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelPercentage"] != (id)[NSNull null])
            viewObj.waterLevelPercentageValue = [NSString stringWithFormat:@"%d",[[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelPercentage"] intValue]];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] != (id)[NSNull null])
            viewObj.waterLevelTypeValue = [NSString stringWithFormat:@"%d",[[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"drainDepth"] != (id)[NSNull null])
            viewObj.drainDepthValue = [NSString stringWithFormat:@"%d",[[[wlsDataArray objectAtIndex:0] objectForKey:@"drainDepth"] intValue]];
        
        if ([[wlsDataArray objectAtIndex:0] objectForKey:@"isSubscribed"] != (id)[NSNull null])
            viewObj.isSubscribed = [[[wlsDataArray objectAtIndex:0] objectForKey:@"isSubscribed"] intValue];
        
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (touchedView.tag==3) {
        WeatherForecastViewController *viewObj = [[WeatherForecastViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (touchedView.tag==4) {
        
        CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
        appDelegate.IS_MOVING_TO_CCTV_FROM_DASHBOARD = YES;
        
        if ([[cctvDataArray objectAtIndex:0] objectForKey:@"CCTVImageURL"] != (id)[NSNull null])
            viewObj.imageUrl = [[cctvDataArray objectAtIndex:0] objectForKey:@"CCTVImageURL"];
        if ([[cctvDataArray objectAtIndex:0] objectForKey:@"Name"] != (id)[NSNull null])
            viewObj.titleString = [[cctvDataArray objectAtIndex:0] objectForKey:@"Name"];
        if ([[cctvDataArray objectAtIndex:0] objectForKey:@"ID"] != (id)[NSNull null])
            viewObj.cctvID = [[cctvDataArray objectAtIndex:0] objectForKey:@"ID"];
        if ([[cctvDataArray objectAtIndex:0] objectForKey:@"Lat"] != (id)[NSNull null])
            viewObj.latValue = [[[cctvDataArray objectAtIndex:0] objectForKey:@"Lat"] doubleValue];
        if ([[cctvDataArray objectAtIndex:0] objectForKey:@"Lon"] != (id)[NSNull null])
            viewObj.longValue = [[[cctvDataArray objectAtIndex:0] objectForKey:@"Lon"] doubleValue];
        
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (touchedView.tag==5) {
        WhatsUpViewController *viewObj = [[WhatsUpViewController alloc] init];
        viewObj.isNotWhatsUpController = YES;
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (touchedView.tag==6) {
        EventsViewController *viewObj = [[EventsViewController alloc] init];
        viewObj.isNotEventController = YES;
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    
}



//*************** Method To Handle Dots Button Action

- (void) handleDotsButtonAction:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
        viewObj.isNotQuickMapController = YES;
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==2) {
        WLSListingViewController *viewObj = [[WLSListingViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==3) {
        WeatherForecastViewController *viewObj = [[WeatherForecastViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==4) {
        CCTVListingController *viewObj = [[CCTVListingController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==5) {
        WhatsUpViewController *viewObj = [[WhatsUpViewController alloc] init];
        viewObj.isNotWhatsUpController = YES;
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==6) {
        EventsViewController *viewObj = [[EventsViewController alloc] init];
        viewObj.isNotEventController = YES;
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}



//*************** Method To Move To Report/Feedback View

- (void) moveToFeedbackView {
    
    FeedbackViewController *viewObj = [[FeedbackViewController alloc] init];
    viewObj.isNotFeedbackController = YES;
    [self.navigationController pushViewController:viewObj animated:YES];
    
}



//*************** Method To Call Dashboard API

- (void) fetchDashboardData {
    
//    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
//    appDelegate.hud.labelText = @"Loading...";

    NSArray *parameters = [[NSArray alloc] initWithObjects:@"IsDashboard",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"true",@"1.0", nil];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}


//*************** Method To Refresh Home Page UI


- (void) refreshHomePageContent {
    
    
    // WLS Content Refresh
    
    if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==1) {
        drainDepthValueLabel.text = @"Low Flood Risk";
    }
    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==2) {
        drainDepthValueLabel.text = @"Moderate Flood Risk";
    }
    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==3) {
        drainDepthValueLabel.text = @"High Flood Risk";
    }
    else {
        drainDepthValueLabel.text = @"Under Maintenance";
    }
    drainDepthValueLabel.numberOfLines = 0;
    [drainDepthValueLabel sizeToFit];

    waterSensorLocationLabel.text = [[wlsDataArray objectAtIndex:0] objectForKey:@"name"];
 
    
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D desinationLocationWLS;
    
    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
    
    desinationLocationWLS.latitude = [[[wlsDataArray objectAtIndex:0] objectForKey:@"latitude"] doubleValue];
    desinationLocationWLS.longitude = [[[wlsDataArray objectAtIndex:0] objectForKey:@"longitude"] doubleValue];
    NSString *wlsDistanceString = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocationWLS]];
    waterSensorDrainDepthLabel.text = wlsDistanceString;
    
    if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==1) {
        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==2) {
        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==3) {
        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else {
        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_undermaintenance.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    
    
    
    // CCTV Content Refresh
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@",[[cctvDataArray objectAtIndex:0] objectForKey:@"CCTVImageURL"]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(cctvImageView.bounds.size.width/2, cctvImageView.bounds.size.height/2);
    [cctvImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            cctvImageView.image = image;
            
        }
        else {
            DebugLog(@"Image Loading Failed..!!");
            cctvImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        [activityIndicator stopAnimating];
    }];
    
    cctvLocationLabel.text = [[cctvDataArray objectAtIndex:0] objectForKey:@"Name"];
    
    CLLocationCoordinate2D desinationLocationCCTV;
    desinationLocationCCTV.latitude = [[[cctvDataArray objectAtIndex:0] objectForKey:@"Lat"] doubleValue];
    desinationLocationCCTV.longitude = [[[cctvDataArray objectAtIndex:0] objectForKey:@"Lon"] doubleValue];
    NSString *cctvDistanceString = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocationCCTV]];
    cctvDistanceLabel.text = cctvDistanceString;
    
    
    // Weather Content Refresh
    
    if (isShowingWeatherModule) {
        [self getTwelveHourWeatherData];
    }
    
    // Whatsup Content Refresh
    [whatsUpListingTable reloadData];
    
    // Events Content Refresh
    [eventsListingTable reloadData];
    
    // Tips Content Refresh
    
    NSString *urlString;
    for (int i=0; i<tipsDataArray.count; i++) {
        if ([[[tipsDataArray objectAtIndex:i] objectForKey:@"Media"] intValue] == 4) {
            urlString = [[tipsDataArray objectAtIndex:i] objectForKey:@"EmbedURL"];
            break;
        }
    }
    // iframe
    NSString *url = urlString;//@"https://www.youtube.com/embed/5fDrVA2_nbg";
    url = [NSString stringWithFormat:@"%@?rel=0&showinfo=0&controls=0",url];
    NSString* embedHTML = [NSString stringWithFormat:@"\
                           <iframe width=\"150\" height=\"150\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                           ",url];
    
    NSString* html = [NSString stringWithFormat:embedHTML, url, self.view.bounds.size.width+10, 150];
    [tipsWebView loadHTMLString:html baseURL:nil];
}



//*************** Method To Create Home Page UI

- (void) createDynamicUIColumns {
    
    
    for (UIView * view in backgroundScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    welcomeView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 110)];
    welcomeView.backgroundColor = [UIColor whiteColor];
    welcomeView.layer.cornerRadius = 10;
    [backgroundScrollView addSubview:welcomeView];
    
    UILabel *welcomeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, welcomeView.bounds.size.width, 20)];
    welcomeHeaderLabel.text = @"   Welcome!";
    welcomeHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
    welcomeHeaderLabel.textColor = [UIColor whiteColor];
    welcomeHeaderLabel.backgroundColor = RGB(67, 79, 93);
    [welcomeView addSubview:welcomeHeaderLabel];
    
    [self setMaskTo:welcomeHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 70, 70)];
    profileImageView.layer.cornerRadius = 35;
    profileImageView.layer.masksToBounds = YES;
    [welcomeView addSubview:profileImageView];
    
    
    if ([[appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"UserProfile"] objectForKey:@"ImageName"] != (id)[NSNull null] || [[[appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"UserProfile"] objectForKey:@"ImageName"] length] !=0) {
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"UserProfile"] objectForKey:@"ImageName"]];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(profileImageView.bounds.size.width/2, profileImageView.bounds.size.height/2);
        [profileImageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                profileImageView.image = image;
            }
            else {
                [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_avatar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
            }
            [activityIndicator stopAnimating];
        }];
    }
    
    welcomeUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, welcomeView.bounds.size.width-110, 70)];
    welcomeUserLabel.text = @"";
    welcomeUserLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
    welcomeUserLabel.textColor = [UIColor blackColor];
    welcomeUserLabel.backgroundColor = [UIColor clearColor];
    welcomeUserLabel.numberOfLines = 0;
    [welcomeView addSubview:welcomeUserLabel];
    
    
    reportIncidentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reportIncidentButton.frame = CGRectMake(10, welcomeView.frame.origin.y + welcomeView.bounds.size.height + 10, self.view.bounds.size.width-20, 40);
    [reportIncidentButton setBackgroundColor:RGB(242, 47, 56)];
    [reportIncidentButton setTitle:@"Report Incident" forState:UIControlStateNormal];
    reportIncidentButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [reportIncidentButton setTintColor:[UIColor whiteColor]];
    reportIncidentButton.layer.cornerRadius = 10;
    [reportIncidentButton addTarget:self action:@selector(moveToFeedbackView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:reportIncidentButton];
    
    
    UIImageView *reportIncidentImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7, 30, 30)];
    [reportIncidentImage setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_report.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [reportIncidentButton addSubview:reportIncidentImage];
    
    
    left_yAxis = reportIncidentButton.frame.origin.y + reportIncidentButton.bounds.size.height + 10;
    right_yAxis = reportIncidentButton.frame.origin.y + reportIncidentButton.bounds.size.height + 10.1;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    
    if (hour < 12) {
        welcomeUserLabel.text = [NSString stringWithFormat:@"Good Morning, %@",[[appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"UserProfile"] objectForKey:@"Name"]];
    }
    else if (hour >= 12 && hour <= 16) {
        welcomeUserLabel.text = [NSString stringWithFormat:@"Good Afternoon, %@",[[appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"UserProfile"] objectForKey:@"Name"]];
    }
    else if (hour > 16) {
        welcomeUserLabel.text = [NSString stringWithFormat:@"Good Evening, %@",[[appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"UserProfile"] objectForKey:@"Name"]];
    }
    
    for (int i=0; i<appDelegate.DASHBOARD_PREFERENCES_ARRAY.count; i++) {
        
        if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"1"]) {
            
            if (left_yAxis < right_yAxis) {
                
                UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake(10, left_yAxis, (self.view.bounds.size.width-30)/2, [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"height"] floatValue])];
                columnView.backgroundColor = [UIColor whiteColor];
                columnView.layer.cornerRadius = 10;
                [backgroundScrollView addSubview:columnView];
                columnView.userInteractionEnabled = YES;
                
                UILabel *columnViewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnView.bounds.size.width, 20)];
                columnViewHeaderLabel.text = [NSString stringWithFormat:@"   %@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"component"]];
                columnViewHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
                columnViewHeaderLabel.textColor = [UIColor whiteColor];
                columnViewHeaderLabel.backgroundColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                [columnView addSubview:columnViewHeaderLabel];
                
                [self setMaskTo:columnViewHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
                
                left_yAxis = left_yAxis + columnView.bounds.size.height + 10;
                
                
                if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==1) {
                    
                    quickMap = [[MKMapView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-3, columnView.bounds.size.height-23)];
                    quickMap.delegate = self;
                    [quickMap setMapType:MKMapTypeStandard];
                    [quickMap setZoomEnabled:YES];
                    [quickMap setScrollEnabled:NO];
                    quickMap.showsUserLocation = YES;
                    quickMap.layer.cornerRadius = 10;
                    quickMap.userTrackingMode = MKUserTrackingModeFollow;
                    [columnView addSubview:quickMap];
                    
                    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
                    [quickMap addGestureRecognizer:lpgr];
                    //                    }
                    
                    if (!locationManager) {
                        locationManager = [[CLLocationManager alloc] init];
                    }
                    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
                    if (locationAllowed == NO){
                        //GPS DISABLED.
                        DebugLog(@"Location is not enabled");
                    }
                    else{
                        if(IS_IOS8()){
                            if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
                                [locationManager requestWhenInUseAuthorization];
                            }
                            //[locationManager requestAlwaysAuthorization];
                        }
                        [locationManager requestWhenInUseAuthorization];
                        locationManager.delegate = self;
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                        [locationManager startUpdatingLocation];
                    }
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==2) {
                    
                
                    drainDepthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(columnView.bounds.size.width/2, 30, columnView.bounds.size.width/2 -10, 60)];
                    drainDepthValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
                    drainDepthValueLabel.textColor = [UIColor blackColor];//RGB(26, 158, 241);
                    drainDepthValueLabel.backgroundColor = [UIColor clearColor];
                    drainDepthValueLabel.numberOfLines = 0;
//                    if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==1) {
//                        drainDepthValueLabel.text = @"Low Flood Risk";
//                    }
//                    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==2) {
//                        drainDepthValueLabel.text = @"Moderate Flood Risk";
//                    }
//                    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==3) {
//                        drainDepthValueLabel.text = @"High Flood Risk";
//                    }
//                    else {
//                        drainDepthValueLabel.text = @"Under Maintenance";
//                    }
//                    [drainDepthValueLabel sizeToFit];
                    [columnView addSubview:drainDepthValueLabel];
                    
                    waterLevelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
                    [columnView addSubview:waterLevelImageView];
                    
                    waterSensorLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    waterSensorLocationImage.frame = CGRectMake(5, 100, 20, 20);
                    [waterSensorLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_blue.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:waterSensorLocationImage];
                    waterSensorLocationImage.userInteractionEnabled = NO;
                    
                    waterSensorDrainDepthImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    waterSensorDrainDepthImage.frame = CGRectMake(5, 125, 20, 20);
                    [waterSensorDrainDepthImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_distance_blue_wls.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:waterSensorDrainDepthImage];
                    waterSensorDrainDepthImage.userInteractionEnabled = NO;
                    
                    waterSensorLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, columnView.bounds.size.width-40, 25)];
                    waterSensorLocationLabel.text = @"";//[[wlsDataArray objectAtIndex:0] objectForKey:@"name"];
                    waterSensorLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    waterSensorLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    waterSensorLocationLabel.backgroundColor = [UIColor clearColor];
                    waterSensorLocationLabel.numberOfLines = 0;
//                    [waterSensorLocationLabel sizeToFit];
                    [columnView addSubview:waterSensorLocationLabel];
                    
                    
//                    CLLocationCoordinate2D currentLocation;
//                    CLLocationCoordinate2D desinationLocation;
//                    
//                    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
//                    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
//                    
//                    desinationLocation.latitude = [[[wlsDataArray objectAtIndex:0] objectForKey:@"latitude"] doubleValue];
//                    desinationLocation.longitude = [[[wlsDataArray objectAtIndex:0] objectForKey:@"longitude"] doubleValue];
                    
                    waterSensorDrainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, columnView.bounds.size.width-40, 25)];
//                    waterSensorDrainDepthLabel.text = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                    waterSensorDrainDepthLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    waterSensorDrainDepthLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    waterSensorDrainDepthLabel.backgroundColor = [UIColor clearColor];
//                    [waterSensorDrainDepthLabel sizeToFit];
                    [columnView addSubview:waterSensorDrainDepthLabel];
                    
                    
                    
//                    if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==1) {
//                        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//                    }
//                    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==2) {
//                        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//                    }
//                    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==3) {
//                        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//                    }
//                    else {
//                        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_undermaintenance.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//                    }
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==3) {
                    
                    isShowingWeatherModule = YES;
                    
                    bigWeatherIcon = [UIButton buttonWithType:UIButtonTypeCustom];
                    bigWeatherIcon.frame = CGRectMake(columnView.bounds.size.width/2 - 25, 30, 50, 50);
                    [columnView addSubview:bigWeatherIcon];
                    bigWeatherIcon.userInteractionEnabled = NO;
                    
                    bigTempSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, bigWeatherIcon.frame.origin.y+bigWeatherIcon.bounds.size.height+10, columnView.bounds.size.width, 15)];
                    bigTempSubtitle.text = @"";
                    bigTempSubtitle.font = [UIFont fontWithName:ROBOTO_BOLD size:14];
                    bigTempSubtitle.textColor = [UIColor blackColor];
                    bigTempSubtitle.backgroundColor = [UIColor clearColor];
                    bigTempSubtitle.numberOfLines = 0;
                    bigTempSubtitle.textAlignment = NSTextAlignmentCenter;
                    [columnView addSubview:bigTempSubtitle];
                    
                    bigWeatherTempTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, bigTempSubtitle.frame.origin.y+bigTempSubtitle.bounds.size.height+3, columnView.bounds.size.width, 15)];
                    bigWeatherTempTitle.text = [NSString stringWithFormat:@""];
                    bigWeatherTempTitle.font = [UIFont fontWithName:ROBOTO_BOLD size:13];
                    bigWeatherTempTitle.textColor = [UIColor blackColor];
                    bigWeatherTempTitle.backgroundColor = [UIColor clearColor];
                    bigWeatherTempTitle.textAlignment = NSTextAlignmentCenter;
                    [columnView addSubview:bigWeatherTempTitle];
                    
                    bigTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bigWeatherTempTitle.frame.origin.y+bigWeatherTempTitle.bounds.size.height+3, columnView.bounds.size.width, 15)];
                    bigTimeLabel.text = @"";
                    bigTimeLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:12];
                    bigTimeLabel.textColor = [UIColor lightGrayColor];
                    bigTimeLabel.backgroundColor = [UIColor clearColor];
                    bigTimeLabel.numberOfLines = 0;
                    bigTimeLabel.textAlignment = NSTextAlignmentCenter;
                    [columnView addSubview:bigTimeLabel];
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==4) {
                    
                    cctvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 20, columnView.bounds.size.width+1, 78)];
                    [columnView addSubview:cctvImageView];
                    
//                    NSString *imageURLString = [NSString stringWithFormat:@"%@",[[cctvDataArray objectAtIndex:0] objectForKey:@"CCTVImageURL"]];
                    
//                    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                    activityIndicator.center = CGPointMake(cctvImageView.bounds.size.width/2, cctvImageView.bounds.size.height/2);
//                    [cctvImageView addSubview:activityIndicator];
//                    [activityIndicator startAnimating];
//                    
//                    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
//                        if (succeeded) {
//                            
//                            cctvImageView.image = image;
//                            
//                        }
//                        else {
//                            DebugLog(@"Image Loading Failed..!!");
//                            cctvImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
//                        }
//                        [activityIndicator stopAnimating];
//                    }];
                    
                    
                    cctvLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    cctvLocationImage.frame = CGRectMake(5, 100, 20, 20);
                    [cctvLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_turqoise.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:cctvLocationImage];
                    cctvLocationImage.userInteractionEnabled = NO;
                    
                    cctvDistanceImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    cctvDistanceImage.frame = CGRectMake(5, 125, 20, 20);
                    [cctvDistanceImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_distance_turqoise.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:cctvDistanceImage];
                    cctvDistanceImage.userInteractionEnabled = NO;
                    
                    cctvLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, columnView.bounds.size.width-40, 25)];
                    cctvLocationLabel.text = @"";//[[cctvDataArray objectAtIndex:0] objectForKey:@"Name"];
                    cctvLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    cctvLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    cctvLocationLabel.backgroundColor = [UIColor clearColor];
                    cctvLocationLabel.numberOfLines = 0;
//                    [cctvLocationLabel sizeToFit];
                    [columnView addSubview:cctvLocationLabel];
                    
                    
//                    CLLocationCoordinate2D currentLocation;
//                    CLLocationCoordinate2D desinationLocation;
//                    
//                    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
//                    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
//                    
//                    desinationLocation.latitude = [[[cctvDataArray objectAtIndex:0] objectForKey:@"Lat"] doubleValue];
//                    desinationLocation.longitude = [[[cctvDataArray objectAtIndex:0] objectForKey:@"Lon"] doubleValue];
                    
                    cctvDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, columnView.bounds.size.width-40, 25)];
                    cctvDistanceLabel.text = @"";//[NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                    cctvDistanceLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    cctvDistanceLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    cctvDistanceLabel.backgroundColor = [UIColor clearColor];
//                    [cctvDistanceLabel sizeToFit];
                    [columnView addSubview:cctvDistanceLabel];
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==5) {
                    
                    whatsUpListingTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-5, columnView.bounds.size.height-25) style:UITableViewStylePlain];
                    whatsUpListingTable.delegate = self;
                    whatsUpListingTable.dataSource = self;
                    [columnView addSubview:whatsUpListingTable];
                    whatsUpListingTable.backgroundColor = [UIColor clearColor];
                    whatsUpListingTable.backgroundView = nil;
                    whatsUpListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                    whatsUpListingTable.scrollEnabled = NO;
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==6) {
                    
                    eventsListingTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-5, columnView.bounds.size.height-25) style:UITableViewStylePlain];
                    eventsListingTable.delegate = self;
                    eventsListingTable.dataSource = self;
                    [columnView addSubview:eventsListingTable];
                    eventsListingTable.backgroundColor = [UIColor clearColor];
                    eventsListingTable.backgroundView = nil;
                    eventsListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                    eventsListingTable.scrollEnabled = NO;
                    
                }
                
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==7) {
                    
                    tipsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 19.5, columnView.bounds.size.width-5, columnView.bounds.size.height-25)];
                    tipsWebView.backgroundColor = [UIColor colorWithRed:28.0/256.0 green:27.0/256.0 blue:28.0/256.0 alpha:1.0];
                    [columnView addSubview:tipsWebView];
                    tipsWebView.scrollView.scrollEnabled = NO;
                    tipsWebView.scrollView.bounces = NO;
                    
//                    // iframe
//                    NSString *url = [[tipsDataArray objectAtIndex:0] objectForKey:@"EmbedURL"];//@"https://www.youtube.com/embed/5fDrVA2_nbg";
//                    url = [NSString stringWithFormat:@"%@?rel=0&showinfo=0&controls=0",url];
//                    NSString* embedHTML = [NSString stringWithFormat:@"\
//                                           <iframe width=\"330\" height=\"150\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
//                                           ",url];
//                    
//                    NSString* html = [NSString stringWithFormat:embedHTML, url, self.view.bounds.size.width+10, 150];
//                    [tipsWebView loadHTMLString:html baseURL:nil];
                    
                }
                
                
                if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==5 || [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==6 || [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==7) {

                }
                else {
                    
                    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    overlayButton.frame = CGRectMake(0, 30, columnView.bounds.size.width, columnView.bounds.size.height-30);
                    overlayButton.tag = [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue];
                    [overlayButton addTarget:self action:@selector(handleColumnsTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
                    [columnView addSubview:overlayButton];
                }
            }
            else {
                
                UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)+5, right_yAxis, (self.view.bounds.size.width-30)/2, [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"height"] floatValue])];
                columnView.backgroundColor = [UIColor whiteColor];
                columnView.layer.cornerRadius = 10;
                [backgroundScrollView addSubview:columnView];
                columnView.userInteractionEnabled = YES;
                
                
                UILabel *columnViewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnView.bounds.size.width, 20)];
                columnViewHeaderLabel.text = [NSString stringWithFormat:@"   %@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"component"]];
                columnViewHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
                columnViewHeaderLabel.textColor = [UIColor whiteColor];
                columnViewHeaderLabel.backgroundColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                [columnView addSubview:columnViewHeaderLabel];
                
                [self setMaskTo:columnViewHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
                
                right_yAxis = right_yAxis + columnView.bounds.size.height + 10;
                
                
                if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==1) {
                    
                    quickMap = [[MKMapView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-3, columnView.bounds.size.height-23)];
                    quickMap.delegate = self;
                    [quickMap setMapType:MKMapTypeStandard];
                    [quickMap setZoomEnabled:YES];
                    [quickMap setScrollEnabled:NO];
                    quickMap.showsUserLocation = YES;
                    quickMap.layer.cornerRadius = 10;
                    quickMap.userTrackingMode = MKUserTrackingModeFollow;
                    [columnView addSubview:quickMap];
                    
                    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
                    [quickMap addGestureRecognizer:lpgr];
                    //                    }
                    
                    if (!locationManager) {
                        locationManager = [[CLLocationManager alloc] init];
                    }
                    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
                    if (locationAllowed == NO){
                        //GPS DISABLED.
                        DebugLog(@"Location is not enabled");
                    }
                    else{
                        if(IS_IOS8()){
                            if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
                                [locationManager requestWhenInUseAuthorization];
                            }

                        }
                        [locationManager requestWhenInUseAuthorization];
                        locationManager.delegate = self;
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                        [locationManager startUpdatingLocation];
                    }
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==2) {
                    
                    
                    drainDepthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(columnView.bounds.size.width/2, 30, columnView.bounds.size.width/2 -10, 60)];
                    drainDepthValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
                    drainDepthValueLabel.textColor = [UIColor blackColor];//RGB(26, 158, 241);
                    drainDepthValueLabel.backgroundColor = [UIColor clearColor];
                    drainDepthValueLabel.numberOfLines = 0;
//                    if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==1) {
//                        drainDepthValueLabel.text = @"Low Flood Risk";
//                    }
//                    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==2) {
//                        drainDepthValueLabel.text = @"Moderate Flood Risk";
//                    }
//                    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==3) {
//                        drainDepthValueLabel.text = @"High Flood Risk";
//                    }
//                    else {
//                        drainDepthValueLabel.text = @"Under Maintenance";
//                    }
//                    [drainDepthValueLabel sizeToFit];
                    [columnView addSubview:drainDepthValueLabel];
                    
                    
                    waterLevelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
                    [columnView addSubview:waterLevelImageView];
                    
                    waterSensorLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    waterSensorLocationImage.frame = CGRectMake(5, 100, 20, 20);
                    [waterSensorLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_blue.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:waterSensorLocationImage];
                    waterSensorLocationImage.userInteractionEnabled = NO;
                    
                    waterSensorDrainDepthImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    waterSensorDrainDepthImage.frame = CGRectMake(5, 125, 20, 20);
                    [waterSensorDrainDepthImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_distance_blue_wls.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:waterSensorDrainDepthImage];
                    waterSensorDrainDepthImage.userInteractionEnabled = NO;
                    
                    waterSensorLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, columnView.bounds.size.width-40, 25)];
                    waterSensorLocationLabel.text = @"";//[[wlsDataArray objectAtIndex:0] objectForKey:@"name"];
                    waterSensorLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    waterSensorLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    waterSensorLocationLabel.backgroundColor = [UIColor clearColor];
                    waterSensorLocationLabel.numberOfLines = 0;
//                    [waterSensorLocationLabel sizeToFit];
                    [columnView addSubview:waterSensorLocationLabel];
                    
                    
//                    CLLocationCoordinate2D currentLocation;
//                    CLLocationCoordinate2D desinationLocation;
//                    
//                    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
//                    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
//                    
//                    desinationLocation.latitude = [[[wlsDataArray objectAtIndex:0] objectForKey:@"latitude"] doubleValue];
//                    desinationLocation.longitude = [[[wlsDataArray objectAtIndex:0] objectForKey:@"longitude"] doubleValue];
                    
                    waterSensorDrainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, columnView.bounds.size.width-40, 25)];
//                    waterSensorDrainDepthLabel.text = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                    waterSensorDrainDepthLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    waterSensorDrainDepthLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    waterSensorDrainDepthLabel.backgroundColor = [UIColor clearColor];
//                    [waterSensorDrainDepthLabel sizeToFit];
                    [columnView addSubview:waterSensorDrainDepthLabel];
                    
                    
                    
//                    if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==1) {
//                        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//                    }
//                    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==2) {
//                        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//                    }
//                    else if ([[[wlsDataArray objectAtIndex:0] objectForKey:@"waterLevelType"] intValue]==3) {
//                        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//                    }
//                    else {
//                        [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_undermaintenance.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//                    }
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==3) {
                    
                    isShowingWeatherModule = YES;
                    
                    bigWeatherIcon = [UIButton buttonWithType:UIButtonTypeCustom];
                    bigWeatherIcon.frame = CGRectMake(columnView.bounds.size.width/2 - 25, 30, 50, 50);
                    [columnView addSubview:bigWeatherIcon];
                    bigWeatherIcon.userInteractionEnabled = NO;
                    
                    bigTempSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, bigWeatherIcon.frame.origin.y+bigWeatherIcon.bounds.size.height+10, columnView.bounds.size.width, 15)];
                    bigTempSubtitle.text = @"";
                    bigTempSubtitle.font = [UIFont fontWithName:ROBOTO_BOLD size:14];
                    bigTempSubtitle.textColor = [UIColor blackColor];
                    bigTempSubtitle.backgroundColor = [UIColor clearColor];
                    bigTempSubtitle.numberOfLines = 0;
                    bigTempSubtitle.textAlignment = NSTextAlignmentCenter;
                    [columnView addSubview:bigTempSubtitle];
                    
                    bigWeatherTempTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, bigTempSubtitle.frame.origin.y+bigTempSubtitle.bounds.size.height+3, columnView.bounds.size.width, 15)];
                    bigWeatherTempTitle.text = [NSString stringWithFormat:@""];
                    bigWeatherTempTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
                    bigWeatherTempTitle.textColor = [UIColor blackColor];
                    bigWeatherTempTitle.backgroundColor = [UIColor clearColor];
                    bigWeatherTempTitle.textAlignment = NSTextAlignmentCenter;
                    [columnView addSubview:bigWeatherTempTitle];
                    
                    bigTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bigWeatherTempTitle.frame.origin.y+bigWeatherTempTitle.bounds.size.height+3, columnView.bounds.size.width, 15)];
                    bigTimeLabel.text = @"";
                    bigTimeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
                    bigTimeLabel.textColor = [UIColor lightGrayColor];
                    bigTimeLabel.backgroundColor = [UIColor clearColor];
                    bigTimeLabel.numberOfLines = 0;
                    bigTimeLabel.textAlignment = NSTextAlignmentCenter;
                    [columnView addSubview:bigTimeLabel];
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==4) {
                    
                    cctvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 20, columnView.bounds.size.width+1, 78)];
                    [columnView addSubview:cctvImageView];
                    
                    
//                    NSString *imageURLString = [NSString stringWithFormat:@"%@",[[cctvDataArray objectAtIndex:0] objectForKey:@"CCTVImageURL"]];
//                    
//                    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                    activityIndicator.center = CGPointMake(cctvImageView.bounds.size.width/2, cctvImageView.bounds.size.height/2);
//                    [cctvImageView addSubview:activityIndicator];
//                    [activityIndicator startAnimating];
//                    
//                    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
//                        if (succeeded) {
//                            
//                            cctvImageView.image = image;
//                            
//                        }
//                        else {
//                            DebugLog(@"Image Loading Failed..!!");
//                            cctvImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
//                        }
//                        [activityIndicator stopAnimating];
//                    }];
                    
                    
                    cctvLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    cctvLocationImage.frame = CGRectMake(5, 100, 20, 20);
                    [cctvLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_turqoise.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:cctvLocationImage];
                    cctvLocationImage.userInteractionEnabled = NO;
                    
                    cctvDistanceImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    cctvDistanceImage.frame = CGRectMake(5, 125, 20, 20);
                    [cctvDistanceImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_distance_turqoise.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:cctvDistanceImage];
                    cctvDistanceImage.userInteractionEnabled = NO;
                    
                    cctvLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, columnView.bounds.size.width-40, 25)];
                    cctvLocationLabel.text = @"";//[[cctvDataArray objectAtIndex:0] objectForKey:@"Name"];
                    cctvLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    cctvLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    cctvLocationLabel.backgroundColor = [UIColor clearColor];
                    cctvLocationLabel.numberOfLines = 0;
//                    [cctvLocationLabel sizeToFit];
                    [columnView addSubview:cctvLocationLabel];
                    
                    
//                    CLLocationCoordinate2D currentLocation;
//                    CLLocationCoordinate2D desinationLocation;
//                    
//                    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
//                    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
//                    
//                    desinationLocation.latitude = [[[cctvDataArray objectAtIndex:0] objectForKey:@"Lat"] doubleValue];
//                    desinationLocation.longitude = [[[cctvDataArray objectAtIndex:0] objectForKey:@"Lon"] doubleValue];
                    
                    cctvDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, columnView.bounds.size.width-40, 25)];
                    cctvDistanceLabel.text = @"";//[NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                    cctvDistanceLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    cctvDistanceLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    cctvDistanceLabel.backgroundColor = [UIColor clearColor];
//                    [cctvDistanceLabel sizeToFit];
                    [columnView addSubview:cctvDistanceLabel];
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==5) {
                    
                    whatsUpListingTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-5, columnView.bounds.size.height-25) style:UITableViewStylePlain];
                    whatsUpListingTable.delegate = self;
                    whatsUpListingTable.dataSource = self;
                    [columnView addSubview:whatsUpListingTable];
                    whatsUpListingTable.backgroundColor = [UIColor clearColor];
                    whatsUpListingTable.backgroundView = nil;
                    whatsUpListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                    whatsUpListingTable.scrollEnabled = NO;
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==6) {
                    
                    eventsListingTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-5, columnView.bounds.size.height-25) style:UITableViewStylePlain];
                    eventsListingTable.delegate = self;
                    eventsListingTable.dataSource = self;
                    [columnView addSubview:eventsListingTable];
                    eventsListingTable.backgroundColor = [UIColor clearColor];
                    eventsListingTable.backgroundView = nil;
                    eventsListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                    eventsListingTable.scrollEnabled = NO;
                    
                }
                
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==7) {
                    
                    tipsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 19.5, columnView.bounds.size.width-5, columnView.bounds.size.height-25)];
                    tipsWebView.backgroundColor = [UIColor colorWithRed:28.0/256.0 green:27.0/256.0 blue:28.0/256.0 alpha:1.0];
                    [columnView addSubview:tipsWebView];
                    tipsWebView.scrollView.scrollEnabled = NO;
                    tipsWebView.scrollView.bounces = NO;
                    
                }
                
                if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==5 || [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==6 || [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==7) {

                }
                else {
                    
                    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    overlayButton.frame = CGRectMake(0, 30, columnView.bounds.size.width, columnView.bounds.size.height-30);
                    overlayButton.tag = [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue];
                    [overlayButton addTarget:self action:@selector(handleColumnsTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
                    [columnView addSubview:overlayButton];
                }
            }
        }
    }
    
    if (right_yAxis > left_yAxis) {
        backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, right_yAxis+80);
    }
    else {
        backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, left_yAxis+80);
    }
    
}


# pragma mark - Youtube Video Method For Orientation

- (void)youTubeStarted:(NSNotification *)notification{
    // Entered Fullscreen code goes here..
}

- (void)youTubeFinished:(NSNotification *)notification{
    // Left fullscreen code goes here...
    
    //CODE BELOW FORCES APP BACK TO PORTRAIT ORIENTATION ONCE YOU LEAVE VIDEO.
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    //present/dismiss viewcontroller in order to activate rotating.
    UIViewController *mVC = [[UIViewController alloc] init];
    [self presentViewController:mVC animated:NO completion:NULL];
    [self dismissViewControllerAnimated:NO completion:NULL];
}




# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [eventsDataArray removeAllObjects];
        [feedsDataArray removeAllObjects];
        [wlsDataArray removeAllObjects];
        [cctvDataArray removeAllObjects];
        [floodsDataArray removeAllObjects];
        [tipsDataArray removeAllObjects];
        
        [eventsDataArray setArray:[[responseString JSONValue] objectForKey:DASHBOARD_API_EVENTS_RESPONSE_NAME]];
        [feedsDataArray setArray:[[responseString JSONValue] objectForKey:DASHBOARD_API_FEEDS_RESPONSE_NAME]];
        [wlsDataArray setArray:[[responseString JSONValue] objectForKey:DASHBOARD_API_WLS_RESPONSE_NAME]];
        [cctvDataArray setArray:[[responseString JSONValue] objectForKey:DASHBOARD_API_CCTV_RESPONSE_NAME]];
        [floodsDataArray setArray:[[responseString JSONValue] objectForKey:DASHBOARD_API_FLOODS_RESPONSE_NAME]];
        [tipsDataArray setArray:[[responseString JSONValue] objectForKey:DASHBOARD_API_TIPS_RESPONSE_NAME]];
        
        [self refreshHomePageContent];
        
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    [appDelegate.hud hide:YES];
    NSError *error = [request error];
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
}



# pragma mark - MKMapViewDelegate Methods


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *pinView = nil;
    
    if (annotation == longPressLocationAnnotation) {
        
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"current_location_icon.png"];
        [quickMap.userLocation setTitle:@"You are here..!!"];
        
    }
    else  if(annotation != quickMap.userLocation) {
        
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"icn_waterlevel_75-90.png"];
        [quickMap.userLocation setTitle:@"You are here..!!"];
        
    }
    
    else {
//        static NSString *defaultPinID = @"com.invasivecode.pin";
//        pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//        if ( pinView == nil )
//            pinView = [[MKAnnotationView alloc]
//                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
//        
//        pinView.canShowCallout = YES;
//        pinView.image = [UIImage imageNamed:@"icn_waterlevel_75-90.png"];
//        [quickMap.userLocation setTitle:@"You are here..!!"];
        
        return nil;
    }
    return pinView;
}


# pragma mark - CLLocationManegerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    appDelegate.CURRENT_LOCATION_LAT = newLocation.coordinate.latitude;
    appDelegate.CURRENT_LOCATION_LONG = newLocation.coordinate.longitude;
    
    appDelegate.USER_CURRENT_LOCATION_COORDINATE = [newLocation coordinate];
    
//    DebugLog(@"current Latitude is %f",newLocation.coordinate.latitude);
//    DebugLog(@"current Longitude is %f",newLocation.coordinate.longitude);
//    //    region.span.longitudeDelta  *= 0.05;
//    //    region.span.latitudeDelta  *= 0.05;
//    region.span.latitudeDelta = 0.02f;
//    region.span.longitudeDelta = 0.02f;
//    region.center.latitude = newLocation.coordinate.latitude;
//    region.center.longitude = newLocation.coordinate.longitude;
//    [quickMap setRegion:region animated:YES];
    [locationManager stopUpdatingLocation];
    
//    if (!annotation1) {
//        annotation1 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
//        annotation1.coordinate = region.center;
//        annotation1.title = @"226H Ang Mo Kio Street 22";
//        annotation1.subtitle = @"";
//        [quickMap addAnnotation:annotation1];
//    }
    [quickMap setRegion:MKCoordinateRegionMake(appDelegate.USER_CURRENT_LOCATION_COORDINATE, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];

    
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    appDelegate.IS_COMING_FROM_DASHBOARD = YES;

    if (tableView==whatsUpListingTable) {
        
        WhatsUpViewController *viewObj = [[WhatsUpViewController alloc] init];
        
        if ([[[feedsDataArray objectAtIndex:indexPath.row] objectForKey:@"IsChatter"] intValue] == true) {
            viewObj.isDashboardChatter = YES;
        }
        else {
            viewObj.isDashboardChatter = NO;
        }
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (tableView==eventsListingTable) {
        
        EventsDetailsViewController *viewObj = [[EventsDetailsViewController alloc] init];
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"id"] != (id)[NSNull null])
            viewObj.eventID = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"title"] != (id)[NSNull null])
            viewObj.titleString = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"description"] != (id)[NSNull null])
            viewObj.descriptionString = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"description"];
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"locationLatitude"] != (id)[NSNull null])
            viewObj.latValue = [[[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"locationLatitude"] doubleValue];
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"locationLongitude"] != (id)[NSNull null])
            viewObj.longValue = [[[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"locationLongitude"] doubleValue];
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"phoneNo"] != (id)[NSNull null])
            viewObj.phoneNoString = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"phoneNo"];
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"location"] != (id)[NSNull null])
            viewObj.addressString = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"location"];
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"startDate"] != (id)[NSNull null]) {
            viewObj.startDateString = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"startDate"];
            viewObj.startDateString = [CommonFunctions dateTimeFromString:viewObj.startDateString];
        }
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"endDate"] != (id)[NSNull null]) {
            viewObj.endDateString = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"endDate"];
            viewObj.endDateString = [CommonFunctions dateTimeFromString:viewObj.endDateString];
        }
        
        if ([[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null]) {
            viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
            viewObj.imageName = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"image"];
        }
        
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}

# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (tableView==whatsUpListingTable) {
        return feedsDataArray.count;
    }
    else if (tableView==eventsListingTable) {
        return eventsDataArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    

    if (tableView==whatsUpListingTable) {
        
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, tableView.bounds.size.width-10, 45)];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11.0];
        cellTitleLabel.numberOfLines = 0;
        cellTitleLabel.textColor = [UIColor blackColor];//RGB(245, 193, 12);
        [cell.contentView addSubview:cellTitleLabel];
        
        cellTitleLabel.text = [[feedsDataArray objectAtIndex:indexPath.row] objectForKey:@"FeedText"];
        
    }
    else if (tableView==eventsListingTable) {
        
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 45, 45)];
        [cell.contentView addSubview:cellImageView];
        
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, tableView.bounds.size.width-65, 45)];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11.0];
        cellTitleLabel.numberOfLines = 0;
        cellTitleLabel.textColor = [UIColor blackColor];//RGB(245, 193, 12);
        [cell.contentView addSubview:cellTitleLabel];
        
        cellTitleLabel.text = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        NSString *imageName = [[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"image"];
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[eventsDataArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
        [cell.contentView addSubview:cellImageView];
        
        
        NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
        NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Events"]];
        
        NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
            if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
                cellImageView.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
        }
        
        else {
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.center = CGPointMake(cellImageView.bounds.size.width/2, cellImageView.bounds.size.height/2);
            [cellImageView addSubview:activityIndicator];
            [activityIndicator startAnimating];
            
            [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    
                    cellImageView.image = image;
                    
                    DebugLog(@"Path %@",destinationPath);
                    
                    NSFileManager *fileManger=[NSFileManager defaultManager];
                    NSError* error;
                    
                    if (![fileManger fileExistsAtPath:destinationPath]){
                        
                        if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                            ;// success
                        else
                        {
                            DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                        }
                    }
                    
                    NSData *data = UIImageJPEGRepresentation(image, 0.8);
                    [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
                }
                else {
                    DebugLog(@"Image Loading Failed..!!");
                    cellImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
                }
                [activityIndicator stopAnimating];
            }];
        }
        
    }
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64.6, cell.bounds.size.width, 0.4)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    return cell;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(245, 245, 245);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundScrollView.showsHorizontalScrollIndicator = NO;
    backgroundScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backgroundScrollView];
    backgroundScrollView.backgroundColor = [UIColor clearColor];
    backgroundScrollView.userInteractionEnabled = YES;
    
    whatsUpFeedDataSource = [[NSMutableArray alloc] init];
    eventsDataSource = [[NSMutableArray alloc] init];
    
    self.title = @"Home";
    
    eventsDataArray = [[NSMutableArray alloc] init];
    feedsDataArray = [[NSMutableArray alloc] init];
    wlsDataArray = [[NSMutableArray alloc] init];
    cctvDataArray = [[NSMutableArray alloc] init];
    floodsDataArray = [[NSMutableArray alloc] init];
    tipsDataArray = [[NSMutableArray alloc] init];
    
    [self createDynamicUIColumns];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [backgroundScrollView setContentOffset:CGPointZero animated:NO];
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    if (appDelegate.IS_COMING_AFTER_LOGIN) {
        appDelegate.IS_COMING_AFTER_LOGIN = NO;
        self.view.alpha = 0.5;
        self.navigationController.navigationBar.alpha = 0.5;
    }
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    
    //    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(242,242,242) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    //    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [titleBarAttributes setValue:RGB(93, 93, 93) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    
//    if (!isExpandingMenu) {
    
        if (appDelegate.DASHBOARD_PREFERENCES_CHANGED) {
            
            appDelegate.DASHBOARD_PREFERENCES_CHANGED = NO;
            [self createDynamicUIColumns];
        }
        
        [self fetchDashboardData];
//    }
//    else {
//        isExpandingMenu = NO;
//    }
}


- (void) viewDidAppear:(BOOL)animated {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    
    [self.view addGestureRecognizer:swipeGesture];
    
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
