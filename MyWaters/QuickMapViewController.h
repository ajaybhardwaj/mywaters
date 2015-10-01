//
//  QuickMapViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AuxilaryService.h"
#import <MapKit/MapKit.h>
#import "QuickMapAnnotations.h"
#import "UPStackMenu.h"
#import "CustomAnnotationView.h"
#import "CCTVDetailViewController.h"

@interface QuickMapViewController : UIViewController <MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UPStackMenuDelegate> {
    
    AppDelegate *appDelegate;
    BOOL isControlMaximize,isShowingFilter;
    
    MKMapView *quickMap;
    UIButton *maximizeButton,*carButton,*chatButton,*cloudButton,*cameraButton,*dropButton,*currentLocationButton;
    BOOL isShowingFlood,isShowingUserFeedback,isShowingRain,isShowingCamera,isShowingDrain;

    UIView *optionsView;
    UITableView *filterTableView;
    NSArray *filterDataSource;
    NSInteger selectedFilterIndex,selectedAnnotationButton;
    
    NSDictionary *locationsDict;
    
    // Place Annotation Point
    QuickMapAnnotations *cctvAnnotation;
    UIView *calloutView;
    BOOL isShowingCallout;
    UITapGestureRecognizer *cctvTapGesture;
    
    
    QuickMapAnnotations *annotation1,*annotation2,*annotation3,*annotation4,*annotation5,*annotation6;
    QuickMapAnnotations *annotation11,*annotation12,*annotation21,*annotation22,*annotation23,*annotation31,*annotation32,*annotation33;
    QuickMapAnnotations *annotation41,*annotation42,*annotation43,*annotation51,*annotation52;
    
    //***** Variables For UPStackMenu
    UIView *menuContentView;
    UPStackMenu *stack;
    UPStackMenuItem *floodStackItem,*wlsStackItem,*cctvStackItem,*userFeedbackStackItem,*rainMapStackItem;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    
    
    NSArray *floodTempArray,*wlsTempArray,*cctvTempArray,*userFeedbackArray,*rainTempArray;
    BOOL isLoadingFloods,isLoadingWLS,isLoadingCCTV,isLoadingFeedback,isLoadingRainMap;
    
    
}

@property (nonatomic, assign) BOOL isNotQuickMapController;

@end
