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


//*************** Method To ANimate Filter Table

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
            
            //Set Default location to zoom
//            CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(1.383194, 103.862344); //Create the CLLocation from user cordinates
//            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500); //Set zooming level
//            MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
//            [quickMap setRegion:adjustedRegion animated:NO]; // create animation zooming
            
            MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion.center.latitude = 1.383194; // Make lat dynamic later
            annotationRegion.center.longitude = 103.862344; // Make long dynamic later
            annotationRegion.span.latitudeDelta = 0.02f;
            annotationRegion.span.longitudeDelta = 0.02f;
            
            annotation4 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation4.coordinate = annotationRegion.center;
            annotation4.title = @"43 Mimosa Rd";
            annotation4.subtitle = @"";
            [quickMap addAnnotation:annotation4];
            
            
            MKCoordinateRegion annotationRegion41 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion41.center.latitude = 1.383451; // Make lat dynamic later
            annotationRegion41.center.longitude = 103.859791; // Make long dynamic later
            annotationRegion41.span.latitudeDelta = 0.02f;
            annotationRegion41.span.longitudeDelta = 0.02f;
            
            annotation41 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation41.coordinate = annotationRegion41.center;
            annotation41.title = @"40 Mimosa Dr";
            annotation41.subtitle = @"";
            [quickMap addAnnotation:annotation41];
            
            
            MKCoordinateRegion annotationRegion42 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion42.center.latitude = 1.386433; // Make lat dynamic later
            annotationRegion42.center.longitude = 103.871571; // Make long dynamic later
            annotationRegion42.span.latitudeDelta = 0.02f;
            annotationRegion42.span.longitudeDelta = 0.02f;
            
            annotation42 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation42.coordinate = annotationRegion42.center;
            annotation42.title = @"22 Seletar Crescent";
            annotation42.subtitle = @"";
            [quickMap addAnnotation:annotation42];
            
            
            MKCoordinateRegion annotationRegion43 = { {0.0, 0.0} , {0.0, 0.0} };
            annotationRegion43.center.latitude = 1.385596; // Make lat dynamic later
            annotationRegion43.center.longitude = 103.871855; // Make long dynamic later
            annotationRegion43.span.latitudeDelta = 0.02f;
            annotationRegion43.span.longitudeDelta = 0.02f;
            
            annotation43 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
            annotation43.coordinate = annotationRegion43.center;
            annotation43.title = @"2 Jalan Lakum";
            annotation43.subtitle = @"";
            [quickMap addAnnotation:annotation43];
            
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
        [self animateFilterTable];
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
        if (selectedAnnotationButton==1) {
            pinView.image = [UIImage imageNamed:@"icn_floodinfo_small.png"];
        }
        else if (selectedAnnotationButton==2) {
            pinView.image = [UIImage imageNamed:@"icn_floodinfo_userfeedback_submission_small.png"];
        }
        else if (selectedAnnotationButton==3) {
            pinView.image = [UIImage imageNamed:@"icn_rainarea_small.png"];
        }
        else if (selectedAnnotationButton==4) {
            pinView.image = [UIImage imageNamed:@"icn_cctv_small.png"];
        }
        else if (selectedAnnotationButton==5) {
            if (annotation==annotation5) {
                pinView.image = [UIImage imageNamed:@"icn_waterlevel_below75.png"];
            }
            else if (annotation==annotation51) {
                pinView.image = [UIImage imageNamed:@"icn_waterlevel_75-90.png"];
            }
            else if (annotation==annotation52) {
                pinView.image = [UIImage imageNamed:@"icn_waterlevel_90.png"];
            }
        }
        
        pinView.tag = selectedAnnotationButton;
    }
    else {
        [quickMap.userLocation setTitle:@"You are here..!!"];
    }
    return pinView;
}



//- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    
//    NSInteger indexOfTheObject = [quickMap.annotations indexOfObject:view.annotation];
//    NSLog(@"Annotation Index %ld",indexOfTheObject);
//    
//    CGSize  calloutSize = CGSizeMake(150.0, 80.0);
//    UIView *calloutView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-calloutSize.height, calloutSize.width, calloutSize.height)];
//    calloutView.backgroundColor = [UIColor whiteColor];
//    
//    
//    if (selectedAnnotationButton==1) {
//        
//        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, calloutView.bounds.size.width-20, 36)];
//        locationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
//        locationLabel.backgroundColor = [UIColor clearColor];
//        locationLabel.text = [floodTempArray objectAtIndex:(indexOfTheObject*3)];
//        locationLabel.numberOfLines = 0;
//        [calloutView addSubview:locationLabel];
//        
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, locationLabel.frame.origin.y+locationLabel.bounds.size.height+3, calloutView.bounds.size.width-20, 30)];
//        messageLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
//        messageLabel.backgroundColor = [UIColor clearColor];
//        messageLabel.text = [floodTempArray objectAtIndex:(indexOfTheObject*3)+1];
//        messageLabel.numberOfLines = 0;
//        [calloutView addSubview:messageLabel];
//        
//        UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, messageLabel.frame.origin.y+messageLabel.bounds.size.height+3, calloutView.bounds.size.width-20, 10)];
//        timestampLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
//        timestampLabel.backgroundColor = [UIColor clearColor];
//        timestampLabel.text = [NSString stringWithFormat:@"@ %@",[floodTempArray objectAtIndex:(indexOfTheObject*3)+2]];
//        timestampLabel.numberOfLines = 0;
//        [calloutView addSubview:timestampLabel];
//    }
//    
////    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////    button.frame = CGRectMake(5.0, 5.0, calloutSize.width - 10.0, calloutSize.height - 10.0);
////    [button setTitle:@"OK" forState:UIControlStateNormal];
////    [button addTarget:self action:@selector(checkin) forControlEvents:UIControlEventTouchUpInside];
////    [calloutView addSubview:button];
//    
//    [view.superview addSubview:calloutView];
//}




# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedFilterIndex = 0;
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    quickMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    quickMap.delegate = self;
    [quickMap setMapType:MKMapTypeStandard];
    [quickMap setZoomEnabled:YES];
    [quickMap setScrollEnabled:YES];
    [self.view  addSubview:quickMap];
//    [quickMap setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
//    quickMap.alpha = 0.5;
    
    
    isShowingFlood = NO;
    isShowingUserFeedback = NO;
    isShowingRain = NO;
    isShowingCamera = NO;
    isShowingDrain = YES;
    
    //    //Set Default location to zoom
    //    CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(51.900708, -2.083160); //Create the CLLocation from user cordinates
    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 50000, 50000); //Set zooming level
    //    MKCoordinateRegion adjustedRegion = [quickMap regionThatFits:viewRegion]; //add location to map
    //    [quickMap setRegion:adjustedRegion animated:YES]; // create animation zooming
    //
    //    MKCoordinateRegion annotationRegion = { {0.0, 0.0} , {0.0, 0.0} };
    //    annotationRegion.center.latitude = 51.100708;
    //    annotationRegion.center.longitude = -2.083160;
    //    annotationRegion.span.latitudeDelta = 0.02f;
    //    annotationRegion.span.longitudeDelta = 0.02f;
    //
    //    // Place Annotation Point
    //    annotation1 = [[QuickMapAnnotations alloc] init]; //Setting Sample location Annotation
    //    annotation1.coordinate = annotationRegion.center;
    ////    [annotation1 setTitleString:@"Test Annotation 1"];
    ////    [annotation1 setSubtitleString:@"Subtitle For Annotation 1"];
    //    annotation1.title = @"Test Annotation 1";
    //    annotation1.subtitle = @"Subtitle For Annotation 1";
    //    [quickMap addAnnotation:annotation1];
    
    
    
    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(quickMap.userLocation.coordinate, 50, 50);
    //    viewRegion.span.longitudeDelta  = 0.005;
    //    viewRegion.span.latitudeDelta  = 0.005;
    //    [quickMap setRegion:viewRegion animated:YES];
    
    //    MKUserLocation *userLocation = quickMap.userLocation;
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    //    [quickMap setRegion:region animated:YES];
    
    
    currentLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [currentLocationButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [currentLocationButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_quick_map.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-60, 40, 40);
    [quickMap addSubview:currentLocationButton];
    
    maximizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [maximizeButton addTarget:self action:@selector(handleExpandingControls) forControlEvents:UIControlEventTouchUpInside];
    [maximizeButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_expand.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    
    if (IS_IPHONE_4_OR_LESS) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-55, quickMap.bounds.size.height-60, 40, 40);
        currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-60, 40, 40);
    }
    else if (IS_IPHONE_5) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-55, quickMap.bounds.size.height-65, 40, 40);
        currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-65, 40, 40);
    }
    else if (IS_IPHONE_6) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-65, quickMap.bounds.size.height-75, 45, 45);
        currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-75, 40, 40);
    }
    else if (IS_IPHONE_6P) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-75, quickMap.bounds.size.height-85, 50, 50);
        currentLocationButton.frame = CGRectMake(15, quickMap.bounds.size.height-85, 40, 40);
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
    
    dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dropButton.frame = CGRectMake(0, carButton.frame.origin.y+carButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    dropButton.tag = 5;
    [dropButton addTarget:self action:@selector(handleMapOptions:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:dropButton];
    
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(0, dropButton.frame.origin.y+dropButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_small_greyout.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    cameraButton.tag = 4;
    [cameraButton addTarget:self action:@selector(handleMapOptions:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:cameraButton];
    
    chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.frame = CGRectMake(0, cameraButton.frame.origin.y+cameraButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
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
    
    
    
    
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -270, self.view.bounds.size.width, 180) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    
    filterDataSource = [[NSArray alloc] initWithObjects:@"Drain 0-75% Full",@"Drain 75%-90% Full",@"Drain 90%-100 Full",@"Station under maintenance", nil];
    
    //[self createDemoAppControls];
    
    
    floodTempArray = [[NSArray alloc] initWithObjects:@"226H Ang Mo Kio Street 22",@"Low Flood",@"03:15 PM",@"225 Ang Mo Kio Avenue 1",@"Moderate Flood",@"8:25 PM",@"226H Ang Mo Kio Street 22",@"High Flood",@"9:15 AM", nil];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;

//    if (!isNotQuickMapController) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
//    }
//    else {
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(229,0,87) frame:CGRectMake(0, 0, 1, 1)];
        [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
        [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
        [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
        
        self.title = @"Quick Map";
        
//        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
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
