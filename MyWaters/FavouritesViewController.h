//
//  FavouritesViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FavouritesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *favouritesListingTableView;
    NSArray *favouritesDataSource;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    UIButton *favouritesDetailButton;
}

@end
