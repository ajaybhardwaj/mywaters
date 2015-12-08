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
#import "MapOverlay.h"
#import "MapOverlayView.h"
#import "WaterLevelSensorsDetailViewController.h"
#import "UserFloodSubmissionViewController.h"
#import "CMPopTipView.h"
#import "WLSMapAnnotations.h"
#import "FeedbackMapAnnotations.h"
#import "CCTVMapAnnoations.h"
#import "FloodMapAnnotations.h"

@interface QuickMapViewController : UIViewController <MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UPStackMenuDelegate,CMPopTipViewDelegate,UISearchBarDelegate,UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    BOOL isControlMaximize,isShowingFilter;
    
    UIButton *maximizeButton,*carButton,*chatButton,*cloudButton,*cameraButton,*dropButton,*currentLocationButton;
    BOOL isShowingFlood,isShowingUserFeedback,isShowingRain,isShowingCamera,isShowingDrain;

    UIView *optionsView;
    UITableView *filterTableView;
    NSArray *filterDataSource;
    NSInteger selectedFilterIndex,selectedAnnotationButton;
    
    NSDictionary *locationsDict;
    
    // Place Annotation Point
    QuickMapAnnotations *longPressLocationAnnotation;
    WLSMapAnnotations *wlsAnnotation;
    FloodMapAnnotations *pubFloodAnnotation;
    FeedbackMapAnnotations *userFloodAnnotation;
    CCTVMapAnnoations *cctvAnnotation;
    
    UIView *calloutView;
    BOOL isShowingCallout;
    UITapGestureRecognizer *cctvTapGesture;
    UIButton *cctvCalloutOverlayButton,*wlsCalloutOverlayButton;

    
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
    
    NSMutableArray *cctvAnnotationsArray,*wlsAnnotationsArray,*userFeedbackAnnotationsArray,*pubFloodAnnotationsArray;
    
    
    //*************** Quick Map Hints Variables
    CMPopTipView *currentLocationPopUp,*menuPopUp,*mapCenterPopUp;
    UIButton *mapCenterHiddenButon;
    
    
    UIButton *btnfilter,*btnHints;
    BOOL isShowingHelpScreen;
    UIImageView *helpScreenImageView;
    UILabel *locationHelpLabel,*menuHelpLabel,*rainAreaHelpLabel,*floodByUsersHelpLabel,*cctvHelpLabel,*wlsHelpLabel,*floodByPUBHelpLabel,*meteorologicalDisclaimerLabel;
    NSString *meteorologicalDisclaimerString,*userSubmissionFinePrintString;
    BOOL isShowingMeteorologicalDisclaimer,isShwoingFinePrint;
    
    
    UIButton *hideFilterButton;
    
    UISearchBar *locationSearchBar;
    
}
@property (nonatomic, strong) id currentPopTipViewTarget;
@property (nonatomic, strong) NSMutableArray	*visiblePopTipViews;

@property (nonatomic, assign) BOOL isNotQuickMapController,isShowingRoute;
@property (nonatomic, strong) MapOverlay *mapOverlay;
@property (nonatomic, strong) MapOverlayView *mapOverlayView;
@property (nonatomic, strong) MKMapView *quickMap;


@property (nonatomic, assign) double destinationLat,destinationLong;
@property (nonatomic, assign) BOOL isComingFromCCTVListing,isComingFromWLSListing;

@end
