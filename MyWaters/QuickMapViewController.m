//
//  QuickMapViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "QuickMapViewController.h"
#import "ViewControllerHelper.h"


@interface QuickMapViewController () {

    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
}

@end

@implementation QuickMapViewController
@synthesize isNotQuickMapController;
@synthesize mapOverlay = _mapOverlay;
@synthesize mapOverlayView = _mapOverlayView;

@synthesize quickMap;
@synthesize destinationLat,destinationLong,isShowingRoute;



//*************** Method For Removing Help Image View

-(void) removeHelpImageView:(UITapGestureRecognizer *)gesture {
    
    [self showHideHelpScreen];
}



//*************** Method For Setting MKMapview Region To Normal

-(void) zoomOutMapView:(UITapGestureRecognizer *)gesture {
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = appDelegate.USER_CURRENT_LOCATION_COORDINATE;
    mapRegion.span.latitudeDelta = 0.08f;
    mapRegion.span.longitudeDelta = 0.08f;
    [quickMap setRegion:mapRegion animated: YES];
}


//*************** Method To Create Hints PopUp Views

- (void) createMapHints {
    
    if (nil == currentLocationPopUp) {
        
        currentLocationPopUp = [[CMPopTipView alloc] initWithMessage:[NSString stringWithFormat:@"Tap to locate your \ncurrent location."]];
        currentLocationPopUp.delegate = self;
        currentLocationPopUp.backgroundColor = [UIColor whiteColor];
        currentLocationPopUp.textColor = [UIColor blackColor];
        
        [self.visiblePopTipViews addObject:currentLocationButton];
        [currentLocationPopUp presentPointingAtView:currentLocationButton inView:self.view animated:YES];
    }
    else {
        [self.visiblePopTipViews addObject:currentLocationButton];
        [currentLocationPopUp presentPointingAtView:currentLocationButton inView:self.view animated:YES];
    }
//    else {
//        // Dismiss
//        [self.roundRectButtonPopTipView dismissAnimated:YES];
//        self.roundRectButtonPopTipView = nil;
//    }
    
    if (nil == menuPopUp) {
        
        menuPopUp = [[CMPopTipView alloc] initWithMessage:@"Tap to see options"];
        menuPopUp.delegate = self;
        menuPopUp.backgroundColor = [UIColor whiteColor];
        menuPopUp.textColor = [UIColor blackColor];
        
        [self.visiblePopTipViews addObject:menuPopUp];
        [menuPopUp presentPointingAtView:menuContentView inView:self.view animated:YES];
    }
    else {
        [self.visiblePopTipViews addObject:menuPopUp];
        [menuPopUp presentPointingAtView:menuContentView inView:self.view animated:YES];
    }
    
    
    if (nil == mapCenterPopUp) {
        
        mapCenterPopUp = [[CMPopTipView alloc] initWithMessage:@"Click anywhere to start exploring."];
        mapCenterPopUp.delegate = self;
        mapCenterPopUp.backgroundColor = [UIColor whiteColor];
        mapCenterPopUp.textColor = [UIColor blackColor];
        
        [self.visiblePopTipViews addObject:mapCenterPopUp];
        [mapCenterPopUp presentPointingAtView:mapCenterHiddenButon inView:self.view animated:YES];
    }
    else {
        [self.visiblePopTipViews addObject:mapCenterPopUp];
        [mapCenterPopUp presentPointingAtView:mapCenterHiddenButon inView:self.view animated:YES];
    }
}



//*************** Method For Saving ABC Water Sites Data

- (void) saveWLSData {
    
    [appDelegate insertWLSData:appDelegate.WLS_LISTING_ARRAY];
}


//*************** Method For Saving ABC Water Sites Data

- (void) saveCCTVData {
    
    [appDelegate insertCCTVData:appDelegate.CCTV_LISTING_ARRAY];
}

//*************** Method To Handle Long Press Gesture For Default Location PIN

- (void) handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    
    selectedAnnotationButton = 10;
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:quickMap];
    CLLocationCoordinate2D touchMapCoordinate = [quickMap convertPoint:touchPoint toCoordinateFromView:quickMap];
    
    longPressLocationAnnotation = [[QuickMapAnnotations alloc] init];
    longPressLocationAnnotation.coordinate = touchMapCoordinate;
    
    [quickMap addAnnotation:longPressLocationAnnotation];
    [quickMap selectAnnotation:longPressLocationAnnotation animated:YES];
    
    UserFloodSubmissionViewController *viewObj = [[UserFloodSubmissionViewController alloc] init];
    viewObj.floodSubmissionLat = longPressLocationAnnotation.coordinate.latitude;
    viewObj.floodSubmissionLon = longPressLocationAnnotation.coordinate.longitude;
    [self.navigationController pushViewController:viewObj animated:YES];
}


//*************** Method For Zooming In To User Location

- (void) zoomInUserLocation {
    
    if (currentLocationPopUp) {
        [currentLocationPopUp removeFromSuperview];
    }
    
    if (mapCenterPopUp) {
        [mapCenterPopUp removeFromSuperview];
    }
    // showing them in the mapView
    //    quickMap.region = MKCoordinateRegionMakeWithDistance(appDelegate.USER_CURRENT_LOCATION_COORDINATE, 250, 250);
    [quickMap setRegion:MKCoordinateRegionMake(appDelegate.USER_CURRENT_LOCATION_COORDINATE, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
}



//*************** Method To Get User Flood Submission Listing

- (void) fetchUserFloodSubmissionListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"10",[CommonFunctions getAppVersionNumber], nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}


//*************** Method To Get PUB Flood Submission Listing

- (void) fetchPUBFloodSubmissionListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"11",[CommonFunctions getAppVersionNumber], nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}


//*************** Method To Get CCTV Listing

- (void) fetchCCTVListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"4",[CommonFunctions getAppVersionNumber], nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}



//*************** Method To Get WLS Listing

- (void) fetchWLSListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"6",[CommonFunctions getAppVersionNumber], nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}



//*************** Method To Dismiss Callout View If Touch In Map View

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 1 || aTouch.tapCount == 2 || aTouch.tapCount == 3)
    {
        CGPoint p = [aTouch locationInView:quickMap];
        if (!CGRectContainsPoint(calloutView.frame, p))
        {
            if (isShowingCallout) {
                isShowingCallout = NO;
                [calloutView removeFromSuperview];
            }
        }
    }
}



//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
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


//*************** Method To Animate Filter Table

- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -270;
        
        quickMap.alpha = 1.0;
        quickMap.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 100;
        
        quickMap.alpha = 0.5;
        quickMap.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}



//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//*************** Method To Handle Tap For Callout View

- (void) handleCCTVCalloutTap: (id) sender {
    
    UIButton *button = (id) sender;
    
    NSLog(@"Annotation tag %ld",button.tag);
    
    CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
    
    if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"CCTVImageURL"] != (id)[NSNull null])
        viewObj.imageUrl = [[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"CCTVImageURL"];
    if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"Name"] != (id)[NSNull null])
        viewObj.titleString = [[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"Name"];
    if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"ID"] != (id)[NSNull null])
        viewObj.cctvID = [[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"ID"];
    if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"Lat"] != (id)[NSNull null])
        viewObj.latValue = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"Lat"] doubleValue];
    if ([[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"Lon"] != (id)[NSNull null])
        viewObj.longValue = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"Lon"] doubleValue];
    
    [self.navigationController pushViewController:viewObj animated:YES];
}


//*************** Method To Handle Tap For Callout View

