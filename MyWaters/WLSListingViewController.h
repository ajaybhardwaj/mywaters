//
//  WLSListingViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 13/7/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WaterLevelSensorsDetailViewController.h"
#import "JSON.h"
#import "XMLReader.h"

@interface WLSListingViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *wlsListingtable;
    NSArray *wlsDataSource;
    
    NSURLConnection *theConnection;
}
@property (strong, nonatomic) NSMutableData *responseData;


@end
