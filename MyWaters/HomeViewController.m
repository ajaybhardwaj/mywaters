//
//  HomeViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewControllerHelper.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
        viewObj.isNotQuickMapController = YES;
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (button.tag==2) {
        CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (button.tag==3) {
        WhatsUpViewController *viewObj = [[WhatsUpViewController alloc] init];
        viewObj.isNotWhatsUpController = YES;
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (button.tag==4) {
        FeedbackViewController *viewObj = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
}


//*************** Demo App UI

- (void) createDemoAppControls {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/dashboard.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    quickMapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quickMapButton.tag = 1;
    [quickMapButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quickMapButton];
    
    cctvButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cctvButton.tag = 2;
    [cctvButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cctvButton];
    
    whatsUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    whatsUpButton.tag = 3;
    [whatsUpButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whatsUpButton];
    
    reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reportButton.tag = 4;
    [reportButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportButton];
    
    if (IS_IPHONE_4_OR_LESS) {
        quickMapButton.frame = CGRectMake(10, 75, (self.view.bounds.size.width-30)/2, 105);
        cctvButton.frame = CGRectMake(10, 300, (self.view.bounds.size.width-30)/2, 100);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 75, (self.view.bounds.size.width-30)/2, 210);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 300, (self.view.bounds.size.width-30)/2, 100);
    }
    else if (IS_IPHONE_5) {
        quickMapButton.frame = CGRectMake(10, 90, (self.view.bounds.size.width-30)/2, 125);
        cctvButton.frame = CGRectMake(10, 360, (self.view.bounds.size.width-30)/2, 130);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 90, (self.view.bounds.size.width-30)/2, 260);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 360, (self.view.bounds.size.width-30)/2, 130);
    }
    else if (IS_IPHONE_6) {
        quickMapButton.frame = CGRectMake(10, 110, (self.view.bounds.size.width-30)/2, 145);
        cctvButton.frame = CGRectMake(10, 430, (self.view.bounds.size.width-30)/2, 150);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 110, (self.view.bounds.size.width-30)/2, 305);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 430, (self.view.bounds.size.width-30)/2, 150);
    }
    else if (IS_IPHONE_6P) {
        quickMapButton.frame = CGRectMake(10, 125, (self.view.bounds.size.width-30)/2, 160);
        cctvButton.frame = CGRectMake(10, 480, (self.view.bounds.size.width-30)/2, 165);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 125, (self.view.bounds.size.width-30)/2, 335);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 480, (self.view.bounds.size.width-30)/2, 165);
    }
    
}



//*************** Method To Create Specific Corner Round For Views

- (void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}


//*************** Method To Move To Selected Views

