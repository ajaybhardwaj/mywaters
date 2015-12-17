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
#import "ABCWaterDetailViewController.h"
#import "TipsListingViewController.h"
#import "FloodMapAnnotations.h"
#import "WLSMapAnnotations.h"

@interface HomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate> {
    
    AppDelegate *appDelegate;
    
    UIView *welcomeView,*notificationView;
    UIImageView *profileImageView,*notificationIconImageView;
    UILabel *welcomeUserLabel,*notificationLabel,*badgeLabel,*welcomeHeaderLabel,*notificationMessageLabel;
    UIScrollView *backgroundScrollView;
    UIButton *reportIncidentButton;
    
    NSInteger leftCoulumnIndex,rightColumnIndex;
    float left_yAxis,right_yAxis;
    
    
    UIImageView *cctvImageView,*waterLevelImageView,*abcWatersImageView,*abcCertifiedLogo;
    
    UILabel *cctvLocationLabel,*cctvDistanceLabel,*waterSensorLocationLabel,*waterSensorDrainDepthLabel,*drainDepthValueLabel,*quickMapLocationLabel,*quickMapDistanceLabel,*nearbyQuickMapLabel,*floodReasonLabel,*floodTagLabel;
    UIButton *cctvLocationImage,*cctvDistanceImage,*waterSensorLocationImage,*waterSensorDrainDepthImage,*quickMapLocationImage,*quickMapDistanceImage,*quickMapFloodIcon;
    
    UILabel *abcWatersNameLabel,*abcWatersDistanceLabel;
    UIButton *abcWatersDistanceImage,*abcWatersLocationImage;
    
    UILabel *bigWeatherTempTitle,*smallWeatherTempTitle1,*smallWeatherTempTitle2,*bigTempSubtitle,*smallTempSubtitle1,*smallTempSubtitle2,*bigTimeLabel,*smallTimeLabel1,*smallTimeLabel2;
    UIButton *bigWeatherIcon,*smallWeatherIcon1,*smallWeatherIcon2;
    UILabel *noWeatherDataLabel;
    
    UITableView *eventsListingTable,*whatsUpListingTable;
    NSMutableArray *eventsDataSource,*whatsUpFeedDataSource;
    
    UILabel *noCCTVDataLabel;
    
    MKMapView *quickMap;
    QuickMapAnnotations *annotation1,*longPressLocationAnnotation;
    
    NSDictionary *twelveHourForecastDictionary;
    BOOL isShowingWeatherModule;
    
    NSMutableArray *eventsDataArray,*feedsDataArray,*wlsDataArray,*cctvDataArray,*floodsDataArray,*tipsDataArray,*abcWatersDataArray;
    
    BOOL isExpandingMenu;
    
    NSString *nowcastTimeString,*nowcastDateString;
    NSDictionary *nowCastWeatherData;
    
    
    FloodMapAnnotations *pubFloodAnnotation;
    WLSMapAnnotations *wlsAnnotation;
    NSMutableArray *pubFloodAnnotationsArray,*wlsAnnotationsArray;
    
    
    UIView *customDefaultLocationView;
    MKMapView *defaultLocationMapView;
    BOOL isDefaultLocationSelected;
    
    //*************** Demo App UI Variables
    UIButton *quickMapButton,*whatsUpButton,*cctvButton,*reportButton;
    
    UIWebView *tipsWebView;
    UILabel *tipsVideoTitleLabel;
    UIImageView *videoThumbnailView;
    
    
    
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) MKCoordinateRegion region;

@end
