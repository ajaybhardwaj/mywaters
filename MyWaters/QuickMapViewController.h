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

@interface QuickMapViewController : UIViewController <MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    BOOL isControlMaximize,isShowingFilter;
    
    MKMapView *quickMap;
    UIButton *maximizeButton,*carButton,*chatButton,*cloudButton,*cameraButton,*dropButton;
    BOOL isShowingFlood,isShowingUserFeedback,isShowingRain,isShowingCamera,isShowingDrain;

    UIView *optionsView;
    UITableView *filterTableView;
    NSArray *filterDataSource;
    NSInteger selectedFilterIndex;
    
    NSDictionary *locationsDict;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    
    
}

@property (nonatomic, assign) BOOL isNotQuickMapController;

@end
