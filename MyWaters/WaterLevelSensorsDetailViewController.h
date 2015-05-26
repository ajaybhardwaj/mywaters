//
//  WaterLevelSensorsDetailViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 14/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "CustomButtons.h"

@interface WaterLevelSensorsDetailViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate> {
    
    AppDelegate *appDelegate;
    
    MKMapView *wateLevelMapView;
    BOOL isShowingTopMenu;
    
    UIView *topMenu,*cctvView;
    UILabel *titleLabel,*timeLabel,*drainDepthLabel;
    UIButton *clockButton,*levelButton,*currentLocationButton;
    UIImageView *measurementBar;
    
    UISearchBar *topSearchBar;
    UIButton *alertButton,*addToFavButton,*refreshButton;
    UILabel *iAlertLabel,*addToFavLabel,*refreshLabel;
}

@end