- (void) handleWLSCalloutTap: (id) sender {
    
    UIButton *button = (id) sender;
    
    NSLog(@"Annotation tag %ld",button.tag);
    
    WaterLevelSensorsDetailViewController *viewObj = [[WaterLevelSensorsDetailViewController alloc] init];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"id"] != (id)[NSNull null])
        viewObj.wlsID = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"id"];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"name"] != (id)[NSNull null])
        viewObj.wlsName = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"name"];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"waterLevelType"] != (id)[NSNull null])
        viewObj.drainDepthType = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"waterLevelType"] intValue];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"latitude"] != (id)[NSNull null])
        viewObj.latValue = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"latitude"] doubleValue];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"longitude"] != (id)[NSNull null])
        viewObj.longValue = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"longitude"] doubleValue];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"observationTime"] != (id)[NSNull null])
        viewObj.observedTime = [CommonFunctions dateTimeFromString:[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"observationTime"]];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"waterLevel"] != (id)[NSNull null])
        viewObj.waterLevelValue = [NSString stringWithFormat:@"%d",[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"waterLevel"] intValue]];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"waterLevelPercentage"] != (id)[NSNull null])
        viewObj.waterLevelPercentageValue = [NSString stringWithFormat:@"%d",[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"waterLevelPercentage"] intValue]];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"waterLevelType"] != (id)[NSNull null])
        viewObj.waterLevelTypeValue = [NSString stringWithFormat:@"%d",[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"waterLevelType"] intValue]];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"drainDepth"] != (id)[NSNull null])
        viewObj.drainDepthValue = [NSString stringWithFormat:@"%d",[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"drainDepth"] intValue]];
    
    if ([[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"isSubscribed"] != (id)[NSNull null])
        viewObj.isSubscribed = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:button.tag-1] objectForKey:@"isSubscribed"] intValue];
    
    [self.navigationController pushViewController:viewObj animated:YES];
}


//*************** Method To Generate CCTV Annotations

