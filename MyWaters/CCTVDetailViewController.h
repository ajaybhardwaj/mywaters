//
//  CCTVDetailViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 29/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CCTVDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UIView *topMenu;
    
    BOOL isShowingTopMenu;
    UIButton *exploreMapButton,*addToFavButton,*refreshButton,*shareButton;
    UILabel *exploreMapLabel,*addToFavLabel,*refreshLabel,*shareLabel;
    
    UIButton *directionButton;
    UIImageView *directionIcon,*arrowIcon,*topImageView;
    UILabel *cctvTitleLabel,*distanceLabel;
    
    UITableView *cctvListingTable;
    NSArray *tableDataSource;
}

@end
