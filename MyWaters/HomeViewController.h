//
//  HomeViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "QuickMapViewController.h"
#import "WhatsUpViewController.h"
#import "FeedbackViewController.h"
#import "CCTVDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WeatherForecastViewController.h"
#import "WaterLevelSensorsDetailViewController.h"
#import <MapKit/MapKit.h>
#import "QuickMapAnnotations.h"
#import <CoreLocation/CoreLocation.h>
#import "EventsDetailsViewController.h"
#import "CommonFunctions.h"

@interface HomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate> {
    
    AppDelegate *appDelegate;
    
    UIView *welcomeView;
    UIImageView *profileImageView;
    UILabel *welcomeUserLabel;
    UIScrollView *backgroundScrollView;
    UIButton *reportIncidentButton;
    
    NSInteger leftCoulumnIndex,rightColumnIndex;
    float left_yAxis,right_yAxis;
    
    
    UIImageView *cctvImageView,*waterLevelImageView;
    
    UILabel *cctvLocationLabel,*cctvDistanceLabel,*waterSensorLocationLabel,*waterSensorDrainDepthLabel,*drainDepthValueLabel,*quickMapLocationLabel,*quickMapDistanceLabel,*nearbyQuickMapLabel,*floodReasonLabel,*floodTagLabel;
    UIButton *cctvLocationImage,*cctvDistanceImage,*waterSensorLocationImage,*waterSensorDrainDepthImage,*quickMapLocationImage,*quickMapDistanceImage,*quickMapFloodIcon;
    
    UILabel *bigWeatherTempTitle,*smallWeatherTempTitle1,*smallWeatherTempTitle2,*bigTempSubtitle,*smallTempSubtitle1,*smallTempSubtitle2,*bigTimeLabel,*smallTimeLabel1,*smallTimeLabel2;
    UIButton *bigWeatherIcon,*smallWeatherIcon1,*smallWeatherIcon2;
    
    UITableView *eventsListingTable,*whatsUpListingTable;
    NSMutableArray *eventsDataSource,*whatsUpFeedDataSource;
    
    MKMapView *quickMap;
    QuickMapAnnotations *annotation1,*longPressLocationAnnotation;
    
    NSDictionary *twelveHourForecastDictionary;
    BOOL isShowingWeatherModule;
    
    NSMutableArray *eventsDataArray,*feedsDataArray,*wlsDataArray,*cctvDataArray,*floodsDataArray;
    
    BOOL isExpandingMenu;
    
    //*************** Demo App UI Variables
    UIButton *quickMapButton,*whatsUpButton,*cctvButton,*reportButton;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) MKCoordinateRegion region;

@end