- (void) generateCCTVAnnotations {
    
    
    if (appDelegate.CCTV_LISTING_ARRAY.count != 0) {
        
        if (!cctvAnnotationsArray) {
            cctvAnnotationsArray = [[NSMutableArray alloc] init];
        }
        [cctvAnnotationsArray removeAllObjects];
        
        for (int i=0; i<appDelegate.CCTV_LISTING_ARRAY.count; i++) {
            
            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion.center.latitude = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Lat"] doubleValue]; // Make lat dynamic later
            annotationRegion.center.longitude = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Lon"] doubleValue]; // Make long dynamic later
            annotationRegion.span.latitudeDelta = 0.02f;
            annotationRegion.span.longitudeDelta = 0.02f;
            
            //----- Change Current Location With Either Current Location Value or Default Location Value
            
            CLLocationCoordinate2D currentLocation;
            CLLocationCoordinate2D desinationLocation;
            
            //            currentLocation.latitude = 1.2912500;
            //            currentLocation.longitude = 103.7870230;
            currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
            currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
            
            desinationLocation.latitude = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Lat"] doubleValue];
            desinationLocation.longitude = [[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Lon"] doubleValue];
            
            cctvAnnotation = [[CCTVMapAnnoations alloc] initWithTitle:[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Name"] AndCoordinates:annotationRegion.center type:@"CCTV" tag:i+1 subtitleValue:[NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]] level:0 image:nil]; //Setting Sample location Annotation
            //            cctvAnnotation = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            cctvAnnotation.annotationTitle = [[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Name"];
            cctvAnnotation.annotationSubtitle = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
            cctvAnnotation.annotationType = @"CCTV";
            cctvAnnotation.annotationTag = i+1;
            cctvAnnotation.coordinate = annotationRegion.center;
            [quickMap addAnnotation:cctvAnnotation];
            
            [cctvAnnotationsArray addObject:cctvAnnotation];
            
        }
    }
}


//*************** Method To Generate WLS Annotations

- (void) generateWLSAnnotations {
    
    int count = 0;
    if (appDelegate.WLS_LISTING_ARRAY.count != 0) {
        
        if (!wlsAnnotationsArray) {
            wlsAnnotationsArray = [[NSMutableArray alloc] init];
        }
        
        [wlsAnnotationsArray removeAllObjects];
        
        
        for (int i=0; i<appDelegate.WLS_LISTING_ARRAY.count; i++) {
            
            if ([[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevelType"] intValue] == selectedFilterIndex) {
            
                count = count+1;
                
                MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
                annotationRegion.center.latitude = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"latitude"] doubleValue]; // Make lat dynamic later
                annotationRegion.center.longitude = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"longitude"] doubleValue]; // Make long dynamic later
                annotationRegion.span.latitudeDelta = 0.02f;
                annotationRegion.span.longitudeDelta = 0.02f;
                
                NSString *waterLevelTypeValue,*percentageValue;
                
//                if ([[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevelType"] intValue] == 1) {
                if (selectedFilterIndex == 1) {
                    percentageValue = @">50%";
                    waterLevelTypeValue = @"Low Flood Risk";
                }
                else if (selectedFilterIndex==2) {
                    percentageValue = @"50%-75%";
                    waterLevelTypeValue = @"Moderate Flood Risk";
                }
                else if (selectedFilterIndex==3) {
                    percentageValue = @"75%-90%";
                    waterLevelTypeValue = @"High Flood Risk";
                }
                else if (selectedFilterIndex==4) {
                    percentageValue = @"";
                    waterLevelTypeValue = @"Under Maintenance";
                }
                
                wlsAnnotation = [[WLSMapAnnotations alloc] initWithTitle:[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"name"] AndCoordinates:annotationRegion.center type:@"WLS" tag:i+1 subtitleValue:[NSString stringWithFormat:@"%@\n%@",percentageValue,waterLevelTypeValue] level:[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevelType"] intValue] image:nil]; //Setting Sample location Annotation
                wlsAnnotation.annotationTitle = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"name"];
//                wlsAnnotation.annotationSubtitle = [NSString stringWithFormat:@"%@\n%@",percentageValue,waterLevelTypeValue];
                wlsAnnotation.annotationSubtitle = [NSString stringWithFormat:@"%@",percentageValue];
                wlsAnnotation.waterLevel = [[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevelType"] intValue];
                wlsAnnotation.annotationType = @"WLS";
                wlsAnnotation.annotationTag = i+1;
                wlsAnnotation.coordinate = annotationRegion.center;
                [quickMap addAnnotation:wlsAnnotation];
                
                [wlsAnnotationsArray addObject:wlsAnnotation];
                
            }
        }
        
        if (count==0) {
            [CommonFunctions showAlertView:nil title:nil msg:@"No data found for selected filter." cancel:@"OK" otherButton:nil];
        }
    }
}



//*************** Method To Generate PUB Flood Annotations

- (void) generatePUBFloodSubmissionAnnotations {
    
    
    if (appDelegate.PUB_FLOOD_SUBMISSION_ARRAY.count != 0) {
        
        if (!pubFloodAnnotationsArray) {
            pubFloodAnnotationsArray = [[NSMutableArray alloc] init];
        }
        
        [pubFloodAnnotationsArray removeAllObjects];
        
        for (int i=0; i<appDelegate.PUB_FLOOD_SUBMISSION_ARRAY.count; i++) {
            
            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion.center.latitude = [[[appDelegate.PUB_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Lat"] doubleValue]; // Make lat dynamic later
            annotationRegion.center.longitude = [[[appDelegate.PUB_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Lon"] doubleValue]; // Make long dynamic later
            annotationRegion.span.latitudeDelta = 0.02f;
            annotationRegion.span.longitudeDelta = 0.02f;
            
            
            pubFloodAnnotation = [[FloodMapAnnotations alloc] initWithTitle:[[appDelegate.PUB_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"LocationName"] AndCoordinates:annotationRegion.center type:@"FLOOD" tag:i+1 subtitleValue:[[appDelegate.PUB_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Comment"] level:0 image:nil]; //Setting Sample location Annotation
            //            cctvAnnotation = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            pubFloodAnnotation.annotationTitle = [[appDelegate.PUB_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"LocationName"];
            pubFloodAnnotation.annotationSubtitle = [[appDelegate.PUB_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Comment"];
            pubFloodAnnotation.annotationType = @"FLOOD";
            pubFloodAnnotation.annotationTag = i+1;
            pubFloodAnnotation.coordinate = annotationRegion.center;
            [quickMap addAnnotation:pubFloodAnnotation];
            
            [pubFloodAnnotationsArray addObject:pubFloodAnnotation];
            
        }
    }
}



//*************** Method To Generate User Flood Annotations

- (void) generateUserFloodSubmissionAnnotations {
    
    
    if (appDelegate.USER_FLOOD_SUBMISSION_ARRAY.count != 0) {
        
        if (!userFeedbackAnnotationsArray) {
            userFeedbackAnnotationsArray = [[NSMutableArray alloc] init];
        }
        
        [userFeedbackAnnotationsArray removeAllObjects];
        
        for (int i=0; i<appDelegate.USER_FLOOD_SUBMISSION_ARRAY.count; i++) {
            
            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion.center.latitude = [[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Lat"] doubleValue]; // Make lat dynamic later
            annotationRegion.center.longitude = [[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Lon"] doubleValue]; // Make long dynamic later
            annotationRegion.span.latitudeDelta = 0.02f;
            annotationRegion.span.longitudeDelta = 0.02f;
            
            
            userFloodAnnotation = [[FeedbackMapAnnotations alloc] initWithTitle:[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"LocationName"] AndCoordinates:annotationRegion.center type:@"FEEDBACK" tag:i+1 subtitleValue:[NSString stringWithFormat:@"Submitted by: %@",[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Comment"]] level:0 image:[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Image"]]; //Setting Sample location Annotation
            //            cctvAnnotation = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            userFloodAnnotation.annotationTitle = [[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"LocationName"];
            userFloodAnnotation.annotationSubtitle = [NSString stringWithFormat:@"Submitted by: %@\n%@",[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Comment"],[CommonFunctions dateForRFC3339DateTimeString:[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"CreatedDate"]]];
            userFloodAnnotation.annotationType = @"FEEDBACK";
            userFloodAnnotation.annotationTag = i+1;
            userFloodAnnotation.annotationImageName = [[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Image"];
            userFloodAnnotation.coordinate = annotationRegion.center;
            [quickMap addAnnotation:userFloodAnnotation];
            
            [userFeedbackAnnotationsArray addObject:userFloodAnnotation];
            
        }
    }
}



//*************** Method To Show And Hide Help Screen

- (void) showHideHelpScreen {
    
    if (isShowingHelpScreen) {
        
        isShowingHelpScreen = NO;
        [btnHints setImage:[UIImage imageNamed:@"icn_helpicon"] forState:UIControlStateNormal];
 
        helpScreenImageView.hidden = YES;
        locationHelpLabel.hidden = YES;
        menuHelpLabel.hidden = YES;
        rainAreaHelpLabel.hidden = YES;
        floodByUsersHelpLabel.hidden = YES;
        cctvHelpLabel.hidden = YES;
        wlsHelpLabel.hidden = YES;
        floodByPUBHelpLabel.hidden = YES;
        
        [quickMap sendSubviewToBack:menuContentView];
//        self.view.userInteractionEnabled = YES;
    }
    else {
        isShowingHelpScreen = YES;
        [btnHints setImage:[UIImage imageNamed:@"icn_help_closebutton"] forState:UIControlStateNormal];
        
        
        helpScreenImageView.hidden = NO;
        locationHelpLabel.hidden = NO;
        menuHelpLabel.hidden = NO;
        rainAreaHelpLabel.hidden = NO;
        floodByUsersHelpLabel.hidden = NO;
        cctvHelpLabel.hidden = NO;
        wlsHelpLabel.hidden = NO;
        floodByPUBHelpLabel.hidden = NO;

        [quickMap bringSubviewToFront:stack];
        [stack openStack];
//        self.view.userInteractionEnabled = NO;
    }
}


#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [quickMap removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [quickMap addOverlay:_routeOverlay];
    
}


//*************** Method To Request Apple Server For Route

- (void) sendRouteRequest {
    
    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
//    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
//    appDelegate.hud.labelText = @"Loading...";
    
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
            [CommonFunctions dismissGlobalHUD];
//            [appDelegate.hud hide:YES];
            
            //            for (MKRoute *route in [response routes]) {
            //                [directionMapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
            //                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
            //
            //                [appDelegate.hud hide:YES];
            //            }
        }
    }];
    
}



#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
//    [self.visiblePopTipViews removeObject:popTipView];
    [self.visiblePopTipViews removeAllObjects];
    self.currentPopTipViewTarget = nil;
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [CommonFunctions dismissGlobalHUD];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        //    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == false) {
        
        if (isLoadingCCTV) {
            
            NSArray *tempArray = [[responseString JSONValue] objectForKey:CCTV_LISTING_RESPONSE_NAME];
            if (tempArray.count!=0) {
                [appDelegate.CCTV_LISTING_ARRAY removeAllObjects];
                [appDelegate.CCTV_LISTING_ARRAY setArray:tempArray];
                
                CLLocationCoordinate2D currentLocation;
                currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
                currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
                
                DebugLog(@"%f---%f",appDelegate.CURRENT_LOCATION_LAT,appDelegate.CURRENT_LOCATION_LONG);
                DebugLog(@"%f---%f",currentLocation.latitude,currentLocation.longitude);
                
                for (int idx = 0; idx<[appDelegate.CCTV_LISTING_ARRAY count];idx++) {
                    
                    NSMutableDictionary *dict = [appDelegate.CCTV_LISTING_ARRAY[idx] mutableCopy];
                    
                    CLLocationCoordinate2D desinationLocation;
                    desinationLocation.latitude = [dict[@"Lat"] doubleValue];
                    desinationLocation.longitude = [dict[@"Lon"] doubleValue];
                    
                    DebugLog(@"%f---%f",desinationLocation.latitude,desinationLocation.longitude);
                    
                    dict[@"distance"] = [CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation];//[NSString stringWithFormat:@"%@",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                    appDelegate.CCTV_LISTING_ARRAY[idx] = dict;
                    
                }
                
                DebugLog(@"%@",appDelegate.CCTV_LISTING_ARRAY);
                
                NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
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
                
                [appDelegate.CCTV_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,sortByDistance,nil]];
                
                [self generateCCTVAnnotations];
                
                // Temp commented for UAT
//                if (appDelegate.CCTV_LISTING_ARRAY.count!=0)
//                    [self performSelectorInBackground:@selector(saveCCTVData) withObject:nil];

            }
            else {
                [CommonFunctions showAlertView:nil title:nil msg:@"No CCTVs data available." cancel:@"OK" otherButton:nil];
            }
        }
        
        else if (isLoadingWLS) {
            
            NSArray *tempArray = [[responseString JSONValue] objectForKey:WLS_LISTING_RESPONSE_NAME];
            if (tempArray.count!=0) {
                [appDelegate.WLS_LISTING_ARRAY removeAllObjects];
                [appDelegate.WLS_LISTING_ARRAY setArray:tempArray];
                
                CLLocationCoordinate2D currentLocation;
                currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
                currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
                
                DebugLog(@"%f---%f",appDelegate.CURRENT_LOCATION_LAT,appDelegate.CURRENT_LOCATION_LONG);
                DebugLog(@"%f---%f",currentLocation.latitude,currentLocation.longitude);
                
                for (int idx = 0; idx<[appDelegate.WLS_LISTING_ARRAY count];idx++) {
                    
                    NSMutableDictionary *dict = [appDelegate.WLS_LISTING_ARRAY[idx] mutableCopy];
                    
                    CLLocationCoordinate2D desinationLocation;
                    desinationLocation.latitude = [dict[@"latitude"] doubleValue];
                    desinationLocation.longitude = [dict[@"longitude"] doubleValue];
                    
                    DebugLog(@"%f---%f",desinationLocation.latitude,desinationLocation.longitude);
                    
                    dict[@"distance"] = [CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation];//[NSString stringWithFormat:@"%@",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
                    appDelegate.WLS_LISTING_ARRAY[idx] = dict;
                    
                }
                
                DebugLog(@"%@",appDelegate.WLS_LISTING_ARRAY);
                
                NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
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
                
                [appDelegate.WLS_LISTING_ARRAY sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,sortByDistance,nil]];
                
                [self generateWLSAnnotations];
                
                // Temp commented for UAT
//                if (appDelegate.WLS_LISTING_ARRAY.count!=0)
//                    [self performSelectorInBackground:@selector(saveWLSData) withObject:nil];

            }
            else {
                [CommonFunctions showAlertView:nil title:nil msg:@"No water level sensors data available." cancel:@"OK" otherButton:nil];
            }
        }
        
        else if (isLoadingFeedback) {
            
            NSArray *tempArray = [[responseString JSONValue] objectForKey:USER_FLOOD_SUBMISSION_RESPONSE_NAME];
            if (tempArray.count!=0) {
                [appDelegate.USER_FLOOD_SUBMISSION_ARRAY removeAllObjects];
                [appDelegate.USER_FLOOD_SUBMISSION_ARRAY setArray:tempArray];
                [self generateUserFloodSubmissionAnnotations];

                if (!appDelegate.IS_SKIPPING_USER_LOGIN)
                    [CommonFunctions showAlertView:nil title:nil msg:@"To submit flood information, long press on map to drop pin." cancel:@"OK" otherButton:nil];

            }
            else {
                if (!appDelegate.IS_SKIPPING_USER_LOGIN)
                    [CommonFunctions showAlertView:nil title:nil msg:[NSString stringWithFormat:@"No user feedbacks data available.\nTo submit flood information, long press on map to drop pin."] cancel:@"OK" otherButton:nil];
                else
                    [CommonFunctions showAlertView:nil title:nil msg:[NSString stringWithFormat:@"No user feedbacks data available."] cancel:@"OK" otherButton:nil];
//                [CommonFunctions showAlertView:nil title:nil msg:@"No data available." cancel:@"OK" otherButton:nil];
            }
        }
        
        else if (isLoadingFloods) {
            
            NSArray *tempArray = [[responseString JSONValue] objectForKey:PUB_FLOOD_SUBMISSION_RESPONSE_NAME];
            if (tempArray.count!=0) {
                [appDelegate.PUB_FLOOD_SUBMISSION_ARRAY removeAllObjects];
                [appDelegate.PUB_FLOOD_SUBMISSION_ARRAY setArray:tempArray];
                [self generatePUBFloodSubmissionAnnotations];
            }
            else {
                [CommonFunctions showAlertView:nil title:nil msg:@"No floods data available." cancel:@"OK" otherButton:nil];
            }
        }
        
//        [appDelegate.hud hide:YES];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions dismissGlobalHUD];
//    [appDelegate.hud hide:YES];
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
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
        
        if (isShowingCallout) {
            isShowingCallout = NO;
            [calloutView removeFromSuperview];
        }
        
        selectedFilterIndex = indexPath.row+1;
        [filterTableView reloadData];
        [self animateFilterTable];
        
        [quickMap removeAnnotations: wlsAnnotationsArray];
        
        if (appDelegate.WLS_LISTING_ARRAY.count!=0) {
            [self generateWLSAnnotations];
        }
        else {
            [self fetchWLSListing];
        }
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
        
        cell.backgroundColor = [UIColor blackColor];//RGB(247, 247, 247);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, filterTableView.bounds.size.width-10, cell.bounds.size.height)];
        titleLabel.text = [filterDataSource objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, filterTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        if (indexPath.row==selectedFilterIndex-1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    
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
    
    else if([overlay isKindOfClass:[MapOverlay class]]) {
        
        MapOverlay *mapOverlay = overlay;
        
        if(!self.mapOverlayView) {
            self.mapOverlayView = [[MapOverlayView alloc] initWithOverlay:mapOverlay];
            UIImageView *imgV =[[UIImageView alloc] init];
            [imgV setContentMode:UIViewContentModeCenter];
            [imgV setFrame:CGRectMake(0, 0, self.mapOverlayView.frame.size.width, self.mapOverlayView.frame.size.height)];
            [imgV setCenter:self.mapOverlayView.center];
            [self.mapOverlayView addSubview:imgV];
        }
        return self.mapOverlayView;
    }
    
    return nil;
}


-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if([overlay isKindOfClass:[MapOverlay class]]) {
        
        MapOverlay *mapOverlay = overlay;
        
        if(!self.mapOverlayView) {
            self.mapOverlayView = [[MapOverlayView alloc] initWithOverlay:mapOverlay];
            UIImageView *imgV =[[UIImageView alloc] init];
            [imgV setContentMode:UIViewContentModeCenter];
            [imgV setFrame:CGRectMake(0, 0, self.mapOverlayView.frame.size.width, self.mapOverlayView.frame.size.height)];
            [imgV setCenter:self.mapOverlayView.center];
            [self.mapOverlayView addSubview:imgV];
        }
        return self.mapOverlayView;
    }
    
    return nil;
}



-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *pinView1,*pinView2,*pinView3,*pinView4,*pinView5;

    if ([annotation isKindOfClass:[FloodMapAnnotations class]]) {
        
        FloodMapAnnotations *flood = (FloodMapAnnotations*) annotation;
        pinView1 = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"FLOOD"];
        pinView1.tag = flood.annotationTag;
        pinView1.image = [UIImage imageNamed:@"icn_floodinfo_small.png"];
        
        return pinView1;
    }
    else if ([annotation isKindOfClass:[WLSMapAnnotations class]]) {
        
        WLSMapAnnotations *wls = (WLSMapAnnotations*) annotation;
        pinView2 = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"WLS"];
        pinView2.tag = wls.annotationTag;
        
        if (wlsAnnotation.waterLevel == 1) {
            pinView2.image = [UIImage imageNamed:@"icn_waterlevel_below75_big.png"];
        }
        else if (wlsAnnotation.waterLevel == 2) {
            pinView2.image = [UIImage imageNamed:@"icn_waterlevel_75-90_big.png"];
        }
        else if (wlsAnnotation.waterLevel == 3) {
            pinView2.image = [UIImage imageNamed:@"icn_waterlevel_90_big.png"];
        }
        else {
            pinView2.image = [UIImage imageNamed:@"icn_waterlevel_undermaintenance.png"];
        }
        return pinView2;
    }
    
    else if ([annotation isKindOfClass:[CCTVMapAnnoations class]]) {
        
        CCTVMapAnnoations *cctv = (CCTVMapAnnoations*) annotation;
        pinView3 = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CCTV"];
        pinView3.tag = cctv.annotationTag;
        pinView3.image = [UIImage imageNamed:@"icn_cctv_small.png"];
        
        return pinView3;
    }
    
    else if ([annotation isKindOfClass:[FeedbackMapAnnotations class]]) {
        
        FeedbackMapAnnotations *feedback = (FeedbackMapAnnotations*) annotation;
        pinView4 = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"FEEDBACK"];
        pinView4.tag = feedback.annotationTag;
        pinView4.image = [UIImage imageNamed:@"icn_floodinfo_userfeedback_submission_small.png"];
        
        return pinView4;
    }
    else if ([annotation isKindOfClass:[QuickMapAnnotations class]]) {
        
        QuickMapAnnotations *userFeedback = (QuickMapAnnotations*) annotation;
        pinView5 = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"USERFEEDBACK"];
        pinView5.tag = userFeedback.annotationTag;
        pinView5.image = [UIImage imageNamed:@"icn_floodinfo_userfeedback_submission_small.png"];
        
        return pinView4;
    }
    else {
        return nil;
    }
    
    return nil;
}


//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
//    if ([view.annotation isKindOfClass:[MKAnnotationView class]]) {
//        if (newState == MKAnnotationViewDragStateEnding) {
//            view.dragState = MKAnnotationViewDragStateNone;
//        }
//    }
//}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        MKAnnotationView *av = [mapView viewForAnnotation:mapView.userLocation];
        av.enabled = NO;
        return;
    }
    else if ([view.annotation isKindOfClass:[FloodMapAnnotations class]]) {
        
        FloodMapAnnotations *temp = (FloodMapAnnotations*)view.annotation;
        
        [calloutView removeFromSuperview];
        
        isShowingCallout = YES;
        
        calloutView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 150, 100)];
        calloutView.backgroundColor = [UIColor whiteColor];
        calloutView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        calloutView.layer.borderWidth = 1.0;
        calloutView.layer.cornerRadius = 10.0f;
        calloutView.userInteractionEnabled = YES;
        
        UIImageView *locationNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        [locationNameImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_grey_quickmap.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        [calloutView addSubview:locationNameImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 110, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = temp.annotationTitle;
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.numberOfLines = 0;
        
        CGRect newTitleLabelFrame = titleLabel.frame;
        newTitleLabelFrame.size.height = [CommonFunctions heightForText:titleLabel.text font:titleLabel.font withinWidth:110];//expectedDescriptionLabelSize.height;
        titleLabel.frame = newTitleLabelFrame;
        [calloutView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        UIImageView *distanceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, titleLabel.frame.origin.y+titleLabel.bounds.size.height + 5, 20, 20)];
        [distanceImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/callout_icn_distance.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        [calloutView addSubview:distanceImageView];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 110, 40)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.text = temp.annotationSubtitle;
        subTitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
        subTitleLabel.numberOfLines = 0;
        
        CGRect newSubTitleLabelFrame = subTitleLabel.frame;
        newSubTitleLabelFrame.size.height = [CommonFunctions heightForText:subTitleLabel.text font:subTitleLabel.font withinWidth:110];//expectedDescriptionLabelSize.height;
        subTitleLabel.frame = newSubTitleLabelFrame;
        [calloutView addSubview:subTitleLabel];
        [subTitleLabel sizeToFit];
        
        
        CGRect newCalloutFrame = calloutView.frame;
        newCalloutFrame.size.height = titleLabel.bounds.size.height+subTitleLabel.bounds.size.height+20;//expectedDescriptionLabelSize.height;
        calloutView.frame = newCalloutFrame;
        
        CGPoint p = [quickMap convertCoordinate:temp.coordinate toPointToView:quickMap];
        CGRect frame = CGRectMake(p.x - (calloutView.frame.size.width/2 - 30),
                                  p.y- (calloutView.frame.size.height / 2 + 30),
                                  calloutView.frame.size.width,
                                  calloutView.frame.size.height);
        
        calloutView.frame = frame;
        
        [quickMap addSubview:calloutView];
        
    }
    else if ([view.annotation isKindOfClass:[CCTVMapAnnoations class]]) {
        
        CCTVMapAnnoations *temp = (CCTVMapAnnoations*)view.annotation;
        
        [calloutView removeFromSuperview];
        
        isShowingCallout = YES;
        
        calloutView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 150, 100)];
        calloutView.backgroundColor = [UIColor whiteColor];
        calloutView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        calloutView.layer.borderWidth = 1.0;
        calloutView.layer.cornerRadius = 10.0f;
        calloutView.userInteractionEnabled = YES;
        
        UIImageView *locationNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        [locationNameImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_grey_quickmap.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        [calloutView addSubview:locationNameImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 110, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = temp.annotationTitle;
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.numberOfLines = 0;
        [calloutView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        UIImageView *distanceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, titleLabel.frame.origin.y+titleLabel.bounds.size.height + 5, 20, 20)];
        [distanceImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/callout_icn_distance.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        [calloutView addSubview:distanceImageView];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 120, 20)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.text = temp.annotationSubtitle;
        subTitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
        subTitleLabel.numberOfLines = 0;
        [calloutView addSubview:subTitleLabel];
        
        
        CGRect newCalloutFrame = calloutView.frame;
        newCalloutFrame.size.height = titleLabel.bounds.size.height+subTitleLabel.bounds.size.height+20;//expectedDescriptionLabelSize.height;
        calloutView.frame = newCalloutFrame;
        
        CGPoint p = [quickMap convertCoordinate:temp.coordinate toPointToView:quickMap];
        CGRect frame = CGRectMake(p.x - (calloutView.frame.size.width/2 - 30),
                                  p.y- (calloutView.frame.size.height / 2 + 30),
                                  calloutView.frame.size.width,
                                  calloutView.frame.size.height);
        
        calloutView.frame = frame;
        
        
        UIButton *overlayButon = [UIButton buttonWithType:UIButtonTypeCustom];
        overlayButon.frame = CGRectMake(0, 0, calloutView.bounds.size.width, calloutView.bounds.size.height);
        overlayButon.tag = temp.annotationTag;
        [overlayButon addTarget:self action:@selector(handleCCTVCalloutTap:) forControlEvents:UIControlEventTouchUpInside];
        [calloutView addSubview:overlayButon];
        
        [quickMap addSubview:calloutView];
        
    }
    else if ([view.annotation isKindOfClass:[FeedbackMapAnnotations class]]) {
        
        FeedbackMapAnnotations *temp = (FeedbackMapAnnotations*) view.annotation;
        
        [calloutView removeFromSuperview];
        
        isShowingCallout = YES;
        
        calloutView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 250, 100)];
        calloutView.backgroundColor = [UIColor whiteColor];
        calloutView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        calloutView.layer.borderWidth = 1.0;
        calloutView.layer.cornerRadius = 10.0f;
        calloutView.userInteractionEnabled = YES;
        
        UIImageView *locationNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        [calloutView addSubview:locationNameImageView];
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,temp.annotationImageName];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(locationNameImageView.bounds.size.width/2, locationNameImageView.bounds.size.height/2);
        [locationNameImageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                
                locationNameImageView.image = image;
            }
            else {
                DebugLog(@"Image Loading Failed..!!");
                locationNameImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
            }
            [activityIndicator stopAnimating];
        }];
        
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = temp.annotationTitle;
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.numberOfLines = 0;
        [calloutView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 160, 40)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.text = temp.annotationSubtitle;
        subTitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
        subTitleLabel.numberOfLines = 0;
        [calloutView addSubview:subTitleLabel];
        
        
        CGRect newCalloutFrame = calloutView.frame;
        newCalloutFrame.size.height = titleLabel.bounds.size.height+subTitleLabel.bounds.size.height+20;//expectedDescriptionLabelSize.height;
        calloutView.frame = newCalloutFrame;
        
        CGPoint p = [quickMap convertCoordinate:temp.coordinate toPointToView:quickMap];
        CGRect frame = CGRectMake(p.x - (calloutView.frame.size.width/2 - 30),
                                  p.y- (calloutView.frame.size.height / 2 + 30),
                                  calloutView.frame.size.width,
                                  calloutView.frame.size.height);
        
        calloutView.frame = frame;
        
        [quickMap addSubview:calloutView];
        
    }
    else if ([view.annotation isKindOfClass:[WLSMapAnnotations class]]) {
        
        WLSMapAnnotations *temp = (WLSMapAnnotations*)view.annotation;
        
        [calloutView removeFromSuperview];
        
        isShowingCallout = YES;
        
        calloutView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 150, 100)];
        calloutView.backgroundColor = [UIColor whiteColor];
        calloutView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        calloutView.layer.borderWidth = 1.0;
        calloutView.layer.cornerRadius = 10.0f;
        calloutView.userInteractionEnabled = YES;
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 130, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = temp.annotationTitle;
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.numberOfLines = 0;
        
        CGRect newTitleLabelFrame = titleLabel.frame;
        newTitleLabelFrame.size.height = [CommonFunctions heightForText:titleLabel.text font:titleLabel.font withinWidth:120];//expectedDescriptionLabelSize.height;
        titleLabel.frame = newTitleLabelFrame;
        [calloutView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        UIImageView *dropIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 15, 15)];
        [dropIconImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_drop_quickmap.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        [calloutView addSubview:dropIconImageView];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 110, 40)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.text = temp.annotationSubtitle;
        subTitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
        subTitleLabel.numberOfLines = 0;
        
        CGRect newSubTitleLabelFrame = subTitleLabel.frame;
        newSubTitleLabelFrame.size.height = [CommonFunctions heightForText:subTitleLabel.text font:subTitleLabel.font withinWidth:110];//expectedDescriptionLabelSize.height;
        subTitleLabel.frame = newSubTitleLabelFrame;
        [calloutView addSubview:subTitleLabel];
        [subTitleLabel sizeToFit];
        
        UILabel *waterLevelTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, subTitleLabel.frame.origin.y+subTitleLabel.bounds.size.height+5, 130, 40)];
        waterLevelTypeLabel.backgroundColor = [UIColor clearColor];
        if (temp.waterLevel==1) {
            waterLevelTypeLabel.text = @"Low Flood Risk";
        }
        else if (temp.waterLevel==2) {
            waterLevelTypeLabel.text = @"Moderate Flood Risk";
        }
        else if (temp.waterLevel==3) {
            waterLevelTypeLabel.text = @"High Flood Risk";
        }
        else {
            waterLevelTypeLabel.text = @"Under Maintenance";
        }
        waterLevelTypeLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
        waterLevelTypeLabel.numberOfLines = 0;
        
        CGRect newWaterLevelTypeLabelFrame = waterLevelTypeLabel.frame;
        newWaterLevelTypeLabelFrame.size.height = [CommonFunctions heightForText:waterLevelTypeLabel.text font:waterLevelTypeLabel.font withinWidth:120];//expectedDescriptionLabelSize.height;
        waterLevelTypeLabel.frame = newWaterLevelTypeLabelFrame;
        [calloutView addSubview:waterLevelTypeLabel];
        [waterLevelTypeLabel sizeToFit];
        
        CGRect newCalloutFrame = calloutView.frame;
        newCalloutFrame.size.height = titleLabel.bounds.size.height+subTitleLabel.bounds.size.height+waterLevelTypeLabel.bounds.size.height+30;//expectedDescriptionLabelSize.height;
        calloutView.frame = newCalloutFrame;
        
        CGPoint p = [quickMap convertCoordinate:temp.coordinate toPointToView:quickMap];
        CGRect frame = CGRectMake(p.x - (calloutView.frame.size.width/2 - 30),
                                  p.y- (calloutView.frame.size.height / 2 + 30),
                                  calloutView.frame.size.width,
                                  calloutView.frame.size.height);
        
        calloutView.frame = frame;
        
        
        UIButton *overlayButon = [UIButton buttonWithType:UIButtonTypeCustom];
        overlayButon.frame = CGRectMake(0, 0, calloutView.bounds.size.width, calloutView.bounds.size.height);
        overlayButon.tag = temp.annotationTag;
        [overlayButon addTarget:self action:@selector(handleWLSCalloutTap:) forControlEvents:UIControlEventTouchUpInside];
        [calloutView addSubview:overlayButon];
        
        [quickMap addSubview:calloutView];
        
    }
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    if (isShowingCallout) {
        isShowingCallout = NO;
        [calloutView removeFromSuperview];
    }
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    if (isShowingCallout) {
        isShowingCallout = NO;
        [calloutView removeFromSuperview];
    }
}


# pragma mark - UPStackMenuDelegate Methods

- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if (menuPopUp) {
        [menuPopUp removeFromSuperview];
    }
    
    if (mapCenterPopUp) {
        [mapCenterPopUp removeFromSuperview];
    }
    
    if([[menuContentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:NO];
}

- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[menuContentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:YES];
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index {
    
    selectedAnnotationButton = index;
    
    if (index==4) {
        
        if (!isShowingFlood) {
            
            isShowingFlood = YES;
            
//            if (appDelegate.PUB_FLOOD_SUBMISSION_ARRAY.count==0) {
            
                isLoadingFloods = YES;
                isLoadingWLS = NO;
                isLoadingCCTV = NO;
                isLoadingFeedback = NO;
                isLoadingRainMap = NO;
                
                [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
                [self fetchPUBFloodSubmissionListing];
//            }
//            else {
//                
//                [self generatePUBFloodSubmissionAnnotations];
//            }
            
            [floodStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
            
        }
        else {
            isShowingFlood = NO;
            
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations: pubFloodAnnotationsArray];
            
            [floodStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
    }
    else if (index==3) {
        
        if (!isShowingDrain) {
            
            isShowingDrain = YES;
            
            btnfilter.hidden = NO;
            
            if (appDelegate.WLS_LISTING_ARRAY.count==0) {
                
                isLoadingFloods = NO;
                isLoadingWLS = YES;
                isLoadingCCTV = NO;
                isLoadingFeedback = NO;
                isLoadingRainMap = NO;
                
                [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
                
                [self fetchWLSListing];
            }
            else {
                
                [self generateWLSAnnotations];
            }
            
            [wlsStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            
            btnfilter.hidden = YES;
            isShowingDrain = NO;
            
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations: wlsAnnotationsArray];
            
            [wlsStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        
    }
    else if (index==2) {
        
        if (!isShowingCamera) {
            
            isShowingCamera = YES;
            
            if (appDelegate.CCTV_LISTING_ARRAY.count==0) {
                
                isLoadingFloods = NO;
                isLoadingWLS = NO;
                isLoadingCCTV = YES;
                isLoadingFeedback = NO;
                isLoadingRainMap = NO;
                
                [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
                
                [self fetchCCTVListing];
            }
            else {
                
                [self generateCCTVAnnotations];
            }
            
            [cctvStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isShowingCamera = NO;
            
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations: cctvAnnotationsArray];
            
            [cctvStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        
    }
    else if (index==1) {
        
        if (!isShowingUserFeedback) {
            
            isShowingUserFeedback = YES;
            isShwoingFinePrint = YES;
            meteorologicalDisclaimerLabel.hidden = NO;

            if (isShowingMeteorologicalDisclaimer) {
                meteorologicalDisclaimerLabel.text = [NSString stringWithFormat:@"%@\n%@",meteorologicalDisclaimerString,userSubmissionFinePrintString];
            }
            else {
                meteorologicalDisclaimerLabel.text = [NSString stringWithFormat:@"%@",userSubmissionFinePrintString];
            }
            
            CGRect newDisclaimerLabelFrame = meteorologicalDisclaimerLabel.frame;
            newDisclaimerLabelFrame.size.height = [CommonFunctions heightForText:meteorologicalDisclaimerLabel.text font:meteorologicalDisclaimerLabel.font withinWidth:self.view.bounds.size.width]-20;//expectedDescriptionLabelSize.height;
            meteorologicalDisclaimerLabel.frame = newDisclaimerLabelFrame;
            
//            if (appDelegate.USER_FLOOD_SUBMISSION_ARRAY.count==0) {
            
                isLoadingFloods = NO;
                isLoadingWLS = NO;
                isLoadingCCTV = NO;
                isLoadingFeedback = YES;
                isLoadingRainMap = NO;
                
                [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
                
                [self fetchUserFloodSubmissionListing];
//            }
//            else {
//                
//                [self generateUserFloodSubmissionAnnotations];
//            }
            
            [userFeedbackStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isShowingUserFeedback = NO;
            isShwoingFinePrint = NO;
            
            if (isShowingMeteorologicalDisclaimer) {
                meteorologicalDisclaimerLabel.hidden = NO;
                meteorologicalDisclaimerLabel.text = [NSString stringWithFormat:@"%@",meteorologicalDisclaimerString];
            }
            else {
                meteorologicalDisclaimerLabel.hidden = YES;
            }
            
            CGRect newDisclaimerLabelFrame = meteorologicalDisclaimerLabel.frame;
            newDisclaimerLabelFrame.size.height = [CommonFunctions heightForText:meteorologicalDisclaimerLabel.text font:meteorologicalDisclaimerLabel.font withinWidth:self.view.bounds.size.width]-20;//expectedDescriptionLabelSize.height;
            meteorologicalDisclaimerLabel.frame = newDisclaimerLabelFrame;

            
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations:userFeedbackAnnotationsArray];
            
            [userFeedbackStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
            
        }
    }
    else if (index==0) {
        
        if (!isShowingRain) {
            
            isShowingRain = YES;
            
            isLoadingFloods = NO;
            isLoadingWLS = NO;
            isLoadingCCTV = NO;
            isLoadingFeedback = NO;
            isLoadingRainMap = YES;
            
            meteorologicalDisclaimerLabel.hidden = NO;
            isShowingMeteorologicalDisclaimer = YES;
            self.mapOverlay = [[MapOverlay alloc] initWithLowerLeftCoordinate:CLLocationCoordinate2DMake(1.229001, 103.607254) withUpperRightCoordinate:CLLocationCoordinate2DMake(1.46926, 104.026108)];
            
            if (isShwoingFinePrint) {
                meteorologicalDisclaimerLabel.text = [NSString stringWithFormat:@"%@\n%@",meteorologicalDisclaimerString,userSubmissionFinePrintString];
            }
            else {
                meteorologicalDisclaimerLabel.text = [NSString stringWithFormat:@"%@",meteorologicalDisclaimerString];
            }
            
            CGRect newDisclaimerLabelFrame = meteorologicalDisclaimerLabel.frame;
            newDisclaimerLabelFrame.size.height = [CommonFunctions heightForText:meteorologicalDisclaimerLabel.text font:meteorologicalDisclaimerLabel.font withinWidth:self.view.bounds.size.width]-20;//expectedDescriptionLabelSize.height;
            meteorologicalDisclaimerLabel.frame = newDisclaimerLabelFrame;
            
            // add the custom overlay
            [quickMap addOverlay:self.mapOverlay];
            
            // set the co-ordinates & zoom to specificly Singapore.
            MKMapPoint lowerLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(1.229001, 103.607254));
            MKMapPoint upperRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(1.46926, 104.026108));
            
            MKMapRect mapRect = MKMapRectMake(lowerLeft.x, upperRight.y, upperRight.x - lowerLeft.x, lowerLeft.y - upperRight.y);
            [quickMap setVisibleMapRect:mapRect animated:YES];
            
            
            [rainMapStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
            
        }
        else {
            isShowingRain = NO;
            
            if (isShwoingFinePrint) {
                meteorologicalDisclaimerLabel.hidden = NO;
                meteorologicalDisclaimerLabel.text = [NSString stringWithFormat:@"%@",meteorologicalDisclaimerString];
            }
            else {
                meteorologicalDisclaimerLabel.hidden = YES;
            }
            
            CGRect newDisclaimerLabelFrame = meteorologicalDisclaimerLabel.frame;
            newDisclaimerLabelFrame.size.height = [CommonFunctions heightForText:meteorologicalDisclaimerLabel.text font:meteorologicalDisclaimerLabel.font withinWidth:self.view.bounds.size.width]-20;//expectedDescriptionLabelSize.height;
            meteorologicalDisclaimerLabel.frame = newDisclaimerLabelFrame;

            
            isShowingMeteorologicalDisclaimer = NO;
            [quickMap removeOverlay:self.mapOverlay];
            [rainMapStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
            
        }
    }
}


- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[menuContentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (90) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}


# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedFilterIndex = 1;
    
    
    btnfilter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnfilter setImage:[UIImage imageNamed:@"icn_filter"] forState:UIControlStateNormal];
    [btnfilter addTarget:self action:@selector(animateFilterTable) forControlEvents:UIControlEventTouchUpInside];
    [btnfilter setFrame:CGRectMake(0, 0, 32, 32)];
    
    btnHints =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHints setImage:[UIImage imageNamed:@"icn_helpicon"] forState:UIControlStateNormal];
    [btnHints addTarget:self action:@selector(showHideHelpScreen) forControlEvents:UIControlEventTouchUpInside];
    [btnHints setFrame:CGRectMake(44, 0, 32, 32)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:btnfilter];
    [rightBarButtonItems addSubview:btnHints];
    btnfilter.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
        if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"RainAreaDisclaimer"]) {
            meteorologicalDisclaimerString = [NSString stringWithFormat:@"  %@",[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"]];
            break;
        }
    }
    
    for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
        if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"UserFloodSubmissionDisclaimer"]) {
            userSubmissionFinePrintString = [NSString stringWithFormat:@"  %@",[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"]];
            break;
        }
    }
    
    quickMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    quickMap.delegate = self;
    [quickMap setMapType:MKMapTypeStandard];
    [quickMap setZoomEnabled:YES];
    [quickMap setScrollEnabled:YES];
    [quickMap setShowsUserLocation:YES];
    [self.view  addSubview:quickMap];
    //    [quickMap setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    //    quickMap.alpha = 0.5;
    
    UITapGestureRecognizer* zoomOutMapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutMapView:)];
    zoomOutMapGesture.numberOfTapsRequired = 2;
    [quickMap addGestureRecognizer:zoomOutMapGesture];
    
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = appDelegate.USER_CURRENT_LOCATION_COORDINATE;
    mapRegion.span.latitudeDelta = 0.08f;
    mapRegion.span.longitudeDelta = 0.08f;
    [quickMap setRegion:mapRegion animated: YES];
    
    if (!appDelegate.IS_SKIPPING_USER_LOGIN) {
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
        [quickMap addGestureRecognizer:lpgr];
    }
    
    isShowingFlood = YES;
    isShowingUserFeedback = NO;
    isShowingRain = NO;
    isShowingCamera = NO;
    isShowingDrain = NO;
    
    self.visiblePopTipViews = [[NSMutableArray alloc] init];
    
    
    currentLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [currentLocationButton addTarget:self action:@selector(zoomInUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [currentLocationButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_quick_map.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-60, 40, 40);
    [quickMap addSubview:currentLocationButton];
    
    mapCenterHiddenButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mapCenterHiddenButon.frame = CGRectMake(quickMap.bounds.size.width/2 - 20, quickMap.bounds.size.height/2-60, 40, 40);
    [quickMap addSubview:mapCenterHiddenButon];
    
    
    
    menuContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [menuContentView.layer setCornerRadius:20];
    [menuContentView setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_expand.png",appDelegate.RESOURCE_FOLDER_PATH]]]];
    [menuContentView setBackgroundColor:[UIColor clearColor]];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_expand.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setFrame:CGRectInset(menuContentView.frame, 0, 0)];
    [menuContentView addSubview:icon];
    if (IS_IPHONE_4_OR_LESS) {
        menuContentView.frame = CGRectMake(quickMap.bounds.size.width-55, quickMap.bounds.size.height-60, 40, 40);
        currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-60, 40, 40);
    }
    else if (IS_IPHONE_5) {
        menuContentView.frame = CGRectMake(quickMap.bounds.size.width-55, quickMap.bounds.size.height-65, 40, 40);
        currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-65, 40, 40);
    }
    else if (IS_IPHONE_6) {
        menuContentView.frame = CGRectMake(quickMap.bounds.size.width-65, quickMap.bounds.size.height-75, 45, 45);
        currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-75, 40, 40);
    }
    else if (IS_IPHONE_6P) {
        menuContentView.frame = CGRectMake(quickMap.bounds.size.width-75, quickMap.bounds.size.height-85, 50, 50);
        currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-85, 40, 40);
    }
    [quickMap addSubview:menuContentView];
    [quickMap sendSubviewToBack:menuContentView];
    
    stack = [[UPStackMenu alloc] initWithContentView:menuContentView];
    [stack setDelegate:self];
    
////    floodStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Flood Info by PUB" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
//    floodStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Flood Info by PUB" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
//
//    wlsStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Water Level Sensor" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
//    cctvStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"CCTV" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
//    userFeedbackStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Flood Info by Users" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
//    rainMapStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Rain Area" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    

    
    //    floodStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Flood Info by PUB" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    floodStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:nil font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    
    wlsStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:nil font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    cctvStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:nil font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    userFeedbackStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:nil font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    rainMapStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:nil font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:rainMapStackItem, userFeedbackStackItem, cctvStackItem, wlsStackItem, floodStackItem, nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor whiteColor]];
        
    }];
    
    
    [stack setAnimationType:UPStackMenuAnimationType_progressive];
    [stack setStackPosition:UPStackMenuStackPosition_up];
    [stack setOpenAnimationDuration:.4];
    [stack setCloseAnimationDuration:.4];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setLabelPosition:UPStackMenuItemLabelPosition_right];
        [item setLabelPosition:UPStackMenuItemLabelPosition_left];
    }];
    [stack addItems:items];
    [quickMap addSubview:stack];
    

    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -270, self.view.bounds.size.width, 200) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    filterTableView.scrollEnabled = NO;
    filterTableView.alwaysBounceVertical = NO;

    
    filterDataSource = [[NSArray alloc] initWithObjects:@"Drain 0-75% Full",@"Drain 75%-90% Full",@"Drain 90%-100 Full",@"Station under maintenance", nil];
    
    isLoadingFloods = YES;
    
    meteorologicalDisclaimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 15)];
    meteorologicalDisclaimerLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10.0];
    meteorologicalDisclaimerLabel.textColor = [UIColor whiteColor];
    meteorologicalDisclaimerLabel.backgroundColor = [UIColor blackColor];
    meteorologicalDisclaimerLabel.numberOfLines = 0;
    [self.view addSubview:meteorologicalDisclaimerLabel];
    meteorologicalDisclaimerLabel.hidden = YES;
    
    
    helpScreenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, quickMap.bounds.size.width, quickMap.bounds.size.height)];
    helpScreenImageView.backgroundColor = [UIColor blackColor];
    helpScreenImageView.alpha = 0.7;
    [quickMap addSubview:helpScreenImageView];
    helpScreenImageView.hidden = YES;
    helpScreenImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* zoomedTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeHelpImageView:)];
    zoomedTap.numberOfTapsRequired = 1;
    [helpScreenImageView addGestureRecognizer:zoomedTap];
    
    locationHelpLabel = [[UILabel alloc] init];
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        locationHelpLabel.frame = CGRectMake(10, quickMap.bounds.size.height-130, 100, 40);
    }
    else {
        locationHelpLabel.frame = CGRectMake(10, quickMap.bounds.size.height-110, 100, 40);
    }
    locationHelpLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    locationHelpLabel.textColor = [UIColor whiteColor];
    locationHelpLabel.backgroundColor = [UIColor clearColor];
    locationHelpLabel.text = [NSString stringWithFormat:@"Tap to locate your\ncurrent location"];
    locationHelpLabel.numberOfLines = 0;
    [quickMap addSubview:locationHelpLabel];
    locationHelpLabel.hidden = YES;
    
    menuHelpLabel = [[UILabel alloc] init];
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        menuHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-240, quickMap.bounds.size.height-75, 160, 20);
    }
    else {
        menuHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, quickMap.bounds.size.height-55, 160, 20);
    }
    menuHelpLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    menuHelpLabel.textColor = [UIColor whiteColor];
    menuHelpLabel.textAlignment = NSTextAlignmentRight;
    menuHelpLabel.backgroundColor = [UIColor clearColor];
    menuHelpLabel.text = [NSString stringWithFormat:@"Tap to Open/Hide options"];
    menuHelpLabel.numberOfLines = 0;
    [quickMap addSubview:menuHelpLabel];
    menuHelpLabel.hidden = YES;
    
    rainAreaHelpLabel = [[UILabel alloc] init];
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        rainAreaHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, menuHelpLabel.frame.origin.y-50, 160, 20);
    }
    else {
        rainAreaHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, menuHelpLabel.frame.origin.y-50, 160, 20);
    }
    rainAreaHelpLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    rainAreaHelpLabel.textColor = [UIColor whiteColor];
    rainAreaHelpLabel.textAlignment = NSTextAlignmentRight;
    rainAreaHelpLabel.backgroundColor = [UIColor clearColor];
    rainAreaHelpLabel.text = [NSString stringWithFormat:@"Rain Area"];
    rainAreaHelpLabel.numberOfLines = 0;
    [quickMap addSubview:rainAreaHelpLabel];
    rainAreaHelpLabel.hidden = YES;
    
    floodByUsersHelpLabel = [[UILabel alloc] init];
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        floodByUsersHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, rainAreaHelpLabel.frame.origin.y-50, 160, 20);
    }
    else {
        floodByUsersHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, rainAreaHelpLabel.frame.origin.y-50, 160, 20);
    }
    floodByUsersHelpLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    floodByUsersHelpLabel.textColor = [UIColor whiteColor];
    floodByUsersHelpLabel.textAlignment = NSTextAlignmentRight;
    floodByUsersHelpLabel.backgroundColor = [UIColor clearColor];
    floodByUsersHelpLabel.text = [NSString stringWithFormat:@"Flood Info by Users"];
    floodByUsersHelpLabel.numberOfLines = 0;
    [quickMap addSubview:floodByUsersHelpLabel];
    floodByUsersHelpLabel.hidden = YES;
    
    cctvHelpLabel = [[UILabel alloc] init];
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        cctvHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, floodByUsersHelpLabel.frame.origin.y-50, 160, 20);
    }
    else {
        cctvHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, floodByUsersHelpLabel.frame.origin.y-50, 160, 20);
    }
    cctvHelpLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    cctvHelpLabel.textColor = [UIColor whiteColor];
    cctvHelpLabel.textAlignment = NSTextAlignmentRight;
    cctvHelpLabel.backgroundColor = [UIColor clearColor];
    cctvHelpLabel.text = [NSString stringWithFormat:@"CCTV"];
    cctvHelpLabel.numberOfLines = 0;
    [quickMap addSubview:cctvHelpLabel];
    cctvHelpLabel.hidden = YES;
    
    wlsHelpLabel = [[UILabel alloc] init];
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        wlsHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, cctvHelpLabel.frame.origin.y-50, 160, 20);
    }
    else {
        wlsHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, cctvHelpLabel.frame.origin.y-50, 160, 20);
    }
    wlsHelpLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    wlsHelpLabel.textColor = [UIColor whiteColor];
    wlsHelpLabel.textAlignment = NSTextAlignmentRight;
    wlsHelpLabel.backgroundColor = [UIColor clearColor];
    wlsHelpLabel.text = [NSString stringWithFormat:@"Water Level Sensor"];
    wlsHelpLabel.numberOfLines = 0;
    [quickMap addSubview:wlsHelpLabel];
    wlsHelpLabel.hidden = YES;
    
    floodByPUBHelpLabel = [[UILabel alloc] init];
    if (IS_IPHONE_6 || IS_IPHONE_6P) {
        floodByPUBHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, wlsHelpLabel.frame.origin.y-50, 160, 20);
    }
    else {
        floodByPUBHelpLabel.frame = CGRectMake(quickMap.bounds.size.width-230, wlsHelpLabel.frame.origin.y-50, 160, 20);
    }
    floodByPUBHelpLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    floodByPUBHelpLabel.textColor = [UIColor whiteColor];
    floodByPUBHelpLabel.textAlignment = NSTextAlignmentRight;
    floodByPUBHelpLabel.backgroundColor = [UIColor clearColor];
    floodByPUBHelpLabel.text = [NSString stringWithFormat:@"Flood Info by PUB"];
    floodByPUBHelpLabel.numberOfLines = 0;
    [quickMap addSubview:floodByPUBHelpLabel];
    floodByPUBHelpLabel.hidden = YES;
    
    
    
    [self fetchPUBFloodSubmissionListing];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [appDelegate setShouldRotate:NO];
    
    if (appDelegate.IS_COMING_FROM_DASHBOARD) {
        appDelegate.IS_COMING_FROM_DASHBOARD = NO;
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    }
    else {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    }
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(208,11,76) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    self.title = @"Quick Map";
    
    
    if (longPressLocationAnnotation) {
        [quickMap removeAnnotation:longPressLocationAnnotation];
    }
    
    if (isShowingRoute) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
        isShowingRoute = NO;
        [self sendRouteRequest];
    }
    else {
        if(_routeOverlay) {
            [quickMap removeOverlay:_routeOverlay];
        }
    }
    
    
//    if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"quickMapHints"] isEqualToString:@"YES"]) {
//        [self createMapHints];
//    }
//    else {
//        if (menuPopUp) {
//            [menuPopUp removeFromSuperview];
//        }
//        
//        if (mapCenterPopUp) {
//            [mapCenterPopUp removeFromSuperview];
//        }
//        
//        if (currentLocationPopUp) {
//            [currentLocationPopUp removeFromSuperview];
//        }
//    }
}


- (void) viewDidAppear:(BOOL)animated {
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
//    swipeGesture.numberOfTouchesRequired = 1;
//    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
//    
//    [self.view addGestureRecognizer:swipeGesture];
    
}


- (void) viewWillDisappear:(BOOL)animated {
    
    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        [req cancel];
        [req setDelegate:nil];
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
