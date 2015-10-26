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



//*************** Method To Create Hints PopUp Views

- (void) createMapHints {
    
    if (nil == currentLocationPopUp) {
        
        currentLocationPopUp = [[CMPopTipView alloc] initWithMessage:@"Tap to locate your current location."];
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
    NSArray *values = [[NSArray alloc] initWithObjects:@"10",@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}


//*************** Method To Get PUB Flood Submission Listing

- (void) fetchPUBFloodSubmissionListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"11",@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}


//*************** Method To Get CCTV Listing

- (void) fetchCCTVListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"4",@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}



//*************** Method To Get WLS Listing

- (void) fetchWLSListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"6",@"1.0", nil];
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
        pos.y = 90;
        
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
            
            cctvAnnotation = [[QuickMapAnnotations alloc] initWithTitle:[[appDelegate.CCTV_LISTING_ARRAY objectAtIndex:i] objectForKey:@"Name"] AndCoordinates:annotationRegion.center type:@"CCTV" tag:i+1 subtitleValue:[NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]] level:0 image:nil]; //Setting Sample location Annotation
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
                
                wlsAnnotation = [[QuickMapAnnotations alloc] initWithTitle:[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"name"] AndCoordinates:annotationRegion.center type:@"WLS" tag:i+1 subtitleValue:[NSString stringWithFormat:@"%@\n%@",percentageValue,waterLevelTypeValue] level:[[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"waterLevelType"] intValue] image:nil]; //Setting Sample location Annotation
                wlsAnnotation.annotationTitle = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"name"];
                wlsAnnotation.annotationSubtitle = [NSString stringWithFormat:@"%@\n%@",percentageValue,waterLevelTypeValue];
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
            
            
            pubFloodAnnotation = [[QuickMapAnnotations alloc] initWithTitle:[[appDelegate.PUB_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"LocationName"] AndCoordinates:annotationRegion.center type:@"FLOOD" tag:i+1 subtitleValue:[[appDelegate.PUB_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Comment"] level:0 image:nil]; //Setting Sample location Annotation
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
            
            
            pubFloodAnnotation = [[QuickMapAnnotations alloc] initWithTitle:[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"LocationName"] AndCoordinates:annotationRegion.center type:@"FEEDBACK" tag:i+1 subtitleValue:[NSString stringWithFormat:@"Submitted by: %@",[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Comment"]] level:0 image:[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Image"]]; //Setting Sample location Annotation
            //            cctvAnnotation = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            pubFloodAnnotation.annotationTitle = [[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"LocationName"];
            pubFloodAnnotation.annotationSubtitle = [NSString stringWithFormat:@"Submitted by: %@",[[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Comment"]];
            pubFloodAnnotation.annotationType = @"FEEDBACK";
            pubFloodAnnotation.annotationTag = i+1;
            pubFloodAnnotation.annotationImageName = [[appDelegate.USER_FLOOD_SUBMISSION_ARRAY objectAtIndex:i] objectForKey:@"Image"];
            pubFloodAnnotation.coordinate = annotationRegion.center;
            [quickMap addAnnotation:pubFloodAnnotation];
            
            [userFeedbackAnnotationsArray addObject:pubFloodAnnotation];
            
        }
    }
}



//*************** Method To Handle Map Options

- (void) handleMapOptions:(id) sender {
    
    //    //copy your annotations to an array
    //    NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithArray: quickMap.annotations];
    //    //Remove the object userlocation
    //    [annotationsToRemove removeObject: quickMap.userLocation];
    //    //Remove all annotations in the array from the mapView
    //    [quickMap removeAnnotations: annotationsToRemove];
    
    
    //    //Set Default location to zoom
    //    CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(51.900708, -2.083160); //Create the CLLocation from user cordinates
    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 50000, 50000); //Set zooming level
    //    MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
    //    [quickMap setRegion:adjustedRegion animated:YES]; // create animation zooming
    
    //    MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
    //    annotationRegion.center.latitude = 51.900708; // Make lat dynamic later
    //    annotationRegion.center.longitude = -2.083160; // Make long dynamic later
    //    annotationRegion.span.latitudeDelta = 0.02f;
    //    annotationRegion.span.longitudeDelta = 0.02f;
    
    

    
    UIButton *button = (id) sender;
    selectedAnnotationButton = button.tag;
    
    if (button.tag==1) {
        
        if (!isShowingFlood) {
            
            isShowingFlood = YES;
            
            //Set Default location to zoom
            //            CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(51.100708, -2.083160); //Create the CLLocation from user cordinates
            
            
            //            CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(1.3673320, 103.837475); //Create the CLLocation from user cordinates
            //            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); //Set zooming level
            //            MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
            //            [quickMap setRegion:adjustedRegion animated:NO]; // create animation zooming
            
            
            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion.center.latitude = 1.3673320; // Make lat dynamic later
            annotationRegion.center.longitude = 103.837475; // Make long dynamic later
            annotationRegion.span.latitudeDelta = 0.02f;
            annotationRegion.span.longitudeDelta = 0.02f;
            
            annotation1 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation1.coordinate = annotationRegion.center;
            annotation1.title = @"226H Ang Mo Kio Street 22";
            annotation1.subtitle = @"";
            //            annotation1.annotationTag = 1;
            [quickMap addAnnotation:annotation1];
            
            
            MKCoordinateRegion annotationRegion11 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion11.center.latitude = 1.366859; // Make lat dynamic later
            annotationRegion11.center.longitude = 103.837786; // Make long dynamic later
            annotationRegion11.span.latitudeDelta = 0.02f;
            annotationRegion11.span.longitudeDelta = 0.02f;
            
            annotation11 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation11.coordinate = annotationRegion11.center;
            annotation11.title = @"225 Ang Mo Kio Avenue 1";
            annotation11.subtitle = @"";
            //            annotation1.annotationTag = 2;
            [quickMap addAnnotation:annotation11];
            
            
            MKCoordinateRegion annotationRegion12 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion12.center.latitude = 1.367717; // Make lat dynamic later
            annotationRegion12.center.longitude = 103.838913; // Make long dynamic later
            annotationRegion12.span.latitudeDelta = 0.02f;
            annotationRegion12.span.longitudeDelta = 0.02f;
            
            annotation12 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation12.coordinate = annotationRegion12.center;
            annotation12.title = @"226H Ang Mo Kio Street 22";
            annotation12.subtitle = @"";
            //            annotation1.annotationTag = 3;
            [quickMap addAnnotation:annotation12];
            
            [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_pub_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isShowingFlood = NO;
            
            NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithObjects:annotation1,annotation11,annotation12, nil];
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations: annotationsToRemove];
            
            [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        
        //        isShowingFlood = YES;
        //        isShowingUserFeedback = NO;
        //        isShowingRain = NO;
        //        isShowingCamera = NO;
        //        isShowingDrain = NO;
        //
        //        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_pub_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (button.tag==2) {
        
        if (!isShowingUserFeedback) {
            
            isShowingUserFeedback = YES;
            
            //Set Default location to zoom
            //            CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(1.371792, 103.846122); //Create the CLLocation from user cordinates
            //            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); //Set zooming level
            //            MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
            //            [quickMap setRegion:adjustedRegion animated:NO]; // create animation zooming
            
            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion.center.latitude = 1.371792; // Make lat dynamic later
            annotationRegion.center.longitude = 103.846122; // Make long dynamic later
            annotationRegion.span.latitudeDelta = 0.02f;
            annotationRegion.span.longitudeDelta = 0.02f;
            
            annotation2 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation2.coordinate = annotationRegion.center;
            annotation2.title = @"No more danger warning here.";
            annotation2.subtitle = @"@blu3_87";
            [quickMap addAnnotation:annotation2];
            
            
            MKCoordinateRegion annotationRegion21 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion21.center.latitude = 1.371943; // Make lat dynamic later
            annotationRegion21.center.longitude = 103.847367; // Make long dynamic later
            annotationRegion21.span.latitudeDelta = 0.02f;
            annotationRegion21.span.longitudeDelta = 0.02f;
            
            annotation21 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation21.coordinate = annotationRegion21.center;
            annotation21.title = @"Flood condition quite bad here, water level reaches till knees.";
            annotation21.subtitle = @"@migh89";
            [quickMap addAnnotation:annotation21];
            
            MKCoordinateRegion annotationRegion22 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion22.center.latitude = 1.384937; // Make lat dynamic later
            annotationRegion22.center.longitude = 103.870670; // Make long dynamic later
            annotationRegion22.span.latitudeDelta = 0.02f;
            annotationRegion22.span.longitudeDelta = 0.02f;
            
            annotation22 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation22.coordinate = annotationRegion22.center;
            annotation22.title = @"Water level reaches to normal.";
            annotation22.subtitle = @"@jeff9";
            [quickMap addAnnotation:annotation22];
            
            MKCoordinateRegion annotationRegion23 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion23.center.latitude = 1.385001; // Make lat dynamic later
            annotationRegion23.center.longitude = 103.872220; // Make long dynamic later
            annotationRegion23.span.latitudeDelta = 0.02f;
            annotationRegion23.span.longitudeDelta = 0.02f;
            
            annotation23 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation23.coordinate = annotationRegion23.center;
            annotation23.title = @"Traffic jam coz of flood water.";
            annotation23.subtitle = @"@miss123";
            [quickMap addAnnotation:annotation23];
            
            [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isShowingUserFeedback = NO;
            
            NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithObjects:annotation2,annotation21,annotation22,annotation23, nil];
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations: annotationsToRemove];
            
            [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        
        //        isShowingFlood = NO;
        //        isShowingUserFeedback = YES;
        //        isShowingRain = NO;
        //        isShowingCamera = NO;
        //        isShowingDrain = NO;
        //
        //        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (button.tag==3) {
        
        if (!isShowingRain) {
            
            isShowingRain = YES;
            
            //Set Default location to zoom
            //            CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(1.375289, 103.852034); //Create the CLLocation from user cordinates
            //            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); //Set zooming level
            //            MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
            //            [quickMap setRegion:adjustedRegion animated:NO]; // create animation zooming
            
            
            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion.center.latitude = 1.375289; // Make lat dynamic later
            annotationRegion.center.longitude = 103.852034; // Make long dynamic later
            annotationRegion.span.latitudeDelta = 0.02f;
            annotationRegion.span.longitudeDelta = 0.02f;
            
            annotation3 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation3.coordinate = annotationRegion.center;
            annotation3.title = @"537 Ang Mo Kio Avenue 5";
            annotation3.subtitle = @"";
            [quickMap addAnnotation:annotation3];
            
            
            MKCoordinateRegion annotationRegion31 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion31.center.latitude = 1.373820; // Make lat dynamic later
            annotationRegion31.center.longitude = 103.851058; // Make long dynamic later
            annotationRegion31.span.latitudeDelta = 0.02f;
            annotationRegion31.span.longitudeDelta = 0.02f;
            
            annotation31 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation31.coordinate = annotationRegion31.center;
            annotation31.title = @"10 Ang Mo Kio Street 53";
            annotation31.subtitle = @"";
            [quickMap addAnnotation:annotation31];
            
            MKCoordinateRegion annotationRegion32 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion32.center.latitude = 1.374077; // Make lat dynamic later
            annotationRegion32.center.longitude = 103.853354; // Make long dynamic later
            annotationRegion32.span.latitudeDelta = 0.02f;
            annotationRegion32.span.longitudeDelta = 0.02f;
            
            annotation32 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation32.coordinate = annotationRegion32.center;
            annotation32.title = @"535 Ang Mo Kio Avenue 5";
            annotation32.subtitle = @"";
            [quickMap addAnnotation:annotation32];
            
            MKCoordinateRegion annotationRegion33 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion33.center.latitude = 1.372736; // Make lat dynamic later
            annotationRegion33.center.longitude = 103.853171; // Make long dynamic later
            annotationRegion33.span.latitudeDelta = 0.02f;
            annotationRegion33.span.longitudeDelta = 0.02f;
            
            annotation33 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation33.coordinate = annotationRegion33.center;
            annotation33.title = @"524 Ang Mo Kio Avenue 5";
            annotation33.subtitle = @"";
            [quickMap addAnnotation:annotation33];
            
            [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isShowingRain = NO;
            
            NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithObjects:annotation3,annotation31,annotation32,annotation33, nil];
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations: annotationsToRemove];
            
            [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        
        //        isShowingFlood = NO;
        //        isShowingUserFeedback = NO;
        //        isShowingRain = YES;
        //        isShowingCamera = NO;
        //        isShowingDrain = NO;
        //
        //        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (button.tag==4) {
        
        if (!isShowingCamera) {
            
            isShowingCamera = YES;
            
            if (appDelegate.CCTV_LISTING_ARRAY.count==0) {
                
                isLoadingFloods = NO;
                isLoadingWLS = NO;
                isLoadingCCTV = YES;
                isLoadingFeedback = NO;
                isLoadingRainMap = NO;
                
                appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
                appDelegate.hud.labelText = @"Loading...";
                [self fetchCCTVListing];
            }
            else {
                
                [self generateCCTVAnnotations];
            }
            //            //Set Default location to zoom
            //            //            CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(1.383194, 103.862344); //Create the CLLocation from user cordinates
            //            //            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); //Set zooming level
            //            //            MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
            //            //            [quickMap setRegion:adjustedRegion animated:NO]; // create animation zooming
            //
            //            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            //            annotationRegion.center.latitude = 1.383194; // Make lat dynamic later
            //            annotationRegion.center.longitude = 103.862344; // Make long dynamic later
            //            annotationRegion.span.latitudeDelta = 0.02f;
            //            annotationRegion.span.longitudeDelta = 0.02f;
            //
            //            annotation4 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            //            annotation4.coordinate = annotationRegion.center;
            //            annotation4.title = @"43 Mimosa Rd";
            //            annotation4.subtitle = @"";
            //            [quickMap addAnnotation:annotation4];
            //
            //
            //            MKCoordinateRegion annotationRegion41 = { {0.0, 0.0} , {0.0, 0.0} };
            //            annotationRegion41.center.latitude = 1.383451; // Make lat dynamic later
            //            annotationRegion41.center.longitude = 103.859791; // Make long dynamic later
            //            annotationRegion41.span.latitudeDelta = 0.02f;
            //            annotationRegion41.span.longitudeDelta = 0.02f;
            //
            //            annotation41 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            //            annotation41.coordinate = annotationRegion41.center;
            //            annotation41.title = @"40 Mimosa Dr";
            //            annotation41.subtitle = @"";
            //            [quickMap addAnnotation:annotation41];
            //
            //
            //            MKCoordinateRegion annotationRegion42 = { {0.0, 0.0} , {0.0, 0.0} };
            //            annotationRegion42.center.latitude = 1.386433; // Make lat dynamic later
            //            annotationRegion42.center.longitude = 103.871571; // Make long dynamic later
            //            annotationRegion42.span.latitudeDelta = 0.02f;
            //            annotationRegion42.span.longitudeDelta = 0.02f;
            //
            //            annotation42 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            //            annotation42.coordinate = annotationRegion42.center;
            //            annotation42.title = @"22 Seletar Crescent";
            //            annotation42.subtitle = @"";
            //            [quickMap addAnnotation:annotation42];
            //
            //
            //            MKCoordinateRegion annotationRegion43 = { {0.0, 0.0} , {0.0, 0.0} };
            //            annotationRegion43.center.latitude = 1.385596; // Make lat dynamic later
            //            annotationRegion43.center.longitude = 103.871855; // Make long dynamic later
            //            annotationRegion43.span.latitudeDelta = 0.02f;
            //            annotationRegion43.span.longitudeDelta = 0.02f;
            //
            //            annotation43 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            //            annotation43.coordinate = annotationRegion43.center;
            //            annotation43.title = @"2 Jalan Lakum";
            //            annotation43.subtitle = @"";
            //            [quickMap addAnnotation:annotation43];
            
            [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isShowingCamera = NO;
            
            NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithObjects:annotation4,annotation41,annotation42,annotation43, nil];
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations: annotationsToRemove];
            
            [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        
        //        isShowingFlood = NO;
        //        isShowingUserFeedback = NO;
        //        isShowingRain = NO;
        //        isShowingCamera = YES;
        //        isShowingDrain = NO;
        //
        //        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (button.tag==5) {
        
        if (!isShowingDrain) {
            
            isShowingDrain = YES;
            
            [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
            
            //Set Default location to zoom
            //            CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(1.385768, 103.871131); //Create the CLLocation from user cordinates
            //            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); //Set zooming level
            //            MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
            //            [quickMap setRegion:adjustedRegion animated:NO]; // create animation zooming
            
            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion.center.latitude = 1.385768; // Make lat dynamic later
            annotationRegion.center.longitude = 103.871131; // Make long dynamic later
            annotationRegion.span.latitudeDelta = 0.02f;
            annotationRegion.span.longitudeDelta = 0.02f;
            
            annotation5 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation5.coordinate = annotationRegion.center;
            annotation5.title = @"11 Jalan Pelajau";
            annotation5.subtitle = @"Flood level below 75%";
            [quickMap addAnnotation:annotation5];
            
            
            MKCoordinateRegion annotationRegion51 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion51.center.latitude = 1.384052; // Make lat dynamic later
            annotationRegion51.center.longitude = 103.868910; // Make long dynamic later
            annotationRegion51.span.latitudeDelta = 0.02f;
            annotationRegion51.span.longitudeDelta = 0.02f;
            
            annotation51 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation51.coordinate = annotationRegion51.center;
            annotation51.title = @"16 Jalan Lebat Daun";
            annotation51.subtitle = @"Flood level between 75%-90%";
            [quickMap addAnnotation:annotation51];
            
            
            MKCoordinateRegion annotationRegion52 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion52.center.latitude = 1.386444; // Make lat dynamic later
            annotationRegion52.center.longitude = 103.869157; // Make long dynamic later
            annotationRegion52.span.latitudeDelta = 0.02f;
            annotationRegion52.span.longitudeDelta = 0.02f;
            
            annotation52 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation52.coordinate = annotationRegion52.center;
            annotation52.title = @"20 Seletar Rd";
            annotation52.subtitle = @"Flood level more than 90%";
            [quickMap addAnnotation:annotation52];
            
            [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            
            self.navigationItem.rightBarButtonItem = nil;
            
            isShowingDrain = NO;
            
            NSMutableArray *annotationsToRemove = [[NSMutableArray alloc] initWithObjects:annotation5,annotation51,annotation52, nil];
            //Remove all annotations in the array from the mapView
            [quickMap removeAnnotations: annotationsToRemove];
            
            [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        
        //        isShowingFlood = NO;
        //        isShowingUserFeedback = NO;
        //        isShowingRain = NO;
        //        isShowingCamera = NO;
        //        isShowingDrain = YES;
        //
        //        [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        //        [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        
        //        [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
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
                if (appDelegate.CCTV_LISTING_ARRAY.count!=0)
                    [self performSelectorInBackground:@selector(saveCCTVData) withObject:nil];

            }
            else {
                [CommonFunctions showAlertView:nil title:nil msg:@"No data available." cancel:@"OK" otherButton:nil];
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
                
                if (appDelegate.WLS_LISTING_ARRAY.count!=0)
                    [self performSelectorInBackground:@selector(saveWLSData) withObject:nil];

            }
            else {
                [CommonFunctions showAlertView:nil title:nil msg:@"No data available." cancel:@"OK" otherButton:nil];
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
                    [CommonFunctions showAlertView:nil title:nil msg:[NSString stringWithFormat:@"No data available.\nTo submit flood information, long press on map to drop pin."] cancel:@"OK" otherButton:nil];
                else
                    [CommonFunctions showAlertView:nil title:nil msg:[NSString stringWithFormat:@"No data available."] cancel:@"OK" otherButton:nil];
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
                [CommonFunctions showAlertView:nil title:nil msg:@"No data available." cancel:@"OK" otherButton:nil];
            }
        }
        
        [appDelegate.hud hide:YES];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [appDelegate.hud hide:YES];
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
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5, filterTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        if (indexPath.row==selectedFilterIndex-1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    
    return cell;
}




# pragma mark - MKMapViewDelegate Methods


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
    
    MKAnnotationView *pinView = nil;
    
    if (annotation==longPressLocationAnnotation) {
        
        pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:@"FEEDBACK"];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:@"FEEDBACK"];
        
        
        pinView.image = [UIImage imageNamed:@"icn_floodinfo_userfeedback_submission_small.png"];
        return pinView;
    }
    
    if(annotation != quickMap.userLocation) {
        
        //        static NSString *defaultPinID = @"com.invasivecode.pin";
        
        if (selectedAnnotationButton==4) {
            
            pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:@"FLOOD"];
            if ( pinView == nil )
                pinView = [[MKAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:@"FLOOD"];
            
            
            pinView.image = [UIImage imageNamed:@"icn_floodinfo_small.png"];
        }
        else if (selectedAnnotationButton==1) {
            
            pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:@"FEEDBACK"];
            if ( pinView == nil )
                pinView = [[MKAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:@"FEEDBACK"];
            
            
            pinView.image = [UIImage imageNamed:@"icn_floodinfo_userfeedback_submission_small.png"];
        }
        else if (selectedAnnotationButton==0) {
            
            pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:@"RAINMAP"];
            if ( pinView == nil )
                pinView = [[MKAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:@"RAINMAP"];
            
            
            pinView.canShowCallout = YES;
            
            pinView.image = [UIImage imageNamed:@"icn_rainarea_small.png"];
        }
        else if (selectedAnnotationButton==2) {
            
            pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:@"CCTV"];
            if ( pinView == nil )
                
                pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CCTV"];
            pinView.image = [UIImage imageNamed:@"icn_cctv_small.png"];
            
            
            
        }
        else if (selectedAnnotationButton==3) {
            
            pinView = (MKAnnotationView *)[quickMap dequeueReusableAnnotationViewWithIdentifier:@"WLS"];
            if ( pinView == nil )
                pinView = [[MKAnnotationView alloc]
                           initWithAnnotation:annotation reuseIdentifier:@"WLS"];
            
            if (wlsAnnotation.waterLevel == 1) {
                pinView.image = [UIImage imageNamed:@"icn_waterlevel_below75_big.png"];
            }
            else if (wlsAnnotation.waterLevel == 2) {
                pinView.image = [UIImage imageNamed:@"icn_waterlevel_75-90_big.png"];
            }
            else if (wlsAnnotation.waterLevel == 3) {
                pinView.image = [UIImage imageNamed:@"icn_waterlevel_90_big.png-90_big.png"];
            }
            else {
                pinView.image = [UIImage imageNamed:@"icn_waterlevel_undermaintenance.png"];
            }
        }
        
        pinView.tag = selectedAnnotationButton;
    }
    
    else {
        
        return nil;
    }
    return pinView;
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        MKAnnotationView *av = [mapView viewForAnnotation:mapView.userLocation];
        av.enabled = NO;
        return;
    }
        
    
    QuickMapAnnotations *temp = (QuickMapAnnotations*)view.annotation;
    
    isShowingCallout = NO;
    
    if ([temp.annotationType isEqualToString:@"CCTV"]) {
        
        [calloutView removeFromSuperview];
        
        isShowingCallout = YES;
        
        calloutView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 150, 100)];
        calloutView.backgroundColor = [UIColor whiteColor];
        calloutView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        calloutView.layer.borderWidth = 1.0;
        calloutView.layer.cornerRadius = 10.0f;
        calloutView.userInteractionEnabled = YES;
        
        UIImageView *locationNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        [locationNameImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/callout_icn_location_grey.png",appDelegate.RESOURCE_FOLDER_PATH]]];
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
    else if ([temp.annotationType isEqualToString:@"WLS"]) {
        
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
        [calloutView addSubview:titleLabel];
        [titleLabel sizeToFit];
        

        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 130, 40)];
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
        [overlayButon addTarget:self action:@selector(handleWLSCalloutTap:) forControlEvents:UIControlEventTouchUpInside];
        [calloutView addSubview:overlayButon];
        
        [quickMap addSubview:calloutView];
    }
    
    else if ([temp.annotationType isEqualToString:@"FLOOD"]) {
        
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
        [calloutView addSubview:titleLabel];
        [titleLabel sizeToFit];
        

        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, 130, 40)];
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
    
    else if ([temp.annotationType isEqualToString:@"FEEDBACK"]) {
        
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
    else {
        
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
            
            if (appDelegate.PUB_FLOOD_SUBMISSION_ARRAY.count==0) {
                
                isLoadingFloods = YES;
                isLoadingWLS = NO;
                isLoadingCCTV = NO;
                isLoadingFeedback = NO;
                isLoadingRainMap = NO;
                
                appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
                appDelegate.hud.labelText = @"Loading...";
                
                [self fetchPUBFloodSubmissionListing];
            }
            else {
                
                [self generatePUBFloodSubmissionAnnotations];
            }
            
            [floodStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_pub_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
            
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
            
            [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
            
            if (appDelegate.WLS_LISTING_ARRAY.count==0) {
                
                isLoadingFloods = NO;
                isLoadingWLS = YES;
                isLoadingCCTV = NO;
                isLoadingFeedback = NO;
                isLoadingRainMap = NO;
                
                appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
                appDelegate.hud.labelText = @"Loading...";
                
                [self fetchWLSListing];
            }
            else {
                
                [self generateWLSAnnotations];
            }
            
            [wlsStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            
            self.navigationItem.rightBarButtonItem = nil;
            
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
                
                appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
                appDelegate.hud.labelText = @"Loading...";
                
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
            
            if (appDelegate.USER_FLOOD_SUBMISSION_ARRAY.count==0) {
                
                isLoadingFloods = NO;
                isLoadingWLS = NO;
                isLoadingCCTV = NO;
                isLoadingFeedback = YES;
                isLoadingRainMap = NO;
                
                appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
                appDelegate.hud.labelText = @"Loading...";
                
                [self fetchUserFloodSubmissionListing];
            }
            else {
                
                [self generateUserFloodSubmissionAnnotations];
            }
            
            [userFeedbackStackItem._imageButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isShowingUserFeedback = NO;
            
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
            
            
            self.mapOverlay = [[MapOverlay alloc] initWithLowerLeftCoordinate:CLLocationCoordinate2DMake(1.229001, 103.607254) withUpperRightCoordinate:CLLocationCoordinate2DMake(1.46926, 104.026108)];
            
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
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    quickMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    quickMap.delegate = self;
    [quickMap setMapType:MKMapTypeStandard];
    [quickMap setZoomEnabled:YES];
    [quickMap setScrollEnabled:YES];
    [quickMap setShowsUserLocation:YES];
    [self.view  addSubview:quickMap];
    //    [quickMap setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
    //    quickMap.alpha = 0.5;
    
    if (!appDelegate.IS_SKIPPING_USER_LOGIN) {
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
        [quickMap addGestureRecognizer:lpgr];
    }
    
    isShowingFlood = NO;
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
    
    
//    currentLocationHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentLocationButton.frame.origin.x+currentLocationButton.bounds.size.width+10, quickMap.bounds.size.height-60, 150, 40)];
//    currentLocationHintLabel.backgroundColor = [UIColor clearColor];
//    currentLocationHintLabel.text = [NSString stringWithFormat:@"--- Tap to locate your\n    current location."];
//    currentLocationHintLabel.numberOfLines = 0;
//    currentLocationHintLabel.textColor = [UIColor whiteColor];
//    currentLocationHintLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
//    [quickMap addSubview:currentLocationHintLabel];
    
    
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
    
    floodStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Flood Info by PUB" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    wlsStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Water Level Sensor" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    cctvStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"CCTV" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    userFeedbackStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Flood Info by Users" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    rainMapStackItem = [[UPStackMenuItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] highlightedImage:nil title:@"Rain Area" font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0]];
    
    
    
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
    [self setStackIconClosed:NO];
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -270, self.view.bounds.size.width, 180) style:UITableViewStylePlain];
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
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    if (appDelegate.IS_COMING_FROM_DASHBOARD) {
        appDelegate.IS_COMING_FROM_DASHBOARD = NO;
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    }
    else {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    }
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(229,0,87) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    self.title = @"Quick Map";
    
    //        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    //    }
    
    
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
    
    
    if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"quickMapHints"] isEqualToString:@"YES"]) {
        [self createMapHints];
    }
    else {
        if (menuPopUp) {
            [menuPopUp removeFromSuperview];
        }
        
        if (mapCenterPopUp) {
            [mapCenterPopUp removeFromSuperview];
        }
        
        if (currentLocationPopUp) {
            [currentLocationPopUp removeFromSuperview];
        }
    }
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
