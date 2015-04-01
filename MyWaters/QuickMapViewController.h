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

@interface QuickMapViewController : UIViewController <MKMapViewDelegate> {
    
    AppDelegate *appDelegate;
    BOOL isControlMaximize;
    
    MKMapView *quickMap;
    UIButton *maximizeButton,*carButton,*chatButton,*cloudButton,*cameraButton,*dropButton;

    UIView *optionsView;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    
    
}

@property (nonatomic, assign) BOOL isNotQuickMapController;

@end
