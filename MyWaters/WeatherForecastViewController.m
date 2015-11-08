//
//  WeatherForecastViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 2/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WeatherForecastViewController.h"

@interface WeatherForecastViewController ()

@end

@implementation WeatherForecastViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//*************** Method To Get Nowcast Weather XML Data

- (void) getThreeDaysWeatherData {
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:THREE_DAYS_FORECAST] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10
                                    ];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *responseString  = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLString:responseString];
    
    threeDayWeatherData = [[[xmlDictionary objectForKey:@"channel"] objectForKey:@"item"] valueForKey:@"weatherForecast"];
    
    //    DebugLog(@"%ld",nowCastWeatherData.count);
    DebugLog(@"%@",threeDayWeatherData);
    
    NSArray *dayArray = [threeDayWeatherData objectForKey:@"day"];
    threeDayFirstDateLabel.text = [dayArray objectAtIndex:0];
    threeDaySecondDateLabel.text = [dayArray objectAtIndex:1];
    threeDayThirdDateLabel.text = [dayArray objectAtIndex:2];
    
    NSArray *tempArray = [threeDayWeatherData objectForKey:@"temperature"];
    threeDayFirstTempLabel.text = [NSString stringWithFormat:@"%@°C/%@°C",[[tempArray objectAtIndex:0] objectForKey:@"_high"],[[tempArray objectAtIndex:0] objectForKey:@"_low"]];
    threeDaySecondTempLabel.text = [NSString stringWithFormat:@"%@°C/%@°C",[[tempArray objectAtIndex:1] objectForKey:@"_high"],[[tempArray objectAtIndex:0] objectForKey:@"_low"]];
    threeDayThirdTempLabel.text = [NSString stringWithFormat:@"%@°C/%@°C",[[tempArray objectAtIndex:2] objectForKey:@"_high"],[[tempArray objectAtIndex:0] objectForKey:@"_low"]];
    
    NSArray *iconArray = [threeDayWeatherData objectForKey:@"icon"];
    NSString *iconImageName;
    for (int i=0; i<3; i++) {
        if ([[iconArray objectAtIndex:i] isEqualToString:@"FD"]) {
            iconImageName = @"FD.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"FN"]) {
            iconImageName = @"FN.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"PC"]) {
            iconImageName = @"PC.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"CD"]) {
            iconImageName = @"CD.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"HZ"]) {
            // Add Image For Hazy
            iconImageName = @"HZ.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"WD"]) {
            // Add image for windy
            iconImageName = @"WD.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"RA"]) {
            iconImageName = @"RA.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"PS"]) {
            // Add image for passing showers
            iconImageName = @"PS.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"SH"]) {
            iconImageName = @"SH.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"TS"]) {
            iconImageName = @"TS.png";
        }
        
        if (i==0) {
            [threeDayFirstIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,iconImageName]]];
        }
        else if (i==1) {
            [threeDaySecondIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,iconImageName]]];
        }
        else if (i==2) {
            [threeDayThirdIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,iconImageName]]];
        }
    }
}


//*************** Method To Get Nowcast Weather XML Data

- (void) getTwelveHourWeatherData {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TWELVE_HOUR_FORECAST] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *responseString  = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLString:responseString];
    
    twelveHourWeatherData = [[xmlDictionary objectForKey:@"channel"] objectForKey:@"item"];
    
    NSString *issueDate = [CommonFunctions dateFromString:[[twelveHourWeatherData objectForKey:@"forecastIssue"] objectForKey:@"_date"]];
