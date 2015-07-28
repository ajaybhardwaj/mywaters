//
//  CCTVDetailViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 29/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CCTVDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    
    UIView *topMenu;
    
    BOOL isShowingTopMenu;
    UIButton *exploreMapButton,*addToFavButton,*refreshButton,*shareButton,*favouritesButton;
    UILabel *exploreMapLabel,*addToFavLabel,*refreshLabel,*shareLabel,*addToFavlabel;
    
    UIButton *directionButton;
    UIImageView *directionIcon,*arrowIcon,*topImageView;
    UILabel *cctvTitleLabel,*distanceLabel;
    
    UITableView *cctvListingTable;
    NSArray *tableDataSource;
}

@end
