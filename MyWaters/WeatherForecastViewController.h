//
//  WeatherForecastViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 2/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "CustomButtons.h"
#import "XMLDictionary.h"

@interface WeatherForecastViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    NSDictionary *nowCastWeatherData,*twelveHourWeatherData,*threeDayWeatherData;
    
    UILabel *threeHourDateTimeLabel;
    UIImageView *threeHourBigIcon;
    
    UILabel *twelveHourTempLabel;
    
    UILabel *threeDayFirstDateLabel,*threeDaySecondDateLabel,*threeDayThirdDateLabel;
    UIImageView *threeDayFirstIcon,*threeDaySecondIcon,*threeDayThirdIcon;
    UILabel *threeDayFirstTempLabel,*threeDaySecondTempLabel,*threeDayThirdTempLabel;
    
}

@end