//    threeHourDateTimeLabel.text = [NSString stringWithFormat:@"%@ @ %@",issueDate,[[twelveHourWeatherData objectForKey:@"forecastIssue"] objectForKey:@"_time"]];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSString *iconImageName;
        
        if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"FD"]) {
            iconImageName = @"FD.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"FN"]) {
            iconImageName = @"FN.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"PC"]) {
            iconImageName = @"PC.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"CD"]) {
            iconImageName = @"CD.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"HZ"]) {
            iconImageName = @"HZ.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"WD"]) {
            iconImageName = @"WD.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"RA"]) {
            iconImageName = @"RA.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"PS"]) {
            iconImageName = @"PS.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"SH"]) {
            iconImageName = @"SH.png";
        }
        else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"TS"]) {
            iconImageName = @"TS.png";
        }
        [threeHourBigIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,iconImageName]]];
        threeHourDateTimeLabel.text = [NSString stringWithFormat:@"%@ @ %@",issueDate,[[twelveHourWeatherData objectForKey:@"forecastIssue"] objectForKey:@"_time"]];

    }
    
    twelveHourTempLabel.text = [NSString stringWithFormat:@"%@°C",[[twelveHourWeatherData objectForKey:@"temperature"] objectForKey:@"_high"]];
    
    [self getThreeDaysWeatherData];
}



//*************** Method To Get Nowcast Weather XML Data

- (void) getNowcastWeatherData {
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:NOWCAST_WEATHER_URL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10
                                    ];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *responseString  = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLString:responseString];
    nowCastWeatherData = [[[[xmlDictionary objectForKey:@"channel"] objectForKey:@"item"] valueForKey:@"weatherForecast"] valueForKey:@"area"];
    nowcastTimeString = [[[xmlDictionary objectForKey:@"channel"] objectForKey:@"item"] valueForKey:@"issue_datentime"];
    
    NSString *match = @"at ";
    NSString *preString,*postString;
    
    NSScanner *scanner = [NSScanner scannerWithString:nowcastTimeString];
    [scanner scanUpToString:match intoString:&preString];
    [scanner scanString:match intoString:nil];
    postString = [nowcastTimeString substringFromIndex:scanner.scanLocation];
    
    nowcastTimeString = [postString substringToIndex:8];
    nowcastDateString = [postString substringWithRange:NSMakeRange(12, 10)];
    
    NSString *issueDate = [CommonFunctions dateFromString:nowcastDateString];
    threeHourDateTimeLabel.text = [NSString stringWithFormat:@"%@ @ %@",issueDate,nowcastTimeString];
    
    
    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tempDict in nowCastWeatherData) {
        
        [tempArray addObject:tempDict];
    }
    
    
    for (int idx = 0; idx<[tempArray count];idx++) {
        
        NSMutableDictionary *dict = [tempArray[idx] mutableCopy];
        
        CLLocationCoordinate2D desinationLocation;
        desinationLocation.latitude = [dict[@"_lat"] doubleValue];
        desinationLocation.longitude = [dict[@"_lon"] doubleValue];
        
        dict[@"distance"] = [CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation];
        tempArray[idx] = dict;
        
    }
    
    
    NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES comparator:^(id left, id right) {
        float v1 = [left floatValue];
        float v2 = [right floatValue];
        if (v1 < v2)
            return NSOrderedAscending;
        else if (v1 > v2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
    [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,nil]];
    
    DebugLog(@"%@",tempArray);
    
    NSString *iconImageName;
    
    if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"FD"]) {
        iconImageName = @"FD.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"FN"]) {
        iconImageName = @"FN.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"PC"]) {
        iconImageName = @"PC.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"CD"]) {
        iconImageName = @"CD.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"HA"] || [[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"HZ"]) {
        iconImageName = @"HZ.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"WD"]) {
        iconImageName = @"WD.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"RA"]) {
        iconImageName = @"RA.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"PS"]) {
        iconImageName = @"PS.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"SH"]) {
        iconImageName = @"SH.png";
    }
    else if ([[[tempArray objectAtIndex:0] objectForKey:@"_icon"] isEqualToString:@"TS"]) {
        iconImageName = @"TS.png";
    }
    [threeHourBigIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,iconImageName]]];
    
    
    [self getTwelveHourWeatherData];
}


//*************** Method To Create UI Placeholders

