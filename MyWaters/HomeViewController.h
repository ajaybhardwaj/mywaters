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


@interface HomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UIView *welcomeView;
    UIImageView *profileImageView;
    UILabel *welcomeUserLabel;
    UIScrollView *backgroundScrollView;
    UIButton *reportIncidentButton;
    
    NSInteger leftCoulumnIndex,rightColumnIndex;
    float left_yAxis,right_yAxis;
    
    
    UIImageView *cctvImageView,*waterLevelImageView;
    
    UILabel *cctvLocationLabel,*cctvDistanceLabel,*waterSensorLocationLabel,*waterSensorDrainDepthLabel,*quickMapLocationLabel,*quickMapDistanceLabel,*nearbyQuickMapLabel,*floodReasonLabel,*floodTagLabel;
    UIButton *cctvLocationImage,*cctvDistanceImage,*waterSensorLocationImage,*waterSensorDrainDepthImage,*quickMapLocationImage,*quickMapDistanceImage,*quickMapFloodIcon;
    
    UILabel *bigWeatherTempTitle,*smallWeatherTempTitle1,*smallWeatherTempTitle2,*bigTempSubtitle,*smallTempSubtitle1,*smallTempSubtitle2,*bigTimeLabel,*smallTimeLabel1,*smallTimeLabel2;
    UIButton *bigWeatherIcon,*smallWeatherIcon1,*smallWeatherIcon2;
    
    UITableView *eventsListingTable,*whatsUpListingTable;
    NSMutableArray *eventsDataSource,*whatsUpFeedDataSource;
    
    //*************** Demo App UI Variables
    UIButton *quickMapButton,*whatsUpButton,*cctvButton,*reportButton;
}

@end
