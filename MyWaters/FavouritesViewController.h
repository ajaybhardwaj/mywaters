//
//  FavouritesViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CCTVDetailViewController.h"
#import "ABCWaterDetailViewController.h"
#import "EventsDetailsViewController.h"
#import "WaterLevelSensorsDetailViewController.h"

@interface FavouritesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *favouritesListingTableView,*filterTableView;
    NSArray *favouritesDataSource,*filtersArray;
    
    BOOL isShowingFilter;
    NSInteger selectedFilterIndex;

    UILabel *noFavFoundLabel;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    UIButton *favouritesDetailButton;
}

@end