- (void) createUI {
    
    threeHourDateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 20)];
    threeHourDateTimeLabel.textAlignment = NSTextAlignmentCenter;
    threeHourDateTimeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:16.0];
    threeHourDateTimeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:threeHourDateTimeLabel];
    
    threeHourBigIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 45, threeHourDateTimeLabel.frame.origin.y+threeHourDateTimeLabel.bounds.size.height+15, 90, 90)];
    [threeHourBigIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/sunny.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:threeHourBigIcon];
    
    
    twelveHourTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, threeHourBigIcon.frame.origin.y+threeHourBigIcon.bounds.size.height+30, self.view.bounds.size.width, 30)];
    twelveHourTempLabel.textAlignment = NSTextAlignmentCenter;
    twelveHourTempLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:27.0];
    twelveHourTempLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:twelveHourTempLabel];
    
    
    threeDayFirstDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, twelveHourTempLabel.frame.origin.y+twelveHourTempLabel.bounds.size.height+40, 100, 20)];
    threeDayFirstDateLabel.textAlignment = NSTextAlignmentLeft;
    threeDayFirstDateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    threeDayFirstDateLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:threeDayFirstDateLabel];
    
    threeDaySecondDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, threeDayFirstDateLabel.frame.origin.y+threeDayFirstDateLabel.bounds.size.height+30, 100, 20)];
    threeDaySecondDateLabel.textAlignment = NSTextAlignmentLeft;
    threeDaySecondDateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    threeDaySecondDateLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:threeDaySecondDateLabel];
    
    threeDayThirdDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, threeDaySecondDateLabel.frame.origin.y+threeDaySecondDateLabel.bounds.size.height+30, 100, 20)];
    threeDayThirdDateLabel.textAlignment = NSTextAlignmentLeft;
    threeDayThirdDateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    threeDayThirdDateLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:threeDayThirdDateLabel];
    
    
    threeDayFirstTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90, twelveHourTempLabel.frame.origin.y+twelveHourTempLabel.bounds.size.height+40, 70, 20)];
    threeDayFirstTempLabel.textAlignment = NSTextAlignmentRight;
    threeDayFirstTempLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    threeDayFirstTempLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:threeDayFirstTempLabel];
    
    threeDaySecondTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90, threeDayFirstTempLabel.frame.origin.y+threeDayFirstTempLabel.bounds.size.height+30, 70, 20)];
    threeDaySecondTempLabel.textAlignment = NSTextAlignmentRight;
    threeDaySecondTempLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    threeDaySecondTempLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:threeDaySecondTempLabel];
    
    threeDayThirdTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-90, threeDaySecondTempLabel.frame.origin.y+threeDaySecondTempLabel.bounds.size.height+30, 70, 20)];
    threeDayThirdTempLabel.textAlignment = NSTextAlignmentRight;
    threeDayThirdTempLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    threeDayThirdTempLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:threeDayThirdTempLabel];
    
    threeDayFirstIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-140, twelveHourTempLabel.frame.origin.y+twelveHourTempLabel.bounds.size.height+30, 40, 40)];
    [self.view addSubview:threeDayFirstIcon];
    
    threeDaySecondIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-140, threeDayFirstIcon.frame.origin.y+threeDayFirstIcon.bounds.size.height+15, 40, 40)];
    [self.view addSubview:threeDaySecondIcon];
    
    threeDayThirdIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-140, threeDaySecondIcon.frame.origin.y+threeDaySecondIcon.bounds.size.height+15, 40, 40)];
    [self.view addSubview:threeDayThirdIcon];
    
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Weather Forecast";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    
    
//    nowCastWeatherData = [[NSMutableDictionary alloc] init];
//    twelveHourWeatherData = [[NSMutableDictionary alloc] init];
//    threeDayWeatherData = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    [self createUI];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(184,213,239) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    
    if (appDelegate.IS_COMING_FROM_DASHBOARD) {
        appDelegate.IS_COMING_FROM_DASHBOARD = NO;
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    }
    else {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
        [self getNowcastWeatherData];
    else
        [self getTwelveHourWeatherData];
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