- (void) handleColumnsTouchEvent:(UIButton *) sender {
    
    UIButton *touchedView = (id) sender;
    
    if (touchedView.tag==1) {
        QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
        viewObj.isNotQuickMapController = YES;
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (touchedView.tag==2) {
        WhatsUpViewController *viewObj = [[WhatsUpViewController alloc] init];
        viewObj.isNotWhatsUpController = YES;
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (touchedView.tag==3) {
        EventsViewController *viewObj = [[EventsViewController alloc] init];
        viewObj.isNotEventController = YES;
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (touchedView.tag==4) {
        // Weahter Detail Page
    }
    else if (touchedView.tag==5) {
        CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (touchedView.tag==6) {
        // Water Level Sensors
    }
}



//*************** Method To Move To Report/Feedback View

- (void) moveToFeedbackView {
    
    FeedbackViewController *viewObj = [[FeedbackViewController alloc] init];
    viewObj.isNotFeedbackController = YES;
    [self.navigationController pushViewController:viewObj animated:NO];
    
}



//*************** Method To Create Home Page UI

- (void) createDynamicUIColumns {
    
    for (int i=0; i<appDelegate.DASHBOARD_PREFERENCES_ARRAY.count; i++) {
        
        if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"1"]) {
            
            if (left_yAxis < right_yAxis) {
                
                UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake(10, left_yAxis, (self.view.bounds.size.width-30)/2, [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"height"] floatValue])];
                columnView.backgroundColor = [UIColor whiteColor];
                columnView.layer.cornerRadius = 10;
                [columnView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
                [columnView.layer setShadowOffset:CGSizeMake(2, 2)];
                [columnView.layer setShadowOpacity:1];
                [columnView.layer setShadowRadius:1.0];
                [backgroundScrollView addSubview:columnView];
                
                UILabel *columnViewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnView.bounds.size.width, 20)];
                columnViewHeaderLabel.text = [NSString stringWithFormat:@"   %@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"component"]];
                columnViewHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
                columnViewHeaderLabel.textColor = [UIColor whiteColor];
                columnViewHeaderLabel.backgroundColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                [columnView addSubview:columnViewHeaderLabel];
                
                [self setMaskTo:columnViewHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
                
                left_yAxis = left_yAxis + columnView.bounds.size.height + 10;
                
                
                if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==1) {
                    
                    quickMapLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    quickMapLocationImage.frame = CGRectMake(5, 130, 20, 20);
                    [quickMapLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_pink.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:quickMapLocationImage];
                    quickMapLocationImage.userInteractionEnabled = NO;
                    
                    quickMapDistanceImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    quickMapDistanceImage.frame = CGRectMake(5, 155, 20, 20);
                    [quickMapDistanceImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_distance_pink.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:quickMapDistanceImage];
                    quickMapDistanceImage.userInteractionEnabled = NO;
                    
                    quickMapLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 130, columnView.bounds.size.width-40, 25)];
                    quickMapLocationLabel.text = @"TPE exit towards AYE";
                    quickMapLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    quickMapLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    quickMapLocationLabel.backgroundColor = [UIColor clearColor];
                    quickMapLocationLabel.numberOfLines = 0;
                    [quickMapLocationLabel sizeToFit];
                    [columnView addSubview:quickMapLocationLabel];
                    
                    quickMapDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 155, columnView.bounds.size.width-40, 25)];
                    quickMapDistanceLabel.text = @"2.1 KM";
                    quickMapDistanceLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    quickMapDistanceLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    quickMapDistanceLabel.backgroundColor = [UIColor clearColor];
                    [quickMapDistanceLabel sizeToFit];
                    [columnView addSubview:quickMapDistanceLabel];
                    
                    quickMapFloodIcon = [UIButton buttonWithType:UIButtonTypeCustom];
                    quickMapFloodIcon.frame = CGRectMake(90, 50, 40, 40);
                    [quickMapFloodIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_quickmap_car.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:quickMapFloodIcon];
                    quickMapFloodIcon.userInteractionEnabled = NO;
                    
                    nearbyQuickMapLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, columnView.bounds.size.width-20, 25)];
                    nearbyQuickMapLabel.text = @"Nearby";
                    nearbyQuickMapLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
                    nearbyQuickMapLabel.textColor = [UIColor blackColor];
                    nearbyQuickMapLabel.backgroundColor = [UIColor clearColor];
                    [nearbyQuickMapLabel sizeToFit];
                    [columnView addSubview:nearbyQuickMapLabel];
                    
                    floodTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 50, 40)];
                    floodTagLabel.text = @"01";
                    floodTagLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:40];
                    floodTagLabel.textColor = [UIColor blackColor];
                    floodTagLabel.backgroundColor = [UIColor clearColor];
                    [floodTagLabel sizeToFit];
                    [columnView addSubview:floodTagLabel];
                    
                    floodReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 95, columnView.bounds.size.width-20, 30)];
                    floodReasonLabel.text = @"Lane covered due to flood.";
                    floodReasonLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    floodReasonLabel.textColor = [UIColor blackColor];
                    floodReasonLabel.backgroundColor = [UIColor clearColor];
                    floodReasonLabel.numberOfLines = 0;
                    [columnView addSubview:floodReasonLabel];
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==2) {
                    
                    whatsUpListingTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-5, columnView.bounds.size.height-25) style:UITableViewStylePlain];
                    whatsUpListingTable.delegate = self;
                    whatsUpListingTable.dataSource = self;
                    [columnView addSubview:whatsUpListingTable];
                    whatsUpListingTable.backgroundColor = [UIColor clearColor];
                    whatsUpListingTable.backgroundView = nil;
                    whatsUpListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                    whatsUpListingTable.scrollEnabled = NO;
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==3) {
                    
                    eventsListingTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-5, columnView.bounds.size.height-25) style:UITableViewStylePlain];
                    eventsListingTable.delegate = self;
                    eventsListingTable.dataSource = self;
                    [columnView addSubview:eventsListingTable];
                    eventsListingTable.backgroundColor = [UIColor clearColor];
                    eventsListingTable.backgroundView = nil;
                    eventsListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                    eventsListingTable.scrollEnabled = NO;
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==4) {
                    
                    bigWeatherTempTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 45, 45)];
                    bigWeatherTempTitle.text = @"29";
                    bigWeatherTempTitle.font = [UIFont fontWithName:ROBOTO_BOLD size:40];
                    bigWeatherTempTitle.textColor = [UIColor blackColor];
                    bigWeatherTempTitle.backgroundColor = [UIColor clearColor];
                    [bigWeatherTempTitle sizeToFit];
                    [columnView addSubview:bigWeatherTempTitle];
                    
                    bigTempSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, columnView.bounds.size.width/2, 10)];
                    bigTempSubtitle.text = @"Cloudy";
                    bigTempSubtitle.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
                    bigTempSubtitle.textColor = [UIColor darkGrayColor];
                    bigTempSubtitle.backgroundColor = [UIColor clearColor];
                    bigTempSubtitle.numberOfLines = 0;
                    [columnView addSubview:bigTempSubtitle];
                    
                    smallWeatherTempTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 85, 30, 30)];
                    smallWeatherTempTitle1.text = @"28";
                    smallWeatherTempTitle1.font = [UIFont fontWithName:ROBOTO_BOLD size:24];
                    smallWeatherTempTitle1.textColor = [UIColor blackColor];
                    smallWeatherTempTitle1.backgroundColor = [UIColor clearColor];
                    [smallWeatherTempTitle1 sizeToFit];
                    [columnView addSubview:smallWeatherTempTitle1];
                    
                    smallTempSubtitle1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 112, columnView.bounds.size.width/2, 10)];
                    smallTempSubtitle1.text = @"Cloudy";
                    smallTempSubtitle1.font = [UIFont fontWithName:ROBOTO_REGULAR size:9];
                    smallTempSubtitle1.textColor = [UIColor darkGrayColor];
                    smallTempSubtitle1.backgroundColor = [UIColor clearColor];
                    smallTempSubtitle1.numberOfLines = 0;
                    [columnView addSubview:smallTempSubtitle1];
                    
                    smallWeatherTempTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 30, 30)];
                    smallWeatherTempTitle2.text = @"32";
                    smallWeatherTempTitle2.font = [UIFont fontWithName:ROBOTO_BOLD size:24];
                    smallWeatherTempTitle2.textColor = [UIColor blackColor];
                    smallWeatherTempTitle2.backgroundColor = [UIColor clearColor];
                    [smallWeatherTempTitle2 sizeToFit];
                    [columnView addSubview:smallWeatherTempTitle2];
                    
                    smallTempSubtitle2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 157, columnView.bounds.size.width/2, 10)];
                    smallTempSubtitle2.text = @"Sunny";
                    smallTempSubtitle2.font = [UIFont fontWithName:ROBOTO_REGULAR size:9];
                    smallTempSubtitle2.textColor = [UIColor darkGrayColor];
                    smallTempSubtitle2.backgroundColor = [UIColor clearColor];
                    smallTempSubtitle2.numberOfLines = 0;
                    [columnView addSubview:smallTempSubtitle2];
                    
                    
                    
                    bigWeatherIcon = [UIButton buttonWithType:UIButtonTypeCustom];
                    bigWeatherIcon.frame = CGRectMake(90, 25, 40, 40);
                    [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_weather_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:bigWeatherIcon];
                    bigWeatherIcon.userInteractionEnabled = NO;
                    
                    bigTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 62, columnView.bounds.size.width/2, 10)];
                    bigTimeLabel.text = @"02:13 AM";
                    bigTimeLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
                    bigTimeLabel.textColor = [UIColor blackColor];
                    bigTimeLabel.backgroundColor = [UIColor clearColor];
                    bigTimeLabel.numberOfLines = 0;
                    [columnView addSubview:bigTimeLabel];
                    
                    smallWeatherIcon1 = [UIButton buttonWithType:UIButtonTypeCustom];
                    smallWeatherIcon1.frame = CGRectMake(90, 80, 28, 28);
                    [smallWeatherIcon1 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_weather_small.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:smallWeatherIcon1];
                    smallWeatherIcon1.userInteractionEnabled = NO;
                    
                    smallTimeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 108, columnView.bounds.size.width/2, 10)];
                    smallTimeLabel1.text = @"05:18 PM";
                    smallTimeLabel1.font = [UIFont fontWithName:ROBOTO_REGULAR size:9];
                    smallTimeLabel1.textColor = [UIColor blackColor];
                    smallTimeLabel1.backgroundColor = [UIColor clearColor];
                    smallTimeLabel1.numberOfLines = 0;
                    [columnView addSubview:smallTimeLabel1];
                    
                    smallWeatherIcon2 = [UIButton buttonWithType:UIButtonTypeCustom];
                    smallWeatherIcon2.frame = CGRectMake(90, 130, 28, 28);
                    [smallWeatherIcon2 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_sunny_small.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:smallWeatherIcon2];
                    smallWeatherIcon2.userInteractionEnabled = NO;
                    
                    smallTimeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 158, columnView.bounds.size.width/2, 10)];
                    smallTimeLabel2.text = @"08:05 PM";
                    smallTimeLabel2.font = [UIFont fontWithName:ROBOTO_REGULAR size:9];
                    smallTimeLabel2.textColor = [UIColor blackColor];
                    smallTimeLabel2.backgroundColor = [UIColor clearColor];
                    smallTimeLabel2.numberOfLines = 0;
                    [columnView addSubview:smallTimeLabel2];
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==5) {
                    
                    cctvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 20, columnView.bounds.size.width+1, 78)];
                    [cctvImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/cctv_dummy.png",appDelegate.RESOURCE_FOLDER_PATH]]];
                    [columnView addSubview:cctvImageView];
                    
                    cctvLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    cctvLocationImage.frame = CGRectMake(5, 100, 20, 20);
                    [cctvLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_turqoise.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:cctvLocationImage];
                    cctvLocationImage.userInteractionEnabled = NO;
                    
                    cctvDistanceImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    cctvDistanceImage.frame = CGRectMake(5, 125, 20, 20);
                    [cctvDistanceImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_distance_turqoise.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:cctvDistanceImage];
                    cctvDistanceImage.userInteractionEnabled = NO;
                    
                    cctvLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, columnView.bounds.size.width-40, 25)];
                    cctvLocationLabel.text = @"Mandalay Road";
                    cctvLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    cctvLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    cctvLocationLabel.backgroundColor = [UIColor clearColor];
                    cctvLocationLabel.numberOfLines = 0;
                    [cctvLocationLabel sizeToFit];
                    [columnView addSubview:cctvLocationLabel];
                    
                    cctvDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, columnView.bounds.size.width-40, 25)];
                    cctvDistanceLabel.text = @"3.1 KM";
                    cctvDistanceLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    cctvDistanceLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    cctvDistanceLabel.backgroundColor = [UIColor clearColor];
                    [cctvDistanceLabel sizeToFit];
                    [columnView addSubview:cctvDistanceLabel];
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==6) {
                    
                    waterLevelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 20, columnView.bounds.size.width+1, 78)];
                    [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/water_level_dummy.png",appDelegate.RESOURCE_FOLDER_PATH]]];
                    [columnView addSubview:waterLevelImageView];
                    
                    waterSensorLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    waterSensorLocationImage.frame = CGRectMake(5, 100, 20, 20);
                    [waterSensorLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_blue.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:waterSensorLocationImage];
                    waterSensorLocationImage.userInteractionEnabled = NO;
                    
                    waterSensorDrainDepthImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    waterSensorDrainDepthImage.frame = CGRectMake(5, 125, 20, 20);
                    [waterSensorDrainDepthImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:waterSensorDrainDepthImage];
                    waterSensorDrainDepthImage.userInteractionEnabled = NO;
                    
                    waterSensorLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, columnView.bounds.size.width-40, 25)];
                    waterSensorLocationLabel.text = @"Mandalay Road";
                    waterSensorLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    waterSensorLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    waterSensorLocationLabel.backgroundColor = [UIColor clearColor];
                    waterSensorLocationLabel.numberOfLines = 0;
                    [waterSensorLocationLabel sizeToFit];
                    [columnView addSubview:waterSensorLocationLabel];
                    
                    waterSensorDrainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, columnView.bounds.size.width-40, 25)];
                    waterSensorDrainDepthLabel.text = @"3.1 KM";
                    waterSensorDrainDepthLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    waterSensorDrainDepthLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    waterSensorDrainDepthLabel.backgroundColor = [UIColor clearColor];
                    [waterSensorDrainDepthLabel sizeToFit];
                    [columnView addSubview:waterSensorDrainDepthLabel];
                }
                
                
                if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==2 || [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==3) {
                    NSLog(@"Dont do anything");
                }
                else {
                    
                    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    overlayButton.frame = CGRectMake(0, 0, columnView.bounds.size.width, columnView.bounds.size.height);
                    overlayButton.tag = [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue];
                    [overlayButton addTarget:self action:@selector(handleColumnsTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
                    [columnView addSubview:overlayButton];
                }
            }
            else {
                
                UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)+5, right_yAxis, (self.view.bounds.size.width-30)/2, [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"height"] floatValue])];
                columnView.backgroundColor = [UIColor whiteColor];
                columnView.layer.cornerRadius = 10;
                [columnView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
                [columnView.layer setShadowOffset:CGSizeMake(2, 2)];
                [columnView.layer setShadowOpacity:1];
                [columnView.layer setShadowRadius:1.0];
                [backgroundScrollView addSubview:columnView];
                
                UILabel *columnViewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnView.bounds.size.width, 20)];
                columnViewHeaderLabel.text = [NSString stringWithFormat:@"   %@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"component"]];
                columnViewHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
                columnViewHeaderLabel.textColor = [UIColor whiteColor];
                columnViewHeaderLabel.backgroundColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                [columnView addSubview:columnViewHeaderLabel];
                
                [self setMaskTo:columnViewHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
                
                right_yAxis = right_yAxis + columnView.bounds.size.height + 10;
                
                
                if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==1) {
                    
                    quickMapLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    quickMapLocationImage.frame = CGRectMake(5, 130, 20, 20);
                    [quickMapLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_pink.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:quickMapLocationImage];
                    quickMapLocationImage.userInteractionEnabled = NO;
                    
                    quickMapDistanceImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    quickMapDistanceImage.frame = CGRectMake(5, 155, 20, 20);
                    [quickMapDistanceImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_distance_pink.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:quickMapDistanceImage];
                    quickMapDistanceImage.userInteractionEnabled = NO;
                    
                    quickMapLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 130, columnView.bounds.size.width-40, 25)];
                    quickMapLocationLabel.text = @"TPE exit towards AYE";
                    quickMapLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    quickMapLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    quickMapLocationLabel.backgroundColor = [UIColor clearColor];
                    quickMapLocationLabel.numberOfLines = 0;
                    [quickMapLocationLabel sizeToFit];
                    [columnView addSubview:quickMapLocationLabel];
                    
                    quickMapDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 155, columnView.bounds.size.width-40, 25)];
                    quickMapDistanceLabel.text = @"2.1 KM";
                    quickMapDistanceLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    quickMapDistanceLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    quickMapDistanceLabel.backgroundColor = [UIColor clearColor];
                    [quickMapDistanceLabel sizeToFit];
                    [columnView addSubview:quickMapDistanceLabel];
                    
                    quickMapFloodIcon = [UIButton buttonWithType:UIButtonTypeCustom];
                    quickMapFloodIcon.frame = CGRectMake(90, 50, 40, 40);
                    [quickMapFloodIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_quickmap_car.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:quickMapFloodIcon];
                    quickMapFloodIcon.userInteractionEnabled = NO;
                    
                    nearbyQuickMapLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, columnView.bounds.size.width-20, 25)];
                    nearbyQuickMapLabel.text = @"Nearby";
                    nearbyQuickMapLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
                    nearbyQuickMapLabel.textColor = [UIColor blackColor];
                    nearbyQuickMapLabel.backgroundColor = [UIColor clearColor];
                    [nearbyQuickMapLabel sizeToFit];
                    [columnView addSubview:nearbyQuickMapLabel];
                    
                    floodTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 50, 40)];
                    floodTagLabel.text = @"01";
                    floodTagLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:40];
                    floodTagLabel.textColor = [UIColor blackColor];
                    floodTagLabel.backgroundColor = [UIColor clearColor];
                    [floodTagLabel sizeToFit];
                    [columnView addSubview:floodTagLabel];
                    
                    floodReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 95, columnView.bounds.size.width-20, 30)];
                    floodReasonLabel.text = @"Lane covered due to flood.";
                    floodReasonLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    floodReasonLabel.textColor = [UIColor blackColor];
                    floodReasonLabel.backgroundColor = [UIColor clearColor];
                    floodReasonLabel.numberOfLines = 0;
                    [columnView addSubview:floodReasonLabel];
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==2) {
                    
                    whatsUpListingTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-5, columnView.bounds.size.height-25) style:UITableViewStylePlain];
                    whatsUpListingTable.delegate = self;
                    whatsUpListingTable.dataSource = self;
                    [columnView addSubview:whatsUpListingTable];
                    whatsUpListingTable.backgroundColor = [UIColor clearColor];
                    whatsUpListingTable.backgroundView = nil;
                    whatsUpListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                    whatsUpListingTable.scrollEnabled = NO;
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==3) {
                    
                    eventsListingTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 20, columnView.bounds.size.width-5, columnView.bounds.size.height-25) style:UITableViewStylePlain];
                    eventsListingTable.delegate = self;
                    eventsListingTable.dataSource = self;
                    [columnView addSubview:eventsListingTable];
                    eventsListingTable.backgroundColor = [UIColor clearColor];
                    eventsListingTable.backgroundView = nil;
                    eventsListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                    eventsListingTable.scrollEnabled = NO;

                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==4) {
                    
                    bigWeatherTempTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 45, 45)];
                    bigWeatherTempTitle.text = @"29";
                    bigWeatherTempTitle.font = [UIFont fontWithName:ROBOTO_BOLD size:40];
                    bigWeatherTempTitle.textColor = [UIColor blackColor];
                    bigWeatherTempTitle.backgroundColor = [UIColor clearColor];
                    [bigWeatherTempTitle sizeToFit];
                    [columnView addSubview:bigWeatherTempTitle];
                    
                    bigTempSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, columnView.bounds.size.width/2, 10)];
                    bigTempSubtitle.text = @"Cloudy";
                    bigTempSubtitle.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
                    bigTempSubtitle.textColor = [UIColor darkGrayColor];
                    bigTempSubtitle.backgroundColor = [UIColor clearColor];
                    bigTempSubtitle.numberOfLines = 0;
                    [columnView addSubview:bigTempSubtitle];
                    
                    smallWeatherTempTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 85, 30, 30)];
                    smallWeatherTempTitle1.text = @"28";
                    smallWeatherTempTitle1.font = [UIFont fontWithName:ROBOTO_BOLD size:24];
                    smallWeatherTempTitle1.textColor = [UIColor blackColor];
                    smallWeatherTempTitle1.backgroundColor = [UIColor clearColor];
                    [smallWeatherTempTitle1 sizeToFit];
                    [columnView addSubview:smallWeatherTempTitle1];
                    
                    smallTempSubtitle1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 112, columnView.bounds.size.width/2, 10)];
                    smallTempSubtitle1.text = @"Cloudy";
                    smallTempSubtitle1.font = [UIFont fontWithName:ROBOTO_REGULAR size:9];
                    smallTempSubtitle1.textColor = [UIColor darkGrayColor];
                    smallTempSubtitle1.backgroundColor = [UIColor clearColor];
                    smallTempSubtitle1.numberOfLines = 0;
                    [columnView addSubview:smallTempSubtitle1];
                    
                    smallWeatherTempTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 30, 30)];
                    smallWeatherTempTitle2.text = @"32";
                    smallWeatherTempTitle2.font = [UIFont fontWithName:ROBOTO_BOLD size:24];
                    smallWeatherTempTitle2.textColor = [UIColor blackColor];
                    smallWeatherTempTitle2.backgroundColor = [UIColor clearColor];
                    [smallWeatherTempTitle2 sizeToFit];
                    [columnView addSubview:smallWeatherTempTitle2];
                    
                    smallTempSubtitle2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 157, columnView.bounds.size.width/2, 10)];
                    smallTempSubtitle2.text = @"Sunny";
                    smallTempSubtitle2.font = [UIFont fontWithName:ROBOTO_REGULAR size:9];
                    smallTempSubtitle2.textColor = [UIColor darkGrayColor];
                    smallTempSubtitle2.backgroundColor = [UIColor clearColor];
                    smallTempSubtitle2.numberOfLines = 0;
                    [columnView addSubview:smallTempSubtitle2];
                    
                    
                    
                    bigWeatherIcon = [UIButton buttonWithType:UIButtonTypeCustom];
                    bigWeatherIcon.frame = CGRectMake(90, 25, 40, 40);
                    [bigWeatherIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_weather_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:bigWeatherIcon];
                    bigWeatherIcon.userInteractionEnabled = NO;
                    
                    bigTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 62, columnView.bounds.size.width/2, 10)];
                    bigTimeLabel.text = @"02:13 AM";
                    bigTimeLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
                    bigTimeLabel.textColor = [UIColor blackColor];
                    bigTimeLabel.backgroundColor = [UIColor clearColor];
                    bigTimeLabel.numberOfLines = 0;
                    [columnView addSubview:bigTimeLabel];
                    
                    smallWeatherIcon1 = [UIButton buttonWithType:UIButtonTypeCustom];
                    smallWeatherIcon1.frame = CGRectMake(90, 80, 28, 28);
                    [smallWeatherIcon1 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_weather_small.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:smallWeatherIcon1];
                    smallWeatherIcon1.userInteractionEnabled = NO;
                    
                    smallTimeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 108, columnView.bounds.size.width/2, 10)];
                    smallTimeLabel1.text = @"05:18 PM";
                    smallTimeLabel1.font = [UIFont fontWithName:ROBOTO_REGULAR size:9];
                    smallTimeLabel1.textColor = [UIColor blackColor];
                    smallTimeLabel1.backgroundColor = [UIColor clearColor];
                    smallTimeLabel1.numberOfLines = 0;
                    [columnView addSubview:smallTimeLabel1];
                    
                    smallWeatherIcon2 = [UIButton buttonWithType:UIButtonTypeCustom];
                    smallWeatherIcon2.frame = CGRectMake(90, 130, 28, 28);
                    [smallWeatherIcon2 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_sunny_small.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:smallWeatherIcon2];
                    smallWeatherIcon2.userInteractionEnabled = NO;
                    
                    smallTimeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 158, columnView.bounds.size.width/2, 10)];
                    smallTimeLabel2.text = @"08:05 PM";
                    smallTimeLabel2.font = [UIFont fontWithName:ROBOTO_REGULAR size:9];
                    smallTimeLabel2.textColor = [UIColor blackColor];
                    smallTimeLabel2.backgroundColor = [UIColor clearColor];
                    smallTimeLabel2.numberOfLines = 0;
                    [columnView addSubview:smallTimeLabel2];
                    
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==5) {
                    
                    cctvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 20, columnView.bounds.size.width+1, 78)];
                    [cctvImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/cctv_dummy.png",appDelegate.RESOURCE_FOLDER_PATH]]];
                    [columnView addSubview:cctvImageView];
                    
                    cctvLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    cctvLocationImage.frame = CGRectMake(5, 100, 20, 20);
                    [cctvLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_turqoise.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:cctvLocationImage];
                    
                    cctvDistanceImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    cctvDistanceImage.frame = CGRectMake(5, 125, 20, 20);
                    [cctvDistanceImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_distance_turqoise.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:cctvDistanceImage];
                    
                    cctvLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, columnView.bounds.size.width-40, 25)];
                    cctvLocationLabel.text = @"Mandalay Road";
                    cctvLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    cctvLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    cctvLocationLabel.backgroundColor = [UIColor clearColor];
                    cctvLocationLabel.numberOfLines = 0;
                    [cctvLocationLabel sizeToFit];
                    [columnView addSubview:cctvLocationLabel];
                    
                    cctvDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, columnView.bounds.size.width-40, 25)];
                    cctvDistanceLabel.text = @"3.1 KM";
                    cctvDistanceLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    cctvDistanceLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    cctvDistanceLabel.backgroundColor = [UIColor clearColor];
                    [cctvDistanceLabel sizeToFit];
                    [columnView addSubview:cctvDistanceLabel];
                }
                else if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==6) {
                    
                    waterLevelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 20, columnView.bounds.size.width+1, 78)];
                    [waterLevelImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/water_level_dummy.png",appDelegate.RESOURCE_FOLDER_PATH]]];
                    [columnView addSubview:waterLevelImageView];
                    
                    waterSensorLocationImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    waterSensorLocationImage.frame = CGRectMake(5, 100, 20, 20);
                    [waterSensorLocationImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location_blue.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:waterSensorLocationImage];
                    
                    waterSensorDrainDepthImage = [UIButton buttonWithType:UIButtonTypeCustom];
                    waterSensorDrainDepthImage.frame = CGRectMake(5, 125, 20, 20);
                    [waterSensorDrainDepthImage setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
                    [columnView addSubview:waterSensorDrainDepthImage];
                    
                    waterSensorLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, columnView.bounds.size.width-40, 25)];
                    waterSensorLocationLabel.text = @"Bukit Timah Road";
                    waterSensorLocationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    waterSensorLocationLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    waterSensorLocationLabel.backgroundColor = [UIColor clearColor];
                    waterSensorLocationLabel.numberOfLines = 0;
                    [waterSensorLocationLabel sizeToFit];
                    [columnView addSubview:waterSensorLocationLabel];
                    
                    waterSensorDrainDepthLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, columnView.bounds.size.width-40, 25)];
                    waterSensorDrainDepthLabel.text = @"Drain Depth (1m)";
                    waterSensorDrainDepthLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
                    waterSensorDrainDepthLabel.textColor = [UIColor colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                    waterSensorDrainDepthLabel.backgroundColor = [UIColor clearColor];
                    [waterSensorDrainDepthLabel sizeToFit];
                    [columnView addSubview:waterSensorDrainDepthLabel];
                }
                
                NSLog(@"%d",[[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]);
                
                if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==2 || [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue]==3) {
                    NSLog(@"Dont do anything");
                }
                else {
                    
                    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    overlayButton.frame = CGRectMake(0, 0, columnView.bounds.size.width, columnView.bounds.size.height);
                    overlayButton.tag = [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue];
                    [overlayButton addTarget:self action:@selector(handleColumnsTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
                    [columnView addSubview:overlayButton];
                }
            }
        }
    }
    
    if (right_yAxis > left_yAxis) {
        backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, right_yAxis+80);
    }
    else {
        backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, left_yAxis+80);
    }
    
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (tableView==whatsUpListingTable) {
        return whatsUpFeedDataSource.count;
    }
    else if (tableView==eventsListingTable) {
        return eventsDataSource.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    //    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11.0];
    //    cell.detailTextLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:9.0];
    //
    //    cell.textLabel.numberOfLines = 0;
    //    cell.detailTextLabel.numberOfLines = 0;
    //    cell.textLabel.textColor = RGB(245, 193, 12);
    
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
    [cell.contentView addSubview:cellImageView];
    
    UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, cell.bounds.size.width-60, 25)];
    cellTitleLabel.backgroundColor = [UIColor clearColor];
    cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11.0];
    cellTitleLabel.numberOfLines = 0;
    cellTitleLabel.textColor = RGB(245, 193, 12);
    [cell.contentView addSubview:cellTitleLabel];
    
    UILabel *cellSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 31, cell.bounds.size.width-60, 20)];
    cellSubTitleLabel.backgroundColor = [UIColor clearColor];
    cellSubTitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:9.0];
    cellSubTitleLabel.numberOfLines = 0;
    [cell.contentView addSubview:cellSubTitleLabel];
    
    
    if (tableView==whatsUpListingTable) {
        
        cellImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/e%ld.png",appDelegate.RESOURCE_FOLDER_PATH,indexPath.row+1]];
        cellTitleLabel.text = [[whatsUpFeedDataSource objectAtIndex:indexPath.row] objectForKey:@"Title"];
        cellSubTitleLabel.text = [[whatsUpFeedDataSource objectAtIndex:indexPath.row] objectForKey:@"Subtitle"];
    }
    else if (tableView==eventsListingTable) {
        
        cellImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/w%ld.png",appDelegate.RESOURCE_FOLDER_PATH,indexPath.row+1]];
        cellTitleLabel.text = [[eventsDataSource objectAtIndex:indexPath.row] objectForKey:@"Title"];
        cellSubTitleLabel.text = [[eventsDataSource objectAtIndex:indexPath.row] objectForKey:@"Date"];
        
    }
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54.6, cell.bounds.size.width, 0.4)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    return cell;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(245, 245, 245);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundScrollView.showsHorizontalScrollIndicator = NO;
    backgroundScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backgroundScrollView];
    backgroundScrollView.backgroundColor = [UIColor clearColor];
    backgroundScrollView.userInteractionEnabled = YES;
    
    whatsUpFeedDataSource = [[NSMutableArray alloc] init];
    eventsDataSource = [[NSMutableArray alloc] init];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    
    self.view.alpha = 1.0;
    if (appDelegate.IS_COMING_AFTER_LOGIN) {
        appDelegate.IS_COMING_AFTER_LOGIN = NO;
        self.view.alpha = 0.5;
    }
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    self.title = @"Home";
    
    
    for (UIView * view in backgroundScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    welcomeView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 110)];
    welcomeView.backgroundColor = [UIColor whiteColor];
    welcomeView.layer.cornerRadius = 10;
    [welcomeView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [welcomeView.layer setShadowOffset:CGSizeMake(2, 2)];
    [welcomeView.layer setShadowOpacity:1];
    [welcomeView.layer setShadowRadius:1.0];
    [backgroundScrollView addSubview:welcomeView];
    
    UILabel *welcomeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, welcomeView.bounds.size.width, 20)];
    welcomeHeaderLabel.text = @"   Welcome!";
    welcomeHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
    welcomeHeaderLabel.textColor = [UIColor whiteColor];
    welcomeHeaderLabel.backgroundColor = RGB(67, 79, 93);
    [welcomeView addSubview:welcomeHeaderLabel];
    
    [self setMaskTo:welcomeHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 70, 70)];
    profileImageView.layer.cornerRadius = 35;
    profileImageView.layer.masksToBounds = YES;
    [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_avatar_image.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [welcomeView addSubview:profileImageView];
    
    
    welcomeUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, welcomeView.bounds.size.width-110, 70)];
    welcomeUserLabel.text = @"";
    welcomeUserLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
    welcomeUserLabel.textColor = [UIColor blackColor];
    welcomeUserLabel.backgroundColor = [UIColor clearColor];
    welcomeUserLabel.numberOfLines = 0;
    [welcomeView addSubview:welcomeUserLabel];
    
    
    reportIncidentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reportIncidentButton.frame = CGRectMake(10, welcomeView.frame.origin.y + welcomeView.bounds.size.height + 10, self.view.bounds.size.width-20, 40);
    [reportIncidentButton setBackgroundColor:RGB(242, 47, 56)];
    [reportIncidentButton setTitle:@"Report Incident" forState:UIControlStateNormal];
    reportIncidentButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [reportIncidentButton setTintColor:[UIColor whiteColor]];
    reportIncidentButton.layer.cornerRadius = 10;
    [reportIncidentButton.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [reportIncidentButton.layer setShadowOffset:CGSizeMake(2, 2)];
    [reportIncidentButton.layer setShadowOpacity:1];
    [reportIncidentButton.layer setShadowRadius:1.0];
    [reportIncidentButton addTarget:self action:@selector(moveToFeedbackView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:reportIncidentButton];
    
    
    UIImageView *reportIncidentImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 2, 36, 36)];
    [reportIncidentImage setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_report.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [reportIncidentButton addSubview:reportIncidentImage];
    
    
    left_yAxis = reportIncidentButton.frame.origin.y + reportIncidentButton.bounds.size.height + 10;
    right_yAxis = reportIncidentButton.frame.origin.y + reportIncidentButton.bounds.size.height + 10.1;
    
    [self createDynamicUIColumns];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    
    if (hour < 12) {
        welcomeUserLabel.text = [NSString stringWithFormat:@"Good Morning, %@",appDelegate.LOGGED_IN_USER_NAME];
    }
    else if (hour >= 12 && hour <= 16) {
        welcomeUserLabel.text = [NSString stringWithFormat:@"Good Afternoon, %@",appDelegate.LOGGED_IN_USER_NAME];
    }
    else if (hour > 16) {
        welcomeUserLabel.text = [NSString stringWithFormat:@"Good Evening, %@",appDelegate.LOGGED_IN_USER_NAME];
    }
    
    
    // Temp DataSoruce Code
    
    NSDate *todayDate = [NSDate date];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    if (whatsUpFeedDataSource.count==0) {
        for (int i=0; i<5; i++) {
            NSDictionary *dictEvents = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",i+1],[NSString stringWithFormat:@"Feed Title %d",i+1],[NSString stringWithFormat:@"Feed Sub-Title %d",i+1],nil] forKeys:[NSArray arrayWithObjects:@"id",@"Title",@"Subtitle", nil]];
            [whatsUpFeedDataSource addObject:dictEvents];
        }
    }
    
    if (eventsDataSource.count==0) {
        for (int i=0; i<5; i++) {
            NSDate *newDate = [todayDate dateByAddingTimeInterval:60*60*24*(i+1)];
            NSString *newDateString = [dateFormatter stringFromDate:newDate];
            
            NSDictionary *dictWhatsUp = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",i+1],[NSString stringWithFormat:@"Event Title %d",i+1],newDateString,nil] forKeys:[NSArray arrayWithObjects:@"id",@"Title",@"Date", nil]];
            [eventsDataSource addObject:dictWhatsUp];
        }
    }
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
