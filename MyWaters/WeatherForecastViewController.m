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
        if ([[iconArray objectAtIndex:i] isEqualToString:@"FD"] || [[iconArray objectAtIndex:i] isEqualToString:@"FD"]) {
            iconImageName = @"sunny.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"PC"]) {
            iconImageName = @"cloudy.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"CD"]) {
            iconImageName = @"cloudy.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"HZ"]) {
            // Add Image For Hazy
            iconImageName = @"cloudy.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"WD"]) {
            // Add image for windy
            iconImageName = @"cloudy.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"RA"]) {
            iconImageName = @"rainy.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"PS"]) {
            // Add image for passing showers
            iconImageName = @"rainy.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"SH"]) {
            iconImageName = @"rainy.png";
        }
        else if ([[iconArray objectAtIndex:i] isEqualToString:@"TS"]) {
            iconImageName = @"thunder.png";
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

- (void) getTwelveWeatherData {
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TWELVE_HOUR_FORECAST] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10
                                    ];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *responseString  = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLString:responseString];

    twelveHourWeatherData = [[xmlDictionary objectForKey:@"channel"] objectForKey:@"item"];
    
    NSString *issueDate = [CommonFunctions dateFromString:[[twelveHourWeatherData objectForKey:@"forecastIssue"] objectForKey:@"_date"]];
    threeHourDateTimeLabel.text = [NSString stringWithFormat:@"%@ @ %@",issueDate,[[twelveHourWeatherData objectForKey:@"forecastIssue"] objectForKey:@"_time"]];

    NSString *iconImageName;
    
    if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"FD"] || [[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"FN"]) {
        iconImageName = @"sunny.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"PC"]) {
        iconImageName = @"cloudy.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"CD"]) {
        iconImageName = @"cloudy.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"HZ"]) {
        iconImageName = @"cloudy.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"WD"]) {
        iconImageName = @"cloudy.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"RA"]) {
        iconImageName = @"rainy.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"PS"]) {
        iconImageName = @"rainy.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"SH"]) {
        iconImageName = @"rainy.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"TS"]) {
        iconImageName = @"thunder.png";
    }
    
    twelveHourTempLabel.text = [NSString stringWithFormat:@"%@°C",[[twelveHourWeatherData objectForKey:@"temperature"] objectForKey:@"_high"]];
    [threeHourBigIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,iconImageName]]];

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
    DebugLog(@"%@",xmlDictionary);
    nowCastWeatherData = [[[[xmlDictionary objectForKey:@"channel"] objectForKey:@"item"] valueForKey:@"weatherForecast"] valueForKey:@"area"];
    
//    DebugLog(@"%ld",nowCastWeatherData.count);
//    DebugLog(@"%@",nowCastWeatherData);

    
//    [self getTwelveWeatherData];
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


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0f;
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //    return weatherDataSource.count;
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
    dayLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    dayLabel.text = @"TODAY";
    dayLabel.textColor = RGB(36,160,236);
    dayLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:dayLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 100, 30)];
    timeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:22.0];
    timeLabel.text = @"08:15 PM";
    timeLabel.textColor = RGB(36,160,236);
    timeLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:timeLabel];
    
    UILabel *weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(weatherTableView.bounds.size.width-80, 10, 100, 15)];
    weatherLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    weatherLabel.text = @"CLOUDY";
    weatherLabel.textColor = [UIColor lightGrayColor];
    weatherLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:weatherLabel];
    
    UILabel *tempratureLabel = [[UILabel alloc] initWithFrame:CGRectMake(weatherTableView.bounds.size.width-80, 25, 100, 30)];
    tempratureLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:22.0];
    tempratureLabel.text = [NSString stringWithFormat:@"36/22%@",@"°"];
    tempratureLabel.textColor = [UIColor blackColor];
    tempratureLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:tempratureLabel];
    
    UIImageView *weatherIcon = [[UIImageView alloc] initWithFrame:CGRectMake((weatherTableView.bounds.size.width/2)-15, 15, 30, 30)];
    [weatherIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainy_weather.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [cell.contentView addSubview:weatherIcon];
    
    return cell;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Weather Forecast";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];

//    weatherTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-64) style:UITableViewStyleGrouped];
//    weatherTableView.delegate = self;
//    weatherTableView.dataSource = self;
//    [self.view addSubview:weatherTableView];
//    weatherTableView.backgroundColor = [UIColor clearColor];
//    weatherTableView.backgroundView = nil;
//    weatherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];

    [self createUI];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(36,160,236) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];

    [self getTwelveWeatherData];
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
