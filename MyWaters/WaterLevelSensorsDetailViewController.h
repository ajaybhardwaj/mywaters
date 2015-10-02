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
#import "QuickMapAnnotations.h"

@interface WaterLevelSensorsDetailViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    
    MKMapView *wateLevelMapView;
    BOOL isShowingTopMenu;
    
    UIView *topMenu,*cctvView;
    UILabel *titleLabel,*timeLabel,*drainDepthLabel,*depthValueLabel;
    UIButton *clockButton,*levelButton,*currentLocationButton;
    UIImageView *measurementBar;
    
    UIImageView *wlsIconView;
    UILabel *riskLabel;
    
    UISearchBar *topSearchBar;
    UIButton *alertButton,*addToFavButton,*refreshButton;
    UILabel *iAlertLabel,*addToFavLabel,*refreshLabel;
    
    UIImageView *topImageView,*directionIcon,*arrowIcon;
    UIButton *directionButton;
    UILabel *cctvTitleLabel,*distanceLabel;
    
    UITableView *wlsListingTable;
    NSArray *nearbyWlsDatasource;
    
    UIButton *notifiyButton;
    
    QuickMapAnnotations *annotation1;
    
}

@property (nonatomic, assign) NSInteger drainDepthType;
@property (nonatomic, strong) NSString *wlsID,*wlsName,*observedTime,*waterLevelValue,*waterLevelPercentageValue,*waterLevelTypeValue,*drainDepthValue;
@property (nonatomic, assign) double latValue,longValue;


@end
